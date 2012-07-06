Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38309 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2GFPB1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 11:01:27 -0400
Received: by yhmm54 with SMTP id m54so9471798yhm.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 08:01:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF61111.7050900@redhat.com>
References: <1340991243-2951-1-git-send-email-elezegarcia@gmail.com>
	<4FF61111.7050900@redhat.com>
Date: Fri, 6 Jul 2012 12:01:24 -0300
Message-ID: <CALF0-+XEgDzHqMyNfMpRuisyJc76jDSr_mPt_EMn_+MnFda1gw@mail.gmail.com>
Subject: Re: [PATCH v4] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,



On Thu, Jul 5, 2012 at 7:11 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index 99937c9..8d94d56 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -661,6 +661,8 @@ source "drivers/media/video/hdpvr/Kconfig"
>>
>>   source "drivers/media/video/em28xx/Kconfig"
>>
>> +source "drivers/media/video/stk1160/Kconfig"
>> +
>>   source "drivers/media/video/tlg2300/Kconfig"
>>
>>   source "drivers/media/video/cx231xx/Kconfig"
>> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>> index d209de0..7698b25 100644
>> --- a/drivers/media/video/Makefile
>> +++ b/drivers/media/video/Makefile
>> @@ -125,6 +125,7 @@ obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
>>   obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
>>   obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
>>   obj-$(CONFIG_VIDEO_TIMBERDALE)      += timblogiw.o
>> +obj-$(CONFIG_VIDEO_STK1160) += stk1160/
>>
>>   obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>>   obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
>> diff --git a/drivers/media/video/stk1160/Kconfig b/drivers/media/video/stk1160/Kconfig
>> new file mode 100644
>> index 0000000..7ae1685
>> --- /dev/null
>> +++ b/drivers/media/video/stk1160/Kconfig
>> @@ -0,0 +1,12 @@
>> +config VIDEO_STK1160
>> +     tristate "STK1160 USB video capture support"
>> +     depends on VIDEO_DEV && I2C && EASYCAP!=m && EASYCAP!=y
>
> Instead of it, why don't you just remove the EASYCAP driver?
>

Sure!



>> +     select VIDEOBUF2_VMALLOC
>> +     select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
>> +     select SND_AC97_CODEC
>> +
>> +     ---help---
>> +       This is a video4linux driver for STK1160 based video capture devices
>> +
>> +       To compile this driver as a module, choose M here: the
>> +       module will be called stk1160
>> diff --git a/drivers/media/video/stk1160/Makefile b/drivers/media/video/stk1160/Makefile
>> new file mode 100644
>> index 0000000..5d8f1ba
>> --- /dev/null
>> +++ b/drivers/media/video/stk1160/Makefile
>> @@ -0,0 +1,6 @@
>> +stk1160-y := stk1160-core.o stk1160-v4l.o stk1160-video.o stk1160-i2c.o stk1160-ac97.o
>> +
>> +obj-$(CONFIG_VIDEO_STK1160) += stk1160.o
>> +
>> +ccflags-y += -Wall
>> +ccflags-y += -Idrivers/media/video
>> diff --git a/drivers/media/video/stk1160/stk1160-ac97.c b/drivers/media/video/stk1160/stk1160-ac97.c
>> new file mode 100644
>> index 0000000..529b05b
>> --- /dev/null
>> +++ b/drivers/media/video/stk1160/stk1160-ac97.c
>> @@ -0,0 +1,152 @@
>> +/*
>> + * STK1160 driver
>> + *
>> + * Copyright (C) 2012 Ezequiel Garcia
>> + * <elezegarcia--a.t--gmail.com>
>> + *
>> + * Based on Easycap driver by R.M. Thomas
>> + *   Copyright (C) 2010 R.M. Thomas
>> + *   <rmthomas--a.t--sciolus.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <sound/core.h>
>> +#include <sound/initval.h>
>> +#include <sound/ac97_codec.h>
>> +
>> +#include "stk1160.h"
>> +#include "stk1160-reg.h"
>> +
>> +static struct snd_ac97 *stk1160_ac97;
>> +
>> +static void stk1160_write_ac97(struct snd_ac97 *ac97, u16 reg, u16 value)
>> +{
>> +     struct stk1160 *dev = ac97->private_data;
>> +
>> +     /* Set codec register address */
>> +     stk1160_write_reg(dev, STK1160_AC97_ADDR, reg);
>> +
>> +     /* Set codec command */
>> +     stk1160_write_reg(dev, STK1160_AC97_CMD, value & 0xff);
>> +     stk1160_write_reg(dev, STK1160_AC97_CMD + 1, (value & 0xff00) >> 8);
>> +
>> +     /*
>> +      * Set command write bit to initiate write operation.
>> +      * The bit will be cleared when transfer is done.
>> +      */
>> +     stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8c);
>> +}
>> +
>> +static u16 stk1160_read_ac97(struct snd_ac97 *ac97, u16 reg)
>> +{
>> +     struct stk1160 *dev = ac97->private_data;
>> +     u8 vall = 0;
>> +     u8 valh = 0;
>> +
>> +     /* Set codec register address */
>> +     stk1160_write_reg(dev, STK1160_AC97_ADDR, reg);
>> +
>> +     /*
>> +      * Set command read bit to initiate read operation.
>> +      * The bit will be cleared when transfer is done.
>> +      */
>> +     stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8b);
>> +
>> +     /* Retrieve register value */
>> +     stk1160_read_reg(dev, STK1160_AC97_CMD, &vall);
>> +     stk1160_read_reg(dev, STK1160_AC97_CMD + 1, &valh);
>> +
>> +     return (valh << 8) | vall;
>> +}
>> +
>> +static void stk1160_reset_ac97(struct snd_ac97 *ac97)
>> +{
>> +     struct stk1160 *dev = ac97->private_data;
>> +     /* Two-step reset AC97 interface and hardware codec */
>> +     stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x94);
>> +     stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x88);
>> +
>> +     /* Set 16-bit audio data and choose L&R channel*/
>> +     stk1160_write_reg(dev, STK1160_AC97CTL_1 + 2, 0x01);
>> +}
>> +
>> +static struct snd_ac97_bus_ops stk1160_ac97_ops = {
>> +     .read   = stk1160_read_ac97,
>> +     .write  = stk1160_write_ac97,
>> +     .reset  = stk1160_reset_ac97,
>> +};
>> +
>> +int stk1160_ac97_register(struct stk1160 *dev)
>> +{
>> +     struct snd_card *card = NULL;
>> +     struct snd_ac97_bus *ac97_bus;
>> +     struct snd_ac97_template ac97_template;
>> +     int rc;
>> +
>> +     /*
>> +      * Just want a card to access ac96 controls,
>> +      * the actual capture interface will be handled by snd-usb-audio
>> +      */
>> +     rc = snd_card_create(SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
>> +                           THIS_MODULE, 0, &card);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     snd_card_set_dev(card, dev->dev);
>> +
>> +     /* TODO: I'm not sure where should I get these names :-( */
>> +     snprintf(card->shortname, sizeof(card->shortname),
>> +              "stk1160-mixer");
>> +     snprintf(card->longname, sizeof(card->longname),
>> +              "stk1160 ac97 codec mixer control");
>> +     strncpy(card->driver, dev->dev->driver->name, sizeof(card->driver));
>> +
>> +     rc = snd_ac97_bus(card, 0, &stk1160_ac97_ops, NULL, &ac97_bus);
>> +     if (rc)
>> +             goto err;
>> +
>> +     /* We must set private_data before calling snd_ac97_mixer */
>> +     memset(&ac97_template, 0, sizeof(ac97_template));
>> +     ac97_template.private_data = dev;
>> +     ac97_template.scaps = AC97_SCAP_SKIP_MODEM;
>> +     rc = snd_ac97_mixer(ac97_bus, &ac97_template, &stk1160_ac97);
>> +     if (rc)
>> +             goto err;
>> +
>> +     dev->snd_card = card;
>> +     rc = snd_card_register(card);
>> +     if (rc)
>> +             goto err;
>> +
>> +     return 0;
>> +
>> +err:
>> +     if (card)
>> +             snd_card_free(card);
>> +     return rc;
>> +}
>> +
>> +int stk1160_ac97_unregister(struct stk1160 *dev)
>> +{
>> +     struct snd_card *card = dev->snd_card;
>> +
>> +     /*
>> +      * We need to check usb_device,
>> +      * because ac97 release attempts to communicate with codec
>> +      */
>> +     if (card && dev->udev)
>> +             snd_card_free(card);
>> +
>> +     return 0;
>> +}
>
> It probably makes sense to put the ac97 part of the code inside the -alsa
> tree. Anyway, this should be submitted c/c alsa ML, as we want them to take
> a look on it and ack.
>
>

