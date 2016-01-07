Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57822 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752533AbcAGT4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 14:56:48 -0500
Date: Thu, 7 Jan 2016 21:56:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Nikhil Devshatwar <nikhil.nd@ti.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] [media] v4l: of: Correct v4l2_of_parse_endpoint()
 kernel-doc
Message-ID: <20160107195645.GC576@valkosipuli.retiisi.org.uk>
References: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
 <1452191248-15847-2-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452191248-15847-2-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 07, 2016 at 03:27:15PM -0300, Javier Martinez Canillas wrote:
> The v4l2_of_parse_endpoint function kernel-doc says that the return value
> is always 0. But that is not true since the function can fail and a error
> negative code is returned on failure. So correct the kernel-doc to match.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
>  drivers/media/v4l2-core/v4l2-of.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index b27cbb1f5afe..93b33681776c 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -146,7 +146,7 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>   * variable without a low fixed limit. Please use
>   * v4l2_of_alloc_parse_endpoint() in new drivers instead.
>   *
> - * Return: 0.
> + * Return: 0 on success or a negative error code on failure.
>   */
>  int v4l2_of_parse_endpoint(const struct device_node *node,
>  			   struct v4l2_of_endpoint *endpoint)

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
