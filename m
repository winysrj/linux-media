Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:55496 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2LLLr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Dec 2012 06:47:27 -0500
Message-ID: <50C86ECC.9050505@collabora.co.uk>
Date: Wed, 12 Dec 2012 12:47:24 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	laurent.pinchart@ideasonboard.com, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org,
	Martin Barrett <martin.barrett@collabora.co.uk>
Subject: issue with uvcvideo and xhci
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

We have an issue when trying to use USB cameras on a particular machine using
the latest mainline Linux 3.7 kernel. This is not a regression since the same
issue is present with older kernels (i.e: 3.5).

The cameras work fine when plugged to an USB2.0 port (using the EHCI HCD host
controller driver) but they don't when using the USB3.0 port (using the xHCI
HCD host controller driver).

The machine's USB3.0 host controller is a NEC Corporation uPD720200 USB 3.0 Host
Controller (rev 04).

When enabling trace on the uvcvideo driver I see that most frames are lost:

Dec 12 11:07:58 thinclient kernel: [ 4965.597637] uvcvideo: USB isochronous
frame lost (-18).
Dec 12 11:07:58 thinclient kernel: [ 4965.597642] uvcvideo: USB isochronous
frame lost (-18).
Dec 12 11:07:58 thinclient kernel: [ 4965.597647] uvcvideo: Marking buffer as
bad (error bit set).
Dec 12 11:07:58 thinclient kernel: [ 4965.597651] uvcvideo: Frame complete (EOF
found).
Dec 12 11:07:58 thinclient kernel: [ 4965.597655] uvcvideo: EOF in empty payload.
Dec 12 11:07:58 thinclient kernel: [ 4965.597661] uvcvideo: Dropping payload
(out of sync).
Dec 12 11:07:58 thinclient kernel: [ 4965.813294] uvcvideo: frame 486 stats:
0/2/8 packets, 0/0/8 pts

The uvcvideo checks if urb->iso_frame_desc[i].status < 0 on the
uvc_video_decode_isoc() function (drivers/media/usb/uvc/uvc_video.c).

I checked on the xhci driver and the only place where this error code (-EXDEV)
is assigned to frame->status is inside the skip_isoc_td() function
(drivers/usb/host/xhci-ring.c).

At this point I'm not sure if this is a bug on the xhci driver, another quirk
needed by the XHCI_NEC_HOST, a camera misconfiguration on the USB Video Class
driver or a firmware/hardware bug.

The cameras are reported to work on the same machine but using another operating
system (Windows).

I was wondering if you can give me some pointers on how to be sure what's the
issue or if this rings any bells to you.

I've enabled both CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING in case you
need more debugging information.

Thanks a lot and best regards,
Javier
