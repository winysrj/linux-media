Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34536 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbcDZSJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 14:09:13 -0400
Received: by mail-lf0-f46.google.com with SMTP id j11so28253467lfb.1
        for <linux-media@vger.kernel.org>; Tue, 26 Apr 2016 11:09:12 -0700 (PDT)
Subject: Re: [PATCH v2 08/13] v4l: vsp1: Make vsp1_entity_get_pad_compose()
 more generic
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1461620198-13428-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <571FAEC6.8010901@cogentembedded.com>
Date: Tue, 26 Apr 2016 21:09:10 +0300
MIME-Version: 1.0
In-Reply-To: <1461620198-13428-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 04/26/2016 12:36 AM, Laurent Pinchart wrote:

> Turn the helper into a function that can retrieve crop and compose
> selection rectangles.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>   drivers/media/platform/vsp1/vsp1_entity.c | 24 ++++++++++++++++++++----
>   drivers/media/platform/vsp1/vsp1_entity.h |  6 +++---
>   drivers/media/platform/vsp1/vsp1_rpf.c    |  7 ++++---
>   3 files changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
> index f60d7926d53f..8c49a74381a1 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -87,12 +87,28 @@ vsp1_entity_get_pad_format(struct vsp1_entity *entity,
>   	return v4l2_subdev_get_try_format(&entity->subdev, cfg, pad);
>   }
>
> +/**
> + * vsp1_entity_get_pad_selection - Get a pad selection from storage for entity
> + * @entity: the entity
> + * @cfg: the configuration storage
> + * @pad: the pad number
> + * @target: the selection target
> + *
> + * Return the selection rectangle stored in the given configuration for an
> + * entity's pad. The configuration can be an ACTIVE or TRY configuration. The
> + * selection target can be COMPOSE or CROP.
> + */
>   struct v4l2_rect *
> -vsp1_entity_get_pad_compose(struct vsp1_entity *entity,
> -			    struct v4l2_subdev_pad_config *cfg,
> -			    unsigned int pad)
> +vsp1_entity_get_pad_selection(struct vsp1_entity *entity,
> +			      struct v4l2_subdev_pad_config *cfg,
> +			      unsigned int pad, unsigned int target)
>   {
> -	return v4l2_subdev_get_try_compose(&entity->subdev, cfg, pad);
> +	if (target == V4L2_SEL_TGT_COMPOSE)
> +		return v4l2_subdev_get_try_compose(&entity->subdev, cfg, pad);
> +	else if (target == V4L2_SEL_TGT_CROP)
> +		return v4l2_subdev_get_try_crop(&entity->subdev, cfg, pad);
> +	else
> +		return NULL;

    How about *switch* instead?

[...]

MBR, Sergei

