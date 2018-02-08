Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:19175 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbeBHSRr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 13:17:47 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: RE: [PATCH] media: intel-ipu3: cio2: Synchronize irqs at
 stop_streaming
Date: Thu, 8 Feb 2018 18:17:43 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AEE4434@ORSMSX106.amr.corp.intel.com>
References: <1518043670-4602-1-git-send-email-yong.zhi@intel.com>
 <20180208073811.ie5c2x6o3vbxvxqi@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180208073811.ie5c2x6o3vbxvxqi@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Wednesday, February 7, 2018 11:38 PM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com;
> tfiga@chromium.org; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Zheng, Jian
> Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
> <rajmohan.mani@intel.com>
> Subject: Re: [PATCH] media: intel-ipu3: cio2: Synchronize irqs at
> stop_streaming
> 
> Hi Yong,
> 
> On Wed, Feb 07, 2018 at 02:47:50PM -0800, Yong Zhi wrote:
> > This is to avoid pending interrupts to be handled during stream off,
> > in which case, the ready buffer will be removed from buffer list, thus
> > not all buffers can be returned to VB2 as expected. Disable CIO2 irq
> > at cio2_hw_exit() so no new interrupts are generated.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> > ---
> >  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > index 725973f..8d75146 100644
> > --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > @@ -518,6 +518,8 @@ static void cio2_hw_exit(struct cio2_device *cio2,
> struct cio2_queue *q)
> >  	unsigned int i, maxloops = 1000;
> >
> >  	/* Disable CSI receiver and MIPI backend devices */
> > +	writel(0, q->csi_rx_base + CIO2_REG_IRQCTRL_MASK);
> > +	writel(0, q->csi_rx_base + CIO2_REG_IRQCTRL_ENABLE);
> >  	writel(0, q->csi_rx_base + CIO2_REG_CSIRX_ENABLE);
> >  	writel(0, q->csi_rx_base + CIO2_REG_MIPIBE_ENABLE);
> >
> > @@ -1027,6 +1029,7 @@ static void cio2_vb2_stop_streaming(struct
> vb2_queue *vq)
> >  			"failed to stop sensor streaming\n");
> >
> >  	cio2_hw_exit(cio2, q);
> > +	synchronize_irq(cio2->pci_dev->irq);
> 
> Shouldn't this be put in cio2_hw_exit(), which is called from multiple
> locations? Presumably the same issue exists there, too.
> 

Thanks for catching this, cio2_hw_exit() is used at two other places, and only one of them is subject to racing, so I will add synchronize_irq there in next update if it's OK.

> >  	cio2_vb2_return_all_buffers(q, VB2_BUF_STATE_ERROR);
> >  	media_pipeline_stop(&q->vdev.entity);
> >  	pm_runtime_put(&cio2->pci_dev->dev);
> 
> --
> Regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
