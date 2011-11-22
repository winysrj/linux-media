Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3532 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1KVKjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 05:39:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH v1 2/2] vb2: add support for app_offset field of the v4l2_plane struct
Date: Tue, 22 Nov 2011 11:38:40 +0100
Cc: linux-media@vger.kernel.org, mingchen@quicinc.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1321939597-6239-1-git-send-email-pawel@osciak.com> <1321939597-6239-3-git-send-email-pawel@osciak.com>
In-Reply-To: <1321939597-6239-3-git-send-email-pawel@osciak.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111221138.40499.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel!

Thanks for doing this work, but I have a few comments...

On Tuesday, November 22, 2011 06:26:37 Pawel Osciak wrote:
> The app_offset can only be set by userspace and will be passed by vb2 to
> the driver.
> 
> Signed-off-by: Pawel Osciak <pawel@osciak.com>
> CC: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/videobuf2-core.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 979e544..41cc8e9 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -830,6 +830,11 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
>  			}
>  		}
>  
> +		/* App offset can only be set by userspace, for all types */
> +		for (plane = 0; plane < vb->num_planes; ++plane)
> +			v4l2_planes[plane].app_offset =
> +				b->m.planes[plane].app_offset;
> +
>  		if (b->memory == V4L2_MEMORY_USERPTR) {
>  			for (plane = 0; plane < vb->num_planes; ++plane) {
>  				v4l2_planes[plane].m.userptr =
> 

I'd like to see this implemented in vivi and preferably one other driver.

What also needs to be clarified is how this affects queue_setup (should the
sizes include the app_offset or not?) and e.g. vb2_plane_size (again, is the
size with or without app_offset?).

Should app_offset handling be enforced (i.e. should all vb2 drivers support
it?) or should it be optional? If optional, then app_offset should be set to
0 somehow.

This code in __qbuf_userptr should probably also be modified as this
currently does not take app_offset into account.

                /* Check if the provided plane buffer is large enough */
                if (planes[plane].length < q->plane_sizes[plane]) {
                        ret = -EINVAL;
                        goto err;
                }


I think there are some subtleties that we don't know about yet, so implementing
this in a real driver would hopefully bring those subtleties out in the open.

Regards,

	Hans
