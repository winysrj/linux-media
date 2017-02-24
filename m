Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33866 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdBXTPx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 14:15:53 -0500
MIME-Version: 1.0
In-Reply-To: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Feb 2017 11:15:51 -0800
Message-ID: <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com>
Subject: Re: [WARNING: A/V UNSCANNABLE][Merge tag 'media/v4.11-1' of git]
 ff58d005cd: BUG: unable to handle kernel NULL pointer dereference at 0000039c
To: kernel test robot <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Ruslan Ruslichenko <rruslich@cisco.com>
Cc: LKP <lkp@01.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        kernel@stlinux.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, wfg@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added more relevant people. I've debugged the immediate problem below,
but I think there's another problem that actually triggered this.

On Fri, Feb 24, 2017 at 10:28 AM, kernel test robot
<fengguang.wu@intel.com> wrote:
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
> commit ff58d005cd10fcd372787cceac547e11cf706ff6
> Merge: 5ab3566 9eeb0ed
>
>     Merge tag 'media/v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
[...]
> [    4.664940] rc rc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registered at minor = 0
> [    4.666322] BUG: unable to handle kernel NULL pointer dereference at 0000039c
> [    4.666675] IP: serial_ir_irq_handler+0x189/0x410

This merge being fingered ends up being a subtle interaction with other changes.

Those "other changes" are (again) the interrupt retrigger code that
was reverted for 4.10, and then we tried to merge them again this
merge window.

Because the immediate cause is:

> [    4.666675] EIP: serial_ir_irq_handler+0x189/0x410
> [    4.666675] Call Trace:
> [    4.666675]  <IRQ>
> [    4.666675]  __handle_irq_event_percpu+0x57/0x100
> [    4.666675]  handle_irq_event_percpu+0x1d/0x50
> [    4.666675]  handle_irq_event+0x32/0x60
> [    4.666675]  handle_edge_irq+0xa5/0x120
> [    4.666675]  handle_irq+0x9d/0xd0
> [    4.666675]  </IRQ>
> [    4.666675]  do_IRQ+0x5f/0x130
> [    4.666675]  common_interrupt+0x33/0x38
> [    4.666675] EIP: hardware_init_port+0x3f/0x190
> [    4.666675] EFLAGS: 00200246 CPU: 0
> [    4.666675] EAX: c718990f EBX: 00000000 ECX: 00000000 EDX: 000003f9
> [    4.666675] ESI: 000003f9 EDI: 000003f8 EBP: c0065d98 ESP: c0065d84
> [    4.666675]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    4.666675]  serial_ir_probe+0xbb/0x300
> [    4.666675]  platform_drv_probe+0x48/0xb0
...

ie an interrupt came in immediately after the request_irq(), before
all the data was properly set up, which then causes the interrupt
handler to take a fault because it tries to access some field that
hasn't even been set up yet.

The code line is helpful, the faulting instruction is

      mov    0x39c(%rax),%eax   <--- fault
      call ..
      mov    someglobalvar,%edx

which together with the supplied config file makes me able to match it
up with the assembly generation around it:

        inb %dx, %al    # tmp254, value
        andb    $1, %al #, tmp255
        testb   %al, %al        # tmp255
        je      .L233   #,
  .L215:
        movl    serial_ir+8, %eax       # serial_ir.rcdev, serial_ir.rcdev
        xorl    %edx, %edx      # _66->timeout
        movl    924(%eax), %eax # _66->timeout, _66->timeout
        call    nsecs_to_jiffies        #
        movl    jiffies, %edx   # jiffies, jiffies.33_70
        addl    %eax, %edx      # _69, tmp259
        movl    $serial_ir+16, %eax     #,
        call    mod_timer       #
        movl    serial_ir+8, %eax       # serial_ir.rcdev,
        call    ir_raw_event_handle     #
        movl    $1, %eax        #, <retval>

so it's that "serial_ir.rcdev->timeout" access that faults. So this is
the faulting source code:

drivers/media/rc/serial_ir.c: 402

        mod_timer(&serial_ir.timeout_timer,
                  jiffies + nsecs_to_jiffies(serial_ir.rcdev->timeout));

        ir_raw_event_handle(serial_ir.rcdev);

        return IRQ_HANDLED;

and serial_ir.rcdev is NULL when ti tries to look up the timeout.

That mod_timer() is new as of commit 2940c7e49775 ("[media] serial_ir:
generate timeout") and *that* is the actual new bug.

Looking at the code, that serial_ir.rcdev thing is initialized fairly
late in serial_ir_init_module(), while the interrupt is allocated
early in serial_ir_probe(), which is done _early_ in
serial_ir_init_module():

serial_ir_init_module -> serial_ir_init -> platform_driver_register ->
serial_ir_probe -> devm_request_irq

Mauro, Sean, please fix.

Anyway, this is clearly a bug in the serial_ir code, but it is *also*
once again clearly now being *triggered* due to the irq handling
changes.

I'm pretty sure that the thing that triggered this is once more commit
a9b4f08770b4 ("x86/ioapic: Restore IO-APIC irq_chip retrigger
callback") which seems to retrigger stale irqs that simply should not
be retriggered.

They aren't actually active any more, if they ever were.

So that commit seems to act like a random CONFIG_DEBUG_SHIRQ. It's
good for testing, but not good for actual users.

I the local APIC retrigger just unconditionally resends that irq. But
it's the core interrupt code that decides to retrigger it incorrectly
for some reason.

Why is IRQS_PENDING set for that thing? Something must have almost
certainly set it, despite the irq not actually having ever been
pending. Thomas?

                  Linus
