Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:40160 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933869AbeFVSaR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 14:30:17 -0400
Subject: Re: [PATCH 1/3] [media] dvb-frontends/cxd2099: fix MODULE_LICENSE to
 'GPL v2'
To: Daniel Scheller <d.scheller.oss@gmail.com>, mchehab@kernel.org,
        mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
References: <20180619185119.24548-1-d.scheller.oss@gmail.com>
 <20180619185119.24548-2-d.scheller.oss@gmail.com>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <3ed1a267-9837-c630-13e1-7caa454fde59@anw.at>
Date: Fri, 22 Jun 2018 20:30:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180619185119.24548-2-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-AT
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You can add my Acked-by: Jasmin Jessich <jasmin@anw.at>

On 06/19/2018 08:51 PM, Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
> 
> In commit 3db30defab4b ("use correct MODULE_LINCESE for GPL v2 only
> according to notice in header") in the upstream repository for the
> mentioned driver at https://github.com/DigitalDevices/dddvb.git, the
> MODULE_LICENSE was fixed to "GPL v2" and is now in sync with the GPL
> copyright boilerplate. Apply this change to the kernel tree driver
> aswell.
> 
> Cc: Ralph Metzler <rjkm@metzlerbros.de>
> Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2099.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/cxd2099.c b/drivers/media/dvb-frontends/cxd2099.c
> index 4a0ce3037fd6..42de3d0badba 100644
> --- a/drivers/media/dvb-frontends/cxd2099.c
> +++ b/drivers/media/dvb-frontends/cxd2099.c
> @@ -701,4 +701,4 @@ module_i2c_driver(cxd2099_driver);
>  
>  MODULE_DESCRIPTION("Sony CXD2099AR Common Interface controller driver");
>  MODULE_AUTHOR("Ralph Metzler");
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
> 
