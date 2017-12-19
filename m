Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38864 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762404AbdLSL5s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:57:48 -0500
Date: Tue, 19 Dec 2017 12:57:42 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
Message-ID: <20171219115742.GB27115@w540>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-4-git-send-email-jacopo+renesas@jmondi.org>
 <2710170.YbEgzp5Yxe@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2710170.YbEgzp5Yxe@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
   a few more details on subdevice management

On Mon, Dec 11, 2017 at 06:15:23PM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> Thank you for the patch.
>
> [snip]
>
> > +static int ceu_sensor_bound(struct v4l2_async_notifier *notifier,
> > +			    struct v4l2_subdev *v4l2_sd,
> > +			    struct v4l2_async_subdev *asd)
> > +{
> > +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> > +	struct ceu_device *ceudev = v4l2_to_ceu(v4l2_dev);
> > +	struct ceu_subdev *ceu_sd = to_ceu_subdev(asd);
> > +
> > +	if (video_is_registered(&ceudev->vdev)) {
> > +		v4l2_err(&ceudev->v4l2_dev,
> > +			 "Video device registered before this sub-device.\n");
> > +		return -EBUSY;
>
> Can this happen ?
>
> > +	}
> > +
> > +	/* Assign subdevices in the order they appear */
> > +	ceu_sd->v4l2_sd = v4l2_sd;
> > +	ceudev->num_sd++;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ceu_sensor_complete(struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> > +	struct ceu_device *ceudev = v4l2_to_ceu(v4l2_dev);
> > +	struct video_device *vdev = &ceudev->vdev;
> > +	struct vb2_queue *q = &ceudev->vb2_vq;
> > +	struct v4l2_subdev *v4l2_sd;
> > +	int ret;
> > +
> > +	/* Initialize vb2 queue */
> > +	q->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	q->io_modes		= VB2_MMAP | VB2_USERPTR;
>
> No dmabuf ?
>
> > +	q->drv_priv		= ceudev;
> > +	q->ops			= &ceu_videobuf_ops;
> > +	q->mem_ops		= &vb2_dma_contig_memops;
> > +	q->buf_struct_size	= sizeof(struct ceu_buffer);
> > +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +	q->lock			= &ceudev->mlock;
> > +	q->dev			= ceudev->v4l2_dev.dev;
>
> [snip]
>
> > +static int ceu_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct ceu_device *ceudev;
> > +	struct resource *res;
> > +	void __iomem *base;
> > +	unsigned int irq;
> > +	int num_sd;
> > +	int ret;
> > +
> > +	ceudev = kzalloc(sizeof(*ceudev), GFP_KERNEL);
>
> The memory is freed in ceu_vdev_release() as expected, but that will only work
> if the video device is registered. If the subdevs are never bound, the ceudev
> memory will be leaked if you unbind the CEU device from its driver. In my
> opinion this calls for registering the video device at probe time (although
> Hans disagrees).
>
> > +	if (!ceudev)
> > +		return -ENOMEM;
> > +
> > +	platform_set_drvdata(pdev, ceudev);
> > +	dev_set_drvdata(dev, ceudev);
>
> You don't need the second line, platform_set_drvdata() is a wrapper around
> dev_set_drvdata().
>
> > +	ceudev->dev = dev;
> > +
> > +	INIT_LIST_HEAD(&ceudev->capture);
> > +	spin_lock_init(&ceudev->lock);
> > +	mutex_init(&ceudev->mlock);
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (IS_ERR(res))
> > +		return PTR_ERR(res);
>
> No need for error handling here, devm_ioremap_resource() will check the res
> pointer.
>
> > +	base = devm_ioremap_resource(dev, res);
>
> You can assign ceudev->base directly and remove the base local variable.
>
> > +	if (IS_ERR(base))
> > +		return PTR_ERR(base);
> > +	ceudev->base = base;
> > +
> > +	ret = platform_get_irq(pdev, 0);
> > +	if (ret < 0) {
> > +		dev_err(dev, "failed to get irq: %d\n", ret);
> > +		return ret;
> > +	}
> > +	irq = ret;
> > +
> > +	ret = devm_request_irq(dev, irq, ceu_irq,
> > +			       0, dev_name(dev), ceudev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Unable to register CEU interrupt.\n");
> > +		return ret;
> > +	}
> > +
> > +	pm_suspend_ignore_children(dev, true);
> > +	pm_runtime_enable(dev);
> > +
> > +	ret = v4l2_device_register(dev, &ceudev->v4l2_dev);
> > +	if (ret)
> > +		goto error_pm_disable;
> > +
> > +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
> > +		num_sd = ceu_parse_dt(ceudev);
> > +	} else if (dev->platform_data) {
> > +		num_sd = ceu_parse_platform_data(ceudev, dev->platform_data);
> > +	} else {
> > +		dev_err(dev, "CEU platform data not set and no OF support\n");
> > +		ret = -EINVAL;
> > +		goto error_v4l2_unregister;
> > +	}
> > +
> > +	if (num_sd < 0) {
> > +		ret = num_sd;
> > +		goto error_v4l2_unregister;
> > +	} else if (num_sd == 0)
> > +		return 0;
>
> You need braces around the second statement too.

Ok, actually parse_dt() and parse_platform_data() behaves differently.
The former returns error if no subdevices are connected to CEU, the
latter returns 0. That's wrong.

I wonder what's the correct behavior here. Other mainline drivers I
looked into (pxa_camera and atmel-isc) behaves differently from each
other, so I guess this is up to each platform to decide.

Also, the CEU can accept one single input (and I made it clear
in DT bindings documentation saying it accepts a single endpoint,
while I'm parsing all the available ones in driver, I will fix this)
but as it happens on Migo-R, there could be HW hacks to share the input
lines between multiple subdevices. Should I accept it from dts as well?

So:
1) Should we fail to probe if no subdevices are connected?
2) Should we accept more than 1 subdevice from dts as it happens right
now for platform data?

Thanks
   j

>
> [snip]
>
> > +static const struct dev_pm_ops ceu_pm_ops = {
> > +	SET_RUNTIME_PM_OPS(ceu_runtime_suspend,
> > +			   ceu_runtime_resume,
> > +			   NULL)
>
> You'll probably need system PM ops eventually, but for now this isn't a
> regression so I won't complain too much.
>
> > +};
>
> [snip]
>
> --
> Regards,
>
> Laurent Pinchart
>
