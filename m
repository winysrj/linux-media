Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail192.messagelabs.com ([216.82.241.243]:38706 "EHLO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab0ECLOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 07:14:20 -0400
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"robert.lukassen@tomtom.com" <robert.lukassen@tomtom.com>
Date: Mon, 3 May 2010 16:44:11 +0530
Subject: RE: [PATCH 1/2] USB gadget: video class function driver
Message-ID: <70376CA23424B34D86F1C7DE6B9973430254343AAE@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <1272826662-8279-1-git-send-email-laurent.pinchart@ideasonboard.com>,<1272826662-8279-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1272826662-8279-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>This USB video class function driver implements a video capture device from the
>host's point of view. It creates a V4L2 output device on the gadget's side to
>transfer data from a userspace application over USB.

>The UVC-specific descriptors are passed by the gadget driver to the UVC
>function driver, making them completely configurable without any modification
>to the function's driver code.

I wanted to test this code. I git cloned[1] tree. It has v4l2-event.[c,h] and
so I assume that now this tree has support for v4l2 event code.

But, while compilation, I am getting this error.
[root@viral linux-next]# make uImage > /dev/null && make modules
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
  CALL    scripts/checksyscalls.sh
  Building modules, stage 2.
  MODPOST 5 modules
ERROR: "v4l2_event_dequeue" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_init" [drivers/usb/gadget/g_webcam.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

And by looking at the code, those symbols are not exported and thus the error is obvious.
Can you please point me out where to take v4l2-event code? I tried to look for on linuxtv.org but was not able to locate the right code.

[1]git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git

Thanks,
Viral

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
