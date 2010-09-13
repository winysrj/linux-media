Return-path: <mchehab@localhost.localdomain>
Received: from perceval.irobotique.be ([92.243.18.41]:50060 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0IMHHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 03:07:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: [PATCH] Illuminators control
Date: Mon, 13 Sep 2010 09:08:36 +0200
Cc: linux-media@vger.kernel.org
References: <20100911110350.02c55173@tele>
In-Reply-To: <20100911110350.02c55173@tele>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009130908.37133.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Hi,

On Saturday 11 September 2010 11:03:50 Jean-Francois Moine wrote:

> @@ -419,6 +421,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum 
v4l2_ctrl_type *type,
>  	case V4L2_CID_AUDIO_LIMITER_ENABLED:
>  	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
>  	case V4L2_CID_PILOT_TONE_ENABLED:
> +	case V4L2_CID_ILLUMINATORS_1:
> +	case V4L2_CID_ILLUMINATORS_2:
>  		*type = V4L2_CTRL_TYPE_BOOLEAN;
>  		*min = 0;
>  		*max = *step = 1;

I would prefer integer controls for this, as we will need to support dimmable 
illuminators.

-- 
Regards,

Laurent Pinchart
