Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36211 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751659Ab2H2OVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Aug 2012 10:21:44 -0400
Date: Wed, 29 Aug 2012 17:21:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-kernel@vger.kernel.org,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] media: v4l2-ctrls: add control for dpcm predictor
Message-ID: <20120829142138.GB5261@valkosipuli.retiisi.org.uk>
References: <1346243467-17094-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346243467-17094-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thanks for the patch.

On Wed, Aug 29, 2012 at 06:01:07PM +0530, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> add V4L2_CID_DPCM_PREDICTOR control of type menu, which
> determines the dpcm predictor. The predictor can be either
> simple or advanced.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  This patches has one checkpatch warning for line over
>  80 characters altough it can be avoided I have kept it
>  for consistency.
> 
>  drivers/media/v4l2-core/v4l2-ctrls.c |    9 +++++++++
>  include/linux/videodev2.h            |    5 +++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b6a2ee7..2d7bc15 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -425,6 +425,11 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Gray",
>  		NULL,
>  	};
> +	static const char * const dpcm_predictor[] = {
> +		"Simple Predictor",
> +		"Advanced Predictor",
> +		NULL,
> +	};
>  
>  	switch (id) {
>  	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> @@ -502,6 +507,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return mpeg4_profile;
>  	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>  		return jpeg_chroma_subsampling;
> +	case V4L2_CID_DPCM_PREDICTOR:
> +		return dpcm_predictor;
>  
>  	default:
>  		return NULL;
> @@ -732,6 +739,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
>  	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
>  	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
> +	case V4L2_CID_DPCM_PREDICTOR:		return "DPCM Predictor";
>  
>  	default:
>  		return NULL;
> @@ -832,6 +840,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_ISO_SENSITIVITY_AUTO:
>  	case V4L2_CID_EXPOSURE_METERING:
>  	case V4L2_CID_SCENE_MODE:
> +	case V4L2_CID_DPCM_PREDICTOR:
>  		*type = V4L2_CTRL_TYPE_MENU;
>  		break;
>  	case V4L2_CID_LINK_FREQ:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 6d6dfa7..4edb941 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -2000,6 +2000,11 @@ enum v4l2_jpeg_chroma_subsampling {
>  
>  #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
>  #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
> +#define V4L2_CID_DPCM_PREDICTOR			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
> +enum v4l2_dpcm_predictor {
> +	V4L2_DPCM_PREDICTOR_SIMPLE	= 0,
> +	V4L2_DPCM_PREDICTOR_ADVANCE	= 1,
> +};

s/ADVANCE/ADVANCED/ perhaps?

To add to Sylwester's comment on the documentation, I think this control
belongs to the image processing controls class.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
