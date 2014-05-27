Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1358 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaE0HMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 03:12:54 -0400
Message-ID: <53843AD3.7060601@xs4all.nl>
Date: Tue, 27 May 2014 09:12:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "P. van Gaans" <w3ird_n3rd@gmx.net>, linux-media@vger.kernel.org
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: add MSI Digivox Trio support
References: <5383D673.5050101@gmx.net>
In-Reply-To: <5383D673.5050101@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2014 02:04 AM, P. van Gaans wrote:
> http://linuxtv.org/wiki/index.php/MSI_DigiVox_Trio
> 
> If you're having a deja-vu, yeah, it's still me. I'm still using this 
> device using my butt-ugly patch by adding:
> 
> { USB_DEVICE(0xeb1a, 0x2885),    /* MSI Digivox Trio */
>              .driver_info = EM2884_BOARD_TERRATEC_H5 },
> 
> to linux/drivers/media/usb/em28xx/em28xx-cards.c.
> 
> It's starting to bug me more and more that I can never update my kernel 
> (well not without hassle anyway). I've written this to the mailinglist 
> before, but with no response.
> 
> I just don't have the skill to write this in the neat way it needs to be 
> to be able to go upstream. Should I try to hire someone to do that? If 
> so, any suggestions? Just put an ad up on craigslist or something? Does 
> such a patch have a chance of going upstream? (as that's the whole point 
> - I want to update my kernel again)
> 
> It should be really straightforward given that no reverse engineering or 
> anything is needed. It's just what it states above - pretend the Digivox 
> is an H5 and it's done.
> 
> Anyone who can tune in on this, please share your thoughts.

I've made it into a proper patch, see below.

Can you reply with your 'Signed-off-by' line?

i.e.: Signed-off-by: John Doe <john.doe@foo.com>

Since you're the author of the patch (I just formatted it), I need that to
get it upstream.

Regards,

	Hans

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 15ad470..9da812b 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2280,6 +2280,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2820_BOARD_UNKNOWN },
 	{ USB_DEVICE(0xeb1a, 0x2875),
 			.driver_info = EM2820_BOARD_UNKNOWN },
+	{ USB_DEVICE(0xeb1a, 0x2885), /* MSI Digivox Trio */
+			.driver_info = EM2884_BOARD_TERRATEC_H5 },
 	{ USB_DEVICE(0xeb1a, 0xe300),
 			.driver_info = EM2861_BOARD_KWORLD_PVRTV_300U },
 	{ USB_DEVICE(0xeb1a, 0xe303),

