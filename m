Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:23688 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2ITJmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 05:42:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] media: sh-vou: fix compilation breakage
Date: Thu, 20 Sep 2012 11:42:26 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1209200856260.25540@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209200856260.25540@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209201142.26142.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 20 September 2012 08:58:48 Guennadi Liakhovetski wrote:
> A recent commit
> 
> commit f135a8a224294fa0f60ec1b8bc120813b7cfc804
> Author: Hans Verkuil <hans.verkuil@cisco.com>
> Date:   Sun Jun 24 06:33:26 2012 -0300
> 
>     [media] sh_vou: remove V4L2_FL_LOCK_ALL_FOPS
> 
> broke compilation of sh_vou.c:
> 
> drivers/media/platform/sh_vou.c: In function 'sh_vou_mmap':
> drivers/media/platform/sh_vou.c:1227: error: 'vdev' undeclared (first use in this function)
> drivers/media/platform/sh_vou.c:1227: error: (Each undeclared identifier is reported only once
> drivers/media/platform/sh_vou.c:1227: error: for each function it appears in.)
> drivers/media/platform/sh_vou.c: In function 'sh_vou_poll':
> drivers/media/platform/sh_vou.c:1242: error: 'vdev' undeclared (first use in this function)
> make[2]: *** [drivers/media/platform/sh_vou.o] Error 1
> 
> Add missing variable definitions.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I've added the sh arch to the daily build as well. So the next time the daily
build should catch such errors.

Regards,

	Hans

> ---
> 
> This is a fix for 3.7
> 
>  drivers/media/platform/sh_vou.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
> index 9f62fd8..7f8b792 100644
> --- a/drivers/media/platform/sh_vou.c
> +++ b/drivers/media/platform/sh_vou.c
> @@ -1224,6 +1224,7 @@ static int sh_vou_release(struct file *file)
>  
>  static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> +	struct video_device *vdev = video_devdata(file);
>  	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
>  	struct sh_vou_file *vou_file = file->private_data;
>  	int ret;
> @@ -1239,6 +1240,7 @@ static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
>  
>  static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
>  {
> +	struct video_device *vdev = video_devdata(file);
>  	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
>  	struct sh_vou_file *vou_file = file->private_data;
>  	unsigned int res;
> 
