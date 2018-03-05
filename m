Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:40147 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933280AbeCEHur (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2018 02:50:47 -0500
Received: by mail-it0-f66.google.com with SMTP id e64so8868683ita.5
        for <linux-media@vger.kernel.org>; Sun, 04 Mar 2018 23:50:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201803011248.FdUWicPr%fengguang.wu@intel.com>
References: <20180227061136.5532-3-matt.ranostay@konsulko.com> <201803011248.FdUWicPr%fengguang.wu@intel.com>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Sun, 4 Mar 2018 23:50:46 -0800
Message-ID: <CAJCx=gmFgNZNhOYyf_Hcp_W6Mvgh_1qdAcn_=pugJtgxGNeqgg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] media: video-i2c: add video-i2c driver
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Luca Barbato <lu_zero@gentoo.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 28, 2018 at 8:22 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Matt,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on linuxtv-media/master]
> [also build test WARNING on v4.16-rc3 next-20180228]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Matt-Ranostay/media-video-i2c-add-video-i2c-driver-support/20180301-111038
> base:   git://linuxtv.org/media_tree.git master
> config: ia64-allmodconfig (attached as .config)
> compiler: ia64-linux-gcc (GCC) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=ia64
>
> All warnings (new ones prefixed by >>):
>
>    drivers/media//i2c/video-i2c.c: In function 'video_i2c_probe':
>>> drivers/media//i2c/video-i2c.c:456:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>       chip_id = (int) of_device_get_match_data(&client->dev);

Suspect this is some Itanium weirdness nobody cares about.

>                 ^
>
> vim +456 drivers/media//i2c/video-i2c.c
>
>    442
>    443  static int video_i2c_probe(struct i2c_client *client,
>    444                               const struct i2c_device_id *id)
>    445  {
>    446          struct video_i2c_data *data;
>    447          struct v4l2_device *v4l2_dev;
>    448          struct vb2_queue *queue;
>    449          int chip_id, ret;
>    450
>    451          data = kzalloc(sizeof(*data), GFP_KERNEL);
>    452          if (!data)
>    453                  return -ENOMEM;
>    454
>    455          if (client->dev.of_node)
>  > 456                  chip_id = (int) of_device_get_match_data(&client->dev);
>    457          else
>    458                  chip_id = id->driver_data;
>    459
>    460          data->chip = &video_i2c_chip[chip_id];
>    461          data->client = client;
>    462          v4l2_dev = &data->v4l2_dev;
>    463          strlcpy(v4l2_dev->name, VIDEO_I2C_DRIVER, sizeof(v4l2_dev->name));
>    464
>    465          ret = v4l2_device_register(&client->dev, v4l2_dev);
>    466          if (ret < 0)
>    467                  goto error_free_device;
>    468
>    469          mutex_init(&data->lock);
>    470          mutex_init(&data->queue_lock);
>    471
>    472          queue = &data->vb_vidq;
>    473          queue->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>    474          queue->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR | VB2_READ;
>    475          queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>    476          queue->drv_priv = data;
>    477          queue->buf_struct_size = sizeof(struct video_i2c_buffer);
>    478          queue->min_buffers_needed = 1;
>    479          queue->ops = &video_i2c_video_qops;
>    480          queue->mem_ops = &vb2_vmalloc_memops;
>    481
>    482          ret = vb2_queue_init(queue);
>    483          if (ret < 0)
>    484                  goto error_unregister_device;
>    485
>    486          data->vdev.queue = queue;
>    487          data->vdev.queue->lock = &data->queue_lock;
>    488
>    489          snprintf(data->vdev.name, sizeof(data->vdev.name),
>    490                                   "I2C %d-%d Transport Video",
>    491                                   client->adapter->nr, client->addr);
>    492
>    493          data->vdev.v4l2_dev = v4l2_dev;
>    494          data->vdev.fops = &video_i2c_fops;
>    495          data->vdev.lock = &data->lock;
>    496          data->vdev.ioctl_ops = &video_i2c_ioctl_ops;
>    497          data->vdev.release = video_i2c_release;
>    498          data->vdev.device_caps = V4L2_CAP_VIDEO_CAPTURE |
>    499                                   V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>    500
>    501          spin_lock_init(&data->slock);
>    502          INIT_LIST_HEAD(&data->vid_cap_active);
>    503
>    504          video_set_drvdata(&data->vdev, data);
>    505          i2c_set_clientdata(client, data);
>    506
>    507          ret = video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
>    508          if (ret < 0)
>    509                  goto error_unregister_device;
>    510
>    511          return 0;
>    512
>    513  error_unregister_device:
>    514          v4l2_device_unregister(v4l2_dev);
>    515
>    516  error_free_device:
>    517          kfree(data);
>    518
>    519          return ret;
>    520  }
>    521
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
