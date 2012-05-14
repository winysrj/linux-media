Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39723 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab2ENM76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 08:59:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 2/5] v4l2-dev/ioctl: determine the valid ioctls upfront.
Date: Mon, 14 May 2012 15:00:05 +0200
Message-ID: <1893556.PJBoFjhgqA@avalon>
In-Reply-To: <e75979b946d3934cbfb12e8b5518bcbbb891ceee.1336632433.git.hans.verkuil@cisco.com>
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl> <e75979b946d3934cbfb12e8b5518bcbbb891ceee.1336632433.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Thursday 10 May 2012 09:05:11 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Rather than testing whether an ioctl is implemented in the driver or not
> every time the ioctl is called, do it upfront when the device is registered.
> 
> This also allows a driver to disable certain ioctls based on the
> capabilities of the detected board, something you can't do today without
> creating separate v4l2_ioctl_ops structs for each new variation.
> 
> For the most part it is pretty straightforward, but for control ioctls a
> flag is needed since it is possible that you have per-filehandle controls,
> and that can't be determined upfront of course.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-dev.c   |  171 +++++++++++++++++
>  drivers/media/video/v4l2-ioctl.c |  391 ++++++++++-------------------------
>  include/media/v4l2-dev.h         |   11 ++
>  3 files changed, 297 insertions(+), 276 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index a51a061..4d98ee1 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -516,6 +516,175 @@ static int get_index(struct video_device *vdev)
>  	return find_first_zero_bit(used, VIDEO_NUM_DEVICES);
>  }
> 
> +#define SET_VALID_IOCTL(ops, cmd, op)			\
> +	if (ops->op)					\
> +		set_bit(_IOC_NR(cmd), valid_ioctls)
> +
> +/* This determines which ioctls are actually implemented in the driver.
> +   It's a one-time thing which simplifies video_ioctl2 as it can just do
> +   a bit test.
> +
> +   Note that drivers can override this by setting bits to 1 in
> +   vdev->valid_ioctls. If an ioctl is marked as 1 when this function is
> +   called, then that ioctl will actually be marked as unimplemented.
> +
> +   It does that by first setting up the local valid_ioctls bitmap, and
> +   at the end do a:
> +
> +   vdev->valid_ioctls = valid_ioctls & ~(vdev->valid_ioctls)

Wouldn't it be more logical to initialize valid_ioctls to all 1s and clear 
bits in v4l2_dont_use_cmd() ? Otherwise the meaning of the field changes 
depending on whether the device is registered or not.

Another bikeshedding comment, what about renaming v4l2_dont_use_cmd() with 
something that includes ioctl in the name ?

- v4l2_dont_use_ioctl
- v4l2_dont_use_ioctl_cmd
- v4l2_ioctl_cmd_not_used
- v4l2_ioctl_dont_use
- v4l2_ioctl_dont_use_cmd
- v4l2_disable_ioctl
- v4l2_disable_ioctl_cmd
...

(I like "disable" slightly better than "don't use").

> + */

-- 
Regards,

Laurent Pinchart

