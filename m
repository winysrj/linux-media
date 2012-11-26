Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:21269 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2KZOMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 09:12:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [patch review 01/02] add driver for Masterkit MA901 usb radio
Date: Mon, 26 Nov 2012 15:12:23 +0100
Cc: linux-media@vger.kernel.org, dougsland@gmail.com
References: <1351474870.3986.54.camel@tux> <201211231242.57611.hverkuil@xs4all.nl> <CALW4P++fY3mrZiESZV9HEiAxzwanN+wfLEAwfGLhm5dv6D7Lzw@mail.gmail.com>
In-Reply-To: <CALW4P++fY3mrZiESZV9HEiAxzwanN+wfLEAwfGLhm5dv6D7Lzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211261512.23378.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 26 November 2012 13:47:36 Alexey Klimov wrote:
> Hi Hans,
> 
> On Fri, Nov 23, 2012 at 3:42 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Alexey,
> >
> > Some (small) comments below...
> >
> > On Mon October 29 2012 02:41:10 Alexey Klimov wrote:
> >> This patch creates a new usb-radio driver, radio-ma901.c, that supports
> >> Masterkit MA 901 USB FM radio devices. This device plugs into both the
> >> USB and an analog audio input or headphones, so this thing only deals
> >> with initialization and frequency setting.
> >>
> >> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
> >>
> >>
> >> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> >> index 8090b87..ead9928 100644
> >> --- a/drivers/media/radio/Kconfig
> >> +++ b/drivers/media/radio/Kconfig
> >> @@ -124,6 +124,18 @@ config USB_KEENE
> >>         To compile this driver as a module, choose M here: the
> >>         module will be called radio-keene.
> >>
> >> +config USB_MA901
> >> +     tristate "Masterkit MA901 USB FM radio support"
> >> +     depends on USB && VIDEO_V4L2
> >> +     ---help---
> >> +       Say Y here if you want to connect this type of radio to your
> >> +       computer's USB port. Note that the audio is not digital, and
> >> +       you must connect the line out connector to a sound card or a
> >> +       set of speakers or headphones.
> >> +
> >> +       To compile this driver as a module, choose M here: the
> >> +       module will be called radio-ma901.
> >> +
> >>  config RADIO_TEA5764
> >>       tristate "TEA5764 I2C FM radio support"
> >>       depends on I2C && VIDEO_V4L2
> >> diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
> >> index c03ce4f..303eaeb 100644
> >> --- a/drivers/media/radio/Makefile
> >> +++ b/drivers/media/radio/Makefile
> >> @@ -24,6 +24,7 @@ obj-$(CONFIG_USB_DSBR) += dsbr100.o
> >>  obj-$(CONFIG_RADIO_SI470X) += si470x/
> >>  obj-$(CONFIG_USB_MR800) += radio-mr800.o
> >>  obj-$(CONFIG_USB_KEENE) += radio-keene.o
> >> +obj-$(CONFIG_USB_MA901) += radio-ma901.o
> >>  obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
> >>  obj-$(CONFIG_RADIO_SAA7706H) += saa7706h.o
> >>  obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
> >> diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
> >> new file mode 100644
> >> index 0000000..987e4db
> >> --- /dev/null
> >> +++ b/drivers/media/radio/radio-ma901.c
> >> @@ -0,0 +1,461 @@
> >> +/*
> >> + * Driver for the MasterKit MA901 USB FM radio. This device plugs
> >> + * into the USB port and an analog audio input or headphones, so this thing
> >> + * only deals with initialization, frequency setting, volume.
> >> + *
> >> + * Copyright (c) 2012 Alexey Klimov <klimov.linux@gmail.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public License
> >> + * along with this program; if not, write to the Free Software
> >> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> >> + */
> >> +
> >> +#include <linux/kernel.h>
> >> +#include <linux/module.h>
> >> +#include <linux/init.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/input.h>
> >> +#include <linux/videodev2.h>
> >> +#include <media/v4l2-device.h>
> >> +#include <media/v4l2-ioctl.h>
> >> +#include <media/v4l2-ctrls.h>
> >> +#include <media/v4l2-event.h>
> >> +#include <linux/usb.h>
> >> +#include <linux/mutex.h>
> >> +
> >> +#define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
> >> +#define DRIVER_DESC "Masterkit MA901 USB FM radio driver"
> >> +#define DRIVER_VERSION "0.0.1"
> >> +
> >> +MODULE_AUTHOR(DRIVER_AUTHOR);
> >> +MODULE_DESCRIPTION(DRIVER_DESC);
> >> +MODULE_LICENSE("GPL");
> >> +MODULE_VERSION(DRIVER_VERSION);
> >> +
> >> +#define USB_MA901_VENDOR  0x16c0
> >> +#define USB_MA901_PRODUCT 0x05df
> >> +
> >> +/* dev_warn macro with driver name */
> >> +#define MA901_DRIVER_NAME "radio-ma901"
> >> +#define ma901radio_dev_warn(dev, fmt, arg...)                                \
> >> +             dev_warn(dev, MA901_DRIVER_NAME " - " fmt, ##arg)
> >> +
> >> +#define ma901radio_dev_err(dev, fmt, arg...) \
> >> +             dev_err(dev, MA901_DRIVER_NAME " - " fmt, ##arg)
> >> +
> >> +/* Probably USB_TIMEOUT should be modified in module parameter */
> >> +#define BUFFER_LENGTH 8
> >> +#define USB_TIMEOUT 500
> >> +
> >> +#define FREQ_MIN  87.5
> >> +#define FREQ_MAX 108.0
> >> +#define FREQ_MUL 16000
> >> +
> >> +#define MA901_VOLUME_MAX 16
> >> +#define MA901_VOLUME_MIN 0
> >> +
> >> +/* Commands that device should understand
> >> + * List isn't full and will be updated with implementation of new functions
> >> + */
> >> +#define MA901_RADIO_SET_FREQ         0x03
> >> +#define MA901_RADIO_SET_VOLUME               0x04
> >> +#define MA901_RADIO_SET_MONO_STEREO  0x05
> >> +
> >> +/* Comfortable defines for ma901radio_set_stereo */
> >> +#define MA901_WANT_STEREO            0x50
> >> +#define MA901_WANT_MONO                      0xd0
> >> +
> >> +/* module parameter */
> >> +static int radio_nr = -1;
> >> +module_param(radio_nr, int, 0);
> >> +MODULE_PARM_DESC(radio_nr, "Radio file number");
> >> +
> >> +/* Data for one (physical) device */
> >> +struct ma901radio_device {
> >> +     /* reference to USB and video device */
> >> +     struct usb_device *usbdev;
> >> +     struct usb_interface *intf;
> >> +     struct video_device vdev;
> >> +     struct v4l2_device v4l2_dev;
> >> +     struct v4l2_ctrl_handler hdl;
> >> +
> >> +     u8 *buffer;
> >> +     struct mutex lock;      /* buffer locking */
> >> +     int curfreq;
> >> +     u16 volume;
> >> +     int stereo;
> >> +     bool muted;
> >> +};
> >> +
> >> +static inline struct ma901radio_device *to_ma901radio_dev(struct v4l2_device *v4l2_dev)
> >> +{
> >> +     return container_of(v4l2_dev, struct ma901radio_device, v4l2_dev);
> >> +}
> >> +
> >> +/* set a frequency, freq is defined by v4l's TUNER_LOW, i.e. 1/16th kHz */
> >> +static int ma901radio_set_freq(struct ma901radio_device *radio, int freq)
> >> +{
> >> +     unsigned int freq_send = 0x300 + (freq >> 5) / 25;
> >> +     int retval;
> >> +
> >> +     radio->buffer[0] = 0x0a;
> >> +     radio->buffer[1] = MA901_RADIO_SET_FREQ;
> >> +     radio->buffer[2] = ((freq_send >> 8) & 0xff) + 0x80;
> >> +     radio->buffer[3] = freq_send & 0xff;
> >> +     radio->buffer[4] = 0x00;
> >> +     radio->buffer[5] = 0x00;
> >> +     radio->buffer[6] = 0x00;
> >> +     radio->buffer[7] = 0x00;
> >> +
> >> +     retval = usb_control_msg(radio->usbdev, usb_sndctrlpipe(radio->usbdev, 0),
> >> +                             9, 0x21, 0x0300, 0,
> >> +                             radio->buffer, BUFFER_LENGTH, USB_TIMEOUT);
> >> +     if (retval < 0)
> >> +             return retval;
> >> +
> >> +     radio->curfreq = freq;
> >> +     return 0;
> >> +}
> >> +
> >> +static int ma901radio_set_volume(struct ma901radio_device *radio, u16 vol_to_set)
> >> +{
> >> +     int retval;
> >> +
> >> +     radio->buffer[0] = 0x0a;
> >> +     radio->buffer[1] = MA901_RADIO_SET_VOLUME;
> >> +     radio->buffer[2] = 0xc2;
> >> +     radio->buffer[3] = vol_to_set + 0x20;
> >> +     radio->buffer[4] = 0x00;
> >> +     radio->buffer[5] = 0x00;
> >> +     radio->buffer[6] = 0x00;
> >> +     radio->buffer[7] = 0x00;
> >> +
> >> +     retval = usb_control_msg(radio->usbdev, usb_sndctrlpipe(radio->usbdev, 0),
> >> +                             9, 0x21, 0x0300, 0,
> >> +                             radio->buffer, BUFFER_LENGTH, USB_TIMEOUT);
> >> +     if (retval < 0)
> >> +             return retval;
> >> +
> >> +     radio->volume = vol_to_set;
> >> +     return retval;
> >> +}
> >> +
> >> +static int ma901_set_stereo(struct ma901radio_device *radio, u8 stereo)
> >> +{
> >> +     int retval;
> >> +
> >> +     radio->buffer[0] = 0x0a;
> >> +     radio->buffer[1] = MA901_RADIO_SET_MONO_STEREO;
> >> +     radio->buffer[2] = stereo;
> >> +     radio->buffer[3] = 0x00;
> >> +     radio->buffer[4] = 0x00;
> >> +     radio->buffer[5] = 0x00;
> >> +     radio->buffer[6] = 0x00;
> >> +     radio->buffer[7] = 0x00;
> >> +
> >> +     retval = usb_control_msg(radio->usbdev, usb_sndctrlpipe(radio->usbdev, 0),
> >> +                             9, 0x21, 0x0300, 0,
> >> +                             radio->buffer, BUFFER_LENGTH, USB_TIMEOUT);
> >> +
> >> +     if (retval < 0)
> >> +             return retval;
> >> +
> >> +     if (stereo == MA901_WANT_STEREO)
> >> +             radio->stereo = V4L2_TUNER_MODE_STEREO;
> >> +     else
> >> +             radio->stereo = V4L2_TUNER_MODE_MONO;
> >> +
> >> +     return retval;
> >> +}
> >> +
> >> +/* Handle unplugging the device.
> >> + * We call video_unregister_device in any case.
> >> + * The last function called in this procedure is
> >> + * usb_ma901radio_device_release.
> >> + */
> >> +static void usb_ma901radio_disconnect(struct usb_interface *intf)
> >> +{
> >> +     struct ma901radio_device *radio = to_ma901radio_dev(usb_get_intfdata(intf));
> >> +
> >> +     mutex_lock(&radio->lock);
> >> +     video_unregister_device(&radio->vdev);
> >> +     usb_set_intfdata(intf, NULL);
> >> +     v4l2_device_disconnect(&radio->v4l2_dev);
> >> +     mutex_unlock(&radio->lock);
> >> +     v4l2_device_put(&radio->v4l2_dev);
> >> +}
> >> +
> >> +/* vidioc_querycap - query device capabilities */
> >> +static int vidioc_querycap(struct file *file, void *priv,
> >> +                                     struct v4l2_capability *v)
> >> +{
> >> +     struct ma901radio_device *radio = video_drvdata(file);
> >> +
> >> +     strlcpy(v->driver, "radio-ma901", sizeof(v->driver));
> >> +     strlcpy(v->card, "Masterkit MA901 USB FM Radio", sizeof(v->card));
> >> +     usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
> >> +     v->device_caps = V4L2_CAP_RADIO | V4L2_CAP_TUNER;
> >> +     v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
> >> +     return 0;
> >> +}
> >> +
> >> +/* vidioc_g_tuner - get tuner attributes */
> >> +static int vidioc_g_tuner(struct file *file, void *priv,
> >> +                             struct v4l2_tuner *v)
> >> +{
> >> +     struct ma901radio_device *radio = video_drvdata(file);
> >> +
> >> +     if (v->index > 0)
> >> +             return -EINVAL;
> >> +
> >> +     v->signal = 0;
> >> +
> >> +     /* TODO: the same words like in _probe() goes here.
> >> +      * When receiving of stats will be implemented then we can call
> >> +      * ma901radio_get_stat().
> >> +      * retval = ma901radio_get_stat(radio, &is_stereo, &v->signal);
> >> +      */
> >> +
> >> +     strcpy(v->name, "FM");
> >> +     v->type = V4L2_TUNER_RADIO;
> >> +     v->rangelow = FREQ_MIN * FREQ_MUL;
> >> +     v->rangehigh = FREQ_MAX * FREQ_MUL;
> >> +     v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
> >> +     /* v->rxsubchans = is_stereo ? V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO; */
> >> +     v->audmode = radio->stereo ?
> >> +             V4L2_TUNER_MODE_STEREO : V4L2_TUNER_MODE_MONO;
> >> +     return 0;
> >> +}
> >> +
> >> +/* vidioc_s_tuner - set tuner attributes */
> >> +static int vidioc_s_tuner(struct file *file, void *priv,
> >> +                             struct v4l2_tuner *v)
> >> +{
> >> +     struct ma901radio_device *radio = video_drvdata(file);
> >> +
> >> +     if (v->index > 0)
> >> +             return -EINVAL;
> >> +
> >> +     /* mono/stereo selector */
> >> +     switch (v->audmode) {
> >> +     case V4L2_TUNER_MODE_MONO:
> >> +             return ma901_set_stereo(radio, MA901_WANT_MONO);
> >> +     default:
> >> +             return ma901_set_stereo(radio, MA901_WANT_STEREO);
> >> +     }
> >> +}
> >> +
> >> +/* vidioc_s_frequency - set tuner radio frequency */
> >> +static int vidioc_s_frequency(struct file *file, void *priv,
> >> +                             struct v4l2_frequency *f)
> >> +{
> >> +     struct ma901radio_device *radio = video_drvdata(file);
> >> +
> >> +     if (f->tuner != 0)
> >> +             return -EINVAL;
> >> +
> >> +     return ma901radio_set_freq(radio, clamp_t(unsigned, f->frequency,
> >> +                             FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL));
> >> +}
> >> +
> >> +/* vidioc_g_frequency - get tuner radio frequency */
> >> +static int vidioc_g_frequency(struct file *file, void *priv,
> >> +                             struct v4l2_frequency *f)
> >> +{
> >> +     struct ma901radio_device *radio = video_drvdata(file);
> >> +
> >> +     if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
> >> +             return -EINVAL;
> >> +     f->type = V4L2_TUNER_RADIO;
> >
> > You don't need to check or set f->type. That's set by the core these days.
> > You still need to do the f->tuner check, though.
> 
> Oh, i didn't know. I'll correct and resend and add one patch with
> maintainers entry for this driver.
> But, it's looks like few usb drivers have this check (radio-mr800 for
> example). I can check and prepare patches for other drivers.

It's fairly new that this check is done in the core, I think it came in 6-9
months ago.

Regards,

	Hans
