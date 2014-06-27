Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2141 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaF0Pk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 11:40:58 -0400
Message-ID: <53AD9081.9090605@xs4all.nl>
Date: Fri, 27 Jun 2014 17:40:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] saa7134: fix regression with
 tvtime
References: <E1WkFfc-0005NC-OA@www.linuxtv.org>
In-Reply-To: <E1WkFfc-0005NC-OA@www.linuxtv.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is this in the queue for v3.14 and 3.15? I haven't seen any email about it
being added to either of those kernels, but the patch should have been mailed
to the stable mailinglist. It has been merged into 3.16.

Was it perhaps missed somehow?

Regards,

	Hans

On 05/13/2014 06:23 PM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] saa7134: fix regression with tvtime
> Author:  Hans Verkuil <hans.verkuil@cisco.com>
> Date:    Thu Apr 17 07:24:31 2014 -0300
>
> This solves this bug:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=73361
>
> The problem is that when you quit tvtime it calls STREAMOFF, but then it queues a
> bunch of buffers for no good reason before closing the file descriptor.
>
> In the past closing the fd would free the vb queue since that was part of the file
> handle struct. Since that was moved to the global struct that no longer happened.
>
> This wouldn't be a problem, but the extra QBUF calls that tvtime does meant that
> the buffer list in videobuf (q->stream) contained buffers, so REQBUFS would fail
> with -EBUSY.
>
> The solution is to init the list head explicitly when releasing the file
> descriptor and to not free the video resource when calling streamoff.
>
> The real fix will hopefully go into kernel 3.16 when the vb2 conversion is
> merged. Basically the saa7134 driver with the old videobuf is so full of holes it
> ain't funny anymore, so consider this a band-aid for kernels 3.14 and 15.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: stable@vger.kernel.org      # for v3.14 and up
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>
>   drivers/media/pci/saa7134/saa7134-video.c |    9 +++------
>   1 files changed, 3 insertions(+), 6 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=17e7f1b515803e1a79b246688aacbddd2e34165d
>
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index eb472b5..40396e8 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1243,6 +1243,7 @@ static int video_release(struct file *file)
>   		videobuf_streamoff(&dev->cap);
>   		res_free(dev, fh, RESOURCE_VIDEO);
>   		videobuf_mmap_free(&dev->cap);
> +		INIT_LIST_HEAD(&dev->cap.stream);
>   	}
>   	if (dev->cap.read_buf) {
>   		buffer_release(&dev->cap, dev->cap.read_buf);
> @@ -1254,6 +1255,7 @@ static int video_release(struct file *file)
>   		videobuf_stop(&dev->vbi);
>   		res_free(dev, fh, RESOURCE_VBI);
>   		videobuf_mmap_free(&dev->vbi);
> +		INIT_LIST_HEAD(&dev->vbi.stream);
>   	}
>
>   	/* ts-capture will not work in planar mode, so turn it off Hac: 04.05*/
> @@ -1987,17 +1989,12 @@ int saa7134_streamoff(struct file *file, void *priv,
>   					enum v4l2_buf_type type)
>   {
>   	struct saa7134_dev *dev = video_drvdata(file);
> -	int err;
>   	int res = saa7134_resource(file);
>
>   	if (res != RESOURCE_EMPRESS)
>   		pm_qos_remove_request(&dev->qos_request);
>
> -	err = videobuf_streamoff(saa7134_queue(file));
> -	if (err < 0)
> -		return err;
> -	res_free(dev, priv, res);
> -	return 0;
> +	return videobuf_streamoff(saa7134_queue(file));
>   }
>   EXPORT_SYMBOL_GPL(saa7134_streamoff);
>
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
>
