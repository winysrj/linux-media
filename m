Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50040 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZLWW3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 17:29:18 -0500
MIME-Version: 1.0
In-Reply-To: <1261562933-26987-3-git-send-email-p.osciak@samsung.com>
References: <1261562933-26987-1-git-send-email-p.osciak@samsung.com>
	 <1261562933-26987-3-git-send-email-p.osciak@samsung.com>
Date: Thu, 24 Dec 2009 01:29:17 +0300
Message-ID: <208cbae30912231429o4821ca2fm9722532b0b277865@mail.gmail.com>
Subject: Re: [PATCH 2/2] [ARM] samsung-rotator: Add Samsung S3C/S5P rotator
	driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: Pawel Osciak <p.osciak@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wed, Dec 23, 2009 at 1:08 PM, Pawel Osciak <p.osciak@samsung.com> wrote:
> The rotator device present on Samsung S3C and S5P series SoCs allows image
> rotation and flipping. It requires contiguous memory buffers to operate,
> as it does not have scatter-gather support. It is also an example of
> a memory-to-memory device, and so uses the mem-2-mem device V4L2 framework.

[...]

> +
> +static const struct v4l2_file_operations s3c_rotator_fops = {
> +       .owner          = THIS_MODULE,
> +       .open           = s3c_rotator_open,
> +       .release        = s3c_rotator_release,
> +       .poll           = s3c_rotator_poll,
> +       .ioctl          = video_ioctl2,
> +       .mmap           = s3c_rotator_mmap,
> +};
> +
> +static struct video_device m2mtest_videodev = {
> +       .name           = S3C_ROTATOR_NAME,
> +       .fops           = &s3c_rotator_fops,
> +       .ioctl_ops      = &s3c_rotator_ioctl_ops,
> +       .minor          = -1,
> +       .release        = video_device_release,
> +};
> +
> +static struct v4l2_m2m_ops m2m_ops = {
> +       .device_run     = device_run,
> +       .job_abort      = job_abort,
> +};
> +
> +static int s3c_rotator_probe(struct platform_device *pdev)
> +{
> +       struct s3c_rotator_dev *dev;
> +       struct video_device *vfd;
> +       struct resource *res;
> +       int ret = -ENOENT;

Here ^^^ (see below please for comments)

> +
> +       dev = kzalloc(sizeof *dev, GFP_KERNEL);
> +       if (!dev)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&dev->irqlock);
> +       ret = -ENOENT;

It's probably bad pedantic part of me speaking but looks like you set
ret equals to -ENOENT two times. Most likely you don't need
assignment second time.


> +       dev->irq = platform_get_irq(pdev, 0);
> +       if (dev->irq <= 0) {
> +               dev_err(&pdev->dev, "Failed to acquire irq\n");
> +               goto free_dev;
> +       }
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               dev_err(&pdev->dev,
> +                       "Failed to acquire memory region resource\n");
> +               goto free_irq;
> +       }
> +
> +       dev->regs_res = request_mem_region(res->start, resource_size(res),
> +                                          dev_name(&pdev->dev));
> +       if (!dev->regs_res) {
> +               dev_err(&pdev->dev, "Failed to reserve memory region\n");
> +               goto free_irq;
> +       }
> +
> +       dev->regs_base = ioremap(res->start, resource_size(res));
> +       if (!dev->regs_base) {
> +               dev_err(&pdev->dev, "Ioremap failed\n");
> +               ret = -ENXIO;
> +               goto rel_res;
> +       }
> +
> +       ret = request_irq(dev->irq, s3c_rotator_isr, 0,
> +                         S3C_ROTATOR_NAME, dev);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Requesting irq failed\n");
> +               goto regs_unmap;
> +       }
> +
> +       ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> +       if (ret)
> +               goto regs_unmap;
> +
> +       atomic_set(&dev->num_inst, 0);
> +
> +       vfd = video_device_alloc();
> +       if (!vfd) {
> +               v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
> +               goto unreg_dev;
> +       }
> +
> +       *vfd = m2mtest_videodev;
> +
> +       ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> +       if (ret) {
> +               v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> +               goto rel_vdev;
> +       }
> +
> +       video_set_drvdata(vfd, dev);
> +       snprintf(vfd->name, sizeof(vfd->name), "%s", m2mtest_videodev.name);
> +       dev->vfd = vfd;
> +       v4l2_info(&dev->v4l2_dev,
> +                       "Device registered as /dev/video%d\n", vfd->num);
> +
> +       platform_set_drvdata(pdev, dev);
> +
> +       dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
> +       if (IS_ERR(dev->m2m_dev)) {
> +               v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
> +               ret = PTR_ERR(dev->m2m_dev);
> +               goto err_m2m;
> +       }
> +
> +       return 0;
> +
> +err_m2m:
> +       video_unregister_device(dev->vfd);
> +rel_vdev:
> +       video_device_release(vfd);
> +unreg_dev:
> +       v4l2_device_unregister(&dev->v4l2_dev);
> +regs_unmap:
> +       iounmap(dev->regs_base);
> +rel_res:
> +       release_resource(dev->regs_res);
> +       kfree(dev->regs_res);
> +free_irq:
> +       free_irq(dev->irq, dev);
> +free_dev:
> +       kfree(dev);
> +
> +       return ret;
> +}
> +
> +static int s3c_rotator_remove(struct platform_device *pdev)
> +{
> +       struct s3c_rotator_dev *dev =
> +               (struct s3c_rotator_dev *)platform_get_drvdata(pdev);
> +
> +       v4l2_info(&dev->v4l2_dev, "Removing %s\n", S3C_ROTATOR_NAME);
> +
> +       v4l2_m2m_release(dev->m2m_dev);
> +       video_unregister_device(dev->vfd);
> +       v4l2_device_unregister(&dev->v4l2_dev);
> +       iounmap(dev->regs_base);
> +       release_resource(dev->regs_res);
> +       kfree(dev->regs_res);
> +       free_irq(dev->irq, dev);
> +       kfree(dev);
> +
> +       return 0;
> +}
> +
> +static int s3c_rotator_suspend(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static int s3c_rotator_resume(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static struct dev_pm_ops s3c_rotator_pm_ops = {
> +       .suspend = s3c_rotator_suspend,
> +       .resume = s3c_rotator_resume,
> +};
> +
> +static struct platform_driver s3c_rotator_pdrv = {
> +       .probe          = s3c_rotator_probe,
> +       .remove         = s3c_rotator_remove,
> +       .driver         = {
> +               .name   = S3C_ROTATOR_NAME,
> +               .owner  = THIS_MODULE,
> +               .pm     = &s3c_rotator_pm_ops
> +       },
> +};
> +
> +static char banner[] __initdata =
> +       KERN_INFO "S3C Rotator V4L2 Driver, (c) 2009 Samsung Electronics\n";
> +
> +static int __init s3c_rotator_init(void)
> +{
> +       printk(banner);
> +       return platform_driver_register(&s3c_rotator_pdrv);
> +}
> +
> +static void __devexit s3c_rotator_exit(void)
> +{
> +       platform_driver_unregister(&s3c_rotator_pdrv);
> +}
> +
> +module_init(s3c_rotator_init);
> +module_exit(s3c_rotator_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Pawel Osciak <p.osciak@samsung.com>");
> +MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");



-- 
Best regards, Klimov Alexey
