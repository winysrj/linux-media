Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54156 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030524Ab2CNOwM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 10:52:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org, archit@ti.com,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH] omap_vout: Fix the build warning and section miss-match warning
Date: Wed, 14 Mar 2012 15:52:37 +0100
Message-ID: <1981335.62NlLPnzP3@avalon>
In-Reply-To: <1331295243-2191-1-git-send-email-hvaibhav@ti.com>
References: <1331295243-2191-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vaibhav,

Thanks for the patch.

On Friday 09 March 2012 17:44:03 Vaibhav Hiremath wrote:
> Patch fixes below build warning and section miss-match warning
> from omap_vout driver -

You should probably not refer to "patch below" in a commit message, as there 
this won't be a patch anymore after it gets applied (and "below" is 
meaningless in a git log).

> Build warnings:
> =============
> drivers/media/video/omap/omap_vout.c: In function 'omapvid_setup_overlay':
> drivers/media/video/omap/omap_vout.c:381:17: warning: 'mode' may be used
> uninitialized in this function
> 
> Section Mis-Match warnings:
> ==========================
> WARNING: drivers/media/video/omap/omap-vout.o(.data+0x0): Section mismatch
> in reference from the variable
> omap_vout_driver to the function .init.text:omap_vout_probe()
> The variable omap_vout_driver references
> the function __init omap_vout_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

There are 3 fixes in this patch: compilation warning, section mismatch 
warning, and addition of .owner = THIS_MODULE. I would have split the patch in 
3.

> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>
> ---
>  drivers/media/video/omap/omap_vout.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c index dffcf66..0fb0437 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -328,7 +328,7 @@ static int video_mode_to_dss_mode(struct
> omap_vout_device *vout) struct omap_overlay *ovl;
>  	struct omapvideo_info *ovid;
>  	struct v4l2_pix_format *pix = &vout->pix;
> -	enum omap_color_mode mode;
> +	enum omap_color_mode mode = -EINVAL;

What about removing "case 0" below ? The default case would then set mode to -
EINVAL.

> 
>  	ovid = &vout->vid_info;
>  	ovl = ovid->overlays[0];
> @@ -2108,7 +2108,7 @@ static void omap_vout_cleanup_device(struct
> omap_vout_device *vout) kfree(vout);
>  }
> 
> -static int omap_vout_remove(struct platform_device *pdev)
> +static int __devexit omap_vout_remove(struct platform_device *pdev)
>  {
>  	int k;
>  	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
> @@ -2129,7 +2129,7 @@ static int omap_vout_remove(struct platform_device
> *pdev) return 0;
>  }
> 
> -static int __init omap_vout_probe(struct platform_device *pdev)
> +static int __devinit omap_vout_probe(struct platform_device *pdev)
>  {
>  	int ret = 0, i;
>  	struct omap_overlay *ovl;
> @@ -2241,9 +2241,10 @@ probe_err0:
>  static struct platform_driver omap_vout_driver = {
>  	.driver = {
>  		.name = VOUT_NAME,
> +		.owner = THIS_MODULE,
>  	},
>  	.probe = omap_vout_probe,
> -	.remove = omap_vout_remove,
> +	.remove = __devexit_p(omap_vout_remove),
>  };
> 
>  static int __init omap_vout_init(void)

-- 
Regards,

Laurent Pinchart

