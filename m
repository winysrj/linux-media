Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:61154 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab0KLPOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 10:14:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/10] MCDE: Add configuration registers
Date: Fri, 12 Nov 2010 16:14:51 +0100
Cc: Jimmy Rubin <jimmy.rubin@stericsson.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	Dan Johansson <dan.johansson@stericsson.com>,
	Linus Walleij <linus.walleij@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-3-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-3-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011121614.51528.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 10 November 2010, Jimmy Rubin wrote:
> This patch adds support for MCDE, Memory-to-display controller
> found in the ST-Ericsson ux500 products.
> 
> This patch adds the configuration registers found in MCDE.

> +
> +#define MCDE_VAL2REG(__reg, __fld, __val) \
> +	(((__val) << __reg##_##__fld##_SHIFT) & __reg##_##__fld##_MASK)
> +#define MCDE_REG2VAL(__reg, __fld, __val) \
> +	(((__val) & __reg##_##__fld##_MASK) >> __reg##_##__fld##_SHIFT)
> +
> +#define MCDE_CR 0x00000000
> +#define MCDE_CR_DSICMD2_EN_V1_SHIFT 0
> +#define MCDE_CR_DSICMD2_EN_V1_MASK 0x00000001
> +#define MCDE_CR_DSICMD2_EN_V1(__x) \
> +	MCDE_VAL2REG(MCDE_CR, DSICMD2_EN_V1, __x)
> +#define MCDE_CR_DSICMD1_EN_V1_SHIFT 1
> +#define MCDE_CR_DSICMD1_EN_V1_MASK 0x00000002
> +#define MCDE_CR_DSICMD1_EN_V1(__x) \
> +	MCDE_VAL2REG(MCDE_CR, DSICMD1_EN_V1, __x)
> +#define MCDE_CR_DSI0_EN_V3_SHIFT 0
> +#define MCDE_CR_DSI0_EN_V3_MASK 0x00000001
> +#define MCDE_CR_DSI0_EN_V3(__x) \
> +	MCDE_VAL2REG(MCDE_CR, DSI0_EN_V3, __x)

This looks all rather unreadable. The easiest way is usually to just
define the bit mask, i.e. the second line of each register definition,
which you can use to mask the bits. It's also useful to indent the lines
so you can easily tell the register offsets apart from the contents:

#define MCDE_CR 0x00000000
#define		MCDE_CR_DSICMD2_EN_V1 0x00000001
#define		MCDE_CR_DSICMD1_EN_V1 0x00000002

Some people prefer to express all this in C instead of macros:

struct mcde_registers {
	enum {
		mcde_cr_dsicmd2_en = 0x00000001,
		mcde_cr_dsicmd1_en = 0x00000002,
		...
	} cr;
	enum {
		mcde_conf0_syncmux0 = 0x00000001,
		...
	} conf0;
	...
};

This gives you better type safety, but which one you choose is your decision.

	Arnd
