Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9LMHCA000347
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 16:22:17 -0500
Received: from mailrelay010.isp.belgacom.be (mailrelay010.isp.belgacom.be
	[195.238.6.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9LM6to031260
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 16:22:06 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Bryan Wu <cooloney@kernel.org>
Date: Sun, 9 Nov 2008 22:22:17 +0100
References: <1225963130-6784-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1225963130-6784-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811092222.18047.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, linux-uvc-devel@lists.berlios.de,
	linux-kernel@vger.kernel.org,
	Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Bryan, Michael,

On Thursday 06 November 2008, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
> Add NOMMU mmap support.
>
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/media/video/uvc/uvc_v4l2.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 758dfef..2237f5e 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -1050,6 +1050,7 @@ static int uvc_v4l2_mmap(struct file *file, struct
> vm_area_struct *vma) break;
>  	}
>
> +#ifdef CONFIG_MMU
>  	if (i == video->queue.count || size != video->queue.buf_size) {
>  		ret = -EINVAL;
>  		goto done;
> @@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file *file, struct
> vm_area_struct *vma) addr += PAGE_SIZE;
>  		size -= PAGE_SIZE;
>  	}
> +#else
> +	if (i == video->queue.count ||
> +		PAGE_ALIGN(size) != video->queue.buf_size) {

Just out of curiosity, why do you need to PAGE_ALIGN size for non-MMU 
platforms ?

> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	vma->vm_flags |= VM_IO | VM_MAYSHARE; /* documentation/nommu-mmap.txt */

VM_MAYSHARE is not documented anywhere in Documentation/ in Linux 2.6.28-rc3. 
Why is it needed for non-MMU architectures only ?

> +
> +	addr = (unsigned long)video->queue.mem + buffer->buf.m.offset;
>
> +	vma->vm_start = addr;
> +	vma->vm_end = addr +  video->queue.buf_size;
> +#endif
>  	vma->vm_ops = &uvc_vm_ops;
>  	vma->vm_private_data = buffer;
>  	uvc_vm_open(vma);

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
