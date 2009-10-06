Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.atlantis.sk ([80.94.52.35]:46659 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbZJFOOZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Oct 2009 10:14:25 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: laurent.pinchart@skynet.be
Subject: uvcvideo: Finally fix Logitech Quickcam for Notebooks Pro
Date: Tue, 6 Oct 2009 16:07:06 +0200
Cc: linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061607.07195.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I have a Logitech Quickcam for Notebooks Pro camera (046d:08c3) which just 
does not work even with kernel 2.6.31 and has never worked well before.

On http://linux-uvc.berlios.de/, there are two problems listed. I want to 
really fix these two problems so the camera will just work after plugging in 
(and not disconnect). I started with problem no. 2 as this causes the camera 
not to work at all when plugged in:

usb 5-2.4: new high speed USB device using ehci_hcd and address 7
usb 5-2.4: configuration #1 chosen from 1 choice
uvcvideo: Found UVC 1.00 device <unnamed> (046d:08c3)
uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling 
workaround.
uvcvideo: Failed to query (129) UVC probe control : -110 (exp. 26).
uvcvideo: Failed to initialize the device (-5).

When I do "modprobe snd_usb_audio", then "rmmod snd_usb_audio" and 
finally "modprobe uvcvideo", it works. So it looks like snd_usb_audio does 
some initialization that allows uvcvideo to work. It didn't work at all I 
didn't have snd_usb_audio module compiled.

What was the change that supposedly broke this in 2.6.22?

-- 
Ondrej Zary
