Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:33258 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZFQV33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 17:29:29 -0400
Received: by an-out-0708.google.com with SMTP id d40so975663and.1
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 14:29:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245269484-8325-2-git-send-email-m-karicheri2@ti.com>
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
	 <1245269484-8325-2-git-send-email-m-karicheri2@ti.com>
Date: Thu, 18 Jun 2009 01:29:31 +0400
Message-ID: <208cbae30906171429q3d5aeb3fy26788be1f415c289@mail.gmail.com>
Subject: Re: [PATCH 1/11 - v3] vpfe capture bridge driver for DM355 and DM6446
From: Alexey Klimov <klimov.linux@gmail.com>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

very small comments, see below please

On Thu, Jun 18, 2009 at 12:11 AM, <m-karicheri2@ti.com> wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>

<snip>

> +static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
> +{
> +       struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
> +       int ret = -ENOENT;
> +
> +       vpfe_cfg->vpssclk = clk_get(vpfe_dev->pdev, "vpss_master");
> +       if (NULL == vpfe_cfg->vpssclk) {
> +               v4l2_err(vpfe_dev->pdev->driver, "No clock defined for"
> +                        "vpss_master\n");
> +               return ret;
> +       }
> +
> +       if (clk_enable(vpfe_cfg->vpssclk)) {
> +               v4l2_err(vpfe_dev->pdev->driver,
> +                       "vpfe vpss master clock not enabled");
> +               goto out;
> +       }
> +       v4l2_info(vpfe_dev->pdev->driver,
> +                "vpfe vpss master clock enabled\n");
> +
> +       vpfe_cfg->slaveclk = clk_get(vpfe_dev->pdev, "vpss_slave");
> +       if (NULL == vpfe_cfg->slaveclk) {
> +               v4l2_err(vpfe_dev->pdev->driver,
> +                       "No clock defined for vpss slave\n");
> +               goto out;
> +       }
> +
> +       if (clk_enable(vpfe_cfg->slaveclk)) {
> +               v4l2_err(vpfe_dev->pdev->driver,
> +                        "vpfe vpss slave clock not enabled");
> +               goto out;
> +       }
> +       v4l2_info(vpfe_dev->pdev->driver,
> +                "vpfe vpss slave clock enabled\n");
> +       return 0;
> +out:
> +       if (vpfe_cfg->vpssclk)
> +               clk_put(vpfe_cfg->vpssclk);
> +       if (vpfe_cfg->slaveclk)
> +               clk_put(vpfe_cfg->slaveclk);
> +
> +       return -1;
> +}
> +
> +/*
> + * vpfe_probe : This function creates device entries by register
> + * itself to the V4L2 driver and initializes fields of each
> + * device objects
> + */
> +static __init int vpfe_probe(struct platform_device *pdev)
> +{
> +       struct vpfe_config *vpfe_cfg;
> +       struct resource *res1;
> +       struct vpfe_device *vpfe_dev;
> +       struct i2c_adapter *i2c_adap;
> +       struct i2c_client *client;
> +       struct video_device *vfd;
> +       int ret = -ENOMEM, i, j;
> +       int num_subdevs = 0;
> +
> +       /* Get the pointer to the device object */
> +       vpfe_dev = vpfe_initialize();
> +
> +       if (!vpfe_dev) {
> +               v4l2_err(pdev->dev.driver,
> +                       "Failed to allocate memory for vpfe_dev\n");
> +               return ret;
> +       }
> +
> +       vpfe_dev->pdev = &pdev->dev;
> +
> +       if (NULL == pdev->dev.platform_data) {
> +               v4l2_err(pdev->dev.driver, "Unable to get vpfe config\n");
> +               ret = -ENOENT;
> +               goto probe_free_dev_mem;
> +       }
> +
> +       vpfe_cfg = pdev->dev.platform_data;
> +       vpfe_dev->cfg = vpfe_cfg;
> +       if (NULL == vpfe_cfg->ccdc ||
> +           NULL == vpfe_cfg->card_name ||
> +           NULL == vpfe_cfg->sub_devs) {
> +               v4l2_err(pdev->dev.driver, "null ptr in vpfe_cfg\n");
> +               ret = -ENOENT;
> +               goto probe_free_dev_mem;
> +       }
> +
> +       /* enable vpss clocks */
> +       ret = vpfe_enable_clock(vpfe_dev);
> +       if (ret)
> +               goto probe_free_dev_mem;
> +
> +       mutex_lock(&ccdc_lock);
> +       /* Allocate memory for ccdc configuration */
> +       ccdc_cfg = kmalloc(sizeof(struct ccdc_config), GFP_KERNEL);
> +       if (NULL == ccdc_cfg) {
> +               v4l2_err(pdev->dev.driver, "Memory allocation failed for"
> +                       "ccdc_cfg");
> +               goto probe_disable_clock;
> +       }
> +
> +       strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
> +       /* Get VINT0 irq resource */
> +       res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +       if (!res1) {
> +               v4l2_err(pdev->dev.driver, "Unable to get interrupt for VINT0");

Do you want to add "\n" to the end of this message? If i'm now wrong
it's better to check other messages in this patch for "\n". Please,
check.

> +               ret = -ENOENT;
> +               goto probe_disable_clock;
> +       }
> +       vpfe_dev->ccdc_irq0 = res1->start;
> +
> +       /* Get VINT1 irq resource */
> +       res1 = platform_get_resource(pdev,
> +                               IORESOURCE_IRQ, 1);
> +       if (!res1) {
> +               v4l2_err(pdev->dev.driver, "Unable to get interrupt for VINT1");

"\n" ?

> +               ret = -ENOENT;
> +               goto probe_disable_clock;
> +       }
> +       vpfe_dev->ccdc_irq1 = res1->start;
> +
> +       /* Get address base of CCDC */
> +       res1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res1) {
> +               v4l2_err(pdev->dev.driver,
> +                       "Unable to get register address map\n");
> +               ret = -ENOENT;
> +               goto probe_disable_clock;
> +       }
> +
> +       ccdc_cfg->ccdc_addr_size = res1->end - res1->start + 1;
> +       if (!request_mem_region(res1->start, ccdc_cfg->ccdc_addr_size,
> +                               pdev->dev.driver->name)) {
> +               v4l2_err(pdev->dev.driver,
> +                       "Failed request_mem_region for ccdc base\n");
> +               ret = -ENXIO;
> +               goto probe_disable_clock;
> +       }
> +       ccdc_cfg->ccdc_addr = ioremap_nocache(res1->start,
> +                                            ccdc_cfg->ccdc_addr_size);
> +       if (!ccdc_cfg->ccdc_addr) {
> +               v4l2_err(pdev->dev.driver, "Unable to ioremap ccdc addr\n");
> +               ret = -ENXIO;
> +               goto probe_out_release_mem1;
> +       }
> +
> +       ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
> +                         "vpfe_capture0", vpfe_dev);
> +
> +       if (0 != ret) {
> +               v4l2_err(pdev->dev.driver, "Unable to request interrupt\n");
> +               goto probe_out_unmap1;
> +       }
> +
> +       /* Allocate memory for video device */
> +       vfd = video_device_alloc();
> +       if (NULL == vfd) {
> +               ret = ENOMEM;

ret = -ENOMEM?

> +               v4l2_err(pdev->dev.driver,
> +                       "Unable to alloc video device\n");
> +               goto probe_out_release_irq;
> +       }
> +
> +       /* Initialize field of video device */
> +       vfd->release            = video_device_release;
> +       vfd->current_norm       = V4L2_STD_UNKNOWN;
> +       vfd->fops               = &vpfe_fops;
> +       vfd->ioctl_ops          = &vpfe_ioctl_ops;
> +       vfd->minor              = -1;
> +       vfd->tvnorms            = 0;
> +       vfd->current_norm       = V4L2_STD_PAL;
> +       vfd->v4l2_dev           = &vpfe_dev->v4l2_dev;
> +       snprintf(vfd->name, sizeof(vfd->name),
> +                "%s_V%d.%d.%d",
> +                CAPTURE_DRV_NAME,
> +                (VPFE_CAPTURE_VERSION_CODE >> 16) & 0xff,
> +                (VPFE_CAPTURE_VERSION_CODE >> 8) & 0xff,
> +                (VPFE_CAPTURE_VERSION_CODE) & 0xff);
> +       /* Set video_dev to the video device */
> +       vpfe_dev->video_dev     = vfd;
> +
> +       ret = v4l2_device_register(&pdev->dev, &vpfe_dev->v4l2_dev);
> +       if (ret) {
> +               v4l2_err(pdev->dev.driver,
> +                       "Unable to register v4l2 device.\n");
> +               goto probe_out_video_release;
> +       }
> +       v4l2_info(&vpfe_dev->v4l2_dev, "v4l2 device registered\n");
> +       spin_lock_init(&vpfe_dev->irqlock);
> +       spin_lock_init(&vpfe_dev->dma_queue_lock);
> +       mutex_init(&vpfe_dev->lock);
> +
> +       /* Initialize field of the device objects */
> +       vpfe_dev->numbuffers = config_params.numbuffers;
> +
> +       /* Initialize prio member of device object */
> +       v4l2_prio_init(&vpfe_dev->prio);
> +       /* register video device */
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> +               "trying to register vpfe device.\n");
> +       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> +               "video_dev=%x\n", (int)&vpfe_dev->video_dev);
> +       vpfe_dev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       ret = video_register_device(vpfe_dev->video_dev,
> +                                   VFL_TYPE_GRABBER, -1);
> +
> +       if (ret) {
> +               v4l2_err(pdev->dev.driver,
> +                       "Unable to register video device.\n");
> +               goto probe_out_v4l2_unregister;
> +       }
> +
> +       v4l2_info(&vpfe_dev->v4l2_dev, "video device registered\n");
> +       /* set the driver data in platform device */
> +       platform_set_drvdata(pdev, vpfe_dev);
> +       /* set driver private data */
> +       video_set_drvdata(vpfe_dev->video_dev, vpfe_dev);
> +       i2c_adap = i2c_get_adapter(1);
> +       vpfe_cfg = pdev->dev.platform_data;
> +       num_subdevs = vpfe_cfg->num_subdevs;
> +       vpfe_dev->sd = kmalloc(sizeof(struct v4l2_subdev *) * num_subdevs,
> +                               GFP_KERNEL);
> +       if (NULL == vpfe_dev->sd) {
> +               v4l2_err(&vpfe_dev->v4l2_dev,
> +                       "unable to allocate memory for subdevice pointers\n");
> +               ret = -ENOMEM;
> +               goto probe_out_video_unregister;
> +       }
> +
> +       for (i = 0; i < num_subdevs; i++) {
> +               struct vpfe_subdev_info *sdinfo = &vpfe_cfg->sub_devs[i];
> +               struct v4l2_input *inps;
> +
> +               list_for_each_entry(client, &i2c_adap->clients, list) {
> +                       if (!strcmp(client->name, sdinfo->name))
> +                               break;
> +               }
> +
> +               if (NULL == client) {
> +                       v4l2_err(&vpfe_dev->v4l2_dev, "No Subdevice found\n");
> +                       ret =  -ENODEV;
> +                       goto probe_sd_out;
> +               }
> +
> +               /* Get subdevice data from the client */
> +               vpfe_dev->sd[i] = i2c_get_clientdata(client);
> +               if (NULL == vpfe_dev->sd[i]) {
> +                       v4l2_err(&vpfe_dev->v4l2_dev,
> +                               "No Subdevice data\n");
> +                       ret =  -ENODEV;
> +                       goto probe_sd_out;
> +               }
> +
> +               vpfe_dev->sd[i]->grp_id = sdinfo->grp_id;
> +               ret = v4l2_device_register_subdev(&vpfe_dev->v4l2_dev,
> +                                                 vpfe_dev->sd[i]);
> +               if (ret) {
> +                       ret =  -ENODEV;
> +                       v4l2_err(&vpfe_dev->v4l2_dev,
> +                               "Error registering v4l2 sub-device\n");
> +                       goto probe_sd_out;
> +               }
> +               v4l2_info(&vpfe_dev->v4l2_dev, "v4l2 sub device %s"
> +                         " registered\n", client->name);
> +
> +               /* update tvnorms from the sub devices */
> +               for (j = 0; j < sdinfo->num_inputs; j++) {
> +                       inps = &sdinfo->inputs[j];
> +                       vfd->tvnorms |= inps->std;
> +               }
> +       }
> +       /* We have at least one sub device to work with */
> +       vpfe_dev->current_subdev = &vpfe_cfg->sub_devs[0];
> +       mutex_unlock(&ccdc_lock);
> +       return 0;
> +
> +probe_sd_out:
> +       for (j = i; j >= 0; j--)
> +               v4l2_device_unregister_subdev(vpfe_dev->sd[j]);
> +       kfree(vpfe_dev->sd);
> +probe_out_video_unregister:
> +       video_unregister_device(vpfe_dev->video_dev);
> +probe_out_v4l2_unregister:
> +       v4l2_device_unregister(&vpfe_dev->v4l2_dev);
> +probe_out_video_release:
> +       video_device_release(vpfe_dev->video_dev);
> +probe_out_release_irq:
> +       free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
> +probe_out_unmap1:
> +       iounmap(ccdc_cfg->ccdc_addr);
> +probe_out_release_mem1:
> +       release_mem_region(res1->start, res1->end - res1->start + 1);
> +probe_disable_clock:
> +       vpfe_disable_clock(vpfe_dev);
> +       mutex_unlock(&ccdc_lock);
> +       kfree(ccdc_cfg);
> +probe_free_dev_mem:
> +       kfree(vpfe_dev);
> +       return ret;

-- 
Best regards, Klimov Alexey
