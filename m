Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F9EC282D5
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 08:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 762B921873
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 08:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbfA3I7K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 03:59:10 -0500
Received: from mga05.intel.com ([192.55.52.43]:11355 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730331AbfA3I7H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 03:59:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2019 00:59:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,540,1539673200"; 
   d="scan'208";a="295606398"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005.jf.intel.com with ESMTP; 30 Jan 2019 00:59:03 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 0B489203F8; Wed, 30 Jan 2019 10:59:01 +0200 (EET)
Date:   Wed, 30 Jan 2019 10:59:01 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Rajmohan Mani <rajmohan.mani@intel.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com, Zhi@paasikivi.fi.intel.com,
        Yong <yong.zhi@intel.com>, hverkuil@xs4all.nl, tfiga@chromium.org
Subject: Re: [PATCH] media: staging/intel-ipu3: Implement lock for stream
 on/off operations
Message-ID: <20190130085901.w2ogdoax7t4yfyj6@paasikivi.fi.intel.com>
References: <20190129222736.6216-1-rajmohan.mani@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190129222736.6216-1-rajmohan.mani@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rajmohan,

On Tue, Jan 29, 2019 at 02:27:36PM -0800, Rajmohan Mani wrote:
> Currently concurrent stream off operations on ImgU nodes are not
> synchronized, leading to use-after-free bugs (as reported by KASAN).
> 
> [  250.090724] BUG: KASAN: use-after-free in ipu3_dmamap_free+0xc5/0x116 [ipu3_imgu]
> [  250.090726] Read of size 8 at addr ffff888127b29bc0 by task yavta/18836
> [  250.090731] Hardware name: HP Soraka/Soraka, BIOS Google_Soraka.10431.17.0 03/22/2018
> [  250.090732] Call Trace:
> [  250.090735]  dump_stack+0x6a/0xb1
> [  250.090739]  print_address_description+0x8e/0x279
> [  250.090743]  ? ipu3_dmamap_free+0xc5/0x116 [ipu3_imgu]
> [  250.090746]  kasan_report+0x260/0x28a
> [  250.090750]  ipu3_dmamap_free+0xc5/0x116 [ipu3_imgu]
> [  250.090754]  ipu3_css_pool_cleanup+0x24/0x37 [ipu3_imgu]
> [  250.090759]  ipu3_css_pipeline_cleanup+0x61/0xb9 [ipu3_imgu]
> [  250.090763]  ipu3_css_stop_streaming+0x1f2/0x321 [ipu3_imgu]
> [  250.090768]  imgu_s_stream+0x94/0x443 [ipu3_imgu]
> [  250.090772]  ? ipu3_vb2_buf_queue+0x280/0x280 [ipu3_imgu]
> [  250.090775]  ? vb2_dma_sg_unmap_dmabuf+0x16/0x6f [videobuf2_dma_sg]
> [  250.090778]  ? vb2_buffer_in_use+0x36/0x58 [videobuf2_common]
> [  250.090782]  ipu3_vb2_stop_streaming+0xf9/0x135 [ipu3_imgu]
> 
> Implemented a lock to synchronize imgu stream on / off operations and
> the modification of streaming flag (in struct imgu_device), to prevent
> these issues.
> 
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
>  drivers/staging/media/ipu3/ipu3-v4l2.c | 6 ++++++
>  drivers/staging/media/ipu3/ipu3.c      | 3 +++
>  drivers/staging/media/ipu3/ipu3.h      | 4 ++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
> index c7936032beb9..cf7e917cd0c8 100644
> --- a/drivers/staging/media/ipu3/ipu3-v4l2.c
> +++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
> @@ -507,12 +507,15 @@ static int ipu3_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
>  			goto fail_stop_pipeline;
>  	}
>  
> +	mutex_lock(&imgu->streaming_lock);
> +

You appear to be using imgu_device.lock (while searching buffers to queue
to the device) as well as imgu_video_device.lock (qbuf, dqbuf) to serialise
access to imgu_video_device.buffers list. The two locks may be acquired at
the same time but each by different processes. That needs to be addressed,
but probably not in this patch.

I wonder if it'd be more simple to use imgu->lock here instead of adding a
new one.

>  	/* Start streaming of the whole pipeline now */
>  	dev_dbg(dev, "IMGU streaming is ready to start");
>  	r = imgu_s_stream(imgu, true);
>  	if (!r)
>  		imgu->streaming = true;
>  
> +	mutex_unlock(&imgu->streaming_lock);
>  	return 0;
>  
>  fail_stop_pipeline:
> @@ -543,6 +546,8 @@ static void ipu3_vb2_stop_streaming(struct vb2_queue *vq)
>  		dev_err(&imgu->pci_dev->dev,
>  			"failed to stop subdev streaming\n");
>  
> +	mutex_lock(&imgu->streaming_lock);
> +
>  	/* Was this the first node with streaming disabled? */
>  	if (imgu->streaming && ipu3_all_nodes_streaming(imgu, node)) {
>  		/* Yes, really stop streaming now */
> @@ -552,6 +557,7 @@ static void ipu3_vb2_stop_streaming(struct vb2_queue *vq)
>  			imgu->streaming = false;
>  	}
>  
> +	mutex_unlock(&imgu->streaming_lock);
>  	ipu3_return_all_buffers(imgu, node, VB2_BUF_STATE_ERROR);

>  	media_pipeline_stop(&node->vdev.entity);
>  }
> diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
> index d521b3afb8b1..2daee51cd845 100644
> --- a/drivers/staging/media/ipu3/ipu3.c
> +++ b/drivers/staging/media/ipu3/ipu3.c
> @@ -635,6 +635,7 @@ static int imgu_pci_probe(struct pci_dev *pci_dev,
>  		return r;
>  
>  	mutex_init(&imgu->lock);
> +	mutex_init(&imgu->streaming_lock);
>  	atomic_set(&imgu->qbuf_barrier, 0);
>  	init_waitqueue_head(&imgu->buf_drain_wq);
>  
> @@ -699,6 +700,7 @@ static int imgu_pci_probe(struct pci_dev *pci_dev,
>  	ipu3_css_set_powerdown(&pci_dev->dev, imgu->base);
>  out_mutex_destroy:
>  	mutex_destroy(&imgu->lock);
> +	mutex_destroy(&imgu->streaming_lock);
>  
>  	return r;
>  }
> @@ -716,6 +718,7 @@ static void imgu_pci_remove(struct pci_dev *pci_dev)
>  	ipu3_dmamap_exit(imgu);
>  	ipu3_mmu_exit(imgu->mmu);
>  	mutex_destroy(&imgu->lock);
> +	mutex_destroy(&imgu->streaming_lock);
>  }
>  
>  static int __maybe_unused imgu_suspend(struct device *dev)
> diff --git a/drivers/staging/media/ipu3/ipu3.h b/drivers/staging/media/ipu3/ipu3.h
> index 04fc99f47ebb..f732315f0701 100644
> --- a/drivers/staging/media/ipu3/ipu3.h
> +++ b/drivers/staging/media/ipu3/ipu3.h
> @@ -146,6 +146,10 @@ struct imgu_device {
>  	 * vid_buf.list and css->queue
>  	 */
>  	struct mutex lock;
> +
> +	/* Lock to protect writes to streaming flag in this struct */
> +	struct mutex streaming_lock;
> +
>  	/* Forbit streaming and buffer queuing during system suspend. */
>  	atomic_t qbuf_barrier;
>  	/* Indicate if system suspend take place while imgu is streaming. */

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
