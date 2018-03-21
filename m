Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43406 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbeCUJrV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 05:47:21 -0400
Date: Wed, 21 Mar 2018 10:47:18 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mvoelkel@DigitalDevices.de,
        rjkm@metzlerbros.de, jasmin@anw.at
Subject: Re: [PATCH 1/5] [media] stv0910/stv6111: add SPDX license headers
Message-ID: <20180321094718.GB16947@kroah.com>
References: <20180320210132.7873-1-d.scheller.oss@gmail.com>
 <20180320210132.7873-2-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320210132.7873-2-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 20, 2018 at 10:01:28PM +0100, Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Add SPDX license headers to the stv0910 and stv6111 DVB frontend
> drivers. Both drivers are licensed as GPL-2.0-only, so fix this in the
> MODULE_LICENSE while at it. Also, the includes were lacking any license
> headers at all, so add them now.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/stv0910.c | 5 +++--
>  drivers/media/dvb-frontends/stv0910.h | 9 +++++++++
>  drivers/media/dvb-frontends/stv6111.c | 6 +++---
>  drivers/media/dvb-frontends/stv6111.h | 7 +++++++
>  4 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
> index 52355c14fd64..ce82264e99ef 100644
> --- a/drivers/media/dvb-frontends/stv0910.c
> +++ b/drivers/media/dvb-frontends/stv0910.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-only

Please only use the identifiers documented in
Documentation/process/license-rules.rst right now.  We wrote and got
that merged _before_ SPDX bumped the tags to 3.0 which added the (imo
crazy) -only variants.

So please stick with what is already in the kernel tree, if we do decide
to update to a newer version of SPDX, we will hit the tree all at once
with a script to give to Linus to run.


>  /*
>   * Driver for the ST STV0910 DVB-S/S2 demodulator.
>   *
> @@ -11,7 +12,7 @@
>   *
>   * This program is distributed in the hope that it will be useful,
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the

Why did you change this in this patch?

Please only do "one" thing per patch.



>   * GNU General Public License for more details.
>   */
>  
> @@ -1836,4 +1837,4 @@ EXPORT_SYMBOL_GPL(stv0910_attach);
>  
>  MODULE_DESCRIPTION("ST STV0910 multistandard frontend driver");
>  MODULE_AUTHOR("Ralph and Marcus Metzler, Manfred Voelkel");
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");

Again, this should be a separate patch.


> diff --git a/drivers/media/dvb-frontends/stv0910.h b/drivers/media/dvb-frontends/stv0910.h
> index fccd8d9b665f..93de08540ce4 100644
> --- a/drivers/media/dvb-frontends/stv0910.h
> +++ b/drivers/media/dvb-frontends/stv0910.h
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Driver for the ST STV0910 DVB-S/S2 demodulator.
> + *
> + * Copyright (C) 2014-2015 Ralph Metzler <rjkm@metzlerbros.de>
> + *                         Marcus Metzler <mocm@metzlerbros.de>
> + *                         developed for Digital Devices GmbH
> + */

Where did that copyright notice come from?

This patch is a total mix of different things, please do not do that at
all!

thanks,

greg k-h