Yes, I wanted to Cc them, but I forgot about it :-(
I'm not sure where to put it in alsa tree, but I'll try to.

Would this be a new module stk1160-mixer?





>> diff --git a/drivers/media/video/stk1160/stk1160-core.c b/drivers/media/video/stk1160/stk1160-core.c
>> new file mode 100644
>> index 0000000..6f62fe6
>> --- /dev/null
>> +++ b/drivers/media/video/stk1160/stk1160-core.c
>> @@ -0,0 +1,433 @@
>> +/*
>> + * STK1160 driver
>> + *
>> + * Copyright (C) 2012 Ezequiel Garcia
>> + * <elezegarcia--a.t--gmail.com>
>> + *
>> + * Based on Easycap driver by R.M. Thomas
>> + *   Copyright (C) 2010 R.M. Thomas
>> + *   <rmthomas--a.t--sciolus.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * TODO:
>> + * Should I dealloc buffers when stop or only on disconnect?
>> + * See em28xx patch about memory fragmentation.
>> + * (Perhaps allow a parameter to control this)
>> + *
>> + * How about framesize and frameinterval v4l2 ioctl?
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/errno.h>
>> +#include <linux/slab.h>
>> +
>> +#include <linux/usb.h>
>> +#include <linux/mm.h>
>> +#include <linux/vmalloc.h>
>> +#include <media/saa7115.h>
>> +
>> +#include "stk1160.h"
>> +#include "stk1160-reg.h"
>> +
>> +static unsigned int input;
>> +module_param(input, int, 0644);
>> +MODULE_PARM_DESC(input, "Set default input");
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Ezequiel Garcia");
>> +MODULE_DESCRIPTION("STK1160 driver");
>> +
>> +/* Devices supported by this driver */
>> +static struct usb_device_id stk1160_id_table[] = {
>> +     { USB_DEVICE(0x05e1, 0x0408) },
>> +     { }
>> +};
>> +MODULE_DEVICE_TABLE(usb, stk1160_id_table);
>> +
>> +/* saa7113 I2C address */
>> +static unsigned short saa7113_addrs[] = {
>> +     0x4a >> 1,
>> +     I2C_CLIENT_END
>> +};
>> +
>> +/*
>> + * Read/Write stk registers
>> + */
>> +int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
>> +{
>> +     int ret;
>> +     int pipe = usb_rcvctrlpipe(dev->udev, 0);
>> +
>> +     *value = 0;
>> +     ret = usb_control_msg(dev->udev, pipe, 0x00,
>> +                     USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>> +                     0x00, reg, value, sizeof(u8), HZ);
>> +     if (ret < 0) {
>> +             stk1160_err("read failed on reg 0x%x (%d)\n",
>> +                     reg, ret);
>> +             return ret;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +int stk1160_write_reg(struct stk1160 *dev, u16 reg, u16 value)
>> +{
>> +     int ret;
>> +     int pipe = usb_sndctrlpipe(dev->udev, 0);
>> +
>> +     ret =  usb_control_msg(dev->udev, pipe, 0x01,
>> +                     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>> +                     value, reg, NULL, 0, HZ);
>> +     if (ret < 0) {
>> +             stk1160_err("write failed on reg 0x%x (%d)\n",
>> +                     reg, ret);
>> +             return ret;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +void stk1160_select_input(struct stk1160 *dev)
>> +{
>> +     static const u8 gctrl[] = {
>> +             0x98, 0x90, 0x88, 0x80
>> +     };
>> +
>> +     if (dev->ctl_input < ARRAY_SIZE(gctrl))
>> +             stk1160_write_reg(dev, STK1160_GCTRL, gctrl[dev->ctl_input]);
>> +}
>> +
>> +/* TODO: We should break this into pieces */
>> +static void stk1160_reg_reset(struct stk1160 *dev)
>> +{
>> +     int i;
>> +
>> +     static const struct regval ctl[] = {
>> +             {STK1160_GCTRL+2, 0x0078},
>> +
>> +             {STK1160_RMCTL+1, 0x0000},
>> +             {STK1160_RMCTL+3, 0x0002},
>> +
>> +             {STK1160_PLLSO,   0x0010},
>> +             {STK1160_PLLSO+1, 0x0000},
>> +             {STK1160_PLLSO+2, 0x0014},
>> +             {STK1160_PLLSO+3, 0x000E},
>> +
>> +             {STK1160_PLLFD,   0x0046},
>> +
>> +             /* Timing generator setup */
>> +             {STK1160_TIGEN,   0x0012},
>> +             {STK1160_TICTL,   0x002D},
>> +             {STK1160_TICTL+1, 0x0001},
>> +             {STK1160_TICTL+2, 0x0000},
>> +             {STK1160_TICTL+3, 0x0000},
>> +             {STK1160_TIGEN,   0x0080},
>> +
>> +             {0xffff, 0xffff}
>> +     };
>> +
>> +     for (i = 0; ctl[i].reg != 0xffff; i++)
>> +             stk1160_write_reg(dev, ctl[i].reg, ctl[i].val);
>> +}
>> +
>> +static void stk1160_release(struct v4l2_device *v4l2_dev)
>> +{
>> +     struct stk1160 *dev = container_of(v4l2_dev, struct stk1160, v4l2_dev);
>> +
>> +     stk1160_info("releasing all resources\n");
>> +
>> +     stk1160_i2c_unregister(dev);
>> +
>> +     v4l2_ctrl_handler_free(&dev->ctrl_handler);
>> +     v4l2_device_unregister(&dev->v4l2_dev);
>> +     kfree(dev->alt_max_pkt_size);
>> +     kfree(dev);
>> +}
>> +
>> +/* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
>> +#define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
>> +
>> +/*
>> + * Scan usb interface and populate max_pkt_size array
>> + * with information on each alternate setting.
>> + * The array should be allocated by the caller.
>> + */
>> +static int stk1160_scan_usb(struct usb_interface *intf, struct usb_device *udev,
>> +             unsigned int *max_pkt_size)
>> +{
>> +     int i, e, sizedescr, size, ifnum;
>> +     const struct usb_endpoint_descriptor *desc;
>> +
>> +     bool has_video = false, has_audio = false;
>> +     char *speed;
>> +
>> +     ifnum = intf->altsetting[0].desc.bInterfaceNumber;
>> +
>> +     /* Get endpoints */
>> +     for (i = 0; i < intf->num_altsetting; i++) {
>> +
>> +             for (e = 0; e < intf->altsetting[i].desc.bNumEndpoints; e++) {
>> +
>> +                     /* This isn't clear enough, at least to me */
>> +                     desc = &intf->altsetting[i].endpoint[e].desc;
>> +                     sizedescr = le16_to_cpu(desc->wMaxPacketSize);
>> +                     size = sizedescr & 0x7ff;
>> +
>> +                     if (udev->speed == USB_SPEED_HIGH)
>> +                             size = size * hb_mult(sizedescr);
>> +
>> +                     if (usb_endpoint_xfer_isoc(desc) &&
>> +                         usb_endpoint_dir_in(desc)) {
>> +                             switch (desc->bEndpointAddress) {
>> +                             case STK1160_EP_AUDIO:
>> +                                     has_audio = true;
>> +                                     break;
>> +                             case STK1160_EP_VIDEO:
>> +                                     has_video = true;
>> +                                     max_pkt_size[i] = size;
>> +                                     break;
>> +                             }
>> +                     }
>> +             }
>> +     }
>> +
>> +     /* Is this even possible? */
>> +     if (!(has_audio || has_video)) {
>> +             dev_err(&udev->dev, "no audio or video endpoints found\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     switch (udev->speed) {
>> +     case USB_SPEED_LOW:
>> +             speed = "1.5";
>> +             break;
>> +     case USB_SPEED_UNKNOWN:
>> +     case USB_SPEED_FULL:
>> +             speed = "12";
>> +             break;
>> +     case USB_SPEED_HIGH:
>> +             speed = "480";
>> +             break;
>> +     default:
>> +             speed = "unknown";
>> +     }
>> +
>> +     dev_info(&udev->dev, "New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
>> +             udev->manufacturer ? udev->manufacturer : "",
>> +             udev->product ? udev->product : "",
>> +             speed,
>> +             le16_to_cpu(udev->descriptor.idVendor),
>> +             le16_to_cpu(udev->descriptor.idProduct),
>> +             ifnum,
>> +             intf->altsetting->desc.bInterfaceNumber);
>> +
>> +     /* This should never happen, since we rejected audio interfaces */
>> +     if (has_audio)
>> +             dev_warn(&udev->dev, "audio interface %d found.\n\
>> +                             This is not implemented by this driver,\
>> +                             you should use snd-usb-audio instead\n", ifnum);
>> +
>> +     if (has_video)
>> +             dev_info(&udev->dev, "video interface %d found\n",
>> +                             ifnum);
>> +
>> +     /*
>> +      * Make sure we have 480 Mbps of bandwidth, otherwise things like
>> +      * video stream wouldn't likely work, since 12 Mbps is generally
>> +      * not enough even for most streams.
>> +      */
>> +     if (udev->speed != USB_SPEED_HIGH) {
>> +             dev_err(&udev->dev, "must be connected to a high-speed USB 2.0 port\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int stk1160_probe(struct usb_interface *interface,
>> +             const struct usb_device_id *id)
>> +{
>> +     int ifnum;
>> +     int rc = 0;
>> +
>> +     unsigned int *alt_max_pkt_size; /* array of wMaxPacketSize */
>> +     struct usb_device *udev;
>> +     struct stk1160 *dev;
>> +
>> +     ifnum = interface->altsetting[0].desc.bInterfaceNumber;
>> +     udev = interface_to_usbdev(interface);
>> +
>> +     /*
>> +      * Since usb audio class is supported by snd-usb-audio,
>> +      * we reject audio interface.
>> +      */
>> +     if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO)
>> +             return -ENODEV;
>> +
>> +     /* Alloc an array for all possible max_pkt_size */
>> +     alt_max_pkt_size = kmalloc(sizeof(alt_max_pkt_size[0]) *
>> +                     interface->num_altsetting, GFP_KERNEL);
>> +     if (alt_max_pkt_size == NULL)
>> +             return -ENOMEM;
>> +
>> +     /*
>> +      * Scan usb posibilities and populate alt_max_pkt_size array.
>> +      * Also, check if device speed is fast enough.
>> +      */
>> +     rc = stk1160_scan_usb(interface, udev, alt_max_pkt_size);
>> +     if (rc < 0) {
>> +             kfree(alt_max_pkt_size);
>> +             return rc;
>> +     }
>> +
>> +     dev = kzalloc(sizeof(struct stk1160), GFP_KERNEL);
>> +     if (dev == NULL) {
>> +             kfree(alt_max_pkt_size);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     dev->alt_max_pkt_size = alt_max_pkt_size;
>> +     dev->udev = udev;
>> +     dev->num_alt = interface->num_altsetting;
>> +     dev->ctl_input = input;
>> +
>> +     /* We save struct device for debug purposes only */
>> +     dev->dev = &interface->dev;
>> +
>> +     usb_set_intfdata(interface, dev);
>> +
>> +     /* initialize videobuf2 stuff */
>> +     rc = stk1160_vb2_setup(dev);
>> +     if (rc < 0)
>> +             goto free_err;
>> +
>> +     /*
>> +      * There is no need to take any locks here in probe
>> +      * because we register the device node as the *last* thing.
>> +      */
>> +     spin_lock_init(&dev->buf_lock);
>> +     mutex_init(&dev->v4l_lock);
>> +
>> +     rc = v4l2_ctrl_handler_init(&dev->ctrl_handler, 0);
>> +     if (rc) {
>> +             stk1160_err("v4l2_ctrl_handler_init failed (%d)\n", rc);
>> +             goto free_err;
>> +     }
>> +
>> +     /*
>> +      * We obtain a v4l2_dev but defer
>> +      * registration of video device node as the last thing.
>> +      * There is no need to set the name if we give a device struct
>> +      */
>> +     dev->v4l2_dev.release = stk1160_release;
>> +     dev->v4l2_dev.ctrl_handler = &dev->ctrl_handler;
>> +     rc = v4l2_device_register(dev->dev, &dev->v4l2_dev);
>> +     if (rc) {
>> +             stk1160_err("v4l2_device_register failed (%d)\n", rc);
>> +             goto free_ctrl;
>> +     }
>> +
>> +     rc = stk1160_i2c_register(dev);
>> +     if (rc < 0)
>> +             goto unreg_v4l2;
>> +
>> +     /*
>> +      * To the best of my knowledge stk1160 boards only have
>> +      * saa7113, but it doesn't hurt to support them all.
>> +      */
>> +     dev->sd_saa7115 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
>> +             "saa7115_auto", 0, saa7113_addrs);
>> +
>> +     stk1160_info("driver ver %s successfully loaded\n",
>> +             STK1160_VERSION);
>> +
>> +     /* i2c reset saa711x */
>> +     v4l2_device_call_all(&dev->v4l2_dev, 0, core, reset, 0);
>> +     v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
>> +                             0, 0, 0);
>> +     v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
>> +
>> +     /* reset stk1160 to default values */
>> +     stk1160_reg_reset(dev);
>> +
>> +     /* select default input */
>> +     stk1160_select_input(dev);
>> +
>> +     rc = stk1160_video_register(dev);
>> +     if (rc < 0)
>> +             goto unreg_i2c;
>> +
>> +     return 0;
>> +
>> +unreg_i2c:
>> +     stk1160_i2c_unregister(dev);
>> +unreg_v4l2:
>> +     v4l2_device_unregister(&dev->v4l2_dev);
>> +free_ctrl:
>> +     v4l2_ctrl_handler_free(&dev->ctrl_handler);
>> +free_err:
>> +     kfree(alt_max_pkt_size);
>> +     kfree(dev);
>> +
>> +     return rc;
>> +}
>> +
>> +/*
>> + * TODO: What happens if device gets diconnected while probing?
>> + */
>> +static void stk1160_disconnect(struct usb_interface *interface)
>> +{
>> +     struct stk1160 *dev;
>> +
>> +     dev = usb_get_intfdata(interface);
>> +     usb_set_intfdata(interface, NULL);
>> +
>> +     /*
>> +      * Wait until all current v4l2 operation are finished
>> +      * then deallocate resources
>> +      */
>> +     mutex_lock(&dev->v4l_lock);
>> +
>> +     /* Here is the only place where isoc get released */
>> +     stk1160_uninit_isoc(dev);
>> +
>> +     /* ac97 unregister needs to be done before usb_device is cleared */
>> +     stk1160_ac97_unregister(dev);
>> +
>> +     stk1160_stop_streaming(dev, false);
>> +     video_unregister_device(&dev->vdev);
>> +     v4l2_device_disconnect(&dev->v4l2_dev);
>> +
>> +     /* This way current users can detect device is gone */
>> +     dev->udev = NULL;
>> +
>> +     mutex_unlock(&dev->v4l_lock);
>> +
>> +     /*
>> +      * This calls stk1160_release if it's the last reference.
>> +      * therwise, release is posponed until there are no users left.
>> +      */
>> +     v4l2_device_put(&dev->v4l2_dev);
>> +}
>> +
>> +static struct usb_driver stk1160_usb_driver = {
>> +     .name = "stk1160",
>> +     .id_table = stk1160_id_table,
>> +     .probe = stk1160_probe,
>> +     .disconnect = stk1160_disconnect,
>> +};
>> +
>> +module_usb_driver(stk1160_usb_driver);
>> diff --git a/drivers/media/video/stk1160/stk1160-i2c.c b/drivers/media/video/stk1160/stk1160-i2c.c
>> new file mode 100644
>> index 0000000..176ac93
>> --- /dev/null
>> +++ b/drivers/media/video/stk1160/stk1160-i2c.c
>> @@ -0,0 +1,294 @@
>> +/*
>> + * STK1160 driver
>> + *
>> + * Copyright (C) 2012 Ezequiel Garcia
>> + * <elezegarcia--a.t--gmail.com>
>> + *
>> + * Based on Easycap driver by R.M. Thomas
>> + *   Copyright (C) 2010 R.M. Thomas
>> + *   <rmthomas--a.t--sciolus.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/usb.h>
>> +#include <linux/i2c.h>
>> +
>> +#include "stk1160.h"
>> +#include "stk1160-reg.h"
>> +
>> +static unsigned int i2c_debug;
>> +module_param(i2c_debug, int, 0644);
>> +MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
>> +
>> +#define dprintk_i2c(fmt, args...)                            \
>> +do {                                                         \
>> +     if (i2c_debug)                                          \
>> +             printk(KERN_DEBUG fmt, ##args);                 \
>> +} while (0)
>> +
>> +static int stk1160_i2c_busy_wait(struct stk1160 *dev, u8 wait_bit_mask)
>> +{
>> +     unsigned long end;
>> +     u8 flag;
>> +
>> +     /* Wait until read/write finish bit is set */
>> +     end = jiffies + msecs_to_jiffies(STK1160_I2C_TIMEOUT);
>> +     while (time_is_after_jiffies(end)) {
>> +
>> +             stk1160_read_reg(dev, STK1160_SICTL+1, &flag);
>> +             /* read/write done? */
>> +             if (flag & wait_bit_mask)
>> +                     goto done;
>> +
>> +             usleep_range(10 * USEC_PER_MSEC, 20 * USEC_PER_MSEC);
>> +     }
>> +
>> +     return -ETIMEDOUT;
>> +
>> +done:
>> +     return 0;
>> +}
>> +
>> +static int stk1160_i2c_write_reg(struct stk1160 *dev, u8 addr,
>> +             u8 reg, u8 value)
>> +{
>> +     int rc;
>> +
>> +     /* Set serial device address */
>> +     rc = stk1160_write_reg(dev, STK1160_SICTL_SDA, addr);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     /* Set i2c device register sub-address */
>> +     rc = stk1160_write_reg(dev, STK1160_SBUSW_WA, reg);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     /* Set i2c device register value */
>> +     rc = stk1160_write_reg(dev, STK1160_SBUSW_WD, value);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     /* Start write now */
>> +     rc = stk1160_write_reg(dev, STK1160_SICTL, 0x01);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     rc = stk1160_i2c_busy_wait(dev, 0x04);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     return 0;
>> +}
>> +
>> +static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
>> +             u8 reg, u8 *value)
>> +{
>> +     int rc;
>> +
>> +     /* Set serial device address */
>> +     rc = stk1160_write_reg(dev, STK1160_SICTL_SDA, addr);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     /* Set i2c device register sub-address */
>> +     rc = stk1160_write_reg(dev, STK1160_SBUSR_RA, reg);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     /* Start read now */
>> +     rc = stk1160_write_reg(dev, STK1160_SICTL, 0x20);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     rc = stk1160_i2c_busy_wait(dev, 0x01);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * stk1160_i2c_check_for_device()
>> + * check if there is a i2c_device at the supplied address
>> + */
>> +static int stk1160_i2c_check_for_device(struct stk1160 *dev,
>> +             unsigned char addr)
>> +{
>> +     int rc;
>> +
>> +     /* Set serial device address */
>> +     rc = stk1160_write_reg(dev, STK1160_SICTL_SDA, addr);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     /* Set device sub-address, we'll chip version reg */
>> +     rc = stk1160_write_reg(dev, STK1160_SBUSR_RA, 0x00);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     /* Start read now */
>> +     rc = stk1160_write_reg(dev, STK1160_SICTL, 0x20);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     rc = stk1160_i2c_busy_wait(dev, 0x01);
>> +     if (rc < 0)
>> +             return -ENODEV;
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * stk1160_i2c_xfer()
>> + * the main i2c transfer function
>> + */
>> +static int stk1160_i2c_xfer(struct i2c_adapter *i2c_adap,
>> +                        struct i2c_msg msgs[], int num)
>> +{
>> +     struct stk1160 *dev = i2c_adap->algo_data;
>> +     int addr, rc, i;
>> +
>> +     for (i = 0; i < num; i++) {
>> +             addr = msgs[i].addr << 1;
>> +             dprintk_i2c("%s: addr=%x", __func__, addr);
>> +
>> +             if (!msgs[i].len) {
>> +                     /* no len: check only for device presence */
>> +                     rc = stk1160_i2c_check_for_device(dev, addr);
>> +                     if (rc < 0) {
>> +                             dprintk_i2c(" no device\n");
>> +                             return rc;
>> +                     }
>> +
>> +             } else if (msgs[i].flags & I2C_M_RD) {
>> +                     /* read request without preceding register selection */
>> +                     dprintk_i2c(" subaddr not selected");
>> +                     rc = -EOPNOTSUPP;
>> +                     goto err;
>> +
>> +             } else if (i + 1 < num && msgs[i].len <= 2 &&
>> +                        (msgs[i + 1].flags & I2C_M_RD) &&
>> +                        msgs[i].addr == msgs[i + 1].addr) {
>> +
>> +                     if (msgs[i].len != 1 || msgs[i + 1].len != 1) {
>> +                             dprintk_i2c(" len not supported");
>> +                             rc = -EOPNOTSUPP;
>> +                             goto err;
>> +                     }
>> +
>> +                     dprintk_i2c(" subaddr=%x", msgs[i].buf[0]);
>> +
>> +                     rc = stk1160_i2c_read_reg(dev, addr, msgs[i].buf[0],
>> +                             msgs[i + 1].buf);
>> +
>> +                     dprintk_i2c(" read=%x", *msgs[i + 1].buf);
>> +
>> +                     /* consumed two msgs, so we skip one of them */
>> +                     i++;
>> +
>> +             } else {
>> +                     if (msgs[i].len != 2) {
>> +                             dprintk_i2c(" len not supported");
>> +                             rc = -EOPNOTSUPP;
>> +                             goto err;
>> +                     }
>> +
>> +                     dprintk_i2c(" subaddr=%x write=%x",
>> +                             msgs[i].buf[0],  msgs[i].buf[1]);
>> +
>> +                     rc = stk1160_i2c_write_reg(dev, addr, msgs[i].buf[0],
>> +                             msgs[i].buf[1]);
>> +             }
>> +
>> +             if (rc < 0)
>> +                     goto err;
>> +             dprintk_i2c(" OK\n");
>> +     }
>> +
>> +     return num;
>> +err:
>> +     dprintk_i2c(" ERROR: %d\n", rc);
>> +     return num;
>> +}
>> +
>> +/*
>> + * functionality(), what da heck is this?
>> + */
>> +static u32 functionality(struct i2c_adapter *adap)
>> +{
>> +     return I2C_FUNC_SMBUS_EMUL;
>> +}
>> +
>> +static struct i2c_algorithm algo = {
>> +     .master_xfer   = stk1160_i2c_xfer,
>> +     .functionality = functionality,
>> +};
>> +
>> +static struct i2c_adapter adap_template = {
>> +     .owner = THIS_MODULE,
>> +     .name = "stk1160",
>> +     .algo = &algo,
>> +};
>> +
>> +static struct i2c_client client_template = {
>> +     .name = "stk1160 internal",
>> +};
>> +
>> +/*
>> + * stk1160_i2c_register()
>> + * register i2c bus
>> + */
>> +int stk1160_i2c_register(struct stk1160 *dev)
>> +{
>> +     int rc;
>> +
>> +     dev->i2c_adap = adap_template;
>> +     dev->i2c_adap.dev.parent = dev->dev;
>> +     strcpy(dev->i2c_adap.name, "stk1160");
>> +     dev->i2c_adap.algo_data = dev;
>> +
>> +     i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
>> +
>> +     rc = i2c_add_adapter(&dev->i2c_adap);
>> +     if (rc < 0) {
>> +             stk1160_err("cannot add i2c adapter (%d)\n", rc);
>> +             return rc;
>> +     }
>> +
>> +     dev->i2c_client = client_template;
>> +     dev->i2c_client.adapter = &dev->i2c_adap;
>> +
>> +     /* Set i2c clock divider device address */
>> +     stk1160_write_reg(dev, STK1160_SICTL_CD,  0x0f);
>> +
>> +     /* ??? */
>> +     stk1160_write_reg(dev, STK1160_ASIC + 3,  0x00);
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * stk1160_i2c_unregister()
>> + * unregister i2c_bus
>> + */
>> +int stk1160_i2c_unregister(struct stk1160 *dev)
>> +{
>> +     i2c_del_adapter(&dev->i2c_adap);
>> +     return 0;
>> +}
>> diff --git a/drivers/media/video/stk1160/stk1160-reg.h b/drivers/media/video/stk1160/stk1160-reg.h
>> new file mode 100644
>> index 0000000..3e49da6
>> --- /dev/null
>> +++ b/drivers/media/video/stk1160/stk1160-reg.h
>> @@ -0,0 +1,93 @@
>> +/*
>> + * STK1160 driver
>> + *
>> + * Copyright (C) 2012 Ezequiel Garcia
>> + * <elezegarcia--a.t--gmail.com>
>> + *
>> + * Based on Easycap driver by R.M. Thomas
>> + *   Copyright (C) 2010 R.M. Thomas
>> + *   <rmthomas--a.t--sciolus.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +/* GPIO Control */
>> +#define STK1160_GCTRL                        0x000
>> +
>> +/* Remote Wakup Control */
>> +#define STK1160_RMCTL                        0x00c
>> +
>> +/*
>> + * Decoder Control Register:
>> + * This byte controls capture start/stop
>> + * with bit #7 (0x?? OR 0x80 to activate).
>> + */
>> +#define STK1160_DCTRL                        0x100
>> +
>> +/* Capture Frame Start Position */
>> +#define STK116_CFSPO                 0x110
>> +#define STK116_CFSPO_STX_L           0x110
>> +#define STK116_CFSPO_STX_H           0x111
>> +#define STK116_CFSPO_STY_L           0x112
>> +#define STK116_CFSPO_STY_H           0x113
>> +
>> +/* Capture Frame End Position */
>> +#define STK116_CFEPO                 0x114
>> +#define STK116_CFEPO_ENX_L           0x114
>> +#define STK116_CFEPO_ENX_H           0x115
>> +#define STK116_CFEPO_ENY_L           0x116
>> +#define STK116_CFEPO_ENY_H           0x117
>> +
>> +/* Serial Interface Control  */
>> +#define STK1160_SICTL                        0x200
>> +#define STK1160_SICTL_CD             0x202
>> +#define STK1160_SICTL_SDA            0x203
>> +
>> +/* Serial Bus Write */
>> +#define STK1160_SBUSW                        0x204
>> +#define STK1160_SBUSW_WA             0x204
>> +#define STK1160_SBUSW_WD             0x205
>> +
>> +/* Serial Bus Read */
>> +#define STK1160_SBUSR                        0x208
>> +#define STK1160_SBUSR_RA             0x208
>> +#define STK1160_SBUSR_RD             0x209
>> +
>> +/* Alternate Serial Inteface Control */
>> +#define STK1160_ASIC                 0x2fc
>> +
>> +/* PLL Select Options */
>> +#define STK1160_PLLSO                        0x018
>> +
>> +/* PLL Frequency Divider */
>> +#define STK1160_PLLFD                        0x01c
>> +
>> +/* Timing Generator */
>> +#define STK1160_TIGEN                        0x300
>> +
>> +/* Timing Control Parameter */
>> +#define STK1160_TICTL                        0x350
>> +
>> +/* AC97 Audio Control */
>> +#define STK1160_AC97CTL_0            0x500
>> +#define STK1160_AC97CTL_1            0x504
>> +
>> +/* Use [0:6] bits of register 0x504 to set codec command address */
>> +#define STK1160_AC97_ADDR            0x504
>> +/* Use [16:31] bits of register 0x500 to set codec command data */
>> +#define STK1160_AC97_CMD             0x502
>> +
>> +/* Audio I2S Interface */
>> +#define STK1160_I2SCTL                       0x50c
>> +
>> +/* EEPROM Interface */
>> +#define STK1160_EEPROM_SZ            0x5f0
>> diff --git a/drivers/media/video/stk1160/stk1160-v4l.c b/drivers/media/video/stk1160/stk1160-v4l.c
>> new file mode 100644
>> index 0000000..024ddf7
>> --- /dev/null
>> +++ b/drivers/media/video/stk1160/stk1160-v4l.c
>> @@ -0,0 +1,923 @@
>> +/*
>> + * STK1160 driver
>> + *
>> + * Copyright (C) 2012 Ezequiel Garcia
>> + * <elezegarcia--a.t--gmail.com>
>> + *
>> + * Based on Easycap driver by R.M. Thomas
>> + *   Copyright (C) 2010 R.M. Thomas
>> + *   <rmthomas--a.t--sciolus.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/usb.h>
>> +#include <linux/mm.h>
>> +#include <linux/slab.h>
>> +
>> +#include <linux/videodev2.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-chip-ident.h>
>> +#include <media/videobuf2-vmalloc.h>
>> +
>> +#include <media/saa7115.h>
>> +
>> +#include "stk1160.h"
>> +#include "stk1160-reg.h"
>> +
>> +static unsigned int vidioc_debug;
>> +module_param(vidioc_debug, int, 0644);
>> +MODULE_PARM_DESC(vidioc_debug, "enable debug messages [vidioc]");
>> +
>> +static bool keep_buffers;
>> +module_param(keep_buffers, bool, 0644);
>> +MODULE_PARM_DESC(keep_buffers, "don't release buffers upon stop streaming");
>> +
>> +/* supported video standards */
>> +static struct stk1160_fmt format[] = {
>> +     {
>> +             .name     = "16 bpp YUY2, 4:2:2, packed",
>> +             .fourcc   = V4L2_PIX_FMT_UYVY,
>> +             .depth    = 16,
>> +     }
>> +};
>> +
>> +static void stk1160_set_std(struct stk1160 *dev)
>> +{
>> +     int i;
>> +
>> +     static struct regval std525[] = {
>> +
>> +             /* 720x480 */
>> +
>> +             /* Frame start */
>> +             {STK116_CFSPO_STX_L, 0x0000},
>> +             {STK116_CFSPO_STX_H, 0x0000},
>> +             {STK116_CFSPO_STY_L, 0x0003},
>> +             {STK116_CFSPO_STY_H, 0x0000},
>> +
>> +             /* Frame end */
>> +             {STK116_CFEPO_ENX_L, 0x05a0},
>> +             {STK116_CFEPO_ENX_H, 0x0005},
>> +             {STK116_CFEPO_ENY_L, 0x00f3},
>> +             {STK116_CFEPO_ENY_H, 0x0000},
>> +
>> +             {0xffff, 0xffff}
>> +     };
>> +
>> +     static struct regval std625[] = {
>> +
>> +             /* 720x576 */
>> +
>> +             /* TODO: Each line of frame has some junk at the end */
>> +             /* Frame start */
>> +             {STK116_CFSPO,   0x0000},
>> +             {STK116_CFSPO+1, 0x0000},
>> +             {STK116_CFSPO+2, 0x0001},
>> +             {STK116_CFSPO+3, 0x0000},
>> +
>> +             /* Frame end */
>> +             {STK116_CFEPO,   0x05a0},
>> +             {STK116_CFEPO+1, 0x0005},
>> +             {STK116_CFEPO+2, 0x0121},
>> +             {STK116_CFEPO+3, 0x0001},
>> +
>> +             {0xffff, 0xffff}
>> +     };
>> +
>> +     if (dev->norm & V4L2_STD_525_60) {
>> +             stk1160_dbg("registers to NTSC like standard\n");
>> +             for (i = 0; std525[i].reg != 0xffff; i++)
>> +                     stk1160_write_reg(dev, std525[i].reg, std525[i].val);
>> +     } else if (dev->norm & V4L2_STD_625_50) {
>> +             stk1160_dbg("registers to PAL like standard\n");
>> +             for (i = 0; std625[i].reg != 0xffff; i++)
>> +                     stk1160_write_reg(dev, std625[i].reg, std625[i].val);
>> +     } else {
>> +             BUG();
>
>
> It doesn't make sense to add a bug here: a wrong parameter generated
> from userspace shouldn't cause a kernel bug.
>
> Just do:
> if (dev->norm & V4L2_STD_525_60) {
>         ...
> } else {
>         ...
> }
>

Yes, you're right.




>> +     }
>> +
>> +}
>> +
>> +/*
>> + * Set a new alternate setting.
>> + * Returns true is dev->max_pkt_size has changed, false otherwise.
>> + */
>> +static bool stk1160_set_alternate(struct stk1160 *dev)
>> +{
>> +     int i, prev_alt = dev->alt;
>> +     unsigned int min_pkt_size;
>> +     bool new_pkt_size;
>> +
>> +     /*
>> +      * If we don't set right alternate,
>> +      * then we will get a green screen with junk.
>> +      */
>> +     min_pkt_size = STK1160_MIN_PKT_SIZE;
>> +
>> +     for (i = 0; i < dev->num_alt; i++) {
>> +             /* stop when the selected alt setting offers enough bandwidth */
>> +             if (dev->alt_max_pkt_size[i] >= min_pkt_size) {
>> +                     dev->alt = i;
>> +                     break;
>> +             /*
>> +              * otherwise make sure that we end up with the maximum bandwidth
>> +              * because the min_pkt_size equation might be wrong...
>> +              */
>> +             } else if (dev->alt_max_pkt_size[i] >
>> +                        dev->alt_max_pkt_size[dev->alt])
>> +                     dev->alt = i;
>> +     }
>> +
>> +     stk1160_info("setting alternate %d\n", dev->alt);
>> +
>> +     if (dev->alt != prev_alt) {
>> +             stk1160_dbg("minimum isoc packet size: %u (alt=%d)\n",
>> +                             min_pkt_size, dev->alt);
>> +             stk1160_dbg("setting alt %d with wMaxPacketSize=%u\n",
>> +                            dev->alt, dev->alt_max_pkt_size[dev->alt]);
>> +             usb_set_interface(dev->udev, 0, dev->alt);
>> +     }
>> +
>> +     new_pkt_size = dev->max_pkt_size != dev->alt_max_pkt_size[dev->alt];
>> +     dev->max_pkt_size = dev->alt_max_pkt_size[dev->alt];
>> +
>> +     return new_pkt_size;
>> +}
>> +
>> +static bool stk1160_acquire_owner(struct stk1160 *dev, struct file *file)
>> +{
>> +     /* If there is an owner and it's not this filehandle */
>> +     if (dev->fh_owner != NULL && dev->fh_owner != file)
>> +             return false;
>> +
>> +     /* We are the owner of this queue and queue operations */
>> +     dev->fh_owner = file;
>> +
>> +     return true;
>> +}
>> +
>> +static void stk1160_drop_owner(struct stk1160 *dev)
>> +{
>> +     dev->fh_owner = NULL;
>> +}
>> +
>> +static bool stk1160_is_owner(struct stk1160 *dev, struct file *file)
>> +{
>> +     return dev->fh_owner == file;
>> +}
>> +
>> +static int stk1160_start_streaming(struct stk1160 *dev)
>> +{
>> +     int i, rc;
>> +     bool new_pkt_size;
>> +
>> +     /* Check device presence */
>> +     if (!dev->udev)
>> +             return -ENODEV;
>> +
>> +     /*
>> +      * For some reason it is mandatory to set alternate *first*
>> +      * and only *then* initialize isoc urbs.
>> +      * Someone please explain me why ;)
>> +      */
>> +     new_pkt_size = stk1160_set_alternate(dev);
>> +
>> +     /*
>> +      * We (re)allocate isoc urbs if:
>> +      * there is no allocated isoc urbs, OR
>> +      * a new dev->max_pkt_size is detected
>> +      */
>> +     if (!dev->isoc_ctl.num_bufs || new_pkt_size) {
>> +             rc = stk1160_alloc_isoc(dev);
>> +             if (rc < 0)
>> +                     return rc;
>> +     }
>> +
>> +     /* submit urbs and enables IRQ */
>> +     for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
>> +             rc = usb_submit_urb(dev->isoc_ctl.urb[i], GFP_KERNEL);
>> +             if (rc) {
>> +                     stk1160_err("cannot submit urb[%d] (%d)\n", i, rc);
>> +                     stk1160_uninit_isoc(dev);
>> +                     return rc;
>> +             }
>> +     }
>> +
>> +     /* Start saa711x */
>> +     v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);
>> +
>> +     /* Start stk1160 */
>> +     stk1160_write_reg(dev, STK1160_DCTRL, 0xb3);
>> +     stk1160_write_reg(dev, STK1160_DCTRL+3, 0x00);
>> +
>> +     stk1160_dbg("streaming started\n");
>> +
>> +     return 0;
>> +}
>> +
>> +int stk1160_stop_streaming(struct stk1160 *dev, bool connected)
>> +{
>> +     struct stk1160_buffer *buf;
>> +     unsigned long flags = 0;
>> +
>> +     stk1160_cancel_isoc(dev);
>> +
>> +     /*
>> +      * It is possible to keep buffers around using a module parameter.
>> +      * This is intended to avoid memory fragmentation.
>> +      */
>> +     if (!keep_buffers)
>> +             stk1160_free_isoc(dev);
>> +
>> +     /* If the device is physically plugged */
>> +     if (connected && dev->udev) {
>> +
>> +             /* set alternate 0 */
>> +             dev->alt = 0;
>> +             stk1160_info("setting alternate %d\n", dev->alt);
>> +             usb_set_interface(dev->udev, 0, 0);
>> +
>> +             /* Stop stk1160 */
>> +             stk1160_write_reg(dev, STK1160_DCTRL, 0x00);
>> +             stk1160_write_reg(dev, STK1160_DCTRL+3, 0x00);
>> +
>> +             /* Stop saa711x */
>> +             v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
>> +     }
>> +
>> +     /* Release all active buffers */
>> +     spin_lock_irqsave(&dev->buf_lock, flags);
>> +     while (!list_empty(&dev->avail_bufs)) {
>> +             buf = list_first_entry(&dev->avail_bufs,
>> +                     struct stk1160_buffer, list);
>> +             list_del(&buf->list);
>> +             vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> +             stk1160_info("buffer [%p/%d] aborted\n",
>> +                             buf, buf->vb.v4l2_buf.index);
>> +     }
>> +     /* It's important to clear current buffer */
>> +     dev->isoc_ctl.buf = NULL;
>> +     spin_unlock_irqrestore(&dev->buf_lock, flags);
>> +
>> +     stk1160_dbg("streaming stopped\n");
>> +     return 0;
>> +}
>> +
>> +/* fops */
>> +static ssize_t stk1160_read(struct file *file,
>> +     char __user *data, size_t count, loff_t *ppos)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     int rc;
>> +
>> +     mutex_lock(&dev->v4l_lock);
>> +     /*
>> +      * Read operation is emulated by videobuf2.
>> +      * When vb2 calls reqbufs it acquires ownership of queue.
>> +      * When the transfer is done, vb2 calls reqbufs with zero count,
>> +      * dropping ownership.
>> +      */
>> +     rc = vb2_read(&dev->vb_vidq, data, count, ppos,
>> +                     file->f_flags & O_NONBLOCK);
>> +
>> +     mutex_unlock(&dev->v4l_lock);
>> +     return rc;
>> +}
>> +
>> +static unsigned int
>> +stk1160_poll(struct file *file, struct poll_table_struct *wait)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     int rc;
>> +
>> +     mutex_lock(&dev->v4l_lock);
>> +     rc = vb2_poll(&dev->vb_vidq, file, wait);
>> +     mutex_unlock(&dev->v4l_lock);
>> +
>> +     return rc;
>> +}
>> +
>> +static int stk1160_close(struct file *file)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     mutex_lock(&dev->v4l_lock);
>> +     /*
>> +      * If this is the owner handle we stop
>> +      * streaming to free/dequeue all buffers.
>> +      * Also, we drop ownership.
>> +      */
>> +     if (stk1160_is_owner(dev, file)) {
>> +             vb2_queue_release(&dev->vb_vidq);
>> +             stk1160_drop_owner(dev);
>> +     }
>> +     mutex_unlock(&dev->v4l_lock);
>> +
>> +     return v4l2_fh_release(file);
>> +}
>> +
>> +static int stk1160_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     int rc;
>> +
>> +     stk1160_dbg("vma=0x%08lx\n", (unsigned long)vma);
>> +
>> +     /* TODO: Lock or trylock? */
>> +     mutex_lock(&dev->v4l_lock);
>> +     rc = vb2_mmap(&dev->vb_vidq, vma);
>> +     mutex_unlock(&dev->v4l_lock);
>> +
>> +     stk1160_dbg("vma start=0x%08lx, size=%ld (%d)\n",
>> +             (unsigned long)vma->vm_start,
>> +             (unsigned long)vma->vm_end - (unsigned long)vma->vm_start,
>> +             rc);
>> +     return rc;
>> +}
>> +
>> +static struct v4l2_file_operations stk1160_fops = {
>> +     .owner = THIS_MODULE,
>> +     .open = v4l2_fh_open,
>> +     .release = stk1160_close,
>> +     .read = stk1160_read,
>> +     .poll = stk1160_poll,
>> +     .unlocked_ioctl = video_ioctl2,
>> +     .mmap = stk1160_mmap,
>> +};
>> +
>> +/*
>> + * vb2 ioctls
>> + */
>> +static int vidioc_reqbufs(struct file *file, void *priv,
>> +                       struct v4l2_requestbuffers *p)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     int rc;
>> +
>> +     if (!stk1160_acquire_owner(dev, file))
>> +             return -EBUSY;
>> +
>> +     rc = vb2_reqbufs(&dev->vb_vidq, p);
>> +
>> +     /*
>> +      * If reqbufs has been called with count == 0
>> +      * it means the owner is releasing the queue,
>> +      * thus dropping ownership.
>> +      */
>> +     if (p->count == 0)
>> +             stk1160_drop_owner(dev);
>> +
>> +     return rc;
>> +}
>> +
>> +static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     if (!stk1160_is_owner(dev, file))
>> +             return -EBUSY;
>> +
>> +     return vb2_querybuf(&dev->vb_vidq, p);
>> +}
>> +
>> +static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     if (!stk1160_is_owner(dev, file))
>> +             return -EBUSY;
>> +
>> +     return vb2_qbuf(&dev->vb_vidq, p);
>> +}
>> +
>> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     if (!stk1160_is_owner(dev, file))
>> +             return -EBUSY;
>> +
>> +     return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags & O_NONBLOCK);
>
> Why to use O_NONBLOCK here? it should be doing whatever userspace wants.

