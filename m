Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1536 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1DDGYl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 02:24:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH 3/3] [media] vb2: prevent drivers from requesting too many buffers/planes.
Date: Mon, 4 Apr 2011 08:24:28 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com
References: <1301873937-14146-1-git-send-email-pawel@osciak.com> <1301873937-14146-3-git-send-email-pawel@osciak.com>
In-Reply-To: <1301873937-14146-3-git-send-email-pawel@osciak.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104040824.28092.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, April 04, 2011 01:38:57 Pawel Osciak wrote:
> Add a sanity check to make sure drivers do not adjust the number of buffers
> or planes above the supported limit on reqbufs.
> 
> Signed-off-by: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/video/videobuf2-core.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 6698c77..6e69584 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -529,6 +529,11 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  	if (ret)
>  		return ret;
>  
> +	/*
> +	 * Make sure driver did not request more buffers/planes than we can handle.
> +	 */
> +	BUG_ON (num_buffers > VIDEO_MAX_FRAME || num_planes > VIDEO_MAX_PLANES);
> +

I would make this a 'if' with a WARN_ON and error return. More debug-friendly.

Regards,

	Hans

>  	/* Finally, allocate buffers and video memory */
>  	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes,
>  				plane_sizes);
> 
