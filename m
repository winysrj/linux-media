Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35219 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbaDICBJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 22:01:09 -0400
MIME-Version: 1.0
In-Reply-To: <1394794130-13660-1-git-send-email-josh.wu@atmel.com>
References: <1392235552-28134-1-git-send-email-pengw@nvidia.com> <1394794130-13660-1-git-send-email-josh.wu@atmel.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 8 Apr 2014 19:00:47 -0700
Message-ID: <CAK5ve-KuPJa6rBdYGvkuPyQU5TCiEe1t=PzEKN4NgsKgVWogqA@mail.gmail.com>
Subject: Re: [v2] media: soc-camera: OF cameras
To: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-tegra <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Josh, I think I will take you point and rework my patch again.
But I need Guennadi's review firstly, Guennadi, could you please help
to review it?

-Bryan

On Fri, Mar 14, 2014 at 3:48 AM, Josh Wu <josh.wu@atmel.com> wrote:
> Hi, Brayn
>
> Sorry for the format of my email. I subscribe the linux-media maillist but
> I didn't find your email in my mailbox even. I don't know why some emails are
> missed.
>
> anyway, Some comments for your patch.
>
>> [snip]
>
>> ... ...
>
>> +static void scan_of_host(struct soc_camera_host *ici)
>> +{
>> +       struct soc_camera_of_client *sofc;
>> +       struct soc_camera_async_client *sasc;
>> +       struct v4l2_async_subdev *asd;
>> +       struct soc_camera_device *icd;
>> +       struct device_node *node = NULL;
>> +
>> +       for (;;) {
>> +               int ret;
>> +
>> +               node = v4l2_of_get_next_endpoint(ici->v4l2_dev.dev->of_node,
>> +                                              node);
>> +               if (!node)
>> +                       break;
>> +
>> +               sofc = soc_camera_of_alloc_client(ici, node);
>> +               if (!sofc) {
>> +                       dev_err(ici->v4l2_dev.dev,
>> +                               "%s(): failed to create a client device\n",
>> +                               __func__);
>> +                       of_node_put(node);
>> +                       break;
>> +               }
>> +               v4l2_of_parse_endpoint(node, &sofc->node);
>> +
>> +               sasc = &sofc->sasc;
>> +               ret = platform_device_add(sasc->pdev);
>> +               if (ret < 0) {
>> +                       /* Useless thing, but keep trying */
>> +                       platform_device_put(sasc->pdev);
>> +                       of_node_put(node);
>> +                       continue;
>> +               }
>> +
>> +               /* soc_camera_pdrv_probe() probed successfully */
>> +               icd = platform_get_drvdata(sasc->pdev);
>> +               if (!icd) {
>> +                       /* Cannot be... */
>> +                       platform_device_put(sasc->pdev);
>> +                       of_node_put(node);
>> +                       continue;
>> +               }
>> +
>> +               asd = sasc->sensor;
>> +               asd->match_type = V4L2_ASYNC_MATCH_OF;
>> +               asd->match.of.node = sofc->link_node;
>> +
>> +               sasc->notifier.subdevs = &asd;
>> +               sasc->notifier.num_subdevs = 1;
>> +               sasc->notifier.bound = soc_camera_async_bound;
>> +               sasc->notifier.unbind = soc_camera_async_unbind;
>> +               sasc->notifier.complete = soc_camera_async_complete;
>> +
>> +               icd->parent = ici->v4l2_dev.dev;
>
> Before register the notifier, you need also register a "mclk" v4l2 clock.
> This clock is needed when the soc-camera i2c sensor driver is probed. Otherwise the
> sensor will always defer the probe and can not probe.
>
> Best Regards,
> Josh Wu
>
>> +
>> +               ret = v4l2_async_notifier_register(&ici->v4l2_dev, &sasc->notifier);
>> +               if (!ret)
>> +                       break;
>> +
>> +               /*
>> +                * We could destroy the icd in there error case here, but the
>> +                * non-OF version doesn't do that, so, we can keep it around too
>> +                */
>> +       }
>> +}
>
>> [snip]
