Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48400 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbbJLP6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 11:58:15 -0400
Date: Mon, 12 Oct 2015 12:58:06 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, k.kozlowski@samsung.com,
	laurent.pinchart@ideasonboard.com, hyun.kwon@xilinx.com,
	michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
	gregkh@linuxfoundation.org, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, lars@metafoo.de,
	elfring@users.sourceforge.net, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/1] media: Correctly determine whether an entity is a
 sub-device
Message-ID: <20151012125806.65ad436a@recife.lan>
In-Reply-To: <1444664303-18454-1-git-send-email-sakari.ailus@iki.fi>
References: <20151011215625.779630d9@recife.lan>
	<1444664303-18454-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 12 Oct 2015 18:38:23 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> If the function of an entity is not one of the pre-defined ones, it is not
> correctly recognised as a V4L2 sub-device.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/media/media-entity.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index a60872a..76e9a124 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -328,6 +328,7 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
>  	case MEDIA_ENT_F_LENS:
>  	case MEDIA_ENT_F_ATV_DECODER:
>  	case MEDIA_ENT_F_TUNER:
> +	case MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN:
>  		return true;

OK.

Reviewed-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

>  
>  	default:
