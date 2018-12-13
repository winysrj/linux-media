Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4568C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 22:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 746192086D
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 22:51:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 746192086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=free.fr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbeLMWvo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 17:51:44 -0500
Received: from lns-bzn-25-82-254-177-192.adsl.proxad.net ([82.254.177.192]:58695
        "EHLO maze.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726813AbeLMWvo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 17:51:44 -0500
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2018 17:51:42 EST
Received: from blok.fork.zz (blok.fork.zz [192.168.0.7])
        by maze.fork.zz (8.15.2/8.15.2) with ESMTPS id wBDMf2BF008716
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Dec 2018 23:41:04 +0100
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by blok.fork.zz (8.15.2/8.15.2) with ESMTP id wBDMf1IQ008268;
        Thu, 13 Dec 2018 23:41:02 +0100
Subject: Re: [PATCH v5 1/1] media: rc: rcmm decoder
To:     linux-media@vger.kernel.org
Cc:     sean@mess.org, linux-media-owner@vger.kernel.org
References: <c44581638d2525bc383a75413259f708@free.fr>
 <cover.1544231670.git.patrick9876@free.fr>
 <20181205002933.20870-1-patrick9876@free.fr>
 <20181205002933.20870-2-patrick9876@free.fr>
 <3a057647b40d9246aca4f64ee771594c32922974.1544175403.git.patrick9876@free.fr>
 <20181207101231.of7c3j67pcz7cetp@gofer.mess.org>
 <28f4bc366ebdb585a5b74a25dd1ee8a525e99884.1544231670.git.patrick9876@free.fr>
From:   Patrick Lerda <patrick9876@free.fr>
Message-ID: <2e368afe-da25-0ab9-c076-6f8831bd26ec@free.fr>
Date:   Thu, 13 Dec 2018 23:41:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <28f4bc366ebdb585a5b74a25dd1ee8a525e99884.1544231670.git.patrick9876@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sean,

    Is the v5 OK?

    Thanks,

Patrick.



Patrick Lerda wrote:
> media: add support for RCMM infrared remote controls.
>
> Signed-off-by: Patrick Lerda <patrick9876@free.fr>
> ---
>   MAINTAINERS                        |   5 +
>   drivers/media/rc/Kconfig           |   7 ++
>   drivers/media/rc/Makefile          |   1 +
>   drivers/media/rc/ir-rcmm-decoder.c | 164 +++++++++++++++++++++++++++++
>   drivers/media/rc/rc-core-priv.h    |   5 +
>   drivers/media/rc/rc-main.c         |   3 +
>   include/media/rc-map.h             |   6 +-
>   include/uapi/linux/lirc.h          |   2 +
>   tools/include/uapi/linux/lirc.h    |   2 +
>   9 files changed, 193 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/media/rc/ir-rcmm-decoder.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3e9f1710ed13..80426d1faaba 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16277,6 +16277,11 @@ M:	David Härdeman <david@hardeman.nu>
>   S:	Maintained
>   F:	drivers/media/rc/winbond-cir.c
>   
> +RCMM REMOTE CONTROLS DECODER
> +M:	Patrick Lerda <patrick9876@free.fr>
> +S:	Maintained
> +F:	drivers/media/rc/ir-rcmm-decoder.c
> +
>   WINSYSTEMS EBC-C384 WATCHDOG DRIVER
>   M:	William Breathitt Gray <vilhelm.gray@gmail.com>
>   L:	linux-watchdog@vger.kernel.org
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 8a216068a35a..43775ac74268 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -133,6 +133,13 @@ config IR_IMON_DECODER
>   	   remote control and you would like to use it with a raw IR
>   	   receiver, or if you wish to use an encoder to transmit this IR.
>   
> +config IR_RCMM_DECODER
> +	tristate "Enable IR raw decoder for the RC-MM protocol"
> +	depends on RC_CORE
> +	help
> +	   Enable this option if you have IR with RC-MM protocol, and
> +	   if the IR is decoded in software
> +
>   endif #RC_DECODERS
>   
>   menuconfig RC_DEVICES
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index 92c163816849..48d23433b3c0 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_IR_SHARP_DECODER) += ir-sharp-decoder.o
>   obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
>   obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
>   obj-$(CONFIG_IR_IMON_DECODER) += ir-imon-decoder.o
> +obj-$(CONFIG_IR_RCMM_DECODER) += ir-rcmm-decoder.o
>   
>   # stand-alone IR receivers/transmitters
>   obj-$(CONFIG_RC_ATI_REMOTE) += ati_remote.o
> diff --git a/drivers/media/rc/ir-rcmm-decoder.c b/drivers/media/rc/ir-rcmm-decoder.c
> new file mode 100644
> index 000000000000..a3c09885da5f
> --- /dev/null
> +++ b/drivers/media/rc/ir-rcmm-decoder.c
> @@ -0,0 +1,164 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +// ir-rcmm-decoder.c - A decoder for the RCMM IR protocol
> +//
> +// Copyright (C) 2018 by Patrick Lerda <patrick9876@free.fr>
> +
> +#include "rc-core-priv.h"
> +#include <linux/module.h>
> +#include <linux/version.h>
> +
> +#define RCMM_UNIT		166667	/* nanosecs */
> +#define RCMM_PREFIX_PULSE	416666  /* 166666.666666666*2.5 */
> +#define RCMM_PULSE_0            277777  /* 166666.666666666*(1+2/3) */
> +#define RCMM_PULSE_1            444444  /* 166666.666666666*(2+2/3) */
> +#define RCMM_PULSE_2            611111  /* 166666.666666666*(3+2/3) */
> +#define RCMM_PULSE_3            777778  /* 166666.666666666*(4+2/3) */
> +
> +enum rcmm_state {
> +	STATE_INACTIVE,
> +	STATE_LOW,
> +	STATE_BUMP,
> +	STATE_VALUE,
> +	STATE_FINISHED,
> +};
> +
> +static bool rcmm_mode(struct rcmm_dec *data)
> +{
> +	return !((0x000c0000 & data->bits) == 0x000c0000);
> +}
> +
> +/**
> + * ir_rcmm_decode() - Decode one RCMM pulse or space
> + * @dev:	the struct rc_dev descriptor of the device
> + * @ev:		the struct ir_raw_event descriptor of the pulse/space
> + *
> + * This function returns -EINVAL if the pulse violates the state machine
> + */
> +static int ir_rcmm_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +{
> +	struct rcmm_dec *data = &dev->raw->rcmm;
> +	u32 scancode;
> +	u8 toggle;
> +	int value;
> +
> +	if (!(dev->enabled_protocols & RC_PROTO_BIT_RCMM))
> +		return 0;
> +
> +	if (!is_timing_event(ev)) {
> +		if (ev.reset)
> +			data->state = STATE_INACTIVE;
> +		return 0;
> +	}
> +
> +	if (ev.duration > RCMM_PULSE_3 + RCMM_UNIT)
> +		goto out;
> +
> +	switch (data->state) {
> +	case STATE_INACTIVE:
> +		if (!ev.pulse)
> +			break;
> +
> +		if (!eq_margin(ev.duration, RCMM_PREFIX_PULSE, RCMM_UNIT / 2))
> +			break;
> +
> +		data->state = STATE_LOW;
> +		data->count = 0;
> +		data->bits  = 0;
> +		return 0;
> +
> +	case STATE_LOW:
> +		if (ev.pulse)
> +			break;
> +
> +		if (!eq_margin(ev.duration, RCMM_PULSE_0, RCMM_UNIT / 2))
> +			break;
> +
> +		data->state = STATE_BUMP;
> +		return 0;
> +
> +	case STATE_BUMP:
> +		if (!ev.pulse)
> +			break;
> +
> +		if (!eq_margin(ev.duration, RCMM_UNIT, RCMM_UNIT / 2))
> +			break;
> +
> +		data->state = STATE_VALUE;
> +		return 0;
> +
> +	case STATE_VALUE:
> +		if (ev.pulse)
> +			break;
> +
> +		if (eq_margin(ev.duration, RCMM_PULSE_0, RCMM_UNIT / 2))
> +			value = 0;
> +		else if (eq_margin(ev.duration, RCMM_PULSE_1, RCMM_UNIT / 2))
> +			value = 1;
> +		else if (eq_margin(ev.duration, RCMM_PULSE_2, RCMM_UNIT / 2))
> +			value = 2;
> +		else if (eq_margin(ev.duration, RCMM_PULSE_3, RCMM_UNIT / 2))
> +			value = 3;
> +		else
> +			break;
> +
> +		data->bits <<= 2;
> +		data->bits |= value;
> +
> +		data->count += 2;
> +
> +		if (data->count < 32)
> +			data->state = STATE_BUMP;
> +		else
> +			data->state = STATE_FINISHED;
> +
> +		return 0;
> +
> +	case STATE_FINISHED:
> +		if (!ev.pulse)
> +			break;
> +
> +		if (!eq_margin(ev.duration, RCMM_UNIT, RCMM_UNIT / 2))
> +			break;
> +
> +		if (rcmm_mode(data)) {
> +			toggle = !!(0x8000 & data->bits);
> +			scancode = data->bits & ~0x8000;
> +		} else {
> +			toggle = 0;
> +			scancode = data->bits;
> +		}
> +
> +		rc_keydown(dev, RC_PROTO_RCMM, scancode, toggle);
> +		data->state = STATE_INACTIVE;
> +		return 0;
> +	}
> +
> +out:
> +	data->state = STATE_INACTIVE;
> +	return -EINVAL;
> +}
> +
> +static struct ir_raw_handler rcmm_handler = {
> +	.protocols	= RC_PROTO_BIT_RCMM,
> +	.decode		= ir_rcmm_decode,
> +};
> +
> +static int __init ir_rcmm_decode_init(void)
> +{
> +	ir_raw_handler_register(&rcmm_handler);
> +
> +	pr_info("IR RCMM protocol handler initialized\n");
> +	return 0;
> +}
> +
> +static void __exit ir_rcmm_decode_exit(void)
> +{
> +	ir_raw_handler_unregister(&rcmm_handler);
> +}
> +
> +module_init(ir_rcmm_decode_init);
> +module_exit(ir_rcmm_decode_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Patrick Lerda");
> +MODULE_DESCRIPTION("RCMM IR protocol decoder");
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index c2cbe7f6266c..2266f61f887f 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -131,6 +131,11 @@ struct ir_raw_event_ctrl {
>   		unsigned int bits;
>   		bool stick_keyboard;
>   	} imon;
> +	struct rcmm_dec {
> +		int state;
> +		unsigned int count;
> +		u64 bits;
> +	} rcmm;
>   };
>   
>   /* Mutex for locking raw IR processing and handler change */
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 66a174979b3c..7df40578dac0 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -70,6 +70,8 @@ static const struct {
>   	[RC_PROTO_CEC] = { .name = "cec", .repeat_period = 0 },
>   	[RC_PROTO_IMON] = { .name = "imon",
>   		.scancode_bits = 0x7fffffff, .repeat_period = 114 },
> +	[RC_PROTO_RCMM] = { .name = "rcmm",
> +		.scancode_bits = 0xffffffff, .repeat_period = 114 },
>   };
>   
>   /* Used to keep track of known keymaps */
> @@ -1006,6 +1008,7 @@ static const struct {
>   	{ RC_PROTO_BIT_XMP,	"xmp",		"ir-xmp-decoder"	},
>   	{ RC_PROTO_BIT_CEC,	"cec",		NULL			},
>   	{ RC_PROTO_BIT_IMON,	"imon",		"ir-imon-decoder"	},
> +	{ RC_PROTO_BIT_RCMM,	"rcmm",		"ir-rcmm-decoder"	},
>   };
>   
>   /**
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index d621acadfbf3..ff5e3b002f91 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -37,6 +37,7 @@
>   #define RC_PROTO_BIT_XMP		BIT_ULL(RC_PROTO_XMP)
>   #define RC_PROTO_BIT_CEC		BIT_ULL(RC_PROTO_CEC)
>   #define RC_PROTO_BIT_IMON		BIT_ULL(RC_PROTO_IMON)
> +#define RC_PROTO_BIT_RCMM		BIT_ULL(RC_PROTO_RCMM)
>   
>   #define RC_PROTO_BIT_ALL \
>   			(RC_PROTO_BIT_UNKNOWN | RC_PROTO_BIT_OTHER | \
> @@ -51,7 +52,7 @@
>   			 RC_PROTO_BIT_RC6_6A_24 | RC_PROTO_BIT_RC6_6A_32 | \
>   			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
>   			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_CEC | \
> -			 RC_PROTO_BIT_IMON)
> +			 RC_PROTO_BIT_IMON | RC_PROTO_BIT_RCMM)
>   /* All rc protocols for which we have decoders */
>   #define RC_PROTO_BIT_ALL_IR_DECODER \
>   			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
> @@ -64,7 +65,8 @@
>   			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
>   			 RC_PROTO_BIT_RC6_6A_24 |  RC_PROTO_BIT_RC6_6A_32 | \
>   			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
> -			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_IMON)
> +			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_IMON | \
> +			 RC_PROTO_BIT_RCMM)
>   
>   #define RC_PROTO_BIT_ALL_IR_ENCODER \
>   			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
> diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
> index 6b319581882f..56106ccea2cb 100644
> --- a/include/uapi/linux/lirc.h
> +++ b/include/uapi/linux/lirc.h
> @@ -192,6 +192,7 @@ struct lirc_scancode {
>    * @RC_PROTO_XMP: XMP protocol
>    * @RC_PROTO_CEC: CEC protocol
>    * @RC_PROTO_IMON: iMon Pad protocol
> + * @RC_PROTO_RCMM: RC-MM protocol
>    */
>   enum rc_proto {
>   	RC_PROTO_UNKNOWN	= 0,
> @@ -218,6 +219,7 @@ enum rc_proto {
>   	RC_PROTO_XMP		= 21,
>   	RC_PROTO_CEC		= 22,
>   	RC_PROTO_IMON		= 23,
> +	RC_PROTO_RCMM		= 24,
>   };
>   
>   #endif
> diff --git a/tools/include/uapi/linux/lirc.h b/tools/include/uapi/linux/lirc.h
> index f189931042a7..c1e5850c56e1 100644
> --- a/tools/include/uapi/linux/lirc.h
> +++ b/tools/include/uapi/linux/lirc.h
> @@ -186,6 +186,7 @@ struct lirc_scancode {
>    * @RC_PROTO_XMP: XMP protocol
>    * @RC_PROTO_CEC: CEC protocol
>    * @RC_PROTO_IMON: iMon Pad protocol
> + * @RC_PROTO_RCMM: RC-MM protocol
>    */
>   enum rc_proto {
>   	RC_PROTO_UNKNOWN	= 0,
> @@ -212,6 +213,7 @@ enum rc_proto {
>   	RC_PROTO_XMP		= 21,
>   	RC_PROTO_CEC		= 22,
>   	RC_PROTO_IMON		= 23,
> +	RC_PROTO_RCMM		= 24,
>   };
>   
>   #endif

