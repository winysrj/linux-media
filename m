Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11915 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1GRGbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 02:31:03 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LOI00DM3NFPE840@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jul 2011 07:31:01 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LOI00HHDNFO86@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jul 2011 07:31:00 +0100 (BST)
Date: Mon, 18 Jul 2011 08:30:13 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFCv1 PATCH 3/6] videobuf2: only start streaming in poll() if so
 requested by the poll mask.
In-reply-to: <7fc8ed81f08a0ac8092c5b6a8badc3427df9bc1e.1310549521.git.hans.verkuil@cisco.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: 'Hans Verkuil' <hans.verkuil@cisco.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <00c901cc4514$26629880$7327c980$%szyprowski@samsung.com>
Content-language: pl
References: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
 <7fc8ed81f08a0ac8092c5b6a8badc3427df9bc1e.1310549521.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, July 13, 2011 11:39 AM Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/media/video/videobuf2-core.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c
> index 3015e60..1892bb8 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1365,6 +1365,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
>   */
>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table
> *wait)
>  {
> +	unsigned long req_events = poll_requested_events(wait);
>  	unsigned long flags;
>  	unsigned int ret;
>  	struct vb2_buffer *vb = NULL;
> @@ -1373,12 +1374,14 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
> file *file, poll_table *wait)
>  	 * Start file I/O emulator only if streaming API has not been used
> yet.
>  	 */
>  	if (q->num_buffers == 0 && q->fileio == NULL) {
> -		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
> {
> +		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)
> &&
> +				(req_events & (POLLIN | POLLRDNORM))) {
>  			ret = __vb2_init_fileio(q, 1);
>  			if (ret)
>  				return POLLERR;
>  		}
> -		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
> {
> +		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)
> &&
> +				(req_events & (POLLOUT | POLLWRNORM))) {
>  			ret = __vb2_init_fileio(q, 0);
>  			if (ret)
>  				return POLLERR;
> --

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



