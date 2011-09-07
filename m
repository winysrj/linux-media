Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1IGQch (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Sep 2011 12:32:37 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p87GWZUJ010515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 7 Sep 2011 12:32:37 -0400
Date: Wed, 7 Sep 2011 11:32:41 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Daniel Dickinson <libre@cshore.neomailbox.net>,
	637740@bugs.debian.org
Subject: Re: [PATCH] uvcvideo: Fix crash when linking entities
Message-ID: <20110907153240.GI10700@zod.bos.redhat.com>
References: <1315348148-7207-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315348148-7207-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 07, 2011 at 12:29:08AM +0200, Laurent Pinchart wrote:
> The uvc_mc_register_entity() function wrongfully selects the
> media_entity associated with a UVC entity when creating links. This
> results in access to uninitialized media_entity structures and can hit a
> BUG_ON statement in media_entity_create_link(). Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/uvc/uvc_entity.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> This patch should fix a v3.0 regression that results in a kernel crash as
> reported in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=637740 and
> https://bugzilla.redhat.com/show_bug.cgi?id=735437.
> 
> Test results will be welcome.

I built a test kernel for Fedora with the patch and the submitter of the
above bug has reported that the issue seems to be fixed.

josh

> diff --git a/drivers/media/video/uvc/uvc_entity.c b/drivers/media/video/uvc/uvc_entity.c
> index 48fea37..29e2399 100644
> --- a/drivers/media/video/uvc/uvc_entity.c
> +++ b/drivers/media/video/uvc/uvc_entity.c
> @@ -49,7 +49,7 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
>  		if (remote == NULL)
>  			return -EINVAL;
>  
> -		source = (UVC_ENTITY_TYPE(remote) != UVC_TT_STREAMING)
> +		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
>  		       ? (remote->vdev ? &remote->vdev->entity : NULL)
>  		       : &remote->subdev.entity;
>  		if (source == NULL)
> -- 
> Regards,
> 
> Laurent Pinchart
> 
