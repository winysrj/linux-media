Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:49508 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZC2HlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 03:41:20 -0400
Received: by bwz17 with SMTP id 17so1505757bwz.37
        for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 00:41:17 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Bernd =?utf-8?q?Strau=C3=9F?= <no_bs@web.de>,
	linux-media@vger.kernel.org, Mauro Chehab <mchehab@infradead.org>
Subject: Re: [Patch] IR support for TeVii S460 DVB-S card
Date: Sun, 29 Mar 2009 09:41:02 +0300
References: <1622164526@web.de>
In-Reply-To: <1622164526@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903290941.02948.liplianin@tut.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28 March 2009 18:15:35 Bernd Strauß wrote:
> changeset:   11251:58f9585b7d94
> tag:         tip
> user:        root
> date:        Sat Mar 28 15:19:20 2009 +0100
> files:       linux/drivers/media/common/ir-keymaps.c
> linux/drivers/media/video/cx88/cx88-input.c linux/include/media/ir-common.h
> description:
>
> IR support for TeVii S460
>
> From: Bernd Strauss <no_bs@web.de>
>
> The remote control that comes with this card doesn't work out of the box.
> This patch fixes that. Works with LIRC and /dev/input/eventX.
>
> Priority: normal
>
> Signed-off-by: Bernd Strauss <no_bs@web.de>
>
>
> diff -r 2adf4a837334 linux/drivers/media/common/ir-keymaps.c
> --- a/linux/drivers/media/common/ir-keymaps.c	Sat Mar 28 06:55:35 2009
> -0300 +++ b/linux/drivers/media/common/ir-keymaps.c	Sat Mar 28 15:15:04
> 2009 +0100 @@ -2800,3 +2800,59 @@
>  	[0x1b] = KEY_B,		/*recall*/
>  };
>  EXPORT_SYMBOL_GPL(ir_codes_dm1105_nec);
> +
> +/* TeVii S460 DVB-S/S2
> +   Bernd Strauss <no_bs@web.de>
> +*/
> +IR_KEYTAB_TYPE ir_codes_tevii_s460[IR_KEYTAB_SIZE] = {
> +	[0x0a] = KEY_POWER,
> +	[0x0c] = KEY_MUTE,
> +	[0x11] = KEY_1,
> +	[0x12] = KEY_2,
> +	[0x13] = KEY_3,
> +	[0x14] = KEY_4,
> +	[0x15] = KEY_5,
> +	[0x16] = KEY_6,
> +	[0x17] = KEY_7,
> +	[0x18] = KEY_8,
> +	[0x19] = KEY_9,
> +	[0x1a] = KEY_LAST,		/* 'recall' / 'event info' */
> +	[0x10] = KEY_0,
> +	[0x1b] = KEY_FAVORITES,
> +
> +	[0x09] = KEY_VOLUMEUP,
> +	[0x0f] = KEY_VOLUMEDOWN,
> +	[0x05] = KEY_TUNER,		/* 'live mode' */
> +	[0x07] = KEY_PVR,		/* 'play mode' */
> +	[0x08] = KEY_CHANNELUP,
> +	[0x06] = KEY_CHANNELDOWN,
> +	[0x00] = KEY_UP,
> +	[0x03] = KEY_LEFT,
> +	[0x1f] = KEY_OK,
> +	[0x02] = KEY_RIGHT,
> +	[0x01] = KEY_DOWN,
> +	[0x1c] = KEY_MENU,
> +	[0x1d] = KEY_BACK,
> +
> +	[0x40] = KEY_PLAYPAUSE,
> +	[0x1e] = KEY_REWIND,		/* '<<' */
> +	[0x4d] = KEY_FASTFORWARD,	/* '>>' */
> +	[0x44] = KEY_EPG,
> +	[0x04] = KEY_RECORD,
> +	[0x0b] = KEY_TIME,              /* 'timer' */
> +	[0x0e] = KEY_OPEN,
> +	[0x4c] = KEY_INFO,
> +	[0x41] = KEY_AB,                /* 'A/B' */
> +	[0x43] = KEY_AUDIO,
> +	[0x45] = KEY_SUBTITLE,
> +	[0x4a] = KEY_LIST,
> +	[0x46] = KEY_F1,		/* 'F1' / 'satellite' */
> +	[0x47] = KEY_F2,		/* 'F2' / 'provider' */
> +	[0x5e] = KEY_F3,		/* 'F3' / 'transp' */
> +	[0x5c] = KEY_F4,		/* 'F4' / 'favorites' */
> +	[0x52] = KEY_F5,		/* 'F5' / 'all' */
> +	[0x5a] = KEY_F6,
> +	[0x56] = KEY_SWITCHVIDEOMODE,	/* 'mon' */
> +	[0x58] = KEY_ZOOM,		/* 'FS' */
> +};
> +EXPORT_SYMBOL_GPL(ir_codes_tevii_s460);
> diff -r 2adf4a837334 linux/drivers/media/video/cx88/cx88-input.c
> --- a/linux/drivers/media/video/cx88/cx88-input.c	Sat Mar 28 06:55:35 2009
> -0300 +++ b/linux/drivers/media/video/cx88/cx88-input.c	Sat Mar 28 15:15:04
> 2009 +0100 @@ -330,6 +330,11 @@
>  		ir->mask_keycode = 0x7e;
>  		ir->polling = 100; /* ms */
>  		break;
> +	case CX88_BOARD_TEVII_S460:
> +		ir_codes = ir_codes_tevii_s460;
> +		ir_type = IR_TYPE_PD;
> +		ir->sampling = 0xff00; /* address */
> +		break;
>  	}
>
>  	if (NULL == ir_codes) {
> @@ -436,6 +441,7 @@
>  	switch (core->boardnr) {
>  	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
>  	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
> +	case CX88_BOARD_TEVII_S460:
>  		ircode = ir_decode_pulsedistance(ir->samples, ir->scount, 1, 4);
>
>  		if (ircode == 0xffffffff) { /* decoding error */
> diff -r 2adf4a837334 linux/include/media/ir-common.h
> --- a/linux/include/media/ir-common.h	Sat Mar 28 06:55:35 2009 -0300
> +++ b/linux/include/media/ir-common.h	Sat Mar 28 15:15:04 2009 +0100
> @@ -162,6 +162,7 @@
>  extern IR_KEYTAB_TYPE ir_codes_kworld_plus_tv_analog[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_kaiomy[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_dm1105_nec[IR_KEYTAB_SIZE];
> +extern IR_KEYTAB_TYPE ir_codes_tevii_s460[IR_KEYTAB_SIZE];
>  #endif
>
>  /*
>
> __________________________________________________________________________
> Verschicken Sie SMS direkt vom Postfach aus - in alle deutschen und viele
> auslДndische Netze zum gleichen Preis!
> https://produkte.web.de/webde_sms/sms
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

So why not to add s420, as it uses the same IR hardware?

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
