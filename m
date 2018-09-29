Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-2.mail.aliyun.com ([115.124.20.2]:39831 "EHLO
        out20-2.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbeI2Qra (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 12:47:30 -0400
Date: Sat, 29 Sep 2018 18:18:44 +0800
From: Yong <yong.deng@magewell.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thierry Reding <treding@nvidia.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v11 2/2] media: V3s: Add support for Allwinner CSI.
Message-Id: <20180929181844.87fd7560cc560f268df3c7b4@magewell.com>
In-Reply-To: <20180928101937.wdlrgezxoqzua5ke@paasikivi.fi.intel.com>
References: <1537951420-24752-1-git-send-email-yong.deng@magewell.com>
        <20180928101937.wdlrgezxoqzua5ke@paasikivi.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Fri, 28 Sep 2018 13:19:37 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> wrote:

> Hi Yong,
> 
> Thanks for the update! This looks pretty good; some small bits to fix
> still, please see my comments below.
> 
> On Wed, Sep 26, 2018 at 04:43:40PM +0800, Yong Deng wrote:
> > Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > interface and CSI1 is used for parallel interface. This is not
> > documented in datasheet but by test and guess.
> > 
> > This patch implement a v4l2 framework driver for it.
> > 
> > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > ISP's support are not included in this patch.
> > 

...

> > +
> > +static void sun6i_csi_v4l2_cleanup(struct sun6i_csi *csi)
> > +{
> > +	v4l2_async_notifier_unregister(&csi->notifier);
> > +	v4l2_async_notifier_cleanup(&csi->notifier);
> > +	sun6i_video_cleanup(&csi->video);
> > +	v4l2_device_unregister(&csi->v4l2_dev);
> > +	media_device_unregister(&csi->media_dev);
> 
> Please unregister the media device as first.

I notice that the release order of intel ipu3 is:
    cio2_notifier_exit(cio2);
    cio2_fbpt_exit_dummy(cio2);
    for (i = 0; i < CIO2_QUEUES; i++) 
        cio2_queue_exit(cio2, &cio2->queue[i]);
    v4l2_device_unregister(&cio2->v4l2_dev);
    media_device_unregister(&cio2->media_dev);
    media_device_cleanup(&cio2->media_dev);
    mutex_destroy(&cio2->lock);

> 
> You're missing freeing the control handler.
> 
> > +	media_device_cleanup(&csi->media_dev);
> > +}
> > +
> > +static int sun6i_csi_v4l2_init(struct sun6i_csi *csi)
> > +{
> > +	int ret;
> > +
> > +	csi->media_dev.dev = csi->dev;
> > +	strlcpy(csi->media_dev.model, "Allwinner Video Capture Device",
> > +		sizeof(csi->media_dev.model));
> 
> strscpy, please.
> 
> > +	csi->media_dev.hw_revision = 0;
> > +
> > +	media_device_init(&csi->media_dev);
> > +
> > +	ret = v4l2_ctrl_handler_init(&csi->ctrl_handler, 0);
> 
> Do you need controls? The driver doesn't appear to register any.

Some one suggest this. They want the drver can pass control queries to 
the subdev.

> 
> > +	if (ret) {
> > +		dev_err(csi->dev, "V4L2 controls handler init failed (%d)\n",
> > +			ret);
> > +		goto clean_media;
> > +	}
> > +
> > +	csi->v4l2_dev.mdev = &csi->media_dev;
> > +	csi->v4l2_dev.ctrl_handler = &csi->ctrl_handler;
> > +	ret = v4l2_device_register(csi->dev, &csi->v4l2_dev);
> > +	if (ret) {
> > +		dev_err(csi->dev, "V4L2 device registration failed (%d)\n",

...

> > +
> > +/*
> > + * PHYS_OFFSET isn't available on all architectures. In order to
> > + * accomodate for COMPILE_TEST, let's define it to something dumb.
> > + */
> > +#ifndef PHYS_OFFSET
> 
> How about:
> 
> #if !defined(CONFIG_COMPILE_TEST) && !defined(PHYS_OFFSET)

Do you mean:
#if defined(CONFIG_COMPILE_TEST) && !defined(PHYS_OFFSET)

> 
> Or something alike. That avoids things going horribly wrong if PHYS_OFFSET
> is undefined for a different reason.
> 
> > +#define PHYS_OFFSET 0
> > +#endif
> > +
> > +static int sun6i_csi_probe(struct platform_device *pdev)
> > +{
> > +	struct sun6i_csi_dev *sdev;
> > +	int ret;
> > +

...

> > +
> > +static const struct v4l2_ioctl_ops sun6i_video_ioctl_ops = {
> > +	.vidioc_querycap		= vidioc_querycap,
> > +	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
> > +	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
> > +	.vidioc_s_fmt_vid_cap		= vidioc_s_fmt_vid_cap,
> > +	.vidioc_try_fmt_vid_cap		= vidioc_try_fmt_vid_cap,
> > +
> > +	.vidioc_enum_input		= vidioc_enum_input,
> > +	.vidioc_s_input			= vidioc_s_input,
> > +	.vidioc_g_input			= vidioc_g_input,
> > +
> > +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> > +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> > +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> > +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> > +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> > +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> > +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> > +	.vidioc_streamon		= vb2_ioctl_streamon,
> > +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> > +
> > +	.vidioc_log_status		= v4l2_ctrl_log_status,
> > +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> > +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> 
> Do you need events? The driver doesn't seem to be using controls for
> anything and I see no trace of events otherwise either.
> 

I am not sure. The reason is same as ctrl handler.


Thanks,
Yong
