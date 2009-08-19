Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:25231 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750953AbZHTBEL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 21:04:11 -0400
From: David Brownell <david-b@pacbell.net>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 3/5 - v3] DaVinci: platform changes to support vpfe camera capture
Date: Wed, 19 Aug 2009 14:04:16 -0700
Cc: m-karicheri2@ti.com, linux-media@vger.kernel.org
References: <1250551146-32543-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1250551146-32543-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200908191404.16404.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 17 August 2009, m-karicheri2@ti.com wrote:
>  static struct i2c_board_info dm355evm_i2c_info[] = {
>         {       I2C_BOARD_INFO("dm355evm_msp", 0x25),
>                 .platform_data = dm355evm_mmcsd_gpios,
>         },
> +       {
> +               I2C_BOARD_INFO("PCA9543A", 0x73),
> +       },
>         /* { plus irq  }, */
>         /* { I2C_BOARD_INFO("tlv320aic3x", 0x1b), }, */
>  };

The DM355 EVM board has no PCA9543A I2C multiplexor
chip, so this is not a good approach to use.  (*)

If I understand correctly you are configuring some
particular add-on board, which uses a chip like that.
There are at least two such boards today, yes?  And
potentially more.  Don't preclude (or complicate)
use of different boards...

The scalable approach is to have a file for each
daughtercard, and Kconfig options to enable the
support for those cards.  The EVM board init code
might call a dm355evm_card_init() routine, and
provide a weak binding for it which would be
overridden by the 

- Dave

(*) Separate issue:  there's ongoing work to get the
    I2C stack to support such chips in generic ways;
    you should plan to use that work, which ISTR wasn't
    too far from being mergeable.

