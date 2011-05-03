Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1ECVHP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 17:07:15 -0400
Message-ID: <4DC06E80.7070009@redhat.com>
Date: Tue, 03 May 2011 18:07:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: h.ordiales@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Adding support to the Geniatech/MyGica SBTVD Stick S870
 	remote control
References: <AANLkTinD-7F0fHvKR3D89B3_IXHWgpHkFwYr0ud93EIJ@mail.gmail.com> <AANLkTinyVoBwSQQbmJrItuZoJzhkrc1yr-Uflc8o2Lex@mail.gmail.com>
In-Reply-To: <AANLkTinyVoBwSQQbmJrItuZoJzhkrc1yr-Uflc8o2Lex@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hernán,

Em 25-05-2010 20:44, Hernán Ordiales escreveu:
> Hi, i'm sending as attachment a patch against
> http://linuxtv.org/hg/v4l-dvb (i hope this is ok) with some changes to
> the the dib0700 module to add support for this remote control. I added
> the key codes and a new case on parsing ir data
> (dvb_usb_dib0700_ir_proto=1).
> 
> Cheers
> --
> Hernán
> http://h.ordia.com.ar
> GnuPG: 0xEE8A3FE9

> patches/lmml_102314_adding_support_to_the_geniatech_mygica_sbtvd_stick_s870_remote_control.patch
> Content-Type: text/plain; charset="utf-8"
> MIME-Version: 1.0
> Content-Transfer-Encoding: 7bit
> Subject: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control
> Date: Tue, 25 May 2010 23:44:28 -0000
> From: =?utf-8?b?SGVybsODxpLDgsKhbiBPcmRpYWxlcyA8aC5vcmRpYWxlc0BnbWFpbC5j?=
>  =?utf-8?b?b20+?=
> X-Patchwork-Id: 102314
> Message-Id: <AANLkTinyVoBwSQQbmJrItuZoJzhkrc1yr-Uflc8o2Lex@mail.gmail.com>
> To: linux-media@vger.kernel.org
> 
> 
> diff -r b576509ea6d2 linux/drivers/media/dvb/dvb-usb/dib0700_core.c
> --- a/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Wed May 19 19:34:33 2010 -0300
> +++ b/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Wed May 26 19:31:24 2010 -0300
> @@ -550,6 +550,16 @@
>  			poll_reply.data_state = 2;
>  			break;
>  		}
> +
> +		break;
> +	case 1:
> +		/* Geniatech/MyGica remote protocol */
> +		poll_reply.report_id  = buf[0];
> +		poll_reply.data_state = buf[1];
> +		poll_reply.system     = (buf[4] << 8) | buf[4];
> +		poll_reply.data       = buf[5];
> +		poll_reply.not_data   = buf[4]; /* integrity check */
> +		
>  		break;
>  	default:
>  		/* RC5 Protocol */
> diff -r b576509ea6d2 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> --- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Wed May 19 19:34:33 2010 -0300
> +++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Wed May 26 19:31:24 2010 -0300
> @@ -831,6 +831,46 @@
>  	{ 0x4540, KEY_RECORD }, /* Font 'Size' for Teletext */
>  	{ 0x4541, KEY_SCREEN }, /*  Full screen toggle, 'Hold' for Teletext */
>  	{ 0x4542, KEY_SELECT }, /* Select video input, 'Select' for Teletext */
> +
> +
> +	/* Key codes for the Geniatech/MyGica SBTVD Stick S870 remote
> +	   set dvb_usb_dib0700_ir_proto=1 */
> +	{ 0x38c7, KEY_TV }, /* TV/AV */
> +	{ 0x0cf3, KEY_POWER },
> +	{ 0x0af5, KEY_MUTE },
> +	{ 0x2bd4, KEY_VOLUMEUP },
> +	{ 0x2cd3, KEY_VOLUMEDOWN },
> +	{ 0x12ed, KEY_CHANNELUP },
> +	{ 0x13ec, KEY_CHANNELDOWN },
> +	{ 0x01fe, KEY_1 },
> +	{ 0x02fd, KEY_2 },
> +	{ 0x03fc, KEY_3 },
> +	{ 0x04fb, KEY_4 },
> +	{ 0x05fa, KEY_5 },
> +	{ 0x06f9, KEY_6 },
> +	{ 0x07f8, KEY_7 },
> +	{ 0x08f7, KEY_8 },
> +	{ 0x09f6, KEY_9 },
> +	{ 0x00ff, KEY_0 },
> +	{ 0x16e9, KEY_PAUSE },
> +	{ 0x17e8, KEY_PLAY },
> +	{ 0x0bf4, KEY_STOP },
> +	{ 0x26d9, KEY_REWIND },
> +	{ 0x27d8, KEY_FASTFORWARD },
> +	{ 0x29d6, KEY_ESC },
> +	{ 0x1fe0, KEY_RECORD },
> +	{ 0x20df, KEY_UP },
> +	{ 0x21de, KEY_DOWN },
> +	{ 0x11ee, KEY_LEFT },
> +	{ 0x10ef, KEY_RIGHT },
> +	{ 0x0df2, KEY_OK },
> +	{ 0x1ee1, KEY_PLAYPAUSE }, /* Timeshift */
> +	{ 0x0ef1, KEY_CAMERA }, /* Snapshot */
> +	{ 0x25da, KEY_EPG }, /* Info KEY_INFO */
> +	{ 0x2dd2, KEY_MENU }, /* DVD Menu */
> +	{ 0x0ff0, KEY_SCREEN }, /* Full screen toggle */
> +	{ 0x14eb, KEY_SHUFFLE },
> +
>  };
>  
>  /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */


