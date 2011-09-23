Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:32844 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196Ab1IWVGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 17:06:38 -0400
References: <4E63C8A0.7030702@o2.pl> <CAOcJUbzXKVoOsfLA+YewyfDKmxuX0PgB8mWdfG49ArdS1fpyfA@mail.gmail.com> <4E7CDEB1.9090901@infradead.org> <CAOcJUby0dK_sjhTB3HEfdxkc9rsWU9KkZ=2B4O=Tcn4E90AE2w@mail.gmail.com>
In-Reply-To: <CAOcJUby0dK_sjhTB3HEfdxkc9rsWU9KkZ=2B4O=Tcn4E90AE2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]Medion 95700 analog video support
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 23 Sep 2011 17:06:11 -0400
To: Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Maciej Szmigiero <mhej@o2.pl>, Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Martin Wilks <m.wilks@technisat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Arnaud Lacombe <lacombar@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sven Barth <pascaldragon@googlemail.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org
Message-ID: <c651371a-b2c4-4e95-bbb3-5b97a8b7281e@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Krufky <mkrufky@linuxtv.org> wrote:

>On Fri, Sep 23, 2011 at 3:32 PM, Mauro Carvalho Chehab
><mchehab@infradead.org> wrote:
>> Em 04-09-2011 16:46, Michael Krufky escreveu:
>>> Maciej,
>>>
>>> I'm excited to see some success getting analog to work in the
>dvb-usb
>>> framework.  Some people have been asking for this support in the
>cxusb
>>> driver for a long time.
>>>
>>> I have a device (DViCO FusionHDTV5 usb) that should work with this
>>> patch with some small modifications -- i will try it out.
>>>
>>> I see that this patch adds analog support to cxusb... have you
>thought
>>> at all about adding generic analog support callbacks to the dvb-usb
>>> framework?  There are some other dvb-usb devices based on the
>dib0700
>>> chipset that also also use the cx25840 decoder for analog -- it
>would
>>> be great if this can be done in a way to benefit both the dib0700
>and
>>> cxusb drivers.
>>>
>>> I will let you know how things go after I try this code on my own
>device, here.
>>
>> Any news on that?
>>
>> Thanks!
>> Mauro
>
>Didn't have a chance to test it yet, but I am quite excited for this,
>and perhaps porting support to dib0700 as well.  I hope to try this
>out *before* the Kernel Summit in Prague.  I apologize for delays, the
>dvb-usb-mfe refactoring has been higher on the priority list lately.
>
>I'll get back to you when I can :-)
>
>Cheers,
>
>Mike
>
>
>
>>>
>>> Thanks for your patch.
>>>
>>> -Mike Krufky
>>>
>>> On Sun, Sep 4, 2011 at 2:51 PM, Maciej Szmigiero <mhej@o2.pl> wrote:
>>>> This patch adds support for analog part of Medion 95700 in the
>cxusb driver.
>>>>
>>>> What works:
>>>> * Video capture at various sizes with sequential fields,
>>>> * Input switching (TV Tuner, Composite, S-Video),
>>>> * TV tuning,
>>>> * Video standard switching and auto detection,
>>>> * Unplugging while capturing,
>>>> * DVB/analog coexistence,
>>>> * Raw BT.656 stream support.
>>>>
>>>> What does not work yet:
>>>> * Audio,
>>>> * Radio,
>>>> * VBI,
>>>> * Picture controls.
>>>>
>>>> Note that this patch needs
>https://patchwork.kernel.org/patch/1110982/ to
>>>> be applied first.
>>>>
>>>> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
>>>>
>>>> diff --git a/drivers/media/dvb/dvb-usb/Kconfig
>b/drivers/media/dvb/dvb-usb/Kconfig
>>>> index 6e97bb3..afecb9d 100644
>>>> --- a/drivers/media/dvb/dvb-usb/Kconfig
>>>> +++ b/drivers/media/dvb/dvb-usb/Kconfig
>>>> @@ -108,6 +108,8 @@ config DVB_USB_UMT_010
>>>>  config DVB_USB_CXUSB
>>>>        tristate "Conexant USB2.0 hybrid reference design support"
>>>>        depends on DVB_USB
>>>> +       select VIDEO_CX25840
>>>> +       select VIDEOBUF2_VMALLOC
>>>>        select DVB_PLL if !DVB_FE_CUSTOMISE
>>>>        select DVB_CX22702 if !DVB_FE_CUSTOMISE
>>>>        select DVB_LGDT330X if !DVB_FE_CUSTOMISE
>>>> diff --git a/drivers/media/dvb/dvb-usb/Makefile
>b/drivers/media/dvb/dvb-usb/Makefile
>>>> index 03ae657..b57600b 100644
>>>> --- a/drivers/media/dvb/dvb-usb/Makefile
>>>> +++ b/drivers/media/dvb/dvb-usb/Makefile
>>>> @@ -42,7 +42,7 @@ obj-$(CONFIG_DVB_USB_AU6610) += dvb-usb-au6610.o
>>>>  dvb-usb-digitv-objs = digitv.o
>>>>  obj-$(CONFIG_DVB_USB_DIGITV) += dvb-usb-digitv.o
>>>>
>>>> -dvb-usb-cxusb-objs = cxusb.o
>>>> +dvb-usb-cxusb-objs = cxusb.o cxusb-analog.o
>>>>  obj-$(CONFIG_DVB_USB_CXUSB) += dvb-usb-cxusb.o
>>>>
>>>>  dvb-usb-ttusb2-objs = ttusb2.o
>>>> diff --git a/drivers/media/dvb/dvb-usb/cxusb-analog.c
>b/drivers/media/dvb/dvb-usb/cxusb-analog.c
>>>> new file mode 100644
>>>> index 0000000..89c9335
>>>> --- /dev/null
>>>> +++ b/drivers/media/dvb/dvb-usb/cxusb-analog.c
>>>> @@ -0,0 +1,1738 @@
>>>> +/* DVB USB compliant linux driver for Conexant USB reference
>design -
>>>> + * (analog part).
>>>> + *
>>>> + * Copyright (C) 2011 Maciej Szmigiero (mhej@o2.pl)
>>>> + *
>>>> + * TODO:
>>>> + *  * audio support,
>>>> + *  * radio support (requires audio of course),
>>>> + *  * VBI support,
>>>> + *  * controls support
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or
>>>> + * modify it under the terms of the GNU General Public License
>>>> + * as published by the Free Software Foundation; either version 2
>>>> + * of the License, or (at your option) any later version.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + *
>>>> + * You should have received a copy of the GNU General Public
>License
>>>> + * along with this program; if not, write to the Free Software
>>>> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
>>>> + * 02110-1301, USA.
>>>> + */
>>>> +
>>>> +#include <media/cx25840.h>
>>>> +#include <media/tuner.h>
>>>> +#include <media/v4l2-ioctl.h>
>>>> +
>>>> +#include "cxusb.h"
>>>> +
>>>> +static int cxusb_medion_v_queue_setup(struct vb2_queue *q,
>>>> +                               unsigned int *num_buffers,
>>>> +                               unsigned int *num_planes,
>>>> +                               unsigned long sizes[],
>>>> +                               void *alloc_ctxs[])
>>>> +{
>>>> +       struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
>>>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>>>> +
>>>> +       if (*num_buffers < 6)
>>>> +               *num_buffers = 6;
>>>> +
>>>> +       *num_planes = 1;
>>>> +
>>>> +       if (cxdev->raw_mode)
>>>> +               sizes[0] = CXUSB_VIDEO_MAX_FRAME_SIZE;
>>>> +       else
>>>> +               sizes[0] = cxdev->width * cxdev->height * 2;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cxusb_medion_v_buf_init(struct vb2_buffer *vb)
>>>> +{
>>>> +       struct dvb_usb_device *dvbdev =
>vb2_get_drv_priv(vb->vb2_queue);
>>>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>>>> +
>>>> +       cxusb_vprintk(dvbdev, OPS, "buffer init\n");
>>>> +
>>>> +       if (cxdev->raw_mode) {
>>>> +               if (vb2_plane_size(vb, 0) <
>CXUSB_VIDEO_MAX_FRAME_SIZE)
>>>> +                       return -ENOMEM;
>>>> +       } else {
>>>> +               if (vb2_plane_size(vb, 0) < cxdev->width *
>cxdev->height * 2)
>>>> +                       return -ENOMEM;
>>>> +       }
>>>> +
>>>> +       cxusb_vprintk(dvbdev, OPS, "buffer OK\n");
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static void cxusb_auxbuf_init(struct cxusb_medion_auxbuf *auxbuf,
>>>> +                       u8 *buf, unsigned int len)
>>>> +{
>>>> +       auxbuf->buf = buf;
>>>> +       auxbuf->len = len;
>>>> +       auxbuf->paylen = 0;
>>>> +}
>>>> +
>>>> +static void cxusb_auxbuf_head_trim(struct dvb_usb_device *dvbdev,
>>>> +                               struct cxusb_medion_auxbuf *auxbuf,
>>>> +                               unsigned int pos)
>>>> +{
>>>> +       if (pos == 0)
>>>> +               return;
>>>> +
>>>> +       BUG_ON(pos > auxbuf->paylen);
>>>> +
>>>> +       cxusb_vprintk(dvbdev, AUXB,
>>>> +               "trimming auxbuf len by %u to %u\n",
>>>> +               pos, auxbuf->paylen - pos);
>>>> +
>>>> +       memmove(auxbuf->buf, auxbuf->buf+pos, auxbuf->paylen -
>pos);
>>>> +       auxbuf->paylen -= pos;
>>>> +}
>>>> +
>>>> +static unsigned int cxusb_auxbuf_paylen(struct cxusb_medion_auxbuf
>*auxbuf)
>>>> +{
>>>> +       return auxbuf->paylen;
>>>> +}
>>>> +
>>>> +static bool cxusb_auxbuf_make_space(struct dvb_usb_device *dvbdev,
>>>> +                                       struct cxusb_medion_auxbuf
>*auxbuf,
>>>> +                                       unsigned int howmuch)
>>>> +{
>>>> +       unsigned int freespace;
>>>> +
>>>> +       BUG_ON(howmuch >= auxbuf->len);
>>>> +
>>>> +       freespace = auxbuf->len -
>>>> +               cxusb_auxbuf_paylen(auxbuf);
>>>> +
>>>> +       cxusb_vprintk(dvbdev, AUXB, "freespace is %u\n",
>freespace);
>>>> +
>>>> +       if (freespace >= howmuch)
>>>> +               return true;
>>>> +
>>>> +       howmuch -= freespace;
>>>> +
>>>> +       cxusb_vprintk(dvbdev, AUXB, "will overwrite %u bytes of "
>>>> +               "buffer\n", howmuch);
>>>> +
>>>> +       cxusb_auxbuf_head_trim(dvbdev, auxbuf, howmuch);
>>>> +
>>>> +       return false;
>>>> +}
>>>> +
>>>> +/* returns false if some data was overwritten */
>>>> +static bool cxusb_auxbuf_append_urb(struct dvb_usb_device *dvbdev,
>>>> +                                       struct cxusb_medion_auxbuf
>*auxbuf,
>>>> +                                       struct urb *urb,
>>>> +                                       unsigned int len)
>>>> +{
>>>> +       int i;
>>>> +       bool ret;
>>>> +
>>>> +       ret = cxusb_auxbuf_make_space(dvbdev, auxbuf, len);
>>>> +
>>>> +       for (i = 0; i < urb->number_of_packets; i++) {
>>>> +               unsigned int to_copy;
>>>> +               to_copy = urb->iso_frame_desc[i].actual_length;
>>>> +
>>>> +               if (to_copy == 0)
>>>> +                       continue;
>>>> +
>>>> +               memcpy(auxbuf->buf+auxbuf->paylen,
>urb->transfer_buffer+
>>>> +                       urb->iso_frame_desc[i].offset, to_copy);
>>>> +
>>>> +               auxbuf->paylen += to_copy;
>>>> +       }
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static bool cxusb_auxbuf_copy(struct cxusb_medion_auxbuf *auxbuf,
>>>> +                               unsigned int pos, unsigned char
>*dest,
>>>> +                               unsigned int len)
>>>> +{
>>>> +       if (pos+len > auxbuf->paylen)
>>>> +               return false;
>>>> +
>>>> +       memcpy(dest, auxbuf->buf+pos, len);
>>>> +
>>>> +       return true;
>>>> +}
>>>> +
>>>> +static unsigned int cxusb_auxbuf_advance(struct
>cxusb_medion_auxbuf *auxbuf,
>>>> +                                       unsigned int pos,
>>>> +                                       unsigned int increment)
>>>> +{
>>>> +       return pos+increment;
>>>> +}
>>>> +
>>>> +static unsigned int cxusb_auxbuf_begin(struct cxusb_medion_auxbuf
>*auxbuf)
>>>> +{
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static bool cxusb_auxbuf_isend(struct cxusb_medion_auxbuf *auxbuf,
>>>> +                       unsigned int pos)
>>>> +{
>>>> +       return pos >= auxbuf->paylen;
>>>> +}
>>>> +
>>>> +static bool cxusb_medion_copy_field(struct dvb_usb_device *dvbdev,
>>>> +                               struct cxusb_medion_auxbuf *auxbuf,
>>>> +                               struct cxusb_bt656_params *bt656,
>>>> +                               bool firstfield,
>>>> +                               unsigned int maxlines,
>>>> +                               unsigned int maxlinesamples)
>>>> +{
>>>> +       while (bt656->line < maxlines &&
>>>> +               !cxusb_auxbuf_isend(auxbuf, bt656->pos)) {
>>>> +
>>>> +               unsigned char val;
>>>> +
>>>> +               if (!cxusb_auxbuf_copy(auxbuf, bt656->pos, &val,
>1))
>>>> +                       return false;
>>>> +
>>>> +               if ((char)val == CXUSB_BT656_COMMON[0]) {
>>>> +                       char buf[3];
>>>> +
>>>> +                       if (!cxusb_auxbuf_copy(auxbuf,
>bt656->pos+1,
>>>> +                                                       buf, 3))
>>>> +                               return false;
>>>> +
>>>> +                       if (buf[0] != (CXUSB_BT656_COMMON)[1] ||
>>>> +                               buf[1] != (CXUSB_BT656_COMMON)[2])
>>>> +                               goto normal_sample;
>>>> +
>>>> +                       if (bt656->line != 0 && (!!firstfield !=
>((buf[2] &
>>>> +                                                      
>CXUSB_FIELD_MASK)
>>>> +                                                       ==
>CXUSB_FIELD_1))) {
>>>> +                               if (bt656->fmode == LINE_SAMPLES) {
>>>> +                                       cxusb_vprintk(dvbdev,
>BT656,
>>>> +                                               "field %c after
>line %u "
>>>> +                                               "field change\n",
>>>> +                                               firstfield ? '1' :
>'2',
>>>> +                                               bt656->line);
>>>> +
>>>> +                                       if (bt656->buf != NULL &&
>>>> +                                               maxlinesamples -
>>>> +                                               bt656->linesamples
>> 0) {
>>>> +
>>>> +                                               memset(bt656->buf,
>0,
>>>> +                                                      
>maxlinesamples -
>>>> +                                                      
>bt656->linesamples);
>>>> +
>>>> +                                               bt656->buf +=
>>>> +                                                      
>maxlinesamples -
>>>> +                                                      
>bt656->linesamples;
>>>> +
>>>> +                                              
>cxusb_vprintk(dvbdev, BT656,
>>>> +                                                       "field %c
>line %u "
>>>> +                                                       "%u samples
>still "
>>>> +                                                       "remaining
>(of %u)\n",
>>>> +                                                       firstfield
>?
>>>> +                                                       '1' : '2',
>>>> +                                                      
>bt656->line,
>>>> +                                                      
>maxlinesamples -
>>>> +                                                      
>bt656->linesamples,
>>>> +                                                      
>maxlinesamples);
>>>> +                                       }
>>>> +
>>>> +                                       bt656->line++;
>>>> +                               }
>>>> +
>>>> +                               if (maxlines - bt656->line > 0 &&

The cx25840 part of the patch breaks ivtv, IIRC.  The patch really need to add board specific configuration and behavior to cx25840.  I'll have time tomorrow late afternoon to properly reviw and comment.

Regards,
Andy
