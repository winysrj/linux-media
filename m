Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:41857 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586AbZJNIMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 04:12:16 -0400
Message-ID: <4AD588DB.4050905@pardus.org.tr>
Date: Wed, 14 Oct 2009 11:16:27 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-usb@vger.kernel.org
Subject: Re: uvcvideo causes ehci_hcd to halt
References: <Pine.LNX.4.44L0.0910131050460.3169-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910131050460.3169-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote On 13-10-2009 17:53:
> Can you add a dump_stack() call just after the ehci_err() line in 
> drivers/usb/host/ehci-hcd.c:handshake_on_error_set_halt()?  It should 
> provide some clues.
>
> At the same time (i.e., during the same test) you should collect a 
> usbmon trace.
>
> Alan Stern
>   

Hi. First the backtrace:

[  149.510272] uvcvideo: Found UVC 1.00 device BisonCam, NB Pro (5986:0203)
[  149.515017] input: BisonCam, NB Pro as
/devices/pci0000:00/0000:00:1d.7/usb1/1-5/1-5:1.0/input/input10
[  149.515588] usbcore: registered new interface driver uvcvideo
[  149.516247] USB Video Class driver (v0.1.0)
[  149.658012] Pid: 1137, comm: hald-probe-vide Tainted: G         C
2.6.31.4-128 #2
[  149.658012] Call Trace:
[  149.658012]  [<c0373f62>] handshake_on_error_set_halt+0x36/0x65
[  149.658012]  [<c0374073>] enable_periodic+0x32/0x72
[  149.658012]  [<c03741c9>] qh_link_periodic+0x116/0x11e
[  149.658012]  [<c0374665>] qh_schedule+0x120/0x12c
[  149.658012]  [<c03775d0>] intr_submit+0x8c/0x124
[  149.658012]  [<c0377d2a>] ehci_urb_enqueue+0x7a/0xa5
[  149.658012]  [<c036965f>] usb_hcd_submit_urb+0xbb/0x13c
[  149.658012]  [<c0369b1e>] usb_submit_urb+0x1f1/0x20d
[  149.658012]  [<f854aaff>] uvc_status_start+0x18/0x1a [uvcvideo]
[  149.658012]  [<f8546e23>] uvc_v4l2_open+0x8a/0xcf [uvcvideo]
[  149.658012]  [<f7c3d74a>] v4l2_open+0x68/0x7c [videodev]
[  149.658012]  [<c01c648e>] chrdev_open+0x125/0x13c
[  149.658012]  [<c01c28a9>] __dentry_open+0x119/0x207
[  149.658012]  [<c01c2a31>] nameidata_to_filp+0x2c/0x43
[  149.658012]  [<c01c6369>] ? chrdev_open+0x0/0x13c
[  149.658012]  [<c01ccc28>] do_filp_open+0x3e5/0x741
[  149.658012]  [<c01ccfe9>] ? getname+0x20/0xb7
[  149.658012]  [<c01d4be8>] ? alloc_fd+0x55/0xbe
[  149.658012]  [<c01c2699>] do_sys_open+0x4a/0xe2
[  149.658012]  [<c0435527>] ? do_page_fault+0x2d6/0x304
[  149.658012]  [<c01c2773>] sys_open+0x1e/0x26
[  149.658012]  [<c0103214>] sysenter_do_call+0x12/0x28
[  149.658012] ehci_hcd 0000:00:1d.7: force halt; handhake f7c66024
00004000 00000000 -> -110

And the usbmon trace during "modprobe uvcvideo" can be found at:

http://cekirdek.pardus.org.tr/~ozan/ivir/logs/usbmon.trace.bad

I also manage to not reproduce the problem so it's kinda racy. You can
find good/bad dmesg/usbmon traces at:

http://cekirdek.pardus.org.tr/~ozan/ivir/logs

Thanks,
Ozan Caglayan



