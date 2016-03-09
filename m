Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40751 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932401AbcCIQKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 11:10:04 -0500
Subject: Re: [PATCH 6/7] [media] gspca: fix a v4l2-compliance failure during
 VIDIOC_REQBUFS
To: Antonio Ospite <ao2@ao2.it>,
	Linux Media <linux-media@vger.kernel.org>
References: <1457539401-11515-1-git-send-email-ao2@ao2.it>
 <1457539401-11515-7-git-send-email-ao2@ao2.it>
Cc: Hans de Goede <hdegoede@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E04AE3.5050409@xs4all.nl>
Date: Wed, 9 Mar 2016 17:10:11 +0100
MIME-Version: 1.0
In-Reply-To: <1457539401-11515-7-git-send-email-ao2@ao2.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/16 17:03, Antonio Ospite wrote:
> When calling VIDIOC_REQBUFS v4l2-compliance fails with this message:
> 
>   fail: v4l2-test-buffers.cpp(476): q.reqbufs(node, 1)
>   test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
> 
> By looking at the v4l2-compliance code the failure happens when trying
> to request V4L2_MEMORY_USERPTR buffers without freeing explicitly the
> previously allocated V4L2_MEMORY_MMAP buffers.
> 
> This would suggest that when changing the memory field in struct
> v4l2_requestbuffers the driver is supposed to free automatically any
> previous allocated buffers, and looking for inspiration at the code in
> drivers/media/v4l2-core/videobuf2-core.c::vb2_core_reqbufs() seems to
> confirm this interpretation; however gspca is just returning -EBUSY in
> this case.
> 
> Removing the special handling for the case of a different memory value
> fixes the compliance failure.
> 
> Signed-off-by: Antonio Ospite <ao2@ao2.it>
> ---
> 
> This should be safe, but I'd really like a comment from someone with a more
> global knowledge of v4l2.
> 
> If my interpretation about how drivers should behave when the value of the
> memory field changes is correct, I could send also a documentation update for
> Documentation/DocBook/media/v4l/vidioc-reqbufs.xml

Your interpretation is correct. Calling REQBUFS again should discard the old
buffers and re-allocate new ones. Except, of course, if the old buffers are
in use, then -EBUSY should be returned.

Regards,

	Hans

> 
> Just let me know.
> 
> Thanks,
>    Antonio
> 
> 
>  drivers/media/usb/gspca/gspca.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> index 84b0d6a..915b6c7 100644
> --- a/drivers/media/usb/gspca/gspca.c
> +++ b/drivers/media/usb/gspca/gspca.c
> @@ -1402,13 +1402,6 @@ static int vidioc_reqbufs(struct file *file, void *priv,
>  	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
>  		return -ERESTARTSYS;
>  
> -	if (gspca_dev->memory != GSPCA_MEMORY_NO
> -	    && gspca_dev->memory != GSPCA_MEMORY_READ
> -	    && gspca_dev->memory != rb->memory) {
> -		ret = -EBUSY;
> -		goto out;
> -	}
> -
>  	/* only one file may do the capture */
>  	if (gspca_dev->capt_file != NULL
>  	    && gspca_dev->capt_file != file) {
> 
