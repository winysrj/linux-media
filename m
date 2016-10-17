Return-path: <linux-media-owner@vger.kernel.org>
Received: from eumx.net ([91.82.101.43]:60655 "EHLO owm.eumx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933289AbcJQLbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 07:31:36 -0400
Subject: Re: [PATCH v2 08/21] [media] imx: Add i.MX IPUv3 capture driver
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <1476466481-24030-9-git-send-email-p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
From: Jack Mitchell <ml@embed.me.uk>
Message-ID: <a5a06050-f6e7-2031-4b14-312f085c5644@embed.me.uk>
Date: Mon, 17 Oct 2016 12:32:15 +0100
MIME-Version: 1.0
In-Reply-To: <1476466481-24030-9-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

I'm looking at how I would enable a parallel greyscale camera using this 
set of drivers and am a little bit confused. Do you have an example 
somewhere of a devicetree with an input node. I also have a further note 
below:

<snip>

> +
> +static int ipu_capture_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct ipu_capture *priv = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *csi_sd = priv->csi_sd;
> +	u32 width = priv->format.fmt.pix.width;
> +	u32 height = priv->format.fmt.pix.height;
> +	struct device *dev = priv->dev;
> +	int burstsize;
> +	struct ipu_capture_buffer *buf;
> +	int nfack_irq;
> +	int ret;
> +	const char *irq_name[2] = { "CSI0", "CSI1" };
> +	bool raw;
> +
> +	ret = ipu_capture_get_resources(priv);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to get resources: %d\n", ret);
> +		goto err_dequeue;
> +	}
> +
> +	ipu_cpmem_zero(priv->ipuch);
> +
> +	nfack_irq = ipu_idmac_channel_irq(priv->ipu, priv->ipuch,
> +					  IPU_IRQ_NFACK);
> +	ret = request_threaded_irq(nfack_irq, NULL,
> +				   ipu_capture_new_frame_handler, IRQF_ONESHOT,
> +				   irq_name[priv->id], priv);
> +	if (ret) {
> +		dev_err(dev, "Failed to request NFACK interrupt: %d\n", nfack_irq);
> +		goto put_resources;
> +	}
> +
> +	dev_dbg(dev, "width: %d height: %d, %.4s\n",
> +		width, height, (char *)&priv->format.fmt.pix.pixelformat);
> +
> +	ipu_cpmem_set_resolution(priv->ipuch, width, height);
> +
> +	raw = false;
> +
> +	if (raw && priv->smfc) {

How does this ever get used? If I were to set 1X8 greyscale it wouldn't 
ever take this path, correct?

> +		/*
> +		 * raw formats. We can only pass them through to memory
> +		 */
> +		u32 fourcc = priv->format.fmt.pix.pixelformat;
> +		int bytes;
> +
> +		switch (fourcc) {
> +		case V4L2_PIX_FMT_GREY:
> +			bytes = 1;
> +			break;
> +		case V4L2_PIX_FMT_Y10:
> +		case V4L2_PIX_FMT_Y16:
> +		case V4L2_PIX_FMT_UYVY:
> +		case V4L2_PIX_FMT_YUYV:
> +			bytes = 2;
> +			break;
> +		}
> +
> +		ipu_cpmem_set_stride(priv->ipuch, width * bytes);
> +		ipu_cpmem_set_format_passthrough(priv->ipuch, bytes * 8);
> +		/*
> +		 * According to table 37-727 (SMFC Burst Size), burstsize should
> +		 * be set to NBP[6:4] for PFS == 6. Unfortunately, with a 16-bit
> +		 * bus any value below 4 doesn't produce proper images.
> +		 */
> +		burstsize = (64 / bytes) >> 3;
> +	} else {
> +		/*
> +		 * formats we understand, we can write it in any format not requiring
> +		 * colorspace conversion.
> +		 */
> +		u32 fourcc = priv->format.fmt.pix.pixelformat;
> +
> +		switch (fourcc) {
> +		case V4L2_PIX_FMT_RGB32:
> +			ipu_cpmem_set_stride(priv->ipuch, width * 4);
> +			ipu_cpmem_set_fmt(priv->ipuch, fourcc);
> +			break;
> +		case V4L2_PIX_FMT_UYVY:
> +		case V4L2_PIX_FMT_YUYV:
> +			ipu_cpmem_set_stride(priv->ipuch, width * 2);
> +			ipu_cpmem_set_yuv_interleaved(priv->ipuch, fourcc);
> +			break;
> +		case V4L2_PIX_FMT_YUV420:
> +		case V4L2_PIX_FMT_YVU420:
> +		case V4L2_PIX_FMT_NV12:
> +		case V4L2_PIX_FMT_YUV422P:
> +			ipu_cpmem_set_stride(priv->ipuch, width);
> +			ipu_cpmem_set_fmt(priv->ipuch, fourcc);
> +			ipu_cpmem_set_yuv_planar(priv->ipuch, fourcc,
> +						 width, height);
> +			burstsize = 16;
> +			break;
> +		default:
> +			dev_err(dev, "invalid color format: %4.4s\n",
> +				(char *)&fourcc);
> +			ret = -EINVAL;
> +			goto free_irq;
> +		}
> +	}
> +

<snip>
