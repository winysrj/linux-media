Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35983 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754407AbdGJPRJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:17:09 -0400
Date: Mon, 10 Jul 2017 17:16:54 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ddbridge: constify i2c_algorithm structure
Message-ID: <20170710171654.3b45ae08@audiostation.wuest.de>
In-Reply-To: <20170710011536.GA24235@embeddedgus>
References: <20170710011536.GA24235@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun, 9 Jul 2017 20:15:36 -0500
schrieb "Gustavo A. R. Silva" <garsilva@embeddedor.com>:

> Check for i2c_algorithm structures that are only stored in
> the algo field of an i2c_adapter structure. This field is
> declared const, so i2c_algorithm structures that have this
> property can be declared as const also.
> 
> This issue was identified using Coccinelle and the following
> semantic patch:
> 
> @r disable optional_qualifier@
> identifier i;
> position p;
> @@
> static struct i2c_algorithm i@p = { ... };
> 
> @ok@
> identifier r.i;
> struct i2c_adapter e;
> position p;
> @@
> e.algo = &i@p;
> 
> @bad@
> position p != {r.p,ok.p};
> identifier r.i;
> @@
> i@p
> 
> @depends on !bad disable optional_qualifier@
> identifier r.i;
> @@
> static
> +const
>  struct i2c_algorithm i = { ... };
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c
> b/drivers/media/pci/ddbridge/ddbridge-core.c index cd1723e..9663a4c
> 100644 --- a/drivers/media/pci/ddbridge/ddbridge-core.c
> +++ b/drivers/media/pci/ddbridge/ddbridge-core.c
> @@ -200,7 +200,7 @@ static u32 ddb_i2c_functionality(struct
> i2c_adapter *adap) return I2C_FUNC_SMBUS_EMUL;
>  }
>  
> -static struct i2c_algorithm ddb_i2c_algo = {
> +static const struct i2c_algorithm ddb_i2c_algo = {
>  	.master_xfer   = ddb_i2c_master_xfer,
>  	.functionality = ddb_i2c_functionality,
>  };

Hi Gustavo,
Hi all,

please hold this single one patch from the constify patches back for
now, since we're in the process of bumping the whole driver to a newer
version which involves lots of code shuffling. With this, quite some
GIT rebasing work needs to be done, and adding this one liner at a
later time (thus rebasing it) is way easier.

To be sure this will not be forgotten afterwards, I've already posted a
patch applying the exact change at [1].

Thank you very much!

[1] https://patchwork.linuxtv.org/patch/42393/

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
