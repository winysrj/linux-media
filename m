Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58778 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727522AbeGPNQ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 09:16:26 -0400
Date: Mon, 16 Jul 2018 15:49:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] videobuf2-core: check for q->error in vb2_core_qbuf()
Message-ID: <20180716124906.hi34a2u5xftakx76@valkosipuli.retiisi.org.uk>
References: <ab3d5aa7-c06b-9918-235e-ff983cb5cce7@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab3d5aa7-c06b-9918-235e-ff983cb5cce7@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Jul 05, 2018 at 10:25:19AM +0200, Hans Verkuil wrote:
> The vb2_core_qbuf() function didn't check if q->error was set. It is checked in
> __buf_prepare(), but that function isn't called if the buffer was already
> prepared before with VIDIOC_PREPARE_BUF.
> 
> So check it at the start of vb2_core_qbuf() as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index d3501cd604cb..5d7946ec80d8 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1484,6 +1484,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>  	struct vb2_buffer *vb;
>  	int ret;
> 
> +	if (q->error) {
> +		dprintk(1, "fatal error occurred on queue\n");
> +		return -EIO;
> +	}
> +
>  	vb = q->bufs[index];
> 
>  	if ((req && q->uses_qbuf) ||

How long has this problem existed? It looks like something that should go
to the stable branches, too...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
