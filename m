Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38926 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbbKWRyI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 12:54:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 12/18] [media] media-entity: must check media_create_pad_link()
Date: Mon, 23 Nov 2015 19:54:17 +0200
Message-ID: <3963361.pdRumI6NVS@avalon>
In-Reply-To: <4dc311149dc667420c59ba7060846ba993cef507.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com> <4dc311149dc667420c59ba7060846ba993cef507.1441559233.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 06 September 2015 14:30:55 Mauro Carvalho Chehab wrote:
> Drivers should check if media_create_pad_link() actually
> worked.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 62f882d872b1..8bdc10dcc5e7 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -348,8 +348,9 @@ int media_entity_init(struct media_entity *entity, u16
> num_pads, struct media_pad *pads);
>  void media_entity_cleanup(struct media_entity *entity);
> 
> -int media_create_pad_link(struct media_entity *source, u16 source_pad,
> -		struct media_entity *sink, u16 sink_pad, u32 flags);
> +__must_check int media_create_pad_link(struct media_entity *source,
> +			u16 source_pad,	struct media_entity *sink,

s/,\t/, /

> +			u16 sink_pad, u32 flags);

And it would make sense to squash this with the patch that introduces 
media_create_pad_link().

>  void __media_entity_remove_links(struct media_entity *entity);
>  void media_entity_remove_links(struct media_entity *entity);

-- 
Regards,

Laurent Pinchart

