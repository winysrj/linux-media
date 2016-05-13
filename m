Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41301 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbcEMJJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 05:09:26 -0400
Subject: Re: [PATCH v2 1/2] vb2: core: Skip planes array verification if pb is
 NULL
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1463055292-25053-1-git-send-email-sakari.ailus@linux.intel.com>
 <1463055292-25053-2-git-send-email-sakari.ailus@linux.intel.com>
Cc: mchehab@osg.samsung.com, david@unsolicited.net,
	linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <573599BF.4050708@xs4all.nl>
Date: Fri, 13 May 2016 11:09:19 +0200
MIME-Version: 1.0
In-Reply-To: <1463055292-25053-2-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/12/2016 02:14 PM, Sakari Ailus wrote:
> An earlier patch fixing an input validation issue introduced another
> issue: vb2_core_dqbuf() is called with pb argument value NULL in some
> cases, causing a NULL pointer dereference. Fix this by skipping the
> verification as there's nothing to verify.
> 
> Signed-off-by: David R <david@unsolicited.net>
> 
> Use if () instead of ? :; it's nicer that way. Improve the comment in the
> code as well.

This comment doesn't seem applicable to this patch.

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

	Hans

> 
> Fixes: e7e0c3e26587 ("[media] videobuf2-core: Check user space planes array in dqbuf")
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org # for v4.4 and later
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 9fbcb67..633fc1a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1648,7 +1648,7 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
>  			     void *pb, int nonblocking)
>  {
>  	unsigned long flags;
> -	int ret;
> +	int ret = 0;
>  
>  	/*
>  	 * Wait for at least one buffer to become available on the done_list.
> @@ -1664,10 +1664,12 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
>  	spin_lock_irqsave(&q->done_lock, flags);
>  	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
>  	/*
> -	 * Only remove the buffer from done_list if v4l2_buffer can handle all
> -	 * the planes.
> +	 * Only remove the buffer from done_list if all planes can be
> +	 * handled. Some cases such as V4L2 file I/O and DVB have pb
> +	 * == NULL; skip the check then as there's nothing to verify.
>  	 */
> -	ret = call_bufop(q, verify_planes_array, *vb, pb);
> +	if (pb)
> +		ret = call_bufop(q, verify_planes_array, *vb, pb);
>  	if (!ret)
>  		list_del(&(*vb)->done_entry);
>  	spin_unlock_irqrestore(&q->done_lock, flags);
> 
