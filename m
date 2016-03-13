Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53483 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbcCMLoB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 07:44:01 -0400
Date: Sun, 13 Mar 2016 08:43:56 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: add dump_stack() if called in atomic context
Message-ID: <20160313084356.0fc39c56@recife.lan>
In-Reply-To: <1457829425-4411-1-git-send-email-shuahkh@osg.samsung.com>
References: <1457829425-4411-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 12 Mar 2016 17:37:05 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Change media_add_link() and media_devnode_create() to dump_stack when
> called in atomic context.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Just to be clear: my suggestion is to use this in order to help you to
debug the issues with au0828/snd-usb-audio, that are sometimes producing
those Kernel messages:

[   23.267197] BUG: sleeping function called from invalid context at mm/slub.c:1289

But I don't think that should patch should be merged upstream.

Regards,
Mauro

> ---
>  drivers/media/media-entity.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index e95070b..66a5392 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -570,6 +570,9 @@ static struct media_link *media_add_link(struct list_head *head)
>  {
>  	struct media_link *link;
>  
> +	if (in_atomic())
> +		dump_stack();
> +
>  	link = kzalloc(sizeof(*link), GFP_KERNEL);
>  	if (link == NULL)
>  		return NULL;
> @@ -891,6 +894,9 @@ struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
>  {
>  	struct media_intf_devnode *devnode;
>  
> +	if (in_atomic())
> +		dump_stack();
> +
>  	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
>  	if (!devnode)
>  		return NULL;


-- 
Thanks,
Mauro
