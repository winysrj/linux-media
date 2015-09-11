Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48848 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbbIKM6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 08:58:52 -0400
Message-ID: <55F2CFC5.7010805@xs4all.nl>
Date: Fri, 11 Sep 2015 14:57:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 14/55] [media] media: add functions to allow creating
 interfaces
References: <510dc75bdef5462b55215ba8aed120b1b7c4997d.1440902901.git.mchehab@osg.samsung.com> <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 02:02 PM, Mauro Carvalho Chehab wrote:
> Interfaces are different than entities: they represent a
> Kernel<->userspace interaction, while entities represent a
> piece of hardware/firmware/software that executes a function.
> 
> Let's distinguish them by creating a separate structure to
> store the interfaces.
> 
> Later patches should change the existing drivers and logic
> to split the current interface embedded inside the entity
> structure (device nodes) into a separate object of the graph.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

But see a small note below:

> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index a23c93369a04..dc679dfe8ade 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -44,11 +44,41 @@ static inline const char *gobj_type(enum media_gobj_type type)
>  		return "pad";
>  	case MEDIA_GRAPH_LINK:
>  		return "link";
> +	case MEDIA_GRAPH_INTF_DEVNODE:
> +		return "intf-devnode";
>  	default:
>  		return "unknown";
>  	}
>  }
>  
> +static inline const char *intf_type(struct media_interface *intf)
> +{
> +	switch (intf->type) {
> +	case MEDIA_INTF_T_DVB_FE:
> +		return "frontend";
> +	case MEDIA_INTF_T_DVB_DEMUX:
> +		return "demux";
> +	case MEDIA_INTF_T_DVB_DVR:
> +		return "DVR";
> +	case MEDIA_INTF_T_DVB_CA:
> +		return  "CA";

Would lower case be better? "dvr" and "ca"? Although for some reason I feel that "CA"
is fine too. Not sure why :-)

What is the name of the associated device node? Upper or lower case? I feel that the
name here should match the name of the device node.

> +	case MEDIA_INTF_T_DVB_NET:
> +		return "dvbnet";
> +	case MEDIA_INTF_T_V4L_VIDEO:
> +		return "video";
> +	case MEDIA_INTF_T_V4L_VBI:
> +		return "vbi";
> +	case MEDIA_INTF_T_V4L_RADIO:
> +		return "radio";
> +	case MEDIA_INTF_T_V4L_SUBDEV:
> +		return "v4l2-subdev";
> +	case MEDIA_INTF_T_V4L_SWRADIO:
> +		return "swradio";
> +	default:
> +		return "unknown-intf";
> +	}
> +};

Regards,

	Hans