This is discussed on another mail.





>
>> +}
>> +
>> +static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     if (!stk1160_is_owner(dev, file))
>> +             return -EBUSY;
>> +
>> +     return vb2_streamon(&dev->vb_vidq, i);
>> +}
>> +
>> +static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     if (!stk1160_is_owner(dev, file))
>> +             return -EBUSY;
>> +
>> +     return vb2_streamoff(&dev->vb_vidq, i);
>> +}
>> +
>> +/*
>> + * vidioc ioctls
>> + */
>> +static int vidioc_querycap(struct file *file,
>> +             void *priv, struct v4l2_capability *cap)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     strcpy(cap->driver, "stk1160");
>> +     strcpy(cap->card, "stk1160");
>> +     usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
>> +     cap->device_caps =
>> +             V4L2_CAP_VIDEO_CAPTURE |
>> +             V4L2_CAP_STREAMING |
>> +             V4L2_CAP_READWRITE;
>> +     cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>> +     return 0;
>> +}
>> +
>> +static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
>> +             struct v4l2_fmtdesc *f)
>> +{
>> +     if (f->index != 0)
>> +             return -EINVAL;
>> +
>> +     strlcpy(f->description, format[f->index].name, sizeof(f->description));
>> +     f->pixelformat = format[f->index].fourcc;
>> +     return 0;
>> +}
>> +
>> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>> +                                     struct v4l2_format *f)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     f->fmt.pix.width = dev->width;
>> +     f->fmt.pix.height = dev->height;
>> +     f->fmt.pix.field = V4L2_FIELD_INTERLACED;
>> +     f->fmt.pix.pixelformat = dev->fmt->fourcc;
>> +     f->fmt.pix.bytesperline = dev->width * 2;
>> +     f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
>> +     f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>> +                     struct v4l2_format *f)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     if (f->fmt.pix.pixelformat != format[0].fourcc) {
>> +             stk1160_err("fourcc format 0x%08x invalid\n",
>> +                     f->fmt.pix.pixelformat);
>> +             return -EINVAL;
>> +     }
>> +
>> +     /*
>> +      * User can't choose size at his own will,
>> +      * so we just return him the current size chosen
>> +      * at standard selection.
>> +      * TODO: Implement frame scaling?
>> +      */
>> +
>> +     f->fmt.pix.width = dev->width;
>> +     f->fmt.pix.height = dev->height;
>> +     f->fmt.pix.field = V4L2_FIELD_INTERLACED;
>> +     f->fmt.pix.bytesperline = dev->width * 2;
>> +     f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
>> +     f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>> +                                     struct v4l2_format *f)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     struct vb2_queue *q = &dev->vb_vidq;
>> +     int rc;
>> +
>> +     if (!stk1160_acquire_owner(dev, file))
>> +             return -EBUSY;
>> +
>> +     rc = vidioc_try_fmt_vid_cap(file, priv, f);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     if (vb2_is_streaming(q)) {
>> +             stk1160_err("device busy\n");
>> +             return -EBUSY;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
>> +     return 0;
>> +}
>> +
>> +static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     *norm = dev->norm;
>> +     return 0;
>> +}
>
> You don't need the above. the logic at v4l2-ioctl already does that:
>
>                 /* Calls the specific handler */
>                 if (ops->vidioc_g_std)
>                         ret = ops->vidioc_g_std(file, fh, id);
>                 else if (vfd->current_norm) {
>                         ret = 0;
>                         *id = vfd->current_norm;
>                 }
>
>


