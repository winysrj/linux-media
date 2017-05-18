Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:60001 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755374AbdERQbd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 12:31:33 -0400
Message-ID: <1495125080.7848.63.camel@linux.intel.com>
Subject: Re: [PATCH] Staging: media: fix missing blank line coding style
 issue in atomisp_tpg.c
From: Alan Cox <alan@linux.intel.com>
To: Manny Vindiola <mannyv@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 18 May 2017 17:31:20 +0100
In-Reply-To: <1495072118-912-1-git-send-email-mannyv@gmail.com>
References: <1495072118-912-1-git-send-email-mannyv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-05-17 at 21:48 -0400, Manny Vindiola wrote:
> This is a patch to the atomisp_tpg.c file that fixes up a missing
> blank line warning found by the checkpatch.pl tool
> 
> Signed-off-by: Manny Vindiola <mannyv@gmail.com>
> ---
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
> b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
> index 996d1bd..48b9604 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
> @@ -56,6 +56,7 @@ static int tpg_set_fmt(struct v4l2_subdev *sd,
>  		       struct v4l2_subdev_format *format)
>  {
>  	struct v4l2_mbus_framefmt *fmt = &format->format;
> +
>  	if (format->pad)
>  		return -EINVAL;
>  	/* only raw8 grbg is supported by TPG */

The TODO fille for this driver specifically says not to send formatting
patches at this point.

There is no point making trivial spacing changes in code that needs
lots of real work. It's like polishing your car when the doors have
fallen off.

Alan
