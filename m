Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38264 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbbBBOnj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 09:43:39 -0500
Message-ID: <1422888215.23897.1.camel@xs4all.nl>
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Raimonds Cicans <ray@apollo.lv>, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org
Date: Mon, 02 Feb 2015 15:43:35 +0100
In-Reply-To: <54CF4508.9070305@xs4all.nl>
References: <54B24370.6010004@apollo.lv> <54C9E238.9090101@xs4all.nl>
	 <54CA1EB4.8000103@apollo.lv> <54CA23BE.7050609@xs4all.nl>
	 <54CE24F2.7090400@apollo.lv> <54CF4508.9070305@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2015-02-02 at 10:36 +0100, Hans Verkuil wrote:
> On 02/01/2015 02:06 PM, Raimonds Cicans wrote:
> > On 29.01.2015 14:12, Hans Verkuil wrote:
> >> On 01/29/15 12:51, Raimonds Cicans wrote:
> >>> On 29.01.2015 09:33, Hans Verkuil wrote:
> >>>> On 01/11/2015 10:33 AM, Raimonds Cicans wrote:
> >>>>> I contacted you because I am hit by regression caused by your commit:
> >>>>> 453afdd "[media] cx23885: convert to vb2"
> >>>>>
> >>>>>
> >>>>> My system:
> >>>>> AMD Athlon(tm) II X2 240e Processor on Asus M5A97 LE R2.0 motherboard
> >>>>> TBS6981 card (Dual DVB-S/S2 PCIe receiver, cx23885 in kernel driver)
> >>>>>
> >>>>> After upgrade from kernel 3.13.10 (do not have commit) to 3.17.7
> >>>>> (have commit) I started receiving following IOMMU related messages:
> >>>>>
> >>>>> 1)
> >>>>> AMD-Vi: Event logged [IO_PAGE_FAULT device=0a:00.0 domain=0x001d
> >>>>> address=0x000000000637c000 flags=0x0000]
> >>>>>
> >>>>> where device=0a:00.0 is TBS6981 card
> >>>> As far as I can tell this has nothing to do with the cx23885 driver but is
> >>>> a bug in the amd iommu/BIOS. See e.g.:
> >>>>
> >>>> https://bbs.archlinux.org/viewtopic.php?pid=1309055
> >>>>
> >>>> I managed to reproduce the Intel equivalent if I enable CONFIG_IOMMU_SUPPORT.
> >>>>
> >>>> Most likely due to broken BIOS/ACPI/whatever information that's read by the
> >>>> kernel. I would recommend disabling this kernel option.
> >>>>
> >>> Maybe...
> >>>
> >>> But on other hand this did not happen on old kernel with old driver.
> >>> And when I did bisection on old kernel + media tree I started to
> >>> receive this message only on new driver.
> >> Was CONFIG_IOMMU_SUPPORT enabled in the old kernel?
> > 
> > zgrep CONFIG_IOMMU_SUPPORT /proc/config.gz
> > CONFIG_IOMMU_SUPPORT=y
> > 
> > 
> > Raimonds Cicans
> > 
Hi Hans,

> Raimonds and Jurgen,
> 
> Can you both test with the following patch applied to the driver:
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
> index 1ad4994..72df5ae 100644
> --- a/drivers/media/pci/cx23885/cx23885-core.c
> +++ b/drivers/media/pci/cx23885/cx23885-core.c
> @@ -1497,6 +1497,7 @@ void cx23885_buf_queue(struct cx23885_tsport *port, struct cx23885_buffer *buf)
>  	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_CNT_INC);
>  	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma + 12);
>  	buf->risc.jmp[2] = cpu_to_le32(0); /* bits 63-32 */
> +	wmb();
>  
>  	spin_lock_irqsave(&dev->slock, flags);
>  	if (list_empty(&cx88q->active)) {
> @@ -1505,10 +1506,12 @@ void cx23885_buf_queue(struct cx23885_tsport *port, struct cx23885_buffer *buf)
>  			buf, buf->vb.v4l2_buf.index, __func__);
>  	} else {
>  		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
> +		wmb();
>  		prev = list_entry(cx88q->active.prev, struct cx23885_buffer,
>  				  queue);
>  		list_add_tail(&buf->queue, &cx88q->active);
>  		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
> +		wmb();
>  		dprintk(1, "[%p/%d] %s - append to active\n",
>  			 buf, buf->vb.v4l2_buf.index, __func__);
>  	}
> 
> I wonder if there is some PCI write reordering going on that is causing some of the weird
> behavior that you see.
I'll test this patch on top of the other patches. So far the only
messages left are the mpeg errors.

Regards,
Jurgen


