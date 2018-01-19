Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55945 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbeASJRf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 04:17:35 -0500
Date: Fri, 19 Jan 2018 11:17:32 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180119091732.x3qyex6lzev2sp2u@paasikivi.fi.intel.com>
References: <1516333071-9766-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5Aq4oX+-ux0r4SjyWAyRUA1DJ34mgBmcvuY6HpG9SJ++g@mail.gmail.com>
 <8E0971CCB6EA9D41AF58191A2D3978B61D4E49E8@PGSMSX111.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E0971CCB6EA9D41AF58191A2D3978B61D4E49E8@PGSMSX111.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Fri, Jan 19, 2018 at 07:29:46AM +0000, Yeh, Andy wrote:
> Thanks Tomasz,
> 
> Agree with your point, if so, we could just change as below with a simple check of streaming flag.
> And for Sakari, do you agree with Tomasz's comment?
> 
> Kindly review and I would send v5 with the change.
> 
> diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> index a7e58bd2..cf1c5ee 100644
> --- a/drivers/media/i2c/imx258.c
> +++ b/drivers/media/i2c/imx258.c
> @@ -561,10 +561,13 @@ static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
> 
>         /*
>          * Applying V4L2 control value only happens
> -        * when power is up for qstreaming
> +        * when streaming flag is on
>          */
> -       if (pm_runtime_get_if_in_use(&client->dev) <= 0)
> +       if (imx258->streaming == 0)

This doesn't address the problem yet. I think we'll need one more field in
the device specific struct to convey this to the driver. Please see the
smiapp driver, and its use of "active" field.

It's a little different implementation, you could well put the check here
rather than the function performing the writes.

This isn't a severe issue though, in practice it'll be unlikely to be
noticed as it hasn't been noticed in some other drivers that use the same
pattern. IMO this could be addressed later on, possibly together with other
drivers with similar issues.

>                 return 0;
> 
>         switch (ctrl->id) {
>         case V4L2_CID_ANALOGUE_GAIN:
> @@ -590,8 +593,6 @@ static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
>                 break;
>         }
> 
> -       pm_runtime_put(&client->dev);
> -
>         return ret;
>  }

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
