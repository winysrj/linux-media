Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:37895 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933869AbeFVSad (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 14:30:33 -0400
Subject: Re: [PATCH 2/3] [media] dvb-frontends/cxd2099: add SPDX license
 identifier
To: Daniel Scheller <d.scheller.oss@gmail.com>, mchehab@kernel.org,
        mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
References: <20180619185119.24548-1-d.scheller.oss@gmail.com>
 <20180619185119.24548-3-d.scheller.oss@gmail.com>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <9a15a36f-c784-11ae-b9f8-36642e978787@anw.at>
Date: Fri, 22 Jun 2018 20:30:25 +0200
MIME-Version: 1.0
In-Reply-To: <20180619185119.24548-3-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-AT
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You can add my Acked-by: Jasmin Jessich <jasmin@anw.at>

On 06/19/2018 08:51 PM, Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
> 
> As both the MODULE_LICENSE and the boilerplates are now in sync and clear
> that the driver is licensed under the terms of the GPLv2-only, add a
> matching SPDX license identifier tag.
> 
> Cc: Ralph Metzler <rjkm@metzlerbros.de>
> Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2099.c | 1 +
>  drivers/media/dvb-frontends/cxd2099.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/media/dvb-frontends/cxd2099.c b/drivers/media/dvb-frontends/cxd2099.c
> index 42de3d0badba..5264e873850e 100644
> --- a/drivers/media/dvb-frontends/cxd2099.c
> +++ b/drivers/media/dvb-frontends/cxd2099.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * cxd2099.c: Driver for the Sony CXD2099AR Common Interface Controller
>   *
> diff --git a/drivers/media/dvb-frontends/cxd2099.h b/drivers/media/dvb-frontends/cxd2099.h
> index ec1910dec3f3..0c101bdef01d 100644
> --- a/drivers/media/dvb-frontends/cxd2099.h
> +++ b/drivers/media/dvb-frontends/cxd2099.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * cxd2099.h: Driver for the Sony CXD2099AR Common Interface Controller
>   *
> 
