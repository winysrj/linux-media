Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:32519 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbeBIN1T (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 08:27:19 -0500
Date: Fri, 9 Feb 2018 15:27:16 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media-device: zero reserved media_links_enum field
Message-ID: <20180209132716.4hrxqfqclbnss4hu@paasikivi.fi.intel.com>
References: <1ad7443b-db60-c140-3ab8-f1a865f26db8@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ad7443b-db60-c140-3ab8-f1a865f26db8@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 09, 2018 at 02:25:44PM +0100, Hans Verkuil wrote:
> Zero the reserved field of struct media_links_enum.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> ---
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index afbf23a19e16..7af6fadd206d 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -155,6 +155,8 @@ static long media_device_enum_links(struct media_device *mdev,
>  	if (entity == NULL)
>  		return -EINVAL;
> 
> +	memset(links->reserved, 0, sizeof(links->reserved));
> +
>  	if (links->pads) {
>  		unsigned int p;
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
