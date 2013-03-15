Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38262 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab3COMQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 08:16:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 3/5] v4l2: pass std by value to the write-only s_std ioctl.
Date: Fri, 15 Mar 2013 13:17:23 +0100
Message-ID: <47014515.Cl8oU7ANsq@avalon>
In-Reply-To: <968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
References: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl> <968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 15 March 2013 11:27:23 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This ioctl is defined as IOW, so pass the argument by value instead of by
> reference. I could have chosen to add const instead, but this is 1) easier
> to handle in drivers and 2) consistent with the s_std subdev operation.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[snip]

> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index 8ec8abe..d80d8af 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1383,15 +1383,15 @@ static int v4l_s_std(const struct v4l2_ioctl_ops
> *ops, struct file *file, void *fh, void *arg)
>  {
>  	struct video_device *vfd = video_devdata(file);
> -	v4l2_std_id *id = arg, norm;
> +	v4l2_std_id id = *(v4l2_std_id *)arg, norm;

This is getting a bit hard to read, I would have split the declaration of norm 
to a separate line, but that's just nit-picking.

>  	int ret;
> 
> -	norm = (*id) & vfd->tvnorms;
> +	norm = id & vfd->tvnorms;
>  	if (vfd->tvnorms && !norm)	/* Check if std is supported */
>  		return -EINVAL;
> 
>  	/* Calls the specific handler */
> -	ret = ops->vidioc_s_std(file, fh, &norm);
> +	ret = ops->vidioc_s_std(file, fh, norm);
> 
>  	/* Updates standard information */
>  	if (ret >= 0)

-- 
Regards,

Laurent Pinchart

