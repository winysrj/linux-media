Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50538 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbbIKNxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 09:53:11 -0400
Message-ID: <55F2DC80.7000309@xs4all.nl>
Date: Fri, 11 Sep 2015 15:52:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 43/55] [media] media: report if a pad is sink or source
 at debug msg
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <a5724b2c7cac1192cbd5033d90745daa586883aa.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <a5724b2c7cac1192cbd5033d90745daa586883aa.1441540862.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Sometimes, it is important to see if the created pad is
> sink or source. Add info to track that.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index d8038a53f945..6ed5eef88593 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -121,8 +121,11 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  		struct media_pad *pad = gobj_to_pad(gobj);
>  
>  		dev_dbg(gobj->mdev->dev,
> -			"%s: id 0x%08x pad#%d: '%s':%d\n",
> -			event_name, gobj->id, media_localid(gobj),
> +			"%s: id 0x%08x %s%spad#%d: '%s':%d\n",
> +			event_name, gobj->id,
> +			pad->flags & MEDIA_PAD_FL_SINK   ? "  sink " : "",
> +			pad->flags & MEDIA_PAD_FL_SOURCE ? "source " : "",
> +			media_localid(gobj),
>  			pad->entity->name, pad->index);
>  		break;
>  	}
> 