Not sure what happened, but this patch is on my queue for a long time...

This patch is wrong, as it were relying on an old code. The proper way would be to
add the keytable inside a rc keymap, as the patch bellow.

Yet, I'm not seeing where Geniatech/MyGica SBTVD Stick S870 is defined at
the dib0700 driver. Without an entry that is known to work for S870 board, I
don't see any sense on adding such patch.

Cheers,
Mauro

--
Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control

Keytable reported by Hernán Ordiales <h.ordiales@gmail.com>

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index 7a5f530..f183799 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -96,6 +96,43 @@ static struct rc_map_table dib0700_nec_table[] = {
 	{ 0x4540, KEY_RECORD }, /* Font 'Size' for Teletext */
 	{ 0x4541, KEY_SCREEN }, /*  Full screen toggle, 'Hold' for Teletext */
 	{ 0x4542, KEY_SELECT }, /* Select video input, 'Select' for Teletext */
+
+	/* Key codes for the Geniatech/MyGica SBTVD Stick S870 remote */
+	{ 0x38c7, KEY_TV }, /* TV/AV */
+	{ 0x0cf3, KEY_POWER },
+	{ 0x0af5, KEY_MUTE },
+	{ 0x2bd4, KEY_VOLUMEUP },
+	{ 0x2cd3, KEY_VOLUMEDOWN },
+	{ 0x12ed, KEY_CHANNELUP },
+	{ 0x13ec, KEY_CHANNELDOWN },
+	{ 0x01fe, KEY_1 },
+	{ 0x02fd, KEY_2 },
+	{ 0x03fc, KEY_3 },
+	{ 0x04fb, KEY_4 },
+	{ 0x05fa, KEY_5 },
+	{ 0x06f9, KEY_6 },
+	{ 0x07f8, KEY_7 },
+	{ 0x08f7, KEY_8 },
+	{ 0x09f6, KEY_9 },
+	{ 0x00ff, KEY_0 },
+	{ 0x16e9, KEY_PAUSE },
+	{ 0x17e8, KEY_PLAY },
+	{ 0x0bf4, KEY_STOP },
+	{ 0x26d9, KEY_REWIND },
+	{ 0x27d8, KEY_FASTFORWARD },
+	{ 0x29d6, KEY_ESC },
+	{ 0x1fe0, KEY_RECORD },
+	{ 0x20df, KEY_UP },
+	{ 0x21de, KEY_DOWN },
+	{ 0x11ee, KEY_LEFT },
+	{ 0x10ef, KEY_RIGHT },
+	{ 0x0df2, KEY_OK },
+	{ 0x1ee1, KEY_PLAYPAUSE }, /* Timeshift */
+	{ 0x0ef1, KEY_CAMERA }, /* Snapshot */
+	{ 0x25da, KEY_EPG }, /* Info KEY_INFO */
+	{ 0x2dd2, KEY_MENU }, /* DVD Menu */
+	{ 0x0ff0, KEY_SCREEN }, /* Full screen toggle */
+	{ 0x14eb, KEY_SHUFFLE },
 };
 
 static struct rc_map_list dib0700_nec_map = {


