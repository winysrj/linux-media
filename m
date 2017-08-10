Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57094 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751940AbdHJLJj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 07:09:39 -0400
Date: Thu, 10 Aug 2017 14:09:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Harold Gomez <haroldgmz11@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Subject:drivers:staging:media:atomisp:
Message-ID: <20170810110936.peuntngfo5xnnugg@valkosipuli.retiisi.org.uk>
References: <20170810093826.GA3361@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170810093826.GA3361@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Harold,

Please use a better subject line.

On Thu, Aug 10, 2017 at 03:08:26PM +0530, Harold Gomez wrote:
> Fix Warning from checkpatch.pl 
> Block comments use * on subsequent lines
> 
> Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>
> ---
>  drivers/staging/media/atomisp/i2c/ap1302.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
> index 9d6ce36..ac1aa96 100644
> --- a/drivers/staging/media/atomisp/i2c/ap1302.c
> +++ b/drivers/staging/media/atomisp/i2c/ap1302.c
> @@ -158,8 +158,9 @@ static struct ap1302_context_info context_info[] = {
>  };
>  
>  /* This array stores the description list for metadata.
> -   The metadata contains exposure settings and face
> -   detection results. */
> + * The metadata contains exposure settings and face
> + * detection results.
> + */

/*
 * Multi-line comments
 * look like this.
 */

>  static u16 ap1302_ss_list[] = {
>  	0xb01c, /* From 0x0186 with size 0x1C are exposure settings. */
>  	0x0186,
> -- 
> 2.1.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
