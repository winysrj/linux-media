Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53891 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbbIKPZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 11:25:22 -0400
Message-ID: <55F2F21A.1030506@xs4all.nl>
Date: Fri, 11 Sep 2015 17:24:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 12/18] [media] media-entity: must check media_create_pad_link()
References: <cover.1441559233.git.mchehab@osg.samsung.com> <4dc311149dc667420c59ba7060846ba993cef507.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <4dc311149dc667420c59ba7060846ba993cef507.1441559233.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 07:30 PM, Mauro Carvalho Chehab wrote:
> Drivers should check if media_create_pad_link() actually
> worked.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 62f882d872b1..8bdc10dcc5e7 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -348,8 +348,9 @@ int media_entity_init(struct media_entity *entity, u16 num_pads,
>  		      struct media_pad *pads);
>  void media_entity_cleanup(struct media_entity *entity);
>  
> -int media_create_pad_link(struct media_entity *source, u16 source_pad,
> -		struct media_entity *sink, u16 sink_pad, u32 flags);
> +__must_check int media_create_pad_link(struct media_entity *source,
> +			u16 source_pad,	struct media_entity *sink,
> +			u16 sink_pad, u32 flags);
>  void __media_entity_remove_links(struct media_entity *entity);
>  void media_entity_remove_links(struct media_entity *entity);
>  
> 

