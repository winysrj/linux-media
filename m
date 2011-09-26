Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1IZLNz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:13:55 -0400
Message-ID: <4E805E6E.3080007@redhat.com>
Date: Mon, 26 Sep 2011 08:13:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-09-2011 12:13, Marek Szyprowski escreveu:
> Hello Mauro,
> 
> I've collected pending selection API patches together with pending
> videobuf2 and Samsung driver fixes to a single git branch. Please pull
> them to your media tree.
> 
> Best regards,
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> The following changes since commit 699cc1962c85351689c27dd46e598e4204fdd105:
> 
>   [media] TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder (2011-09-21 17:06:56 -0300)
> 
> are available in the git repository at:
>   git://git.infradead.org/users/kmpark/linux-2.6-samsung for_mauro

Continuing the patches review from this series:

0689133 [media] s5p-tv: fix mbus configuration
17b2747 [media] s5p-tv: hdmi: use DVI mode
0f6c565 [media] s5p-tv: Add PM_RUNTIME dependency

Applied, thanks!

> Scott Jiang (1):
>       vb2: add vb2_get_unmapped_area in vb2 core

> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index ea55c08..977410b 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -309,6 +309,13 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
>  int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
>  
>  int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
> +#ifndef CONFIG_MMU
> +unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
> +				    unsigned long addr,
> +				    unsigned long len,
> +				    unsigned long pgoff,
> +				    unsigned long flags);
> +#endif
>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
>  size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
>  		loff_t *ppos, int nonblock);

This sounds me like a hack, as it is passing the problem of working with a non-mmu
capable hardware to the driver, inserting architecture-dependent bits on them.

The proper way to do it is to provide a vb2 core support to handle the non-mmu case 
inside it.

Thanks,
Mauro
