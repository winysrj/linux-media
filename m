Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:46588 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1FUP2B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 11:28:01 -0400
Message-ID: <4E00B87A.20205@infradead.org>
Date: Tue, 21 Jun 2011 12:27:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Chain von den Keiya <Chain@rpgfiction.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	cavedon@sssup.it
Subject: Re: [em28xx] Support for TerraTec G3?
References: <201106090038.18115.Chain@rpgfiction.net>
In-Reply-To: <201106090038.18115.Chain@rpgfiction.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 08-06-2011 19:38, Chain von den Keiya escreveu:
> Hello,
> 
> I hope this is the correct way to ask, so if it isn't, I am truly sorry.

c/c the linux-media mailing list, as other people may also have the same issue.

> 
> I have aquired a TerraTec G3 Video Grabber, USB-ID 0ccd:10a7. Now, I was 
> hoping that it would get detected by the em28xx driver - it contains an em2860 
> chip - but it wasn't (as of 2.6.38). However, I could see that there are quite 
> some models which look similar, so I tried out the whole card=xx range. Didn't 
> help. So now the question is, can this be done? Or is it impossible and I have 
> to scrap this nice little device? I would be willing to help - testing 
> drivers, opening the device up and identify chips, et cetera. Because I think 
> if it's not that hard, it won't hurt if Linux supports a few more devices. 
> (Actually, the G1 looks similar to this one again...)
> 
> The only thing I could find was:
> http://linux.terratec.de/video_en.html - but no driver? I don't really 
> understand this. So, now I am at a loss, but not giving up yet. So please help 
> me, either by pointing me into the right direction - or by enhancing the 
> driver to work with this card.

I pushed yesterday some patches for em2861 audio that may help to make your
device work. If the model is similar to Terratec Grabby, then perhaps all that it is
needed is to add your device USB ID into the kernel driver.

Please test the enclosed patch.

em28xx: add support for TerraTec G3

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index c892a1e..d6af828 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1861,6 +1861,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2860_BOARD_TERRATEC_AV350 },
 	{ USB_DEVICE(0x0ccd, 0x0096),
 			.driver_info = EM2860_BOARD_TERRATEC_GRABBY },
+	{ USB_DEVICE(0x0ccd, 0x10a7),
+			.driver_info = EM2860_BOARD_TERRATEC_GRABBY },
 	{ USB_DEVICE(0x0fd9, 0x0033),
 			.driver_info = EM2860_BOARD_ELGATO_VIDEO_CAPTURE},
 	{ USB_DEVICE(0x185b, 0x2870),
