Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57319 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932281AbbD1IYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 04:24:21 -0400
Date: Tue, 28 Apr 2015 11:23:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-of: fix compiler errors if CONFIG_OF is undefined
Message-ID: <20150428082344.GA3188@valkosipuli.retiisi.org.uk>
References: <553F2B7C.20506@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <553F2B7C.20506@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Apr 28, 2015 at 08:41:00AM +0200, Hans Verkuil wrote:
> You must use static inline otherwise you get these errors if CONFIG_OF is not defined:
> 
> In file included from drivers/media/platform/soc_camera/soc_camera.c:39:0:
> include/media/v4l2-of.h:112:13: warning: 'v4l2_of_free_endpoint' defined but not used [-Wunused-function]
>  static void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
>              ^
> In file included from drivers/media/platform/soc_camera/atmel-isi.c:28:0:
> include/media/v4l2-of.h:112:13: warning: 'v4l2_of_free_endpoint' defined but not used [-Wunused-function]
>  static void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
>              ^
> In file included from drivers/media/platform/soc_camera/rcar_vin.c:36:0:
> include/media/v4l2-of.h:112:13: warning: 'v4l2_of_free_endpoint' defined but not used [-Wunused-function]
>  static void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
>              ^
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index 241e98a..4dc34b2 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -103,13 +103,13 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
>  	return -ENOSYS;
>  }
>  
> -struct v4l2_of_endpoint *v4l2_of_alloc_parse_endpoint(
> +static inline struct v4l2_of_endpoint *v4l2_of_alloc_parse_endpoint(
>  	const struct device_node *node)
>  {
>  	return NULL;
>  }
>  
> -static void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
> +static inline void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
>  {
>  }
>  

Oops. My bad. Thanks for the patch!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
