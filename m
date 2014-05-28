Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3591 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaE1Lbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 07:31:31 -0400
Message-ID: <5385C8D7.3090804@xs4all.nl>
Date: Wed, 28 May 2014 13:30:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Pawel Osciak <pawel@osciak.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] videobuf2: call __verify_length only for MMAP
 and USERPTR memory
References: <1401113934-29601-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1401113934-29601-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

I will have to look at this more carefully when I have more time. I'm not too
keen about having an exception for dmabuf. Perhaps this check should be moved
for all memory models.

On 05/26/14 16:18, Philipp Zabel wrote:
> For DMABUF memory, buffer length is allowed to be zero on QBUF because the
> actual buffer size can be taken from the DMABUF. Therefore, the length check
> can only be done later in __qbuf_dmabuf, once the dmabuf was obtained.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index f9059bb..434bdff 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1374,6 +1374,15 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  		if (planes[plane].length == 0)
>  			planes[plane].length = dbuf->size;
>  
> +		/* verify that the bytesused value fits in the plane length and
> +		 * that the data offset doesn't exceed the bytesused value.
> +		 */
> +		if ((planes[plane].bytesused > planes[plane].length) ||
> +		    (planes[plane].data_offset >= planes[plane].bytesused)) {

This is wrong, it should be:

		if ((planes[plane].bytesused > planes[plane].length) ||
		    (planes[plane].data_offset > 0 &&
		     planes[plane].data_offset >= planes[plane].bytesused)) {

just like what __verify_length does. In rare cases bytesused can be 0.

For the reason why see commit 3c5c23c57717bf134a3c3f4af5886c7e08500e34:

    [media] vb2: Allow queuing OUTPUT buffers with zeroed 'bytesused'
    
    Modify the bytesused/data_offset check to not fail if both bytesused
    and data_offset is set to 0. This should minimize possible issues in
    existing applications which worked before we enforced the plane lengths
    for output buffers checks introduced in commit 8023ed09cb278004a2
    "videobuf2-core: Verify planes lengths for output buffers"

Hmm, the length check should really be commented with that commit message
since it looks weird otherwise.

Regards,

	Hans

> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
>  		if (planes[plane].length < planes[plane].data_offset +
>  		    q->plane_sizes[plane]) {
>  			dprintk(1, "qbuf: invalid dmabuf length for plane %d\n",
> @@ -1488,9 +1497,10 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	struct rw_semaphore *mmap_sem;
> -	int ret;
> +	int ret = 0;
>  
> -	ret = __verify_length(vb, b);
> +	if (q->memory != V4L2_MEMORY_DMABUF)
> +		ret = __verify_length(vb, b);
>  	if (ret < 0) {
>  		dprintk(1, "%s(): plane parameters verification failed: %d\n",
>  			__func__, ret);
> @@ -1529,6 +1539,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  		up_read(mmap_sem);
>  		break;
>  	case V4L2_MEMORY_DMABUF:
> +		/* __qbuf_dmabuf verifies buffer length itself */
>  		ret = __qbuf_dmabuf(vb, b);
>  		break;
>  	default:
> 

