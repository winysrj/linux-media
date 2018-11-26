Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20960 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbeKZTvE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 14:51:04 -0500
Date: Mon, 26 Nov 2018 10:57:32 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        rajmohan.mani@intel.com, bingbu.cao@linux.intel.com,
        mchehab+samsung@kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 2/2] media: imx355: fix wrong order in test pattern menus
Message-ID: <20181126085732.vupidoa2lozp5ndo@paasikivi.fi.intel.com>
References: <1543218214-10767-1-git-send-email-bingbu.cao@intel.com>
 <1543218214-10767-2-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543218214-10767-2-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bing Bu,

On Mon, Nov 26, 2018 at 03:43:34PM +0800, bingbu.cao@intel.com wrote:
> From: Bingbu Cao <bingbu.cao@intel.com>
> 
> current imx355 test pattern order in ctrl menu
> is not correct, this patch fixes it.
> 
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> ---
>  drivers/media/i2c/imx355.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
> index 20c8eea5db4b..9c9559dfd3dd 100644
> --- a/drivers/media/i2c/imx355.c
> +++ b/drivers/media/i2c/imx355.c
> @@ -876,8 +876,8 @@ struct imx355 {
>  
>  static const char * const imx355_test_pattern_menu[] = {
>  	"Disabled",
> -	"100% color bars",
>  	"Solid color",
> +	"100% color bars",
>  	"Fade to gray color bars",
>  	"PN9"
>  };

While at it, could you use the existing test pattern naming as well for the
drivers? That could be a separate patch.

>From drivers/media/i2c/smiapp/smiapp-core.c :

static const char * const smiapp_test_patterns[] = {
	"Disabled",
	"Solid Colour",
  	"Eight Vertical Colour Bars",
	"Colour Bars With Fade to Grey",
	"Pseudorandom Sequence (PN9)",
};

It's not strictly necessary from interface point of view, but for the user
space it'd be good to align the naming.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
