Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44750 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758222Ab0DVUUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 16:20:25 -0400
Received: by wyb39 with SMTP id 39so5128055wyb.19
        for <linux-media@vger.kernel.org>; Thu, 22 Apr 2010 13:20:23 -0700 (PDT)
Date: Thu, 22 Apr 2010 23:20:18 +0300
From: George Tellalov <gtellalov@bigfoot.com>
To: Bee Hock Goh <beehock@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: tm6000: Patch that will fixed analog video (tested on tm5600)
Message-ID: <20100422202017.GA13005@joro.homelinux.org>
References: <u2u6e8e83e21004212214i8c186922he28162cbed66d292@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u2u6e8e83e21004212214i8c186922he28162cbed66d292@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 22, 2010 at 01:14:39PM +0800, Bee Hock Goh wrote:
> Dear all,
> 
> Anyone who have a tm6000 compatible analog device, please do try out this patch.
> 
> Its working for me on a tm5600 using mplayer. It can be compile
> against the latest hg tree.
> 

Here's what I get using mplayer:

tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
BUG: unable to handle kernel paging request at 0000000000800200
IP: [<ffffffffa0340b48>] tm6000_irq_callback+0x32a/0x886 [tm6000]
PGD 5de26067 PUD 5d50d067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/devices/platform/abituguru.224/temp3_input
CPU 0
Pid: 0, comm: swapper Tainted: G         C 2.6.33 #1 AV8 (VIA K8T800P-8237)/
RIP: 0010:[<ffffffffa0340b48>]  [<ffffffffa0340b48>] tm6000_irq_callback+0x32a/0x886 [tm6000]
RSP: 0018:ffff880001803cc8  EFLAGS: 00010006
RAX: 0000000000000004 RBX: ffff8800425df800 RCX: 0000000000000003
RDX: ffff8800425df800 RSI: ffff880042612c00 RDI: 0000000000800200
RBP: ffff8800425df800 R08: 0000000000000000 R09: 0000000000000002
R10: ffff8800425df800 R11: ffffffff814af69b R12: ffff8800425dfe9c
R13: ffff880042612c00 R14: 00000000000000b4 R15: 00000000000000b4
FS:  00000000459cb950(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000800200 CR3: 000000005d548000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81600000, task ffffffff81648020)
Stack:
 ffffffff81248064 ffff88005f911000 ffff88005d683750 0000000000000000
<0> ffff880001803d80 00000000000ca800 ffff880042612ffd ffff880200000001
<0> ffffffff8123420d 0000000000005593 d392d818d757d33e 0000000400000003
Call Trace:
 <IRQ>
 [<ffffffff81248064>] ? tcp_v4_do_rcv+0x19b/0x346
 [<ffffffff8123420d>] ? __inet_lookup_established+0x43/0x245
 [<ffffffffa0055f65>] ? usb_hcd_giveback_urb+0x76/0xa9 [usbcore]
 [<ffffffffa0103a54>] ? ehci_urb_done+0x6b/0x7b [ehci_hcd]
 [<ffffffffa0105dfb>] ? ehci_work+0x3ec/0x78d [ehci_hcd]
 [<ffffffffa0108f89>] ? ehci_irq+0x18f/0x1ba [ehci_hcd]
 [<ffffffffa0055819>] ? usb_hcd_irq+0x39/0x7e [usbcore]
 [<ffffffff8107b853>] ? handle_IRQ_event+0x58/0x126
 [<ffffffff8107d0e7>] ? handle_fasteoi_irq+0x78/0xaf
 [<ffffffff81005664>] ? handle_irq+0x17/0x1f
 [<ffffffff81004cb6>] ? do_IRQ+0x57/0xbd
 [<ffffffff812b2353>] ? ret_from_intr+0x0/0x11
 <EOI>
 [<ffffffff8101d534>] ? native_safe_halt+0x2/0x3
 [<ffffffff8100a0bd>] ? default_idle+0x34/0x51
 [<ffffffff81001d9e>] ? cpu_idle+0xa2/0xda
 [<ffffffff816b6140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816b6cc4>] ? start_kernel+0x3e5/0x3f1
 [<ffffffff816b6396>] ? x86_64_start_kernel+0xf9/0x106
Code: b8 04 00 00 00 f3 a4 4c 89 ee 48 8b 94 24 98 00 00 00 b1 04 2b 8a a0 06 00 00 8b ba 9c 06 00 00 48 03 bc 24 b8 00 00 00 48 63 c9 <f3> a4 2b 82 a0 06 00 00 48 98 49 01 c5 eb 63 41 80 7d 03 47 74
RIP  [<ffffffffa0340b48>] tm6000_irq_callback+0x32a/0x886 [tm6000]
 RSP <ffff880001803cc8>
CR2: 0000000000800200
---[ end trace e0d33b74978ba13e ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 0, comm: swapper Tainted: G      D  C 2.6.33 #1
Call Trace:
 <IRQ>  [<ffffffff812b00fd>] ? panic+0x86/0x14b
 [<ffffffff81069f6b>] ? crash_kexec+0xf8/0x101
 [<ffffffff8105259a>] ? up+0xe/0x37
 [<ffffffff81037466>] ? kmsg_dump+0xa6/0x13e
 [<ffffffff81006635>] ? oops_end+0xa6/0xb3
 [<ffffffff8101fcec>] ? no_context+0x1f2/0x201
 [<ffffffff8101fea8>] ? __bad_area_nosemaphore+0x1ad/0x1d1
 [<ffffffffa0335209>] ? tcp_packet+0xc56/0xc99 [nf_conntrack]
 [<ffffffff812627bb>] ? bictcp_cong_avoid+0x12/0x247
 [<ffffffffa005710e>] ? usb_hcd_submit_urb+0x7f5/0x8eb [usbcore]
 [<ffffffff812b25c5>] ? page_fault+0x25/0x30
 [<ffffffffa0340b48>] ? tm6000_irq_callback+0x32a/0x886 [tm6000]
 [<ffffffffa0340939>] ? tm6000_irq_callback+0x11b/0x886 [tm6000]
 [<ffffffff81248064>] ? tcp_v4_do_rcv+0x19b/0x346
 [<ffffffff8123420d>] ? __inet_lookup_established+0x43/0x245
 [<ffffffffa0055f65>] ? usb_hcd_giveback_urb+0x76/0xa9 [usbcore]
 [<ffffffffa0103a54>] ? ehci_urb_done+0x6b/0x7b [ehci_hcd]
 [<ffffffffa0105dfb>] ? ehci_work+0x3ec/0x78d [ehci_hcd]
 [<ffffffffa0108f89>] ? ehci_irq+0x18f/0x1ba [ehci_hcd]
 [<ffffffffa0055819>] ? usb_hcd_irq+0x39/0x7e [usbcore]
 [<ffffffff8107b853>] ? handle_IRQ_event+0x58/0x126
 [<ffffffff8107d0e7>] ? handle_fasteoi_irq+0x78/0xaf
 [<ffffffff81005664>] ? handle_irq+0x17/0x1f
 [<ffffffff81004cb6>] ? do_IRQ+0x57/0xbd
 [<ffffffff812b2353>] ? ret_from_intr+0x0/0x11
 <EOI>  [<ffffffff8101d534>] ? native_safe_halt+0x2/0x3
 [<ffffffff8100a0bd>] ? default_idle+0x34/0x51
 [<ffffffff81001d9e>] ? cpu_idle+0xa2/0xda
 [<ffffffff816b6140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816b6cc4>] ? start_kernel+0x3e5/0x3f1
 [<ffffffff816b6396>] ? x86_64_start_kernel+0xf9/0x106