Mmm, I know v4l handles this.
Hans Verkuil suggested to current implementation (see v2 patch),
he said he was planning to remove current_norm.

You can see this in his tree, he committed this change:

http://git.linuxtv.org/hverkuil/media_tree.git/blobdiff/9a32d70e71bd0b416b9b66421c006934aad78791..ed5c9cbbaea611f81977e357a4e8e615bb0db3a8:/drivers/media/video/stk1160/stk1160-v4l.c

So, what do you suggest?


>> +
>> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     struct vb2_queue *q = &dev->vb_vidq;
>> +
>> +     if (!stk1160_acquire_owner(dev, file))
>> +             return -EBUSY;
>> +
>> +     if (vb2_is_streaming(q)) {
>> +             stk1160_err("device busy\n");
>> +             return -EBUSY;
>> +     }
>> +
>> +     /* Check device presence */
>> +     if (!dev->udev)
>> +             return -ENODEV;
>> +
>> +     /* This is taken from saa7115 video decoder */
>> +     if (dev->norm & V4L2_STD_525_60) {
>> +             dev->width = 720;
>> +             dev->height = 480;
>> +     } else if (dev->norm & V4L2_STD_625_50) {
>> +             dev->width = 720;
>> +             dev->height = 576;
>> +     } else {
>> +             stk1160_err("invalid standard\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* We need to set this now, before we call stk1160_set_std */
>> +     dev->norm = *norm;
>> +
>> +     stk1160_set_std(dev);
>> +
>> +     v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
>> +                     dev->norm);
>> +
>> +     return 0;
>> +}
>> +
>> +/* FIXME: Extend support for other inputs */
>> +static int vidioc_enum_input(struct file *file, void *priv,
>> +                             struct v4l2_input *i)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     if (i->index > STK1160_MAX_INPUT)
>> +             return -EINVAL;
>> +
>> +     sprintf(i->name, "Composite%d", i->index);
>> +     i->type = V4L2_INPUT_TYPE_CAMERA;
>> +     i->std = dev->vdev.tvnorms;
>> +     return 0;
>> +}
>> +
>> +static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     *i = dev->ctl_input;
>> +     return 0;
>> +}
>> +
>> +static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     if (!stk1160_acquire_owner(dev, file))
>> +             return -EBUSY;
>> +
>> +     if (i > STK1160_MAX_INPUT)
>> +             return -EINVAL;
>> +
>> +     dev->ctl_input = i;
>> +
>> +     stk1160_select_input(dev);
>> +
>> +     return 0;
>> +}
>> +
>
>
>> +static int vidioc_enum_framesizes(struct file *file, void *fh,
>> +                              struct v4l2_frmsizeenum *fsize)
>> +{
>> +     /* TODO: Is this needed? */
>> +     return -EINVAL;
>> +}
>> +
>> +static int vidioc_enum_frameintervals(struct file *file, void *fh,
>> +                               struct v4l2_frmivalenum *fival)
>> +{
>> +     /* TODO: Is this needed? */
>> +     return -EINVAL;
>> +}
>
> The return codes for the above functions are wrong. Just don't implement
> those two functions and the core will do the right thing.

Yes, I'll remove these.


Thanks a lot for reviewing, I'll fix a v5.
Ezequiel.
