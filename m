Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36784 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbFIDVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 23:21:33 -0400
Received: by igbpi8 with SMTP id pi8so3220170igb.1
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2015 20:21:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433812846-7450-2-git-send-email-chehabrafael@gmail.com>
References: <1433812846-7450-1-git-send-email-chehabrafael@gmail.com>
	<1433812846-7450-2-git-send-email-chehabrafael@gmail.com>
Date: Mon, 8 Jun 2015 21:08:32 -0600
Message-ID: <CAKocOOOJVDXyAem2SwYVbYo=1naSisP6Qt4iWm+MH_oWKJZnOg@mail.gmail.com>
Subject: Re: [PATCH 2/2 v3] au0828: Add support for media controller
From: Shuah Khan <shuahkhan@gmail.com>
To: =?UTF-8?Q?Rafael_Louren=C3=A7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 8, 2015 at 7:20 PM, Rafael Lourenço de Lima Chehab
<chehabrafael@gmail.com> wrote:
> Add support for analog and dvb tv using media controller.
>
> Signed-off-by: Rafael Lourenço de Lima Chehab <chehabrafael@gmail.com>
> ---
>  drivers/media/dvb-frontends/au8522_decoder.c | 17 +++++
>  drivers/media/dvb-frontends/au8522_priv.h    | 12 ++++
>  drivers/media/usb/au0828/au0828-core.c       | 98 ++++++++++++++++++++++++++++
>  drivers/media/usb/au0828/au0828-dvb.c        | 10 +++
>  drivers/media/usb/au0828/au0828-video.c      | 83 +++++++++++++++++++++++
>  drivers/media/usb/au0828/au0828.h            |  6 ++
>  6 files changed, 226 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
> index 33aa9410b624..24990db7ba38 100644
> --- a/drivers/media/dvb-frontends/au8522_decoder.c
> +++ b/drivers/media/dvb-frontends/au8522_decoder.c
> @@ -731,6 +731,9 @@ static int au8522_probe(struct i2c_client *client,
>         struct v4l2_subdev *sd;
>         int instance;
>         struct au8522_config *demod_config;
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       int ret;
> +#endif

You won't need to enclose the code in CONFIG_MEDIA_CONTROLLER
blocks, once the patch I sent gets in. Please see below for patch.

https://lkml.org/lkml/2015/6/5/777

>
>         /* Check if the adapter supports the needed features */
>         if (!i2c_check_functionality(client->adapter,
> @@ -767,6 +770,20 @@ static int au8522_probe(struct i2c_client *client,
>
>         sd = &state->sd;
>         v4l2_i2c_subdev_init(sd, client, &au8522_ops);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +
> +       state->pads[AU8522_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
> +       state->pads[AU8522_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
> +       state->pads[AU8522_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
> +       sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> +
> +       ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
> +                               state->pads, 0);
> +       if (ret < 0) {
> +               v4l_info(client, "failed to initialize media entity!\n");
> +               return ret;
> +       }
> +#endif
>
>         hdl = &state->hdl;
>         v4l2_ctrl_handler_init(hdl, 4);
> diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
> index b8aca1c84786..ed6eb2675508 100644
> --- a/drivers/media/dvb-frontends/au8522_priv.h
> +++ b/drivers/media/dvb-frontends/au8522_priv.h
> @@ -39,6 +39,14 @@
>  #define AU8522_DIGITAL_MODE 1
>  #define AU8522_SUSPEND_MODE 2
>
> +enum au8522_media_pads {
> +       AU8522_PAD_INPUT,
> +       AU8522_PAD_VID_OUT,
> +       AU8522_PAD_VBI_OUT,
> +
> +       AU8522_NUM_PADS
> +};
> +
>  struct au8522_state {
>         struct i2c_client *c;
>         struct i2c_adapter *i2c;
> @@ -68,6 +76,10 @@ struct au8522_state {
>         u32 id;
>         u32 rev;
>         struct v4l2_ctrl_handler hdl;
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       struct media_pad pads[AU8522_NUM_PADS];
> +#endif
>  };
>
>  /* These are routines shared by both the VSB/QAM demodulator and the analog
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 0934024fb89d..0378a2c99ebb 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -127,8 +127,22 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>         return status;
>  }
>
> +static void au0828_unregister_media_device(struct au0828_dev *dev)
> +{
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       if (dev->media_dev) {
> +               media_device_unregister(dev->media_dev);
> +               kfree(dev->media_dev);
> +               dev->media_dev = NULL;
> +       }
> +#endif
> +}
> +
>  static void au0828_usb_release(struct au0828_dev *dev)
>  {
> +       au0828_unregister_media_device(dev);
> +
>         /* I2C */
>         au0828_i2c_unregister(dev);
>
> @@ -161,6 +175,8 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
>         */
>         dev->dev_state = DEV_DISCONNECTED;
>
> +       au0828_unregister_media_device(dev);
> +
>         au0828_rc_unregister(dev);
>         /* Digital TV */
>         au0828_dvb_unregister(dev);
> @@ -180,6 +196,81 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
>         au0828_usb_release(dev);
>  }
>
> +static void au0828_media_device_register(struct au0828_dev *dev,
> +                                         struct usb_device *udev)
> +{
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       struct media_device *mdev;
> +       int ret;
> +
> +       mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> +       if (!mdev)
> +               return;
> +
> +       mdev->dev = &udev->dev;
> +
> +       if (!dev->board.name)
> +               strlcpy(mdev->model, "unknown au0828", sizeof(mdev->model));
> +       else
> +               strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
> +       if (udev->serial)
> +               strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
> +       strcpy(mdev->bus_info, udev->devpath);
> +       mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
> +       mdev->driver_version = LINUX_VERSION_CODE;

Does this work? I saw checkpatch warnings come up for using
LINUX_VERSION_CODE.

> +
> +       ret = media_device_register(mdev);
> +       if (ret) {
> +               pr_err(
> +                       "Couldn't create a media device. Error: %d\n",
> +                       ret);
> +               kfree(mdev);
> +               return;
> +       }
> +
> +       dev->media_dev = mdev;
> +#endif
> +}
> +
> +
> +static void au0828_create_media_graph(struct au0828_dev *dev)
> +{
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       struct media_device *mdev = dev->media_dev;
> +       struct media_entity *entity;
> +       struct media_entity *tuner = NULL, *decoder = NULL;
> +
> +       if (!mdev)
> +               return;
> +
> +       media_device_for_each_entity(entity, mdev) {
> +               switch (entity->type) {
> +               case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
> +                       tuner = entity;
> +                       break;
> +               case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
> +                       decoder = entity;
> +                       break;
> +               }
> +       }
> +
> +       /* Analog setup, using tuner as a link */
> +
> +       if (!decoder)
> +               return;
> +
> +       if (tuner)
> +               media_entity_create_link(tuner, 0, decoder, 0,
> +                                        MEDIA_LNK_FL_ENABLED);
> +       if (dev->vdev.entity.links)
> +               media_entity_create_link(decoder, 1, &dev->vdev.entity, 0,
> +                                MEDIA_LNK_FL_ENABLED);
> +       if (dev->vbi_dev.entity.links)
> +               media_entity_create_link(decoder, 2, &dev->vbi_dev.entity, 0,
> +                                MEDIA_LNK_FL_ENABLED);
> +#endif
> +}
> +
>  static int au0828_usb_probe(struct usb_interface *interface,
>         const struct usb_device_id *id)
>  {
> @@ -224,11 +315,16 @@ static int au0828_usb_probe(struct usb_interface *interface,
>         dev->boardnr = id->driver_info;
>         dev->board = au0828_boards[dev->boardnr];
>
> +       /* Register the media controller */
> +       au0828_media_device_register(dev, usbdev);
>
>  #ifdef CONFIG_VIDEO_AU0828_V4L2
>         dev->v4l2_dev.release = au0828_usb_v4l2_release;
>
>         /* Create the v4l2_device */
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       dev->v4l2_dev.mdev = dev->media_dev;
> +#endif
>         retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
>         if (retval) {
>                 pr_err("%s() v4l2_device_register failed\n",
> @@ -287,6 +383,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
>
>         mutex_unlock(&dev->lock);
>
> +       au0828_create_media_graph(dev);
> +
>         return retval;
>  }
>
> diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
> index c267d76f5b3c..c01772c4f9f0 100644
> --- a/drivers/media/usb/au0828/au0828-dvb.c
> +++ b/drivers/media/usb/au0828/au0828-dvb.c
> @@ -415,6 +415,11 @@ static int dvb_register(struct au0828_dev *dev)
>                        result);
>                 goto fail_adapter;
>         }
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
> +       dvb->adapter.mdev = dev->media_dev;
> +#endif
> +
>         dvb->adapter.priv = dev;
>
>         /* register frontend */
> @@ -480,6 +485,11 @@ static int dvb_register(struct au0828_dev *dev)
>
>         dvb->start_count = 0;
>         dvb->stop_count = 0;
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
> +       dvb_create_media_graph(&dvb->adapter);
> +#endif
> +
>         return 0;
>
>  fail_fe_conn:
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 1a362a041ab3..4ebe13673adf 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -637,6 +637,75 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
>         return rc;
>  }
>
> +static int au0828_enable_analog_tuner(struct au0828_dev *dev)
> +{
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       struct media_device *mdev = dev->media_dev;
> +       struct media_entity  *entity, *decoder = NULL, *source;
> +       struct media_link *link, *found_link = NULL;
> +       int i, ret, active_links = 0;
> +
> +       if (!mdev)
> +               return 0;
> +
> +       /*
> +        * This will find the tuner that is connected into the decoder.
> +        * Technically, this is not 100% correct, as the device may be
> +        * using an analog input instead of the tuner. However, as we can't
> +        * do DVB streaming while the DMA engine is being used for V4L2,
> +        * this should be enough for the actual needs.
> +        */
> +       media_device_for_each_entity(entity, mdev) {
> +               if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
> +                       decoder = entity;
> +                       break;
> +               }
> +       }
> +       if (!decoder)
> +               return 0;
> +
> +       for (i = 0; i < decoder->num_links; i++) {
> +               link = &decoder->links[i];
> +               if (link->sink->entity == decoder) {
> +                       found_link = link;
> +                       if (link->flags & MEDIA_LNK_FL_ENABLED)
> +                               active_links++;
> +                       break;
> +               }
> +       }
> +
> +       if (active_links == 1 || !found_link)
> +               return 0;
> +
> +       source = found_link->source->entity;
> +       for (i = 0; i < source->num_links; i++) {
> +               struct media_entity *sink;
> +               int flags = 0;
> +
> +               link = &source->links[i];
> +               sink = link->sink->entity;
> +
> +               if (sink == entity)
> +                       flags = MEDIA_LNK_FL_ENABLED;
> +
> +               ret = media_entity_setup_link(link, flags);
> +               if (ret) {
> +                       pr_err(
> +                               "Couldn't change link %s->%s to %s. Error %d\n",
> +                               source->name, sink->name,
> +                               flags ? "enabled" : "disabled",
> +                               ret);
> +                       return ret;
> +               } else
> +                       au0828_isocdbg(
> +                               "link %s->%s was %s\n",
> +                               source->name, sink->name,
> +                               flags ? "ENABLED" : "disabled");
> +       }
> +#endif
> +       return 0;
> +}
> +
>  static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
>                        unsigned int *nbuffers, unsigned int *nplanes,
>                        unsigned int sizes[], void *alloc_ctxs[])
> @@ -652,6 +721,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
>         *nplanes = 1;
>         sizes[0] = size;
>
> +       au0828_enable_analog_tuner(dev);
> +
>         return 0;
>  }
>
> @@ -1821,6 +1892,18 @@ int au0828_analog_register(struct au0828_dev *dev,
>         dev->vbi_dev.queue->lock = &dev->vb_vbi_queue_lock;
>         strcpy(dev->vbi_dev.name, "au0828a vbi");
>
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +       dev->video_pad.flags = MEDIA_PAD_FL_SINK;
> +       ret = media_entity_init(&dev->vdev.entity, 1, &dev->video_pad, 0);
> +       if (ret < 0)
> +               pr_err("failed to initialize video media entity!\n");
> +
> +       dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
> +       ret = media_entity_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad, 0);
> +       if (ret < 0)
> +               pr_err("failed to initialize vbi media entity!\n");
> +#endif
> +
>         /* initialize videobuf2 stuff */
>         retval = au0828_vb2_setup(dev);
>         if (retval != 0) {
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index 3b480005ce3b..7e6a3bbc68ab 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -32,6 +32,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-fh.h>
> +#include <media/media-device.h>
>
>  /* DVB */
>  #include "demux.h"
> @@ -275,6 +276,11 @@ struct au0828_dev {
>         /* Preallocated transfer digital transfer buffers */
>
>         char *dig_transfer_buffer[URB_COUNT];
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       struct media_device *media_dev;
> +       struct media_pad video_pad, vbi_pad;
> +#endif
>  };
>
>
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
