Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:29035 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbbIJRQO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 13:16:14 -0400
Subject: Re: [PATCH 1/2] [media] media-device: check before unregister if mdev
 was registered
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
References: <1441890195-11650-1-git-send-email-javier@osg.samsung.com>
 <1441890195-11650-2-git-send-email-javier@osg.samsung.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <55F1BAA8.3030107@linux.intel.com>
Date: Thu, 10 Sep 2015 20:15:20 +0300
MIME-Version: 1.0
In-Reply-To: <1441890195-11650-2-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Javier Martinez Canillas wrote:
> Most media functions that unregister, check if the corresponding register
> function succeed before. So these functions can safely be called even if a
> registration was never made or the component as already been unregistered.
> 
> Add the same check to media_device_unregister() function for consistency.
> 
> This will also allow to split the media_device_register() function in an
> initialization and registration functions without the need to change the
> generic cleanup functions and error code paths for all the media drivers.
> 
> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
>  drivers/media/media-device.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 1312e93ebd6e..745defb34b33 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -574,6 +574,8 @@ EXPORT_SYMBOL_GPL(__media_device_register);
>   * media_device_unregister - unregister a media device
>   * @mdev:	The media device
>   *
> + * If the media device has never been registered this function will
> + * return immediately.

I'd say "It is safe to call this function on an unregistered (but
initialised) media device.". Up to you.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
