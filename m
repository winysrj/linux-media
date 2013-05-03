Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37972 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751Ab3ECFtI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 01:49:08 -0400
Received: by mail-ea0-f178.google.com with SMTP id m14so594179eaj.37
        for <linux-media@vger.kernel.org>; Thu, 02 May 2013 22:49:07 -0700 (PDT)
Date: Fri, 3 May 2013 08:50:25 +0300
From: Timo Teras <timo.teras@iki.fi>
To: Timo Teras <timo.teras@iki.fi>
Cc: Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130503085025.0a989c42@vostro>
In-Reply-To: <20130429152618.6795bae7@vostro>
References: <20130325190846.3250fe98@vostro>
	<20130325143647.3da1360f@redhat.com>
	<20130325194820.7c122834@vostro>
	<20130325153220.3e6dbfe5@redhat.com>
	<20130325211238.7c325d5e@vostro>
	<20130326102056.63b55916@vostro>
	<20130327161049.683483f8@vostro>
	<20130328105201.7bcc7388@vostro>
	<20130328094052.26b7f3f5@redhat.com>
	<20130328153556.0b58d1aa@vostro>
	<20130328122252.19769614@redhat.com>
	<20130330115455.56c34b5f@vostro>
	<5159C35D.7080901@googlemail.com>
	<20130402084305.0f623e6e@vostro>
	<515B09BD.2040104@googlemail.com>
	<20130403112750.0bc79874@vostro>
	<515EEEB3.2080100@googlemail.com>
	<20130429152618.6795bae7@vostro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Apr 2013 15:26:18 +0300
Timo Teras <timo.teras@iki.fi> wrote:

> > > When comparing these two picture, you see that the frame is offset
> > > with one or two pixels in x-direction. Perhaps this is a byte
> > > offset, and in RGB format causes color values to be connected to
> > > wrong pixel.
> > >
> > > As final note, now I hooked the device on faster machine, and the
> > > AC97 detection seems random. It seemed to work with the slower
> > > machine reliably after I had it do the saa7113 initialization. So
> > > sounds like some sort of timing issue.
> > 
> > More details please. ;)
> > Do you mean that "Config register raw data" (see dmesg output) value
> > varies ?
> 
> I traced the USB init sequence that windows does. It is as follows
> (simplified by removing some other register / eeprom reads):
> 	em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
> 	msleep(20);
> 	em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
> 	msleep(100);
> 	em28xx_write_reg(dev, EM28XX_R08_GPIO, 0x7d);
> 	msleep(60);
> 	em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x24);
> 	em28xx_write_reg(dev, 0x0d, 0x42);
> 
> Will test if it makes the detection of the audio chip more reliable.

The patch added is below. Seems that detecting the audio chip is now a
lot more reliable. So far I have not seen failures. Not sure if the
GPIO twidling drives something - or if it's just the additional delay
fixing things.

--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2479,6 +2479,19 @@
 		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
 		msleep(70);
 		break;
+
+	case EM2860_BOARD_TERRATEC_GRABBY:
+		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
+		msleep(20);
+		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
+		msleep(100);
+		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
+		msleep(100);
+		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0x7d);
+		msleep(60);
+		em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x24);
+		em28xx_write_reg(dev, 0x0d, 0x42);
+		break;
 	}
 
 	em28xx_gpio_set(dev, dev->board.tuner_gpio);
