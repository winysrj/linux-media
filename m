Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35252 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753261AbeGBHt4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 03:49:56 -0400
Received: by mail-yw0-f196.google.com with SMTP id t18-v6so6353944ywg.2
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 00:49:56 -0700 (PDT)
Received: from mail-yw0-f175.google.com (mail-yw0-f175.google.com. [209.85.161.175])
        by smtp.gmail.com with ESMTPSA id j187-v6sm5704535ywd.51.2018.07.02.00.49.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 00:49:54 -0700 (PDT)
Received: by mail-yw0-f175.google.com with SMTP id 139-v6so1012318ywg.12
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 00:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com> <1522376100-22098-12-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1522376100-22098-12-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 2 Jul 2018 16:49:43 +0900
Message-ID: <CAAFQd5DdJddmypcpLswQzwV8jdiS1iPGTO=FUJoz+AmnzOy2cg@mail.gmail.com>
Subject: Re: [PATCH v6 11/12] intel-ipu3: Add v4l2 driver based on media framework
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Vijaykumar, Ramya" <ramya.vijaykumar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
[snip]
> +static int ipu3_vidioc_enum_input(struct file *file, void *fh,
> +                                 struct v4l2_input *input)
> +{
> +       if (input->index > 0)
> +               return -EINVAL;
> +       strlcpy(input->name, "camera", sizeof(input->name));
> +       input->type = V4L2_INPUT_TYPE_CAMERA;
> +
> +       return 0;
> +}
> +
> +static int ipu3_vidioc_g_input(struct file *file, void *fh, unsigned int *input)
> +{
> +       *input = 0;
> +
> +       return 0;
> +}
> +
> +static int ipu3_vidioc_s_input(struct file *file, void *fh, unsigned int input)
> +{
> +       return input == 0 ? 0 : -EINVAL;
> +}
> +
> +static int ipu3_vidioc_enum_output(struct file *file, void *fh,
> +                                  struct v4l2_output *output)
> +{
> +       if (output->index > 0)
> +               return -EINVAL;
> +       strlcpy(output->name, "camera", sizeof(output->name));
> +       output->type = V4L2_INPUT_TYPE_CAMERA;
> +
> +       return 0;
> +}
> +
> +static int ipu3_vidioc_g_output(struct file *file, void *fh,
> +                               unsigned int *output)
> +{
> +       *output = 0;
> +
> +       return 0;
> +}
> +
> +static int ipu3_vidioc_s_output(struct file *file, void *fh,
> +                               unsigned int output)
> +{
> +       return output == 0 ? 0 : -EINVAL;
> +}

Do we really need to implement the 6 functions above? They don't seem
to be doing anything useful.

[snip]

> +int ipu3_v4l2_register(struct imgu_device *imgu)
> +{
> +       struct v4l2_mbus_framefmt def_bus_fmt = { 0 };
> +       struct v4l2_pix_format_mplane def_pix_fmt = { 0 };
> +
> +       int i, r;
> +
> +       /* Initialize miscellaneous variables */
> +       imgu->streaming = false;
> +
> +       /* Set up media device */
> +       imgu->media_dev.dev = &imgu->pci_dev->dev;
> +       strlcpy(imgu->media_dev.model, IMGU_NAME,
> +               sizeof(imgu->media_dev.model));
> +       snprintf(imgu->media_dev.bus_info, sizeof(imgu->media_dev.bus_info),
> +                "%s", dev_name(&imgu->pci_dev->dev));
> +       imgu->media_dev.hw_revision = 0;
> +       media_device_init(&imgu->media_dev);
> +       r = media_device_register(&imgu->media_dev);
> +       if (r) {
> +               dev_err(&imgu->pci_dev->dev,
> +                       "failed to register media device (%d)\n", r);
> +               return r;
> +       }

Shouldn't we register the media device at the end, after all video
nodes are registered below? Otherwise, since media_device_register()
exposes the media node to userspace, we risk a race, when userspace
opens the media device before all the entities are created and linked.

[snip]

> +int ipu3_v4l2_unregister(struct imgu_device *imgu)
> +{
> +       unsigned int i;
> +
> +       for (i = 0; i < IMGU_NODE_NUM; i++) {
> +               video_unregister_device(&imgu->nodes[i].vdev);
> +               media_entity_cleanup(&imgu->nodes[i].vdev.entity);
> +               mutex_destroy(&imgu->nodes[i].lock);
> +       }
> +
> +       v4l2_device_unregister_subdev(&imgu->subdev);
> +       media_entity_cleanup(&imgu->subdev.entity);
> +       kfree(imgu->subdev_pads);
> +       v4l2_device_unregister(&imgu->v4l2_dev);
> +       media_device_unregister(&imgu->media_dev);

Should unregister media device at the beginning, so that it cannot be
used when we continue to clean up the entities.

> +       media_device_cleanup(&imgu->media_dev);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu3_v4l2_unregister);

Best regards,
Tomasz
