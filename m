Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:33966 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbdKEX2z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 18:28:55 -0500
Date: Fri, 3 Nov 2017 00:41:21 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, hyungwoo.yang@intel.com,
        chiranjeevi.rapolu@intel.com, jerry.w.hu@intel.com,
        Vijaykumar Ramya <ramya.vijaykumar@intel.com>
Subject: Re: [PATCH v7 3/3] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20171102224120.zp7adyuajwhag7ye@kekkonen.localdomain>
References: <1509652801-9729-1-git-send-email-yong.zhi@intel.com>
 <1509652801-9729-4-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509652801-9729-4-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Thanks for the update!

I took a final glance, there are a few matters that still need to be
addressed but then I think we're done. Please see below.

Then we'll need an entry in the MAINTAINERS file in the kernel root
directory. Could you add an entry for this driver in v8?

On Thu, Nov 02, 2017 at 03:00:01PM -0500, Yong Zhi wrote:
...
> +static int cio2_fbpt_rearrange(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	unsigned int i, j;
> +
> +	for (i = 0, j = q->bufs_first; i < CIO2_MAX_BUFFERS;
> +		i++, j = (j + 1) % CIO2_MAX_BUFFERS)
> +		if (q->bufs[j])
> +			break;
> +
> +	if (i == CIO2_MAX_BUFFERS)
> +		return 0;

You always return 0. The return type could be void.

You could also move this function just above the function using it (it's a
single location).

> +
> +	if (j) {
> +		arrange(q->fbpt, sizeof(struct cio2_fbpt_entry) * CIO2_MAX_LOPS,
> +			CIO2_MAX_BUFFERS, j);
> +		arrange(q->bufs, sizeof(struct cio2_buffer *),
> +			CIO2_MAX_BUFFERS, j);
> +	}
> +
> +	/*
> +	 * DMA clears the valid bit when accessing the buffer.
> +	 * When stopping stream in suspend callback, some of the buffers
> +	 * may be in invalid state. After resume, when DMA meets the invalid
> +	 * buffer, it will halt and stop receiving new data.
> +	 * To avoid DMA halting, set the valid bit for all buffers in FBPT.
> +	 */
> +	for (i = 0; i < CIO2_MAX_BUFFERS; i++)
> +		cio2_fbpt_entry_enable(cio2, q->fbpt + i * CIO2_MAX_LOPS);
> +
> +	return 0;
> +}

...

> +static int cio2_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct cio2_queue *q = vb2q_to_cio2_queue(vq);
> +	struct cio2_device *cio2 = vb2_get_drv_priv(vq);
> +	int r;
> +
> +	cio2->cur_queue = q;
> +	atomic_set(&q->frame_sequence, 0);
> +
> +	r = pm_runtime_get_sync(&cio2->pci_dev->dev);
> +	if (r < 0) {
> +		dev_info(&cio2->pci_dev->dev, "failed to set power %d\n", r);
> +		pm_runtime_put(&cio2->pci_dev->dev);
> +		return r;
> +	}
> +
> +	r = media_pipeline_start(&q->vdev.entity, &q->pipe);
> +	if (r)
> +		goto fail_pipeline;
> +
> +	r = cio2_hw_init(cio2, q);
> +	if (r)
> +		goto fail_hw;
> +
> +	/* Start streaming on sensor */
> +	r = v4l2_subdev_call(q->sensor, video, s_stream, 1);
> +	if (r)
> +		goto fail_csi2_subdev;
> +
> +	cio2->streaming = true;
> +
> +	return 0;
> +
> +fail_csi2_subdev:
> +	cio2_hw_exit(cio2, q);
> +fail_hw:
> +	media_pipeline_stop(&q->vdev.entity);
> +fail_pipeline:
> +	dev_dbg(&cio2->pci_dev->dev, "failed to start streaming (%d)\n", r);
> +	cio2_vb2_return_all_buffers(q);

I believe there should be

	pm_runtime_put(&cio2->pci_dev->dev);

here. You should also add a label and use goto from where you do
pm_runtime_put() in error handling in this function in order to make this
cleaner.

> +
> +	return r;
> +}

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
