Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56198 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbbLFAxo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 19:53:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 43/55] [media] media: report if a pad is sink or source at debug msg
Date: Sun, 06 Dec 2015 02:53:57 +0200
Message-ID: <29589100.xT3BcZGtSY@avalon>
In-Reply-To: <a5724b2c7cac1192cbd5033d90745daa586883aa.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <a5724b2c7cac1192cbd5033d90745daa586883aa.1441540862.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 06 September 2015 09:03:03 Mauro Carvalho Chehab wrote:
> Sometimes, it is important to see if the created pad is
> sink or source. Add info to track that.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index d8038a53f945..6ed5eef88593 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -121,8 +121,11 @@ static void dev_dbg_obj(const char *event_name,  struct
> media_gobj *gobj) struct media_pad *pad = gobj_to_pad(gobj);
> 
>  		dev_dbg(gobj->mdev->dev,
> -			"%s: id 0x%08x pad#%d: '%s':%d\n",
> -			event_name, gobj->id, media_localid(gobj),
> +			"%s: id 0x%08x %s%spad#%d: '%s':%d\n",
> +			event_name, gobj->id,
> +			pad->flags & MEDIA_PAD_FL_SINK   ? "  sink " : "",
> +			pad->flags & MEDIA_PAD_FL_SOURCE ? "source " : "",

I'm wondering if we really need the two leading spaces in "  sink ", as a 
bidirectional pad would print "  sink source pad" and mess up the alignment 
anyway.

> +			media_localid(gobj),
>  			pad->entity->name, pad->index);
>  		break;
>  	}

-- 
Regards,

Laurent Pinchart

