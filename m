Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35061 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbcD3C5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 22:57:36 -0400
Received: by mail-pf0-f194.google.com with SMTP id r187so16597530pfr.2
        for <linux-media@vger.kernel.org>; Fri, 29 Apr 2016 19:57:36 -0700 (PDT)
Subject: Re: [PATCH] [media] em28xx_dvb: add support for PLEX PX-BCUD (ISDB-S
 usb dongle)
To: Satoshi Nagahama <sattnag@aim.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
References: <a0564a33-161b-3e2e-d4d3-c6ed896a7b89@aim.com>
From: Akihiro TSUKADA <tskd08@gmail.com>
Message-ID: <e1c557f3-c110-f330-3270-bd168f8508f1@gmail.com>
Date: Sat, 30 Apr 2016 11:57:31 +0900
MIME-Version: 1.0
In-Reply-To: <a0564a33-161b-3e2e-d4d3-c6ed896a7b89@aim.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Satoshi,

just some small comments about tuners/qm1d1c0042...

> --- a/drivers/media/tuners/qm1d1c0042.c
> +++ b/drivers/media/tuners/qm1d1c0042.c
> @@ -32,14 +32,23 @@
>  #include "qm1d1c0042.h"
> 
>  #define QM1D1C0042_NUM_REGS 0x20
> -
> -static const u8 reg_initval[QM1D1C0042_NUM_REGS] = {
> -    0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
> -    0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
> -    0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
> -    0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00
> +#define QM1D1C0042_NUM_REG_ROWS 2
> +
> +static const u8
> reg_initval[QM1D1C0042_NUM_REG_ROWS][QM1D1C0042_NUM_REGS] = { {
> +        0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
> +        0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
> +        0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
> +        0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00
> +    }, {
> +        0x68, 0x1c, 0xc0, 0x10, 0xbc, 0xc1, 0x11, 0x33,
> +        0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
> +        0x00, 0xff, 0xf3, 0x00, 0x3f, 0x25, 0x5c, 0xd6,
> +        0x55, 0xcf, 0x95, 0xf6, 0x36, 0xf2, 0x09, 0x00
> +    }
>  };
> 
> +static int reg_index;
> +

* The names of _REG_ROWS / reg_index might be a bit vague to others.
  I would prefer _CHIP_IDS / chip_id  or something like that.

* reg_index should not be static as it is per device property.
  Instead, it shouldj be defined in qm1d1c0042_init() locally, or
  in struct qm1d1c0042_state, if "reg_index" can be used elsewhere.

Thre rest looks OK to me.

regards,
akihiro
