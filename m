Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:57773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1IQUz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 16:55:58 -0400
Date: Sat, 17 Sep 2011 22:54:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
In-Reply-To: <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
Message-ID: <Pine.LNX.4.64.1109172251140.31071@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One more clean-up possibility:

On Tue, 13 Sep 2011, Scott Jiang wrote:

> this is a v4l2 bridge driver for Blackfin video capture device,
> support ppi interface
> 
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
> ---

[snip]

> diff --git a/drivers/media/video/blackfin/bfin_capture.c b/drivers/media/video/blackfin/bfin_capture.c
> new file mode 100644
> index 0000000..24f89f2
> --- /dev/null
> +++ b/drivers/media/video/blackfin/bfin_capture.c
> @@ -0,0 +1,1099 @@

[snip]

> +static int __devinit bcap_probe(struct platform_device *pdev)
> +{
> +	struct bcap_device *bcap_dev;
> +	struct video_device *vfd;
> +	struct i2c_adapter *i2c_adap;
> +	struct bfin_capture_config *config;
> +	struct vb2_queue *q;
> +	int ret;
> +
> +	config = pdev->dev.platform_data;
> +	if (!config) {
> +		v4l2_err(pdev->dev.driver, "Unable to get board config\n");
> +		return -ENODEV;
> +	}
> +
> +	bcap_dev = kzalloc(sizeof(*bcap_dev), GFP_KERNEL);
> +	if (!bcap_dev) {
> +		v4l2_err(pdev->dev.driver, "Unable to alloc bcap_dev\n");
> +		return -ENOMEM;
> +	}
> +
> +	bcap_dev->cfg = config;
> +
> +	bcap_dev->ppi = create_ppi_instance(config->ppi_info);
> +	if (!bcap_dev->ppi) {
> +		v4l2_err(pdev->dev.driver, "Unable to create ppi\n");
> +		ret = -ENODEV;
> +		goto err_free_dev;
> +	}
> +	bcap_dev->ppi->priv = bcap_dev;
> +
> +	bcap_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(bcap_dev->alloc_ctx)) {
> +		ret = PTR_ERR(bcap_dev->alloc_ctx);
> +		goto err_free_ppi;
> +	}
> +
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		ret = -ENOMEM;
> +		v4l2_err(pdev->dev.driver, "Unable to alloc video device\n");
> +		goto err_cleanup_ctx;
> +	}
> +
> +	/* initialize field of video device */
> +	vfd->release            = video_device_release;
> +	vfd->fops               = &bcap_fops;
> +	vfd->ioctl_ops          = &bcap_ioctl_ops;
> +	vfd->tvnorms            = 0;
> +	vfd->v4l2_dev           = &bcap_dev->v4l2_dev;
> +	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
> +	strncpy(vfd->name, CAPTURE_DRV_NAME, sizeof(vfd->name));
> +	bcap_dev->video_dev     = vfd;
> +
> +	ret = v4l2_device_register(&pdev->dev, &bcap_dev->v4l2_dev);
> +	if (ret) {
> +		v4l2_err(pdev->dev.driver,
> +				"Unable to register v4l2 device\n");
> +		goto err_release_vdev;
> +	}
> +	v4l2_info(&bcap_dev->v4l2_dev, "v4l2 device registered\n");
> +
> +	spin_lock_init(&bcap_dev->lock);
> +	/* initialize queue */
> +	q = &bcap_dev->buffer_queue;
> +	memset(q, 0, sizeof(*q));

This is superfluous: bcap_dev is allocated with kzalloc().

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
