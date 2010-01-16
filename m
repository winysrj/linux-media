Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42418 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0APMvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 07:51:09 -0500
Received: by bwz27 with SMTP id 27so1190780bwz.21
        for <linux-media@vger.kernel.org>; Sat, 16 Jan 2010 04:50:59 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
Date: Sat, 16 Jan 2010 14:50:43 +0200
Cc: linux-media@vger.kernel.org,
	Andreas Tschirpke <andreas.tschirpke@gmail.com>,
	Matthias Fechner <idefix@fechner.net>, stoth@kernellabs.com
References: <1263614561.6084.15.camel@palomino.walls.org>
In-Reply-To: <1263614561.6084.15.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001161450.44222.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 ������ 2010 06:02:41 Andy Walls wrote:
> Hi,
>
> I've got reworked changes for the IR for the TeVii S470 and the HVR-1250
> at
>
> 	http://linuxtv.org/hg/~awalls/cx23885-ir2
>
> Thanks to loaner HVR-1250 hardware from Devin Heitmueller,
> I've solved the infinite interrupt problem with the CX23885 AV core and
> have reworked the change set against the latest v4l-dvb.
>
> Please test.
>
> Note
>
> 1. the parameters for the IR controller setup in
> linux/drivers/video/cx23885-input.c may need to be tweaked to set the
> proper "params.modulation" and "params.invert_level" before you get
> keypresses decoded.
>
> 2. I guessed at a reasonable set of remote keycodes for the TeVii S470,
> so don't be surprised if the button mapping isn't quite right.
>
> 3.  These module settings may be helpful for debug and test:
>
>        # modprobe cx25840 debug=2 ir_debug=2
>        # modprobe cx23885 debug=7
>
> Also directing "kern.*" messages to /var/log/messages
> in /etc/rsyslogd.conf and giving rsyslod a SIGHUP may be helpful for
> capturing the messages.
>
> 4.  In case I didn't fix the infinite interrupts problem for the TeVii
> S470: Before testing, blacklist the cx23885 module
> in /etc/modprobe.d/blacklist, so that when you reboot, the module
> doesn't automatically load.  If your system seems to be very busy with
> inifinite interrupts upon cx23885 module load, stop testing (and let me
> know).
>
> Regards,
> Andy
Hi

modprobe cx23885 gives "nobody cared" : 

Creating IR device irrcv0
irq 16: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.33-rc4 #3
Call Trace:
 [<c1054700>] ? __report_bad_irq+0x24/0x69
 [<c1054707>] ? __report_bad_irq+0x2b/0x69
 [<c105482c>] ? note_interrupt+0xe7/0x13f
 [<c1054d66>] ? handle_fasteoi_irq+0x7a/0x97
 [<c1003e80>] ? handle_irq+0x38/0x40
 [<c10036d8>] ? do_IRQ+0x38/0x8e
 [<c1002ca9>] ? common_interrupt+0x29/0x30
 [<c100796e>] ? mwait_idle+0x7a/0x7f
 [<c1001ab3>] ? cpu_idle+0x37/0x4c
 [<c1648774>] ? start_kernel+0x29a/0x29d
handlers:
[<c1332132>] (usb_hcd_irq+0x0/0x59)
[<f87cdd88>] (cx23885_irq+0x0/0x4e0 [cx23885])
Disabling IRQ #16

Igor

