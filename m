Return-path: <mchehab@gaivota>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:50225 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab1ADUJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jan 2011 15:09:13 -0500
Message-ID: <4D237E10.2010806@arcor.de>
Date: Tue, 04 Jan 2011 21:07:44 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Holger Nelson <hnelson@hnelson.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Add Terratec Grabster support to tm6000
References: <alpine.DEB.2.00.1101041917040.6749@nova.crius.de>
In-Reply-To: <alpine.DEB.2.00.1101041917040.6749@nova.crius.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Am 04.01.2011 20:12, schrieb Holger Nelson:
> Hi,
>
> the following patch adds support for a Terratec Grabster AV MX150
> (and maybe other devices in the Grabster series). This device is an
> analog frame grabber device using a tm5600. This device doesn't have
> a tuner, so I changed the code to skip the tuner reset if neither
> has_tuner nor has_dvb is set.
it skip, if you has no tuner gpio defined. You does'nt need more. Work
the driver with input select (tv (conposite0), composite, s-vhs)?
>
> Holger
>
> diff -urpN --exclude='*~'
> linux-2.6.37-rc8/drivers/staging/tm6000/tm6000-cards.c
> linux-lts-backport-natty-2.6.37/drivers/staging/tm6000/tm6000-cards.c
> --- linux-2.6.37-rc8/drivers/staging/tm6000/tm6000-cards.c
> 2010-12-29 02:05:48.000000000 +0100
> +++
> linux-lts-backport-natty-2.6.37/drivers/staging/tm6000/tm6000-cards.c
> 2011-01-04 10:46:40.582497722 +0100
please use the lastest development kernel from
git://linuxtv.org/media_tree.git (http://linuxtv.org/git/media_tree.git).
> @@ -50,6 +50,7 @@
> #define TM6010_BOARD_BEHOLD_VOYAGER 11
> #define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE 12
> #define TM6010_BOARD_TWINHAN_TU501 13
> +#define TM5600_BOARD_TERRATEC_GRABSTER 14
>
> #define TM6000_MAXBOARDS 16
> static unsigned int card[] = {[0 ... (TM6000_MAXBOARDS - 1)] =
> UNSET };
> @@ -303,6 +304,19 @@ struct tm6000_board tm6000_boards[] = {
> .dvb_led = TM6010_GPIO_5,
> .ir = TM6010_GPIO_0,
> },
> + },
> + [TM5600_BOARD_TERRATEC_GRABSTER] = {
> + .name = "Terratec Grabster Series",
> + .type = TM5600,
> + .caps = {
> + .has_tuner = 0,
> + .has_dvb = 0,
> + .has_zl10353 = 0,
> + .has_eeprom = 0,
> + .has_remote = 0,
> + },
> + .gpio = {
> + },
> }
> };
>
> @@ -325,6 +339,7 @@ struct usb_device_id tm6000_id_table[] =
> { USB_DEVICE(0x13d3, 0x3241), .driver_info =
> TM6010_BOARD_TWINHAN_TU501 },
> { USB_DEVICE(0x13d3, 0x3243), .driver_info =
> TM6010_BOARD_TWINHAN_TU501 },
> { USB_DEVICE(0x13d3, 0x3264), .driver_info =
> TM6010_BOARD_TWINHAN_TU501 },
> + { USB_DEVICE(0x0ccd, 0x0079), .driver_info =
> TM5600_BOARD_TERRATEC_GRABSTER },
> { },
> };
>
> @@ -505,33 +520,35 @@ int tm6000_cards_setup(struct tm6000_cor
> * reset, just add the code at the board-specific part
> */
>
> - if (dev->gpio.tuner_reset) {
> - for (i = 0; i < 2; i++) {
> - rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> - dev->gpio.tuner_reset, 0x00);
> - if (rc < 0) {
> - printk(KERN_ERR "Error %i doing tuner reset\n", rc);
> - return rc;
> - }
> + if (dev->caps.has_tuner||dev->caps.has_dvb) {
this is bad, if you mean skip tuner reset. We use the line "if
(dev->gpio.tuner_reset)" to check the true tuner reset gpio - if no
gpio set, it skip reset - , and you has no defined a tuner gpio, so it
skip alone.
Why you added then this line?
> + if (dev->gpio.tuner_reset) {
> + for (i = 0; i < 2; i++) {
> + rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> + dev->gpio.tuner_reset, 0x00);
> + if (rc < 0) {
> + printk(KERN_ERR "Error %i doing tuner reset\n",
> rc);
> + return rc;
> + }
>
> - msleep(10); /* Just to be conservative */
> - rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> - dev->gpio.tuner_reset, 0x01);
> - if (rc < 0) {
> - printk(KERN_ERR "Error %i doing tuner reset\n", rc);
> - return rc;
> - }
> - msleep(10);
> + msleep(10); /* Just to be conservative */
> + rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> + dev->gpio.tuner_reset, 0x01);
> + if (rc < 0) {
> + printk(KERN_ERR "Error %i doing tuner reset\n",
> rc);
> + return rc;
> + }
> + msleep(10);
>
> - if (!i) {
> - rc = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
> - if (rc >= 0)
> - printk(KERN_DEBUG "board=0x%08x\n", rc);
> + if (!i) {
> + rc = tm6000_get_reg32(dev, REQ_40_GET_VERSION,
> 0, 0);
> + if (rc >= 0)
> + printk(KERN_DEBUG "board=0x%08x\n", rc);
> + }
> }
> + } else {
> + printk(KERN_ERR "Tuner reset is not configured\n");
> + return -1;
> }
> - } else {
> - printk(KERN_ERR "Tuner reset is not configured\n");
> - return -1;
> }
>
> msleep(50);
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJNI34QAAoJEAWtPFjxMvFGZwEH/R51EPEp2a/+DC34YkW+ywk6
aF6dJQLSq97hcvm2l6u7P7ku6XNAHqK/uqxXmM7trlyoK9RA1v4GWJV/aod+WmHo
jDocoiYG3ZWANco9aqdcutMCiVFlSKZRk2PsiJQwS+LAOabQGGe3pe6EIPQDmO5h
6TaVVLpzOyvGOHxYAy6PMI4ahJzkeJi1YORFN1a43UzV2GrViroT+BDWDKJk9QPk
Mg2diBj29gR0dwPTusqU0I6mwCqwV13incRlROMiKV1WIkaX1XW64qD0FKfMkSZA
edAljweR/S8ktqYGVrBFPvLUmFaX5zTruSgbRvskAKNO5CZO8isihSEJk9zEEbw=
=Z6bs
-----END PGP SIGNATURE-----

