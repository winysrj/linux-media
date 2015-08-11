Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:46907 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbbHKK7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 06:59:25 -0400
Message-ID: <55C9D500.3050902@xs4all.nl>
Date: Tue, 11 Aug 2015 12:57:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v2 13/16] media: make the internal function to create
 links more generic
References: <cover.1438954897.git.mchehab@osg.samsung.com> <078d36a3aa5db1b692ae1b8910d0be0313bd03b9.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <078d36a3aa5db1b692ae1b8910d0be0313bd03b9.1438954897.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/07/15 16:20, Mauro Carvalho Chehab wrote:
> In preparation to add a public function to add links, let's
> make the internal function that creates link more generic.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 96d48aec8381..c68dc421b022 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -461,7 +461,12 @@ EXPORT_SYMBOL_GPL(media_entity_put);
>   * Links management
>   */
>  
> -static struct media_link *media_entity_add_link(struct media_entity *entity)
> +static struct media_link *__media_create_link(struct media_device *mdev,
> +					      enum media_graph_link_dir dir,

Am I blind? I can't find the media_graph_link_dir enum definition anywhere in
this patch series...

Regards,

	Hans
