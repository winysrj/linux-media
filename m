Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40465 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756085AbbCCKOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 05:14:48 -0500
Message-ID: <54F58988.1040404@xs4all.nl>
Date: Tue, 03 Mar 2015 11:14:32 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	adi-buildroot-devel@lists.sourceforge.net
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 06/15] media: blackfin: bfin_capture: use vb2_fop_mmap/poll
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com> <1424544001-19045-7-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-7-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/2015 07:39 PM, Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> No need to reinvent the wheel. Just use the already existing
> functions provided by vb2.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/blackfin/bfin_capture.c | 28 +++-----------------------
>  1 file changed, 3 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index be0d0a2b..ee0e848 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -244,18 +244,6 @@ static int bcap_release(struct file *file)
>  	return 0;
>  }
>  
> -static int bcap_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	struct bcap_device *bcap_dev = video_drvdata(file);
> -	int ret;
> -
> -	if (mutex_lock_interruptible(&bcap_dev->mutex))
> -		return -ERESTARTSYS;
> -	ret = vb2_mmap(&bcap_dev->buffer_queue, vma);
> -	mutex_unlock(&bcap_dev->mutex);
> -	return ret;
> -}
> -
>  #ifndef CONFIG_MMU
>  static unsigned long bcap_get_unmapped_area(struct file *file,
>  					    unsigned long addr,
> @@ -273,17 +261,6 @@ static unsigned long bcap_get_unmapped_area(struct file *file,

This can also be replaced by vb2_fop_get_unmapped_area().

Patch is welcome :-)

Regards,

	Hans
