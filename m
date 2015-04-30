Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:41539 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbbD3OfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:35:09 -0400
Message-ID: <55423D8F.3080706@xs4all.nl>
Date: Thu, 30 Apr 2015 16:34:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 04/22] vivid: fix bad indenting
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com> <cb935bebf4749114a7ae10fcd28d0f830b9dc2c5.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cb935bebf4749114a7ae10fcd28d0f830b9dc2c5.1430402823.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2015 04:08 PM, Mauro Carvalho Chehab wrote:
> drivers/media/platform/vivid/vivid-vid-out.c:1155 vivid_vid_out_g_parm() warn: inconsistent indenting
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
> index 0af43dc7715c..00f42df947c0 100644
> --- a/drivers/media/platform/vivid/vivid-vid-out.c
> +++ b/drivers/media/platform/vivid/vivid-vid-out.c
> @@ -1152,7 +1152,8 @@ int vivid_vid_out_g_parm(struct file *file, void *priv,
>  	parm->parm.output.capability   = V4L2_CAP_TIMEPERFRAME;
>  	parm->parm.output.timeperframe = dev->timeperframe_vid_out;
>  	parm->parm.output.writebuffers  = 1;
> -return 0;
> +
> +	return 0;
>  }
>  
>  int vidioc_subscribe_event(struct v4l2_fh *fh,
> 

