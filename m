Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36936 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729762AbeKTCQ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 21:16:26 -0500
Message-ID: <24f4a902b8e07536e48998b68ea289019d8e23a2.camel@collabora.com>
Subject: Re: [PATCH] videobuf2-v4l2: drop WARN_ON in
 vb2_warn_zero_bytesused()
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 19 Nov 2018 12:52:21 -0300
In-Reply-To: <b3fae3d4-2370-d99a-b997-d6ae13cebe85@xs4all.nl>
References: <b3fae3d4-2370-d99a-b997-d6ae13cebe85@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-11-19 at 16:33 +0100, Hans Verkuil wrote:
> Userspace shouldn't set bytesused to 0 for output buffers.
> vb2_warn_zero_bytesused() warns about this (only once!), but it also
> calls WARN_ON(1), which is confusing since it is not immediately clear
> that it warns about a 0 value for bytesused.
> 
> Just drop the WARN_ON as it serves no purpose.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Ezequiel Garcia <ezequiel@collabora.com>

> ---
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index a17033ab2c22..713326ef4e72 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -158,7 +158,6 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
>  		return;
> 
>  	check_once = true;
> -	WARN_ON(1);
> 
>  	pr_warn("use of bytesused == 0 is deprecated and will be removed in the future,\n");
>  	if (vb->vb2_queue->allow_zero_bytesused)
