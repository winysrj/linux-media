Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57032 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbaE0AEF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 20:04:05 -0400
Received: from [192.168.1.56] ([84.26.254.29]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0M39zL-1WXXgi44O7-00sxOc for
 <linux-media@vger.kernel.org>; Tue, 27 May 2014 02:04:04 +0200
Message-ID: <5383D673.5050101@gmx.net>
Date: Tue, 27 May 2014 02:04:03 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: MSI Digivox Trio, should I try to hire someone to patch for this
 device?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

http://linuxtv.org/wiki/index.php/MSI_DigiVox_Trio

If you're having a deja-vu, yeah, it's still me. I'm still using this 
device using my butt-ugly patch by adding:

{ USB_DEVICE(0xeb1a, 0x2885),    /* MSI Digivox Trio */
             .driver_info = EM2884_BOARD_TERRATEC_H5 },

to linux/drivers/media/usb/em28xx/em28xx-cards.c.

It's starting to bug me more and more that I can never update my kernel 
(well not without hassle anyway). I've written this to the mailinglist 
before, but with no response.

I just don't have the skill to write this in the neat way it needs to be 
to be able to go upstream. Should I try to hire someone to do that? If 
so, any suggestions? Just put an ad up on craigslist or something? Does 
such a patch have a chance of going upstream? (as that's the whole point 
- I want to update my kernel again)

It should be really straightforward given that no reverse engineering or 
anything is needed. It's just what it states above - pretend the Digivox 
is an H5 and it's done.

Anyone who can tune in on this, please share your thoughts.

Best regards,

P. van Gaans
