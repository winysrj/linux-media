Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1IWTcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 15:32:31 -0400
Message-ID: <4E7CDEB1.9090901@infradead.org>
Date: Fri, 23 Sep 2011 16:32:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Maciej Szmigiero <mhej@o2.pl>, Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Martin Wilks <m.wilks@technisat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Arnaud Lacombe <lacombar@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sven Barth <pascaldragon@googlemail.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH]Medion 95700 analog video support
References: <4E63C8A0.7030702@o2.pl> <CAOcJUbzXKVoOsfLA+YewyfDKmxuX0PgB8mWdfG49ArdS1fpyfA@mail.gmail.com>
In-Reply-To: <CAOcJUbzXKVoOsfLA+YewyfDKmxuX0PgB8mWdfG49ArdS1fpyfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-09-2011 16:46, Michael Krufky escreveu:
> Maciej,
> 
> I'm excited to see some success getting analog to work in the dvb-usb
> framework.  Some people have been asking for this support in the cxusb
> driver for a long time.
> 
> I have a device (DViCO FusionHDTV5 usb) that should work with this
> patch with some small modifications -- i will try it out.
> 
> I see that this patch adds analog support to cxusb... have you thought
> at all about adding generic analog support callbacks to the dvb-usb
> framework?  There are some other dvb-usb devices based on the dib0700
> chipset that also also use the cx25840 decoder for analog -- it would
> be great if this can be done in a way to benefit both the dib0700 and
> cxusb drivers.
> 
> I will let you know how things go after I try this code on my own device, here.

Any news on that?

Thanks!
Mauro
> 
> Thanks for your patch.
> 
> -Mike Krufky
> 
> On Sun, Sep 4, 2011 at 2:51 PM, Maciej Szmigiero <mhej@o2.pl> wrote:
>> This patch adds support for analog part of Medion 95700 in the cxusb driver.
>>
>> What works:
>> * Video capture at various sizes with sequential fields,
>> * Input switching (TV Tuner, Composite, S-Video),
>> * TV tuning,
>> * Video standard switching and auto detection,
>> * Unplugging while capturing,
>> * DVB/analog coexistence,
>> * Raw BT.656 stream support.
>>
>> What does not work yet:
>> * Audio,
>> * Radio,
>> * VBI,
>> * Picture controls.
>>
>> Note that this patch needs https://patchwork.kernel.org/patch/1110982/ to
>> be applied first.
>>
>> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
>>
>> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
>> index 6e97bb3..afecb9d 100644
>> --- a/drivers/media/dvb/dvb-usb/Kconfig
>> +++ b/drivers/media/dvb/dvb-usb/Kconfig
>> @@ -108,6 +108,8 @@ config DVB_USB_UMT_010
>>  config DVB_USB_CXUSB
>>        tristate "Conexant USB2.0 hybrid reference design support"
>>        depends on DVB_USB
>> +       select VIDEO_CX25840
>> +       select VIDEOBUF2_VMALLOC
>>        select DVB_PLL if !DVB_FE_CUSTOMISE
>>        select DVB_CX22702 if !DVB_FE_CUSTOMISE
>>        select DVB_LGDT330X if !DVB_FE_CUSTOMISE
>> diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
>> index 03ae657..b57600b 100644
>> --- a/drivers/media/dvb/dvb-usb/Makefile
>> +++ b/drivers/media/dvb/dvb-usb/Makefile
>> @@ -42,7 +42,7 @@ obj-$(CONFIG_DVB_USB_AU6610) += dvb-usb-au6610.o
>>  dvb-usb-digitv-objs = digitv.o
>>  obj-$(CONFIG_DVB_USB_DIGITV) += dvb-usb-digitv.o
>>
>> -dvb-usb-cxusb-objs = cxusb.o
>> +dvb-usb-cxusb-objs = cxusb.o cxusb-analog.o
>>  obj-$(CONFIG_DVB_USB_CXUSB) += dvb-usb-cxusb.o
>>
>>  dvb-usb-ttusb2-objs = ttusb2.o
>> diff --git a/drivers/media/dvb/dvb-usb/cxusb-analog.c b/drivers/media/dvb/dvb-usb/cxusb-analog.c
>> new file mode 100644
>> index 0000000..89c9335
>> --- /dev/null
>> +++ b/drivers/media/dvb/dvb-usb/cxusb-analog.c
>> @@ -0,0 +1,1738 @@
>> +/* DVB USB compliant linux driver for Conexant USB reference design -
>> + * (analog part).
>> + *
>> + * Copyright (C) 2011 Maciej Szmigiero (mhej@o2.pl)
>> + *
>> + * TODO:
>> + *  * audio support,
>> + *  * radio support (requires audio of course),
>> + *  * VBI support,
>> + *  * controls support
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
>> + * 02110-1301, USA.
>> + */
>> +
>> +#include <media/cx25840.h>
>> +#include <media/tuner.h>
>> +#include <media/v4l2-ioctl.h>
>> +
>> +#include "cxusb.h"
>> +
>> +static int cxusb_medion_v_queue_setup(struct vb2_queue *q,
>> +                               unsigned int *num_buffers,
>> +                               unsigned int *num_planes,
>> +                               unsigned long sizes[],
>> +                               void *alloc_ctxs[])
>> +{
>> +       struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       if (*num_buffers < 6)
>> +               *num_buffers = 6;
>> +
>> +       *num_planes = 1;
>> +
>> +       if (cxdev->raw_mode)
>> +               sizes[0] = CXUSB_VIDEO_MAX_FRAME_SIZE;
>> +       else
>> +               sizes[0] = cxdev->width * cxdev->height * 2;
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_v_buf_init(struct vb2_buffer *vb)
>> +{
>> +       struct dvb_usb_device *dvbdev = vb2_get_drv_priv(vb->vb2_queue);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "buffer init\n");
>> +
>> +       if (cxdev->raw_mode) {
>> +               if (vb2_plane_size(vb, 0) < CXUSB_VIDEO_MAX_FRAME_SIZE)
>> +                       return -ENOMEM;
>> +       } else {
>> +               if (vb2_plane_size(vb, 0) < cxdev->width * cxdev->height * 2)
>> +                       return -ENOMEM;
>> +       }
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "buffer OK\n");
>> +
>> +       return 0;
>> +}
>> +
>> +static void cxusb_auxbuf_init(struct cxusb_medion_auxbuf *auxbuf,
>> +                       u8 *buf, unsigned int len)
>> +{
>> +       auxbuf->buf = buf;
>> +       auxbuf->len = len;
>> +       auxbuf->paylen = 0;
>> +}
>> +
>> +static void cxusb_auxbuf_head_trim(struct dvb_usb_device *dvbdev,
>> +                               struct cxusb_medion_auxbuf *auxbuf,
>> +                               unsigned int pos)
>> +{
>> +       if (pos == 0)
>> +               return;
>> +
>> +       BUG_ON(pos > auxbuf->paylen);
>> +
>> +       cxusb_vprintk(dvbdev, AUXB,
>> +               "trimming auxbuf len by %u to %u\n",
>> +               pos, auxbuf->paylen - pos);
>> +
>> +       memmove(auxbuf->buf, auxbuf->buf+pos, auxbuf->paylen - pos);
>> +       auxbuf->paylen -= pos;
>> +}
>> +
>> +static unsigned int cxusb_auxbuf_paylen(struct cxusb_medion_auxbuf *auxbuf)
>> +{
>> +       return auxbuf->paylen;
>> +}
>> +
>> +static bool cxusb_auxbuf_make_space(struct dvb_usb_device *dvbdev,
>> +                                       struct cxusb_medion_auxbuf *auxbuf,
>> +                                       unsigned int howmuch)
>> +{
>> +       unsigned int freespace;
>> +
>> +       BUG_ON(howmuch >= auxbuf->len);
>> +
>> +       freespace = auxbuf->len -
>> +               cxusb_auxbuf_paylen(auxbuf);
>> +
>> +       cxusb_vprintk(dvbdev, AUXB, "freespace is %u\n", freespace);
>> +
>> +       if (freespace >= howmuch)
>> +               return true;
>> +
>> +       howmuch -= freespace;
>> +
>> +       cxusb_vprintk(dvbdev, AUXB, "will overwrite %u bytes of "
>> +               "buffer\n", howmuch);
>> +
>> +       cxusb_auxbuf_head_trim(dvbdev, auxbuf, howmuch);
>> +
>> +       return false;
>> +}
>> +
>> +/* returns false if some data was overwritten */
>> +static bool cxusb_auxbuf_append_urb(struct dvb_usb_device *dvbdev,
>> +                                       struct cxusb_medion_auxbuf *auxbuf,
>> +                                       struct urb *urb,
>> +                                       unsigned int len)
>> +{
>> +       int i;
>> +       bool ret;
>> +
>> +       ret = cxusb_auxbuf_make_space(dvbdev, auxbuf, len);
>> +
>> +       for (i = 0; i < urb->number_of_packets; i++) {
>> +               unsigned int to_copy;
>> +               to_copy = urb->iso_frame_desc[i].actual_length;
>> +
>> +               if (to_copy == 0)
>> +                       continue;
>> +
>> +               memcpy(auxbuf->buf+auxbuf->paylen, urb->transfer_buffer+
>> +                       urb->iso_frame_desc[i].offset, to_copy);
>> +
>> +               auxbuf->paylen += to_copy;
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +static bool cxusb_auxbuf_copy(struct cxusb_medion_auxbuf *auxbuf,
>> +                               unsigned int pos, unsigned char *dest,
>> +                               unsigned int len)
>> +{
>> +       if (pos+len > auxbuf->paylen)
>> +               return false;
>> +
>> +       memcpy(dest, auxbuf->buf+pos, len);
>> +
>> +       return true;
>> +}
>> +
>> +static unsigned int cxusb_auxbuf_advance(struct cxusb_medion_auxbuf *auxbuf,
>> +                                       unsigned int pos,
>> +                                       unsigned int increment)
>> +{
>> +       return pos+increment;
>> +}
>> +
>> +static unsigned int cxusb_auxbuf_begin(struct cxusb_medion_auxbuf *auxbuf)
>> +{
>> +       return 0;
>> +}
>> +
>> +static bool cxusb_auxbuf_isend(struct cxusb_medion_auxbuf *auxbuf,
>> +                       unsigned int pos)
>> +{
>> +       return pos >= auxbuf->paylen;
>> +}
>> +
>> +static bool cxusb_medion_copy_field(struct dvb_usb_device *dvbdev,
>> +                               struct cxusb_medion_auxbuf *auxbuf,
>> +                               struct cxusb_bt656_params *bt656,
>> +                               bool firstfield,
>> +                               unsigned int maxlines,
>> +                               unsigned int maxlinesamples)
>> +{
>> +       while (bt656->line < maxlines &&
>> +               !cxusb_auxbuf_isend(auxbuf, bt656->pos)) {
>> +
>> +               unsigned char val;
>> +
>> +               if (!cxusb_auxbuf_copy(auxbuf, bt656->pos, &val, 1))
>> +                       return false;
>> +
>> +               if ((char)val == CXUSB_BT656_COMMON[0]) {
>> +                       char buf[3];
>> +
>> +                       if (!cxusb_auxbuf_copy(auxbuf, bt656->pos+1,
>> +                                                       buf, 3))
>> +                               return false;
>> +
>> +                       if (buf[0] != (CXUSB_BT656_COMMON)[1] ||
>> +                               buf[1] != (CXUSB_BT656_COMMON)[2])
>> +                               goto normal_sample;
>> +
>> +                       if (bt656->line != 0 && (!!firstfield != ((buf[2] &
>> +                                                       CXUSB_FIELD_MASK)
>> +                                                       == CXUSB_FIELD_1))) {
>> +                               if (bt656->fmode == LINE_SAMPLES) {
>> +                                       cxusb_vprintk(dvbdev, BT656,
>> +                                               "field %c after line %u "
>> +                                               "field change\n",
>> +                                               firstfield ? '1' : '2',
>> +                                               bt656->line);
>> +
>> +                                       if (bt656->buf != NULL &&
>> +                                               maxlinesamples -
>> +                                               bt656->linesamples > 0) {
>> +
>> +                                               memset(bt656->buf, 0,
>> +                                                       maxlinesamples -
>> +                                                       bt656->linesamples);
>> +
>> +                                               bt656->buf +=
>> +                                                       maxlinesamples -
>> +                                                       bt656->linesamples;
>> +
>> +                                               cxusb_vprintk(dvbdev, BT656,
>> +                                                       "field %c line %u "
>> +                                                       "%u samples still "
>> +                                                       "remaining (of %u)\n",
>> +                                                       firstfield ?
>> +                                                       '1' : '2',
>> +                                                       bt656->line,
>> +                                                       maxlinesamples -
>> +                                                       bt656->linesamples,
>> +                                                       maxlinesamples);
>> +                                       }
>> +
>> +                                       bt656->line++;
>> +                               }
>> +
>> +                               if (maxlines - bt656->line > 0 &&
>> +                                       bt656->buf != NULL) {
>> +                                       memset(bt656->buf, 0,
>> +                                               (maxlines - bt656->line)
>> +                                               * maxlinesamples);
>> +
>> +                                       bt656->buf +=
>> +                                               (maxlines - bt656->line)
>> +                                               * maxlinesamples;
>> +
>> +                                       cxusb_vprintk(dvbdev, BT656,
>> +                                               "field %c %u lines still "
>> +                                               "remaining (of %u)\n",
>> +                                               firstfield ? '1' : '2',
>> +                                               maxlines - bt656->line,
>> +                                               maxlines);
>> +                               }
>> +
>> +                               return true;
>> +                       }
>> +
>> +                       if (bt656->fmode == START_SEARCH) {
>> +                               if ((buf[2] & CXUSB_SEAV_MASK) ==
>> +                                               CXUSB_SEAV_SAV &&
>> +                                        (!!firstfield == ((buf[2] &
>> +                                                       CXUSB_FIELD_MASK)
>> +                                                       == CXUSB_FIELD_1))) {
>> +
>> +                                       if ((buf[2] & CXUSB_VBI_MASK) ==
>> +                                               CXUSB_VBI_OFF) {
>> +                                               cxusb_vprintk(dvbdev,
>> +                                                       BT656,
>> +                                                       "line start @ "
>> +                                                       "pos %x\n",
>> +                                                       bt656->pos);
>> +
>> +                                               bt656->linesamples = 0;
>> +                                               bt656->fmode = LINE_SAMPLES;
>> +                                       } else {
>> +                                               cxusb_vprintk(dvbdev,
>> +                                                       BT656,
>> +                                                       "VBI start @ "
>> +                                                       "pos %x\n",
>> +                                                       bt656->pos);
>> +
>> +                                               bt656->fmode = VBI_SAMPLES;
>> +                                       }
>> +                               }
>> +
>> +                               bt656->pos =
>> +                                       cxusb_auxbuf_advance(auxbuf,
>> +                                                       bt656->pos, 4);
>> +                               continue;
>> +                       } else if (bt656->fmode == LINE_SAMPLES) {
>> +                               if ((buf[2] & CXUSB_SEAV_MASK) ==
>> +                                               CXUSB_SEAV_SAV)
>> +                                       cxusb_vprintk(dvbdev, BT656,
>> +                                               "SAV in line samples @ "
>> +                                               "line %u, pos %x\n",
>> +                                               bt656->line, bt656->pos);
>> +
>> +                               if (bt656->buf != NULL && maxlinesamples -
>> +                                               bt656->linesamples > 0) {
>> +
>> +                                       memset(bt656->buf, 0,
>> +                                               maxlinesamples -
>> +                                               bt656->linesamples);
>> +                                       bt656->buf += maxlinesamples -
>> +                                               bt656->linesamples;
>> +
>> +                                       cxusb_vprintk(dvbdev, BT656,
>> +                                               "field %c line %u %u "
>> +                                               "samples still remaining "
>> +                                               "(of %u)\n",
>> +                                               firstfield ? '1' : '2',
>> +                                               bt656->line,
>> +                                               maxlinesamples -
>> +                                               bt656->linesamples,
>> +                                               maxlinesamples);
>> +                               }
>> +
>> +
>> +                               bt656->fmode = START_SEARCH;
>> +                               bt656->line++;
>> +                               continue;
>> +                       } else if (bt656->fmode == VBI_SAMPLES) {
>> +                               if ((buf[2] & CXUSB_SEAV_MASK) ==
>> +                                               CXUSB_SEAV_SAV)
>> +                                       cxusb_vprintk(dvbdev, BT656,
>> +                                               "SAV in VBI samples "
>> +                                               "@ pos %x\n", bt656->pos);
>> +
>> +                               bt656->fmode = START_SEARCH;
>> +                               continue;
>> +                       }
>> +
>> +                       bt656->pos =
>> +                               cxusb_auxbuf_advance(auxbuf, bt656->pos, 4);
>> +                       continue;
>> +               }
>> +
>> +normal_sample:
>> +               if (bt656->fmode == START_SEARCH && bt656->line != 0) {
>> +                       unsigned char buf[64];
>> +                       unsigned int idx;
>> +                       unsigned int tocheck = min(sizeof(buf),
>> +                                               max(sizeof(buf),
>> +                                                       maxlinesamples/4));
>> +
>> +                       if (!cxusb_auxbuf_copy(auxbuf, bt656->pos+1,
>> +                                                       buf, tocheck)) {
>> +                               bt656->pos =
>> +                                       cxusb_auxbuf_advance(auxbuf,
>> +                                                       bt656->pos, 1);
>> +                               continue;
>> +                       }
>> +
>> +                       for (idx = 0; idx <= tocheck-3; idx++)
>> +                               if (memcmp(buf+idx, CXUSB_BT656_COMMON, 3)
>> +                                       == 0)
>> +                                       break;
>> +
>> +                       if (idx <= tocheck-3) {
>> +                               bt656->pos =
>> +                                       cxusb_auxbuf_advance(auxbuf,
>> +                                                       bt656->pos, 1);
>> +                               continue;
>> +                       }
>> +
>> +                       cxusb_vprintk(dvbdev, BT656, "line %u "
>> +                               "early start, pos %x\n",
>> +                               bt656->line, bt656->pos);
>> +
>> +                       bt656->linesamples = 0;
>> +                       bt656->fmode = LINE_SAMPLES;
>> +                       continue;
>> +               } else if (bt656->fmode == LINE_SAMPLES) {
>> +                       if (bt656->buf != NULL)
>> +                               *(bt656->buf++) = val;
>> +
>> +                       bt656->linesamples++;
>> +                       bt656->pos =
>> +                               cxusb_auxbuf_advance(auxbuf,
>> +                                               bt656->pos, 1);
>> +
>> +                       if (bt656->linesamples >= maxlinesamples) {
>> +                               bt656->fmode = START_SEARCH;
>> +                               bt656->line++;
>> +                       }
>> +
>> +                       continue;
>> +               }
>> +               /* TODO: copy VBI samples */
>> +
>> +               bt656->pos =
>> +                       cxusb_auxbuf_advance(auxbuf,
>> +                                       bt656->pos, 1);
>> +       }
>> +
>> +       if (bt656->line >= maxlines)
>> +               return true;
>> +       else {
>> +               cxusb_vprintk(dvbdev, BT656, "end of buffer, pos = %u\n",
>> +                       bt656->pos);
>> +               return false;
>> +       }
>> +}
>> +
>> +static void cxusb_medion_v_complete_work(struct work_struct *work)
>> +{
>> +       struct cxusb_medion_dev *cxdev = container_of(work,
>> +                                               struct cxusb_medion_dev,
>> +                                               urbwork);
>> +       struct dvb_usb_device *dvbdev = cxdev->dvbdev;
>> +       struct urb *urb;
>> +       int ret;
>> +       unsigned int i, urbn;
>> +
>> +       mutex_lock(cxdev->videodev->lock);
>> +
>> +       cxusb_vprintk(dvbdev, URB, "worker called, streaming = %d\n",
>> +               (int)cxdev->streaming);
>> +
>> +       if (!cxdev->streaming)
>> +               goto unlock;
>> +
>> +       urbn = cxdev->nexturb;
>> +       if (test_bit(urbn, &cxdev->urbcomplete)) {
>> +               urb = cxdev->streamurbs[urbn];
>> +               clear_bit(urbn, &cxdev->urbcomplete);
>> +
>> +               cxdev->nexturb++;
>> +               cxdev->nexturb %= CXUSB_VIDEO_URBS;
>> +       } else {
>> +               for (i = 0, urbn++; i < CXUSB_VIDEO_URBS-1; i++, urbn++) {
>> +                       urbn %= CXUSB_VIDEO_URBS;
>> +                       if (test_bit(urbn, &cxdev->urbcomplete)) {
>> +                               urb = cxdev->streamurbs[urbn];
>> +                               clear_bit(urbn, &cxdev->urbcomplete);
>> +                               break;
>> +                       }
>> +               }
>> +
>> +               if (i >= CXUSB_VIDEO_URBS-1) {
>> +                       cxusb_vprintk(dvbdev, URB,
>> +                       "URB worker called but no URB ready\n");
>> +                       goto unlock;
>> +               }
>> +
>> +               cxusb_vprintk(dvbdev, URB,
>> +                       "out-of-order URB: expected %u but %u is ready\n",
>> +                       cxdev->nexturb, urbn);
>> +
>> +               cxdev->nexturb = urbn + 1;
>> +               cxdev->nexturb %= CXUSB_VIDEO_URBS;
>> +       }
>> +
>> +       cxusb_vprintk(dvbdev, URB, "URB %u status = %d\n", urbn, urb->status);
>> +
>> +       if (urb->status == 0 || urb->status == -EXDEV) {
>> +               int i;
>> +
>> +               unsigned long len = 0;
>> +               for (i = 0; i < urb->number_of_packets; i++)
>> +                       len += urb->iso_frame_desc[i].actual_length;
>> +
>> +               cxusb_vprintk(dvbdev, URB, "URB %u data len = %lu\n",
>> +                       urbn, len);
>> +
>> +               if (len == 0)
>> +                       goto resubmit;
>> +
>> +               if (cxdev->raw_mode) {
>> +                       u8 *buf;
>> +                       struct cxusb_medion_vbuffer *vbuf;
>> +
>> +                       if (list_empty(&cxdev->buflist)) {
>> +                               dev_warn(&dvbdev->udev->dev,
>> +                                       "no free buffers\n");
>> +
>> +                               goto resubmit;
>> +                       }
>> +
>> +                       vbuf = list_first_entry(&cxdev->buflist,
>> +                                               struct cxusb_medion_vbuffer,
>> +                                               list);
>> +                       list_del(&vbuf->list);
>> +
>> +                       buf = vb2_plane_vaddr(&vbuf->vb2, 0);
>> +
>> +                       for (i = 0; i < urb->number_of_packets; i++) {
>> +                               memcpy(buf, urb->transfer_buffer+
>> +                                       urb->iso_frame_desc[i].offset,
>> +                                       urb->iso_frame_desc[i].actual_length);
>> +
>> +                               buf += urb->iso_frame_desc[i].actual_length;
>> +                       }
>> +
>> +                       vb2_set_plane_payload(&vbuf->vb2, 0, len);
>> +
>> +                       vb2_buffer_done(&vbuf->vb2, VB2_BUF_STATE_DONE);
>> +               } else {
>> +                       struct cxusb_bt656_params *bt656 = &cxdev->bt656;
>> +                       bool reset;
>> +
>> +                       cxusb_vprintk(dvbdev, URB, "appending urb\n");
>> +
>> +                       /* append new data to circ. buffer */
>> +                       /* overwrite old data if necessary */
>> +                       reset = !cxusb_auxbuf_append_urb(
>> +                               dvbdev, &cxdev->auxbuf, urb, len);
>> +
>> +                       /* if this is a new frame */
>> +                       /* fetch a buffer from list */
>> +                       if (bt656->mode == NEW_FRAME) {
>> +                               if (!list_empty(&cxdev->buflist)) {
>> +                                       cxdev->vbuf = list_first_entry(
>> +                                               &cxdev->buflist,
>> +                                               struct cxusb_medion_vbuffer,
>> +                                               list);
>> +
>> +                                       list_del(&cxdev->vbuf->list);
>> +                               } else {
>> +                                       dev_warn(&dvbdev->udev->dev,
>> +                                               "no free buffers\n");
>> +                                       cxdev->vbuf = NULL;
>> +                                       bt656->buf = NULL;
>> +                               }
>> +                       }
>> +
>> +                       if (bt656->mode == NEW_FRAME || reset) {
>> +                               bt656->pos = cxusb_auxbuf_begin(
>> +                                       &cxdev->auxbuf);
>> +                               bt656->mode = FIRST_FIELD;
>> +                               bt656->fmode = START_SEARCH;
>> +                               bt656->line = 0;
>> +
>> +                               if (cxdev->vbuf != NULL)
>> +                                       bt656->buf = vb2_plane_vaddr(
>> +                                               &cxdev->vbuf->vb2, 0);
>> +                       }
>> +
>> +                       cxusb_vprintk(dvbdev, URB, "auxbuf payload len %u",
>> +                               cxusb_auxbuf_paylen(&cxdev->auxbuf));
>> +
>> +                       if (bt656->mode == FIRST_FIELD) {
>> +                               cxusb_vprintk(dvbdev, URB,
>> +                                       "copying field 1\n");
>> +
>> +                               if (!cxusb_medion_copy_field(
>> +                                               dvbdev, &cxdev->auxbuf,
>> +                                               bt656, true,
>> +                                               cxdev->height / 2,
>> +                                               cxdev->width * 2))
>> +                                       goto resubmit;
>> +
>> +
>> +                               /* do not trim buffer there in case */
>> +                               /* we need to reset search later */
>> +
>> +                               bt656->mode = SECOND_FIELD;
>> +                               bt656->fmode = START_SEARCH;
>> +                               bt656->line = 0;
>> +                       }
>> +
>> +                       if (bt656->mode == SECOND_FIELD) {
>> +                               cxusb_vprintk(dvbdev, URB,
>> +                                       "copying field 2\n");
>> +
>> +                               if (!cxusb_medion_copy_field(
>> +                                               dvbdev, &cxdev->auxbuf,
>> +                                               bt656, false,
>> +                                               cxdev->height / 2,
>> +                                               cxdev->width * 2))
>> +                                       goto resubmit;
>> +
>> +                               cxusb_auxbuf_head_trim(dvbdev,
>> +                                               &cxdev->auxbuf, bt656->pos);
>> +
>> +                               bt656->mode = NEW_FRAME;
>> +
>> +                               if (cxdev->vbuf != NULL) {
>> +                                       vb2_set_plane_payload(
>> +                                               &cxdev->vbuf->vb2, 0,
>> +                                               cxdev->width *
>> +                                               cxdev->height * 2);
>> +
>> +                                       vb2_buffer_done(&cxdev->vbuf->vb2,
>> +                                                       VB2_BUF_STATE_DONE);
>> +
>> +                                       cxusb_vprintk(dvbdev, URB,
>> +                                               "frame done\n");
>> +                               } else
>> +                                       cxusb_vprintk(dvbdev, URB,
>> +                                               "frame skipped\n");
>> +                       }
>> +               }
>> +
>> +       }
>> +
>> +resubmit:
>> +       cxusb_vprintk(dvbdev, URB, "URB %u submit\n", urbn);
>> +
>> +       ret = usb_submit_urb(urb, GFP_KERNEL);
>> +       if (ret != 0)
>> +               dev_err(&dvbdev->udev->dev,
>> +               "unable to submit URB (%d), you'll have to "
>> +               "restart streaming\n", ret);
>> +
>> +       for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +               if (test_bit(i, &cxdev->urbcomplete)) {
>> +                       schedule_work(&cxdev->urbwork);
>> +                       break;
>> +               }
>> +
>> +unlock:
>> +       mutex_unlock(cxdev->videodev->lock);
>> +}
>> +
>> +static void cxusb_medion_v_complete(struct urb *u)
>> +{
>> +       struct dvb_usb_device *dvbdev = u->context;
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       unsigned int i;
>> +
>> +       for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +               if (cxdev->streamurbs[i] == u)
>> +                       break;
>> +
>> +       if (i >= CXUSB_VIDEO_URBS) {
>> +               dev_err(&dvbdev->udev->dev,
>> +                       "complete on unknown URB\n");
>> +               return;
>> +       }
>> +
>> +       cxusb_vprintk(dvbdev, URB, "URB %d complete\n", i);
>> +
>> +       set_bit(i, &cxdev->urbcomplete);
>> +       schedule_work(&cxdev->urbwork);
>> +}
>> +
>> +static int cxusb_medion_v_start_streaming(struct vb2_queue *q)
>> +{
>> +       struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       u8 streamon_params[2] = { 0x03, 0x00 };
>> +       int npackets, i;
>> +       int ret;
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "should start streaming\n");
>> +
>> +       /* already streaming */
>> +       if (cxdev->streaming)
>> +               return 0;
>> +
>> +       /* not streaming but URB is still active - stream is being stopped */
>> +       if (cxdev->streamurbs[0] != NULL)
>> +               return -EBUSY;
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, video, s_stream, 1);
>> +       if (ret != 0) {
>> +               dev_err(&dvbdev->udev->dev,
>> +                       "unable to start stream (%d)\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       ret = cxusb_ctrl_msg(dvbdev, CMD_STREAMING_ON, streamon_params, 2,
>> +                       NULL, 0);
>> +       if (ret != 0) {
>> +               dev_err(&dvbdev->udev->dev,
>> +                       "unable to start streaming (%d)\n", ret);
>> +               goto ret_unstream_cx;
>> +       }
>> +
>> +       if (cxdev->raw_mode) {
>> +               npackets = CXUSB_VIDEO_MAX_FRAME_PKTS;
>> +       } else {
>> +               u8 *buf;
>> +               unsigned int urblen, auxbuflen;
>> +
>> +               /* has to be less than full frame size */
>> +               urblen = (cxdev->width * 2 + 4 + 4) * cxdev->height;
>> +               npackets = urblen / CXUSB_VIDEO_PKT_SIZE;
>> +               urblen = npackets * CXUSB_VIDEO_PKT_SIZE;
>> +
>> +               auxbuflen = (cxdev->width * 2 + 4 + 4) *
>> +                       (cxdev->height + 50 /* VBI lines */) + urblen;
>> +
>> +               buf = vmalloc(auxbuflen);
>> +               if (buf == NULL) {
>> +                       dev_err(&dvbdev->udev->dev,
>> +                               "cannot allocate auxiliary buffer of %u "
>> +                               "bytes\n", auxbuflen);
>> +                       ret = -ENOMEM;
>> +                       goto ret_unstream_md;
>> +               }
>> +
>> +               cxusb_auxbuf_init(&cxdev->auxbuf, buf, auxbuflen);
>> +       }
>> +
>> +
>> +       for (i = 0; i < CXUSB_VIDEO_URBS; i++) {
>> +               int framen;
>> +               u8 *streambuf;
>> +
>> +               streambuf = kmalloc(npackets*CXUSB_VIDEO_PKT_SIZE,
>> +                               GFP_KERNEL);
>> +               if (streambuf == NULL) {
>> +                       if (i == 0) {
>> +                               dev_err(&dvbdev->udev->dev,
>> +                                       "cannot allocate stream buffer\n");
>> +                               ret = -ENOMEM;
>> +                               goto ret_freeab;
>> +                       } else
>> +                               break;
>> +               }
>> +
>> +               cxdev->streamurbs[i] = usb_alloc_urb(npackets, GFP_KERNEL);
>> +
>> +               if (cxdev->streamurbs[i] == NULL) {
>> +                       dev_err(&dvbdev->udev->dev,
>> +                               "cannot allocate URB %d\n", i);
>> +
>> +                       kfree(streambuf);
>> +                       ret = -ENOMEM;
>> +                       goto ret_freeu;
>> +               }
>> +
>> +               cxdev->streamurbs[i]->dev = dvbdev->udev;
>> +               cxdev->streamurbs[i]->context = dvbdev;
>> +               cxdev->streamurbs[i]->pipe =
>> +                       usb_rcvisocpipe(dvbdev->udev, 2);
>> +
>> +               cxdev->streamurbs[i]->interval = 1;
>> +               cxdev->streamurbs[i]->transfer_flags =
>> +                       URB_ISO_ASAP;
>> +
>> +               cxdev->streamurbs[i]->transfer_buffer = streambuf;
>> +
>> +               cxdev->streamurbs[i]->complete = cxusb_medion_v_complete;
>> +               cxdev->streamurbs[i]->number_of_packets = npackets;
>> +               cxdev->streamurbs[i]->transfer_buffer_length =
>> +                       npackets*CXUSB_VIDEO_PKT_SIZE;
>> +
>> +               for (framen = 0; framen < npackets; framen++) {
>> +                       cxdev->streamurbs[i]->
>> +                               iso_frame_desc[framen].offset =
>> +                               CXUSB_VIDEO_PKT_SIZE * framen;
>> +
>> +                       cxdev->streamurbs[i]->
>> +                               iso_frame_desc[framen].length =
>> +                               CXUSB_VIDEO_PKT_SIZE;
>> +               }
>> +       }
>> +
>> +
>> +       cxdev->urbcomplete = 0;
>> +       cxdev->nexturb = 0;
>> +       cxdev->bt656.mode = NEW_FRAME;
>> +
>> +       for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +               if (cxdev->streamurbs[i] != NULL) {
>> +                       ret = usb_submit_urb(cxdev->streamurbs[i],
>> +                                       GFP_KERNEL);
>> +                       if (ret != 0)
>> +                               dev_err(&dvbdev->udev->dev,
>> +                                       "URB %d submission "
>> +                                       "failed (%d)\n", i, ret);
>> +               }
>> +
>> +       cxdev->streaming = true;
>> +
>> +       return 0;
>> +
>> +ret_freeu:
>> +       for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +               if (cxdev->streamurbs[i] != NULL) {
>> +                       kfree(cxdev->streamurbs[i]->transfer_buffer);
>> +                       usb_free_urb(cxdev->streamurbs[i]);
>> +                       cxdev->streamurbs[i] = NULL;
>> +               }
>> +
>> +ret_freeab:
>> +       if (!cxdev->raw_mode)
>> +               vfree(cxdev->auxbuf.buf);
>> +
>> +ret_unstream_md:
>> +       cxusb_ctrl_msg(dvbdev, CMD_STREAMING_OFF, NULL, 0, NULL, 0);
>> +
>> +ret_unstream_cx:
>> +       v4l2_subdev_call(cxdev->cx25840, video, s_stream, 0);
>> +
>> +       return ret;
>> +}
>> +
>> +static int cxusb_medion_v_stop_streaming(struct vb2_queue *q)
>> +{
>> +       struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int i, ret = 0;
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "should stop streaming\n");
>> +
>> +       if (!cxdev->streaming)
>> +               return 0;
>> +
>> +       cxdev->streaming = false;
>> +
>> +       cxusb_ctrl_msg(dvbdev, CMD_STREAMING_OFF, NULL, 0, NULL, 0);
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, video, s_stream, 0);
>> +       if (ret != 0)
>> +               dev_err(&dvbdev->udev->dev, "unable to stop stream (%d)\n",
>> +                       ret);
>> +
>> +       /* forget about queued buffers */
>> +       INIT_LIST_HEAD(&cxdev->buflist);
>> +
>> +       /* let URB completion run */
>> +       mutex_unlock(cxdev->videodev->lock);
>> +
>> +       for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +               if (cxdev->streamurbs[i] != NULL)
>> +                       usb_kill_urb(cxdev->streamurbs[i]);
>> +
>> +       flush_work_sync(&cxdev->urbwork);
>> +
>> +       mutex_lock(cxdev->videodev->lock);
>> +
>> +       /* free transfer buffer and URB */
>> +       if (!cxdev->raw_mode)
>> +               vfree(cxdev->auxbuf.buf);
>> +
>> +       for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +               if (cxdev->streamurbs[i] != NULL) {
>> +                       kfree(cxdev->streamurbs[i]->transfer_buffer);
>> +                       usb_free_urb(cxdev->streamurbs[i]);
>> +                       cxdev->streamurbs[i] = NULL;
>> +               }
>> +
>> +       return ret;
>> +}
>> +
>> +static void cxusub_medion_v_buf_queue(struct vb2_buffer *vb)
>> +{
>> +       struct cxusb_medion_vbuffer *vbuf =
>> +               container_of(vb, struct cxusb_medion_vbuffer, vb2);
>> +       struct dvb_usb_device *dvbdev = vb2_get_drv_priv(vb->vb2_queue);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "mmmm.. fresh buffer...\n");
>> +
>> +       list_add_tail(&vbuf->list, &cxdev->buflist);
>> +}
>> +
>> +static void cxusub_medion_v_wait_prepare(struct vb2_queue *q)
>> +{
>> +       struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       mutex_unlock(cxdev->videodev->lock);
>> +}
>> +
>> +static void cxusub_medion_v_wait_finish(struct vb2_queue *q)
>> +{
>> +       struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       mutex_lock(cxdev->videodev->lock);
>> +}
>> +
>> +static const struct vb2_ops cxdev_video_qops = {
>> +       .queue_setup = cxusb_medion_v_queue_setup,
>> +       .buf_init = cxusb_medion_v_buf_init,
>> +       .start_streaming = cxusb_medion_v_start_streaming,
>> +       .stop_streaming = cxusb_medion_v_stop_streaming,
>> +       .buf_queue = cxusub_medion_v_buf_queue,
>> +       .wait_prepare = cxusub_medion_v_wait_prepare,
>> +       .wait_finish = cxusub_medion_v_wait_finish
>> +};
>> +
>> +static int cxusb_medion_v_querycap(struct file *file, void *fh,
>> +                       struct v4l2_capability *cap)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       /*struct video_device *vdev = video_devdata(file);*/
>> +
>> +       strncpy(cap->driver, dvbdev->udev->dev.driver->name,
>> +               sizeof(cap->driver)-1);
>> +       strncpy(cap->bus_info, dvbdev->udev->devpath,
>> +               sizeof(cap->bus_info)-1);
>> +       strcpy(cap->card, "Medion 95700");
>> +
>> +       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
>> +               V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>> +       cap->version = KERNEL_VERSION(0, 0, 1);
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_v_enum_fmt_vid_cap(struct file *file, void *fh,
>> +                                       struct v4l2_fmtdesc *f)
>> +{
>> +       if (f->index != 0)
>> +               return -EINVAL;
>> +
>> +       f->pixelformat = V4L2_PIX_FMT_UYVY;
>> +       strcpy(f->description, "YUV 4:2:2");
>> +       f->flags = 0;
>> +       memset(f->reserved, 0, sizeof(f->reserved));
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_v_enum_fmt_vid_pvt(struct file *file, void *fh,
>> +                                       struct v4l2_fmtdesc *f)
>> +{
>> +       if (f->index != 0)
>> +               return -EINVAL;
>> +
>> +       f->pixelformat = 0;
>> +       strcpy(f->description, "BT.656 multiplexed stream");
>> +       f->flags = 0;
>> +       memset(f->reserved, 0, sizeof(f->reserved));
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_g_fmt_vid_cap(struct file *file, void *fh,
>> +                               struct v4l2_format *f)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +       f->fmt.pix.width = cxdev->width;
>> +       f->fmt.pix.height = cxdev->height;
>> +       f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
>> +       f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
>> +       f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +       f->fmt.pix.bytesperline = cxdev->width * 2;
>> +       f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
>> +               f->fmt.pix.height;
>> +       f->fmt.pix.priv = 0;
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_g_fmt_vid_pvt(struct file *file, void *fh,
>> +                               struct v4l2_format *f)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       f->type = V4L2_BUF_TYPE_PRIVATE;
>> +       f->fmt.pix.width = cxdev->width;
>> +       f->fmt.pix.height = cxdev->height;
>> +       f->fmt.pix.pixelformat = 0;
>> +       f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
>> +       f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +       f->fmt.pix.bytesperline = 0;
>> +       f->fmt.pix.sizeimage = CXUSB_VIDEO_MAX_FRAME_SIZE;
>> +       f->fmt.pix.priv = 0;
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusub_medion_v_check_format_change(struct file *file)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       /* check if nobody is set for streaming */
>> +       if (cxdev->streamingfh == NULL)
>> +               return 0;
>> +
>> +       /* check if that is our FH */
>> +       if (file != cxdev->streamingfh)
>> +               return -EBUSY;
>> +
>> +       if (cxdev->streaming)
>> +               return -EBUSY;
>> +
>> +       vb2_queue_release(&cxdev->videoqueue);
>> +       cxdev->streamingfh = NULL;
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_s_fmt_vid_cap(struct file *file, void *fh,
>> +                               struct v4l2_format *f)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       struct v4l2_mbus_framefmt mbusfmt;
>> +       int ret;
>> +
>> +       ret = cxusub_medion_v_check_format_change(file);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_UYVY)
>> +               return -EINVAL;
>> +
>> +       mbusfmt.width = f->fmt.pix.width & ~1;
>> +       mbusfmt.height = f->fmt.pix.height & ~1;
>> +       mbusfmt.code = V4L2_MBUS_FMT_FIXED;
>> +       mbusfmt.field = V4L2_FIELD_SEQ_TB;
>> +       mbusfmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +       memset(mbusfmt.reserved, 0, sizeof(mbusfmt.reserved));
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, video, s_mbus_fmt, &mbusfmt);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       cxdev->width = f->fmt.pix.width = mbusfmt.width;
>> +       cxdev->height = f->fmt.pix.height = mbusfmt.height;
>> +       cxdev->raw_mode = false;
>> +       f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
>> +       f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +       f->fmt.pix.bytesperline = cxdev->width * 2;
>> +       f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height;
>> +       f->fmt.pix.priv = 0;
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_s_fmt_vid_pvt(struct file *file, void *fh,
>> +                               struct v4l2_format *f)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       struct v4l2_mbus_framefmt mbusfmt;
>> +       int ret;
>> +
>> +       ret = cxusub_medion_v_check_format_change(file);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       if (f->fmt.pix.pixelformat != 0)
>> +               return -EINVAL;
>> +
>> +       mbusfmt.width = f->fmt.pix.width & ~1;
>> +       mbusfmt.height = f->fmt.pix.height & ~1;
>> +       mbusfmt.code = V4L2_MBUS_FMT_FIXED;
>> +       mbusfmt.field = V4L2_FIELD_SEQ_TB;
>> +       mbusfmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +       memset(mbusfmt.reserved, 0, sizeof(mbusfmt.reserved));
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, video, s_mbus_fmt, &mbusfmt);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       cxdev->width = f->fmt.pix.width = mbusfmt.width;
>> +       cxdev->height = f->fmt.pix.height = mbusfmt.height;
>> +       cxdev->raw_mode = true;
>> +       f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
>> +       f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +       f->fmt.pix.bytesperline = 0;
>> +       f->fmt.pix.sizeimage = CXUSB_VIDEO_MAX_FRAME_SIZE;
>> +       f->fmt.pix.priv = 0;
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct {
>> +       struct v4l2_input input;
>> +       u32 inputcfg;
>> +} cxusb_medion_inputs[] = {
>> +       { .input = { .name = "TV Tuner", .type = V4L2_INPUT_TYPE_TUNER,
>> +                    .tuner = 0, .std = V4L2_STD_PAL },
>> +         .inputcfg = CX25840_COMPOSITE2, },
>> +
>> +       {  .input = { .name = "Composite", .type = V4L2_INPUT_TYPE_CAMERA,
>> +                    .std = V4L2_STD_ALL },
>> +          .inputcfg = CX25840_COMPOSITE1, },
>> +
>> +       {  .input = { .name = "S-Video", .type = V4L2_INPUT_TYPE_CAMERA,
>> +                     .std = V4L2_STD_ALL },
>> +          .inputcfg = CX25840_SVIDEO3 }
>> +};
>> +
>> +#define CXUSB_INPUT_CNT (sizeof(cxusb_medion_inputs) / \
>> +                               sizeof(cxusb_medion_inputs[0]))
>> +
>> +static int cxusb_medion_enum_input(struct file *file, void *fh,
>> +                               struct v4l2_input *inp)
>> +{
>> +       u32 index = inp->index;
>> +
>> +       if (index >= CXUSB_INPUT_CNT)
>> +               return -EINVAL;
>> +
>> +       *inp = cxusb_medion_inputs[index].input;
>> +       inp->index = index;
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_g_input(struct file *file, void *fh,
>> +                               unsigned int *i)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       return cxdev->input;
>> +}
>> +
>> +static int cxusb_medion_s_input(struct file *file, void *fh,
>> +                               unsigned int i)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       if (i >= CXUSB_INPUT_CNT)
>> +               return -EINVAL;
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, video, s_routing,
>> +                       cxusb_medion_inputs[i].inputcfg, 0, 0);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       cxdev->input = i;
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_g_tuner(struct file *file, void *fh,
>> +                               struct v4l2_tuner *tuner)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       if (tuner->index != 0)
>> +               return -EINVAL;
>> +
>> +       tuner->type = V4L2_TUNER_ANALOG_TV;
>> +       tuner->capability = 0;
>> +
>> +       /* fills afc, rangelow, rangehigh */
>> +       ret = v4l2_subdev_call(cxdev->tuner, tuner, g_tuner, tuner);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       /* fills signal, rxsubchans, audmode */
>> +       ret = v4l2_subdev_call(cxdev->cx25840, tuner, g_tuner, tuner);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       strcpy(tuner->name, "TV Tuner");
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_s_tuner(struct file *file, void *fh,
>> +                               struct v4l2_tuner *tuner)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       if (tuner->index != 0)
>> +               return -EINVAL;
>> +
>> +       return v4l2_subdev_call(cxdev->cx25840, tuner, s_tuner, tuner);
>> +}
>> +
>> +
>> +static int cxusb_medion_g_frequency(struct file *file, void *fh,
>> +                               struct v4l2_frequency *freq)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       if (freq->tuner != 0)
>> +               return -EINVAL;
>> +
>> +       freq->type = V4L2_TUNER_ANALOG_TV;
>> +
>> +       return v4l2_subdev_call(cxdev->tuner, tuner, g_frequency, freq);
>> +}
>> +
>> +static int cxusb_medion_s_frequency(struct file *file, void *fh,
>> +                               struct v4l2_frequency *freq)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       if (freq->tuner != 0)
>> +               return -EINVAL;
>> +
>> +       if (freq->type != V4L2_TUNER_ANALOG_TV)
>> +               return -EINVAL;
>> +
>> +       return v4l2_subdev_call(cxdev->tuner, tuner, s_frequency, freq);
>> +}
>> +
>> +static int cxusb_medion_s_std(struct file *file, void *fh,
>> +                       v4l2_std_id *norm)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       /* on composite or S-Video any std is acceptable */
>> +       if (cxdev->input != 0)
>> +               return v4l2_subdev_call(cxdev->cx25840, core, s_std, *norm);
>> +
>> +       /* TV Tuner is only able to demodulate PAL */
>> +       if ((*norm & ~V4L2_STD_PAL) != 0)
>> +               return -EINVAL;
>> +
>> +       /* no autodetection support */
>> +       if (*norm == 0)
>> +               return -EINVAL;
>> +
>> +       ret = v4l2_subdev_call(cxdev->tuner, core, s_std, *norm);
>> +       if (ret != 0) {
>> +               dev_err(&dvbdev->udev->dev,
>> +                       "tuner norm setup failed (%d)\n",
>> +                       ret);
>> +               return ret;
>> +       }
>> +
>> +       ret = v4l2_subdev_call(cxdev->tda9887, core, s_std, *norm);
>> +       if (ret != 0) {
>> +               dev_err(&dvbdev->udev->dev,
>> +                       "tda9887 norm setup failed (%d)\n",
>> +                       ret);
>> +               return ret;
>> +       }
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, core, s_std, *norm);
>> +       if (ret != 0) {
>> +               dev_err(&dvbdev->udev->dev,
>> +                       "cx25840 norm setup failed (%d)\n",
>> +                       ret);
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_v_check_queue(struct file *file)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       /* our FH is the streaming one, so queue is ready for us */
>> +       if (file == cxdev->streamingfh)
>> +               return 0;
>> +
>> +       /* some other FH is set for streaming now */
>> +       if (cxdev->streamingfh != NULL)
>> +               return -EBUSY;
>> +
>> +       memset(&cxdev->videoqueue, 0, sizeof(cxdev->videoqueue));
>> +       cxdev->videoqueue.type = cxdev->raw_mode ? V4L2_BUF_TYPE_PRIVATE :
>> +               V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +       cxdev->videoqueue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
>> +       cxdev->videoqueue.buf_struct_size =
>> +               sizeof(struct cxusb_medion_vbuffer);
>> +       cxdev->videoqueue.mem_ops = &vb2_vmalloc_memops;
>> +       cxdev->videoqueue.ops = &cxdev_video_qops;
>> +       cxdev->videoqueue.drv_priv = dvbdev;
>> +
>> +       ret = vb2_queue_init(&cxdev->videoqueue);
>> +       if (ret) {
>> +               dev_err(&dvbdev->udev->dev, "video queue init failed\n");
>> +               return ret;
>> +       }
>> +
>> +       cxdev->streamingfh = file;
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_v_reqbufs(struct file *file, void *priv,
>> +                               struct v4l2_requestbuffers *p)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       ret = cxusb_medion_v_check_queue(file);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       return vb2_reqbufs(&cxdev->videoqueue, p);
>> +}
>> +
>> +static int cxusb_medion_v_querybuf(struct file *file, void *priv,
>> +                               struct v4l2_buffer *p)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       ret = cxusb_medion_v_check_queue(file);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       return vb2_querybuf(&cxdev->videoqueue, p);
>> +}
>> +
>> +static int cxusb_medion_v_qbuf(struct file *file, void *priv,
>> +                       struct v4l2_buffer *p)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       ret = cxusb_medion_v_check_queue(file);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       return vb2_qbuf(&cxdev->videoqueue, p);
>> +}
>> +
>> +static int cxusb_medion_v_dqbuf(struct file *file, void *priv,
>> +                               struct v4l2_buffer *p)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       ret = cxusb_medion_v_check_queue(file);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       return vb2_dqbuf(&cxdev->videoqueue, p, file->f_flags & O_NONBLOCK);
>> +}
>> +
>> +static int cxusb_medion_v_streamon(struct file *file, void *priv,
>> +                               enum v4l2_buf_type i)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       ret = cxusb_medion_v_check_queue(file);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       return vb2_streamon(&cxdev->videoqueue, i);
>> +}
>> +
>> +static int cxusb_medion_v_streamoff(struct file *file, void *priv,
>> +                               enum v4l2_buf_type i)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       ret = cxusb_medion_v_check_queue(file);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       return vb2_streamoff(&cxdev->videoqueue, i);
>> +}
>> +
>> +static const struct v4l2_ioctl_ops cxusb_video_ioctl = {
>> +       .vidioc_querycap = cxusb_medion_v_querycap,
>> +       .vidioc_enum_fmt_vid_cap = cxusb_medion_v_enum_fmt_vid_cap,
>> +       .vidioc_enum_fmt_type_private = cxusb_medion_v_enum_fmt_vid_pvt,
>> +       .vidioc_g_fmt_vid_cap = cxusb_medion_g_fmt_vid_cap,
>> +       .vidioc_g_fmt_type_private = cxusb_medion_g_fmt_vid_pvt,
>> +       .vidioc_s_fmt_vid_cap = cxusb_medion_s_fmt_vid_cap,
>> +       .vidioc_s_fmt_type_private = cxusb_medion_s_fmt_vid_pvt,
>> +       .vidioc_enum_input = cxusb_medion_enum_input,
>> +       .vidioc_g_input = cxusb_medion_g_input,
>> +       .vidioc_s_input = cxusb_medion_s_input,
>> +       .vidioc_g_tuner = cxusb_medion_g_tuner,
>> +       .vidioc_s_tuner = cxusb_medion_s_tuner,
>> +       .vidioc_g_frequency = cxusb_medion_g_frequency,
>> +       .vidioc_s_frequency = cxusb_medion_s_frequency,
>> +       .vidioc_s_std = cxusb_medion_s_std,
>> +       .vidioc_reqbufs = cxusb_medion_v_reqbufs,
>> +       .vidioc_querybuf = cxusb_medion_v_querybuf,
>> +       .vidioc_qbuf = cxusb_medion_v_qbuf,
>> +       .vidioc_dqbuf = cxusb_medion_v_dqbuf,
>> +       .vidioc_streamon = cxusb_medion_v_streamon,
>> +       .vidioc_streamoff = cxusb_medion_v_streamoff
>> +};
>> +
>> +/* in principle, this should be const, but s_io_pin_config is declared */
>> +/* to take non-const, and gcc complains */
>> +static struct v4l2_subdev_io_pin_config cxusub_medion_pin_config[] = {
>> +       { .pin = CX25840_PIN_DVALID_PRGM0, .function = CX25840_PAD_DEFAULT,
>> +         .strength = CX25840_PIN_DRIVE_MEDIUM },
>> +       { .pin = CX25840_PIN_PLL_CLK_PRGM7, .function = CX25840_PAD_AUX_PLL },
>> +       { .pin = CX25840_PIN_HRESET_PRGM2, .function = CX25840_PAD_ACTIVE,
>> +         .strength = CX25840_PIN_DRIVE_MEDIUM }
>> +};
>> +
>> +int cxusb_medion_analog_init(struct dvb_usb_device *dvbdev)
>> +{
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       struct v4l2_mbus_framefmt mbusfmt;
>> +       int ret;
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, core, load_fw);
>> +       if (ret != 0)
>> +               dev_warn(&dvbdev->udev->dev,
>> +                       "cx25840 fw load failed (%d)\n", ret);
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, video, s_routing,
>> +                       CX25840_COMPOSITE1, 0,
>> +                       CX25840_VCONFIG_FMT_BT656|CX25840_VCONFIG_RES_8BIT|
>> +                       CX25840_VCONFIG_VBIRAW_DISABLED|
>> +                       CX25840_VCONFIG_ANCDATA_DISABLED|
>> +                       CX25840_VCONFIG_ACTIVE_COMPOSITE|
>> +                       CX25840_VCONFIG_VALID_ANDACTIVE|
>> +                       CX25840_VCONFIG_HRESETW_NORMAL|
>> +                       CX25840_VCONFIG_CLKGATE_NONE|
>> +                       CX25840_VCONFIG_DCMODE_DWORDS);
>> +       if (ret != 0)
>> +               dev_warn(&dvbdev->udev->dev,
>> +                       "cx25840 mode set failed (%d)\n", ret);
>> +
>> +       /* composite */
>> +       cxdev->input = 1;
>> +
>> +       /* TODO: setup audio samples insertion */
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, core, s_io_pin_config,
>> +                       sizeof(cxusub_medion_pin_config)/
>> +                       sizeof(cxusub_medion_pin_config[0]),
>> +                       cxusub_medion_pin_config);
>> +       if (ret != 0)
>> +               dev_warn(&dvbdev->udev->dev,
>> +                       "cx25840 pin config failed (%d)\n", ret);
>> +
>> +       mbusfmt.width = cxdev->width;
>> +       mbusfmt.height = cxdev->height;
>> +       mbusfmt.code = V4L2_MBUS_FMT_FIXED;
>> +       mbusfmt.field = V4L2_FIELD_SEQ_TB;
>> +       mbusfmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +       memset(mbusfmt.reserved, 0, sizeof(mbusfmt.reserved));
>> +
>> +       ret = v4l2_subdev_call(cxdev->cx25840, video, s_mbus_fmt, &mbusfmt);
>> +       if (ret != 0)
>> +               dev_warn(&dvbdev->udev->dev,
>> +                       "cx25840 format set failed (%d)\n", ret);
>> +       else {
>> +               cxdev->width = mbusfmt.width;
>> +               cxdev->height = mbusfmt.height;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_video_open(struct file *f)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(f);
>> +       int ret;
>> +
>> +       ret = cxusb_medion_get(dvbdev, CXUSB_ANALOG);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       ret = v4l2_fh_open(f);
>> +       if (ret != 0)
>> +               goto ret_release;
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "got open\n");
>> +
>> +       return 0;
>> +
>> +ret_release:
>> +
>> +       cxusb_medion_put(dvbdev);
>> +
>> +       return ret;
>> +}
>> +
>> +static int cxusb_video_release(struct file *f)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(f);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "got release\n");
>> +
>> +       ret = v4l2_fh_release(f);
>> +
>> +       /* check if we have queue set  */
>> +       if (f == cxdev->streamingfh) {
>> +               vb2_queue_release(&cxdev->videoqueue);
>> +               cxdev->streamingfh = NULL;
>> +       }
>> +
>> +       cxusb_medion_put(dvbdev);
>> +
>> +       return ret;
>> +}
>> +
>> +static ssize_t cxusb_video_read(struct file *f, char __user *b, size_t s,
>> +                               loff_t *o)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(f);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       ret = cxusb_medion_v_check_queue(f);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       return vb2_read(&cxdev->videoqueue, b, s, o,
>> +                       f->f_flags & O_NONBLOCK);
>> +}
>> +
>> +static unsigned int cxusb_video_poll(struct file *f,
>> +                               struct poll_table_struct *p)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(f);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       ret = cxusb_medion_v_check_queue(f);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       return vb2_poll(&cxdev->videoqueue, f, p);
>> +}
>> +
>> +static int cxusb_video_mmap(struct file *f, struct vm_area_struct *v)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_drvdata(f);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret;
>> +
>> +       ret = cxusb_medion_v_check_queue(f);
>> +       if (ret != 0)
>> +               return ret;
>> +
>> +       return vb2_mmap(&cxdev->videoqueue, v);
>> +}
>> +
>> +static const struct v4l2_file_operations cxusb_video_fops = {
>> +       .owner = THIS_MODULE,
>> +       .open = cxusb_video_open,
>> +       .release = cxusb_video_release,
>> +       .read = cxusb_video_read,
>> +       .poll = cxusb_video_poll,
>> +       .mmap = cxusb_video_mmap,
>> +       .unlocked_ioctl = video_ioctl2
>> +};
>> +
>> +static void cxusb_medion_v4l2_release(struct v4l2_device *v4l2_dev)
>> +{
>> +       struct cxusb_medion_dev *cxdev =
>> +               container_of(v4l2_dev, struct cxusb_medion_dev, v4l2dev);
>> +       struct dvb_usb_device *dvbdev = cxdev->dvbdev;
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "v4l2 device release\n");
>> +
>> +       while (completion_done(&cxdev->v4l2_release))
>> +               schedule();
>> +
>> +       complete(&cxdev->v4l2_release);
>> +}
>> +
>> +static void cxusb_medion_videodev_release(struct video_device *vdev)
>> +{
>> +       struct dvb_usb_device *dvbdev = video_get_drvdata(vdev);
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "video device release\n");
>> +
>> +       while (completion_done(&cxdev->videodev_release))
>> +               schedule();
>> +
>> +       complete(&cxdev->videodev_release);
>> +
>> +       video_device_release(vdev);
>> +}
>> +
>> +int cxusb_medion_register_analog(struct dvb_usb_device *dvbdev)
>> +{
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       struct tuner_setup tun_setup;
>> +       struct v4l2_priv_tun_config tda9887_config;
>> +       unsigned int tda9887_priv;
>> +
>> +       int ret;
>> +
>> +       init_completion(&cxdev->v4l2_release);
>> +
>> +       cxdev->v4l2dev.release = cxusb_medion_v4l2_release;
>> +
>> +       ret = v4l2_device_register(&dvbdev->udev->dev, &cxdev->v4l2dev);
>> +       if (ret != 0) {
>> +               dev_err(&dvbdev->udev->dev,
>> +                       "V4L2 device registration failed, "
>> +                       "ret = %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       /* attach capture chip */
>> +       cxdev->cx25840 = v4l2_i2c_new_subdev(&cxdev->v4l2dev,
>> +                                       &dvbdev->i2c_adap,
>> +                                       "cx25840", 0x44, NULL);
>> +
>> +       if (cxdev->cx25840 == NULL) {
>> +               dev_err(&dvbdev->udev->dev, "cx25840 not found\n");
>> +               ret = -ENODEV;
>> +               goto ret_unregister;
>> +       }
>> +
>> +       /* attach analog tuner */
>> +       cxdev->tuner = v4l2_i2c_new_subdev(&cxdev->v4l2dev,
>> +                                       &dvbdev->i2c_adap,
>> +                                       "tuner", 0x61, NULL);
>> +       if (cxdev->tuner == NULL) {
>> +               dev_err(&dvbdev->udev->dev, "tuner not found\n");
>> +               ret = -ENODEV;
>> +               goto ret_unregister;
>> +       }
>> +
>> +       /* configure it */
>> +       memset(&tun_setup, 0, sizeof(tun_setup));
>> +       tun_setup.mode_mask = T_RADIO | T_ANALOG_TV;
>> +       tun_setup.type = TUNER_PHILIPS_FMD1216ME_MK3;
>> +       tun_setup.addr = 0x61;
>> +       v4l2_subdev_call(cxdev->tuner, tuner, s_type_addr, &tun_setup);
>> +
>> +       /* attach demod */
>> +       cxdev->tda9887 = v4l2_i2c_new_subdev(&cxdev->v4l2dev,
>> +                                       &dvbdev->i2c_adap,
>> +                                       "tuner", 0x43, NULL);
>> +       if (cxdev->tda9887 == NULL) {
>> +               dev_err(&dvbdev->udev->dev, "tda9887 not found\n");
>> +               ret = -ENODEV;
>> +               goto ret_unregister;
>> +       }
>> +
>> +       /* configure it */
>> +       memset(&tda9887_config, 0, sizeof(tda9887_config));
>> +       tda9887_config.tuner = TUNER_TDA9887;
>> +       tda9887_priv = TDA9887_AUTOMUTE;
>> +       tda9887_config.priv = &tda9887_priv;
>> +       v4l2_subdev_call(cxdev->tda9887, tuner, s_config, &tda9887_config);
>> +
>> +       INIT_WORK(&cxdev->urbwork, cxusb_medion_v_complete_work);
>> +       INIT_LIST_HEAD(&cxdev->buflist);
>> +
>> +       cxdev->width = 320;
>> +       cxdev->height = 240;
>> +
>> +       cxdev->videodev = video_device_alloc();
>> +       if (cxdev->videodev == NULL) {
>> +               dev_err(&dvbdev->udev->dev, "video device alloc failed\n");
>> +               ret = -ENOMEM;
>> +               goto ret_unregister;
>> +       }
>> +
>> +       init_completion(&cxdev->videodev_release);
>> +
>> +       cxdev->videodev->release = cxusb_medion_videodev_release;
>> +       cxdev->videodev->v4l2_dev = &cxdev->v4l2dev;
>> +       strcpy(cxdev->videodev->name, "cxusb");
>> +       cxdev->videodev->fops = &cxusb_video_fops;
>> +       cxdev->videodev->ioctl_ops = &cxusb_video_ioctl;
>> +       cxdev->videodev->tvnorms = V4L2_STD_ALL;
>> +       cxdev->videodev->lock = kmalloc(sizeof(*(cxdev->videodev->lock)),
>> +                                       GFP_KERNEL);
>> +
>> +       if (cxdev->videodev->lock == NULL) {
>> +               dev_err(&dvbdev->udev->dev,
>> +                       "video device mutex alloc failed\n");
>> +               ret = -ENOMEM;
>> +               goto ret_drelease;
>> +       }
>> +
>> +       mutex_init(cxdev->videodev->lock);
>> +
>> +       ret = video_register_device(cxdev->videodev, VFL_TYPE_GRABBER, -1);
>> +       if (ret) {
>> +               dev_err(&dvbdev->udev->dev, "video device register failed\n");
>> +               goto ret_mfree;
>> +       }
>> +
>> +       video_set_drvdata(cxdev->videodev, dvbdev);
>> +
>> +       return 0;
>> +
>> +
>> +ret_mfree:
>> +       mutex_destroy(cxdev->videodev->lock);
>> +       kfree(cxdev->videodev->lock);
>> +
>> +ret_drelease:
>> +       video_device_release(cxdev->videodev);
>> +
>> +ret_unregister:
>> +       v4l2_device_unregister(&cxdev->v4l2dev);
>> +
>> +       return ret;
>> +}
>> +
>> +void cxusb_medion_unregister_analog(struct dvb_usb_device *dvbdev)
>> +{
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       struct mutex *mutex = cxdev->videodev->lock;
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "unregistering analog\n");
>> +
>> +       video_unregister_device(cxdev->videodev);
>> +
>> +       wait_for_completion(&cxdev->videodev_release);
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "video dev unregistered\n");
>> +
>> +       v4l2_device_unregister(&cxdev->v4l2dev);
>> +
>> +       wait_for_completion(&cxdev->v4l2_release);
>> +
>> +       cxusb_vprintk(dvbdev, OPS, "v4l dev unregistered\n");
>> +
>> +       mutex_destroy(mutex);
>> +
>> +       kfree(mutex);
>> +
>> +}
>> diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
>> index a76f431..e279f81 100644
>> --- a/drivers/media/dvb/dvb-usb/cxusb.c
>> +++ b/drivers/media/dvb/dvb-usb/cxusb.c
>> @@ -11,11 +11,11 @@
>>  * design, so it can be reused for the "analogue-only" device (if it will
>>  * appear at all).
>>  *
>> - * TODO: Use the cx25840-driver for the analogue part
>>  *
>>  * Copyright (C) 2005 Patrick Boettcher (patrick.boettcher@desy.de)
>>  * Copyright (C) 2006 Michael Krufky (mkrufky@linuxtv.org)
>>  * Copyright (C) 2006, 2007 Chris Pascoe (c.pascoe@itee.uq.edu.au)
>> + * Copyright (C) 2011 Maciej Szmigiero (mhej@o2.pl)
>>  *
>>  *   This program is free software; you can redistribute it and/or modify it
>>  *   under the terms of the GNU General Public License as published by the Free
>> @@ -44,16 +44,19 @@
>>  #include "atbm8830.h"
>>
>>  /* debug */
>> -static int dvb_usb_cxusb_debug;
>> +int dvb_usb_cxusb_debug;
>>  module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
>> -MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
>> +MODULE_PARM_DESC(debug, "set debugging level (see cxusb.h)."
>> +               DVB_USB_DEBUG_STATUS);
>>
>>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>>
>> -#define deb_info(args...)   dprintk(dvb_usb_cxusb_debug, 0x03, args)
>> -#define deb_i2c(args...)    dprintk(dvb_usb_cxusb_debug, 0x02, args)
>> +#define deb_info(args...)   dprintk(dvb_usb_cxusb_debug, CXUSB_DBG_MISC, args)
>> +#define deb_i2c(args...)    dprintk(dvb_usb_cxusb_debug, CXUSB_DBG_I2C, args)
>>
>> -static int cxusb_ctrl_msg(struct dvb_usb_device *d,
>> +static struct usb_device_id cxusb_table[];
>> +
>> +int cxusb_ctrl_msg(struct dvb_usb_device *d,
>>                          u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
>>  {
>>        int wo = (rbuf == NULL || rlen == 0); /* write-only */
>> @@ -303,7 +306,20 @@ static int cxusb_d680_dmb_power_ctrl(struct dvb_usb_device *d, int onoff)
>>
>>  static int cxusb_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>>  {
>> +       struct dvb_usb_device *dvbdev = adap->dev;
>>        u8 buf[2] = { 0x03, 0x00 };
>> +
>> +       /* Medion 95700 */
>> +       if (dvbdev->props.devices[0].warm_ids[0] == &cxusb_table[0]) {
>> +               if (onoff) {
>> +                       int ret;
>> +                       ret = cxusb_medion_get(dvbdev, CXUSB_DIGITAL);
>> +                       if (ret != 0)
>> +                               return ret;
>> +               } else
>> +                       cxusb_medion_put(dvbdev);
>> +       }
>> +
>>        if (onoff)
>>                cxusb_ctrl_msg(adap->dev, CMD_STREAMING_ON, buf, 2, NULL, 0);
>>        else
>> @@ -829,17 +845,76 @@ static int cxusb_mygica_d689_tuner_attach(struct dvb_usb_adapter *adap)
>>        return (fe == NULL) ? -EIO : 0;
>>  }
>>
>> -static int cxusb_cx22702_frontend_attach(struct dvb_usb_adapter *adap)
>> +static int cxusb_medion_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
>> +{
>> +       struct dvb_usb_adapter *adap = fe->dvb->priv;
>> +       struct dvb_usb_device *dvbdev = adap->dev;
>> +
>> +       if (acquire)
>> +               return cxusb_medion_get(dvbdev, CXUSB_DIGITAL);
>> +       else
>> +               cxusb_medion_put(dvbdev);
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_medion_set_mode(struct dvb_usb_device *dvbdev, bool digital)
>>  {
>> +       int ret;
>>        u8 b;
>> -       if (usb_set_interface(adap->dev->udev, 0, 6) < 0)
>> -               err("set interface failed");
>>
>> -       cxusb_ctrl_msg(adap->dev, CMD_DIGITAL, NULL, 0, &b, 1);
>> +       if (digital) {
>> +               ret = usb_set_interface(dvbdev->udev, 0, 6);
>> +               if (ret != 0) {
>> +                       dev_err(&dvbdev->udev->dev,
>> +                               "digital interface "
>> +                               "selection failed (%d)\n",
>> +                               ret);
>> +                       return ret;
>> +               }
>> +       } else {
>> +               ret = usb_set_interface(dvbdev->udev, 0, 1);
>> +               if (ret != 0) {
>> +                       dev_err(&dvbdev->udev->dev,
>> +                       "analog interface selection failed (%d)\n",
>> +                       ret);
>> +                       return ret;
>> +               }
>> +       }
>> +
>> +       /* pipes need to be cleared after setting interface */
>> +       ret = usb_clear_halt(dvbdev->udev, usb_rcvbulkpipe(dvbdev->udev, 1));
>> +       if (ret != 0)
>> +               dev_warn(&dvbdev->udev->dev,
>> +                       "clear halt on IN pipe failed (%d)\n",
>> +                       ret);
>> +
>> +       ret = usb_clear_halt(dvbdev->udev, usb_sndbulkpipe(dvbdev->udev, 1));
>> +       if (ret != 0)
>> +               dev_warn(&dvbdev->udev->dev,
>> +                       "clear halt on OUT pipe failed (%d)\n",
>> +                       ret);
>> +
>> +       ret = cxusb_ctrl_msg(dvbdev, digital ? CMD_DIGITAL : CMD_ANALOG,
>> +                       NULL, 0, &b, 1);
>> +       if (ret != 0) {
>> +               dev_err(&dvbdev->udev->dev, "mode switch failed (%d)\n",
>> +                       ret);
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int cxusb_cx22702_frontend_attach(struct dvb_usb_adapter *adap)
>> +{
>> +       cxusb_medion_set_mode(adap->dev, true);
>>
>>        if ((adap->fe[0] = dvb_attach(cx22702_attach, &cxusb_cx22702_config,
>> -                                  &adap->dev->i2c_adap)) != NULL)
>> +                                  &adap->dev->i2c_adap)) != NULL) {
>> +               adap->fe[0]->ops.ts_bus_ctrl = cxusb_medion_fe_ts_bus_ctrl;
>>                return 0;
>> +       }
>>
>>        return -EIO;
>>  }
>> @@ -1299,6 +1374,113 @@ static int bluebird_patch_dvico_firmware_download(struct usb_device *udev,
>>        return -EINVAL;
>>  }
>>
>> +int cxusb_medion_get(struct dvb_usb_device *dvbdev,
>> +               enum cxusb_open_type open_type)
>> +{
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +       int ret = 0;
>> +
>> +       mutex_lock(&cxdev->open_lock);
>> +
>> +       BUG_ON(cxdev->open_type == CXUSB_NONE && cxdev->open_ctr != 0);
>> +
>> +       if (cxdev->open_ctr == 0) {
>> +               if (cxdev->open_type != open_type) {
>> +                       if (open_type == CXUSB_ANALOG) {
>> +                               /* switch to the digital mode, powerup, */
>> +                               /* init DVB demod and enable its I2C gate */
>> +                               ret = cxusb_medion_set_mode(dvbdev, true);
>> +                               if (ret != 0) {
>> +                                       dev_warn(&dvbdev->udev->dev,
>> +                                               "temporary digital switch "
>> +                                               "failed (%d)\n",
>> +                                               ret);
>> +                                       ret = 0;
>> +                               }
>> +
>> +                               ret = cxusb_power_ctrl(dvbdev, 1);
>> +                               if (ret != 0) {
>> +                                       dev_warn(&dvbdev->udev->dev,
>> +                                               "powerup failed (%d)\n",
>> +                                               ret);
>> +                                       ret = 0;
>> +                               }
>> +
>> +                               if (dvbdev->adapter[0].fe[0] != NULL) {
>> +                                       dvbdev->adapter[0].fe[0]->
>> +                                               ops.init(
>> +                                                       dvbdev->
>> +                                                       adapter[0].fe[0]);
>> +
>> +                                       dvbdev->adapter[0].fe[0]->
>> +                                               ops.i2c_gate_ctrl(
>> +                                                       dvbdev->
>> +                                                       adapter[0].fe[0], 1);
>> +                               } else
>> +                                       dev_warn(&dvbdev->udev->dev,
>> +                                               "no way to enable I2C gate "
>> +                                               "in DVB demod - expect "
>> +                                               "tuning problems\n");
>> +
>> +
>> +                               /* now we can switch to the analog mode */
>> +                               ret = cxusb_medion_set_mode(dvbdev, false);
>> +                               if (ret != 0)
>> +                                       goto ret_unlock;
>> +
>> +                               ret = cxusb_medion_analog_init(dvbdev);
>> +                               if (ret != 0)
>> +                                       goto ret_unlock;
>> +                       } else { /* digital */
>> +                               ret = cxusb_medion_set_mode(dvbdev, true);
>> +                               if (ret != 0)
>> +                                       goto ret_unlock;
>> +
>> +                               ret = cxusb_power_ctrl(dvbdev, 0);
>> +                               if (ret != 0) {
>> +                                       dev_warn(&dvbdev->udev->dev,
>> +                                               "powerdown failed (%d)\n",
>> +                                               ret);
>> +                                       ret = 0;
>> +                               }
>> +                       }
>> +
>> +                       cxdev->open_type = open_type;
>> +               }
>> +
>> +               cxdev->open_ctr = 1;
>> +
>> +               deb_info("acquire idle %s\n", open_type == CXUSB_ANALOG ?
>> +                       "analog" : "digital");
>> +       } else if (cxdev->open_type == open_type) {
>> +               cxdev->open_ctr++;
>> +               deb_info("acquire %s\n", open_type == CXUSB_ANALOG ?
>> +                       "analog" : "digital");
>> +       } else
>> +               ret = -EBUSY;
>> +
>> +ret_unlock:
>> +       mutex_unlock(&cxdev->open_lock);
>> +
>> +       return ret;
>> +}
>> +
>> +void cxusb_medion_put(struct dvb_usb_device *dvbdev)
>> +{
>> +       struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +       mutex_lock(&cxdev->open_lock);
>> +
>> +       BUG_ON(cxdev->open_ctr < 1);
>> +
>> +       cxdev->open_ctr--;
>> +
>> +       deb_info("release %s\n", cxdev->open_type == CXUSB_ANALOG ?
>> +               "analog" : "digital");
>> +
>> +       mutex_unlock(&cxdev->open_lock);
>> +}
>> +
>>  /* DVB USB Driver stuff */
>>  static struct dvb_usb_device_properties cxusb_medion_properties;
>>  static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties;
>> @@ -1313,12 +1495,87 @@ static struct dvb_usb_device_properties cxusb_aver_a868r_properties;
>>  static struct dvb_usb_device_properties cxusb_d680_dmb_properties;
>>  static struct dvb_usb_device_properties cxusb_mygica_d689_properties;
>>
>> +static bool cxusb_medion_check_intf(struct usb_interface *intf)
>> +{
>> +       unsigned int ctr;
>> +       bool found_iso = false;
>> +
>> +       if (intf->num_altsetting < 2) {
>> +               dev_err(intf->usb_dev, "no alternate interface");
>> +               return false;
>> +       }
>> +
>> +       for (ctr = 0; ctr < intf->num_altsetting && !found_iso; ctr++)
>> +               if (intf->altsetting[ctr].desc.bAlternateSetting == 1) {
>> +                       unsigned int ctr2;
>> +                       for (ctr2 = 0; ctr2 <
>> +                                    intf->altsetting[ctr].desc.bNumEndpoints
>> +                                    ; ctr2++)
>> +                               if ((intf->altsetting[ctr].endpoint[ctr2].
>> +                                               desc.bEndpointAddress
>> +                                               & USB_ENDPOINT_NUMBER_MASK)
>> +                                       == 2) {
>> +                                       if (intf->altsetting[ctr].
>> +                                               endpoint[ctr2].desc.
>> +                                               bEndpointAddress
>> +                                               & USB_DIR_IN &&
>> +                                               ((intf->altsetting[ctr].
>> +                                                       endpoint[ctr2].
>> +                                                       desc.
>> +                                                       bmAttributes
>> +                                           & USB_ENDPOINT_XFERTYPE_MASK) ==
>> +                                           USB_ENDPOINT_XFER_ISOC)) {
>> +                                               found_iso = true;
>> +                                               break;
>> +                                       }
>> +
>> +                                       break;
>> +                               }
>> +
>> +                       break;
>> +               }
>> +
>> +       if (!found_iso) {
>> +               dev_err(intf->usb_dev, "no iso interface");
>> +               return false;
>> +       }
>> +
>> +       return true;
>> +}
>> +
>>  static int cxusb_probe(struct usb_interface *intf,
>>                       const struct usb_device_id *id)
>>  {
>> +       struct dvb_usb_device *dvbdev;
>> +       int ret;
>> +
>> +       /* Medion 95700 */
>>        if (0 == dvb_usb_device_init(intf, &cxusb_medion_properties,
>> -                                    THIS_MODULE, NULL, adapter_nr) ||
>> -           0 == dvb_usb_device_init(intf, &cxusb_bluebird_lgh064f_properties,
>> +                                       THIS_MODULE, &dvbdev, adapter_nr)) {
>> +               struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +               cxdev->dvbdev = dvbdev;
>> +
>> +               if (!cxusb_medion_check_intf(intf)) {
>> +                       ret = -ENODEV;
>> +                       goto ret_uninit;
>> +               }
>> +
>> +               cxdev->open_type = CXUSB_NONE;
>> +               mutex_init(&cxdev->open_lock);
>> +
>> +               cxusb_power_ctrl(dvbdev, 1);
>> +               cxusb_medion_set_mode(dvbdev, false);
>> +
>> +               ret = cxusb_medion_register_analog(dvbdev);
>> +               if (ret != 0)
>> +                       goto ret_uninit;
>> +
>> +               cxusb_medion_set_mode(dvbdev, true);
>> +               cxusb_power_ctrl(dvbdev, 0);
>> +
>> +               return 0;
>> +       } else if (0 == dvb_usb_device_init(intf, &cxusb_bluebird_lgh064f_properties,
>>                                     THIS_MODULE, NULL, adapter_nr) ||
>>            0 == dvb_usb_device_init(intf, &cxusb_bluebird_dee1601_properties,
>>                                     THIS_MODULE, NULL, adapter_nr) ||
>> @@ -1335,7 +1592,7 @@ static int cxusb_probe(struct usb_interface *intf,
>>                                     THIS_MODULE, NULL, adapter_nr) ||
>>            0 == dvb_usb_device_init(intf, &cxusb_aver_a868r_properties,
>>                                     THIS_MODULE, NULL, adapter_nr) ||
>> -           0 == dvb_usb_device_init(intf,
>> +               0 == dvb_usb_device_init(intf,
>>                                     &cxusb_bluebird_dualdig4_rev2_properties,
>>                                     THIS_MODULE, NULL, adapter_nr) ||
>>            0 == dvb_usb_device_init(intf, &cxusb_d680_dmb_properties,
>> @@ -1346,6 +1603,26 @@ static int cxusb_probe(struct usb_interface *intf,
>>                return 0;
>>
>>        return -EINVAL;
>> +
>> +ret_uninit:
>> +       dvb_usb_device_exit(intf);
>> +
>> +       return ret;
>> +}
>> +
>> +static void cxusb_disconnect(struct usb_interface *intf)
>> +{
>> +       struct dvb_usb_device *dvbdev = usb_get_intfdata(intf);
>> +
>> +       /* Medion 95700 */
>> +       if (dvbdev->props.devices[0].warm_ids[0] == &cxusb_table[0]) {
>> +               struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +               cxusb_medion_unregister_analog(dvbdev);
>> +               mutex_destroy(&cxdev->open_lock);
>> +       }
>> +
>> +       dvb_usb_device_exit(intf);
>>  }
>>
>>  static struct usb_device_id cxusb_table [] = {
>> @@ -1378,7 +1655,7 @@ static struct dvb_usb_device_properties cxusb_medion_properties = {
>>
>>        .usb_ctrl = CYPRESS_FX2,
>>
>> -       .size_of_priv     = sizeof(struct cxusb_state),
>> +       .size_of_priv     = sizeof(struct cxusb_medion_dev),
>>
>>        .num_adapters = 1,
>>        .adapter = {
>> @@ -1984,7 +2261,7 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
>>  static struct usb_driver cxusb_driver = {
>>        .name           = "dvb_usb_cxusb",
>>        .probe          = cxusb_probe,
>> -       .disconnect     = dvb_usb_device_exit,
>> +       .disconnect     = cxusb_disconnect,
>>        .id_table       = cxusb_table,
>>  };
>>
>> @@ -2012,6 +2289,7 @@ module_exit (cxusb_module_exit);
>>  MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
>>  MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
>>  MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
>> +MODULE_AUTHOR("Maciej Szmigiero <mhej@o2.pl>");
>>  MODULE_DESCRIPTION("Driver for Conexant USB2.0 hybrid reference design");
>> -MODULE_VERSION("1.0-alpha");
>> +MODULE_VERSION("1.0-beta");
>>  MODULE_LICENSE("GPL");
>> diff --git a/drivers/media/dvb/dvb-usb/cxusb.h b/drivers/media/dvb/dvb-usb/cxusb.h
>> index 1a51eaf..8c5399c 100644
>> --- a/drivers/media/dvb/dvb-usb/cxusb.h
>> +++ b/drivers/media/dvb/dvb-usb/cxusb.h
>> @@ -1,9 +1,27 @@
>>  #ifndef _DVB_USB_CXUSB_H_
>>  #define _DVB_USB_CXUSB_H_
>>
>> +#include <linux/spinlock.h>
>> +#include <linux/list.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/usb.h>
>> +
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-dev.h>
>> +
>> +#include <media/videobuf2-vmalloc.h>
>> +
>>  #define DVB_USB_LOG_PREFIX "cxusb"
>>  #include "dvb-usb.h"
>>
>> +#define CXUSB_VIDEO_URBS (5)
>> +
>> +#define CXUSB_VIDEO_PKT_SIZE 3030
>> +#define CXUSB_VIDEO_MAX_FRAME_PKTS 346
>> +#define CXUSB_VIDEO_MAX_FRAME_SIZE (CXUSB_VIDEO_MAX_FRAME_PKTS* \
>> +                                       CXUSB_VIDEO_PKT_SIZE)
>> +
>>  /* usb commands - some of it are guesses, don't have a reference yet */
>>  #define CMD_BLUEBIRD_GPIO_RW 0x05
>>
>> @@ -28,8 +46,119 @@
>>  #define CMD_ANALOG        0x50
>>  #define CMD_DIGITAL       0x51
>>
>> +#define CXUSB_BT656_COMMON "\xff\x00\x00"
>> +
>> +#define CXUSB_FIELD_MASK (0x40)
>> +#define CXUSB_FIELD_1 (0)
>> +#define CXUSB_FIELD_2 (0x40)
>> +
>> +#define CXUSB_SEAV_MASK (0x10)
>> +#define CXUSB_SEAV_EAV (0x10)
>> +#define CXUSB_SEAV_SAV (0)
>> +
>> +#define CXUSB_VBI_MASK (0x20)
>> +#define CXUSB_VBI_ON (0x20)
>> +#define CXUSB_VBI_OFF (0)
>> +
>>  struct cxusb_state {
>>        u8 gpio_write_state[3];
>>  };
>>
>> +enum cxusb_open_type {
>> +       CXUSB_NONE, CXUSB_ANALOG, CXUSB_DIGITAL
>> +};
>> +
>> +struct cxusb_medion_auxbuf {
>> +       u8 *buf;
>> +       unsigned int len;
>> +       unsigned int paylen;
>> +};
>> +
>> +enum cxusb_bt656_mode {
>> +       NEW_FRAME, FIRST_FIELD, SECOND_FIELD
>> +};
>> +
>> +enum cxusb_bt656_fmode {
>> +       START_SEARCH, LINE_SAMPLES, VBI_SAMPLES
>> +};
>> +
>> +struct cxusb_bt656_params {
>> +       enum cxusb_bt656_mode mode;
>> +       enum cxusb_bt656_fmode fmode;
>> +       unsigned int pos;
>> +       unsigned int line;
>> +       unsigned int linesamples;
>> +       u8 *buf;
>> +};
>> +
>> +struct cxusb_medion_dev {
>> +       /* has to be the first one */
>> +       struct cxusb_state state;
>> +       struct dvb_usb_device *dvbdev;
>> +
>> +       struct v4l2_device v4l2dev;
>> +       struct v4l2_subdev *cx25840;
>> +       struct v4l2_subdev *tuner;
>> +       struct v4l2_subdev *tda9887;
>> +       struct video_device *videodev;
>> +
>> +       enum cxusb_open_type open_type;
>> +       unsigned int open_ctr;
>> +       struct mutex open_lock;
>> +
>> +       struct vb2_queue videoqueue;
>> +       struct file *streamingfh;
>> +       u32 input;
>> +       bool streaming;
>> +       u32 width, height;
>> +       bool raw_mode;
>> +       struct cxusb_medion_auxbuf auxbuf;
>> +
>> +       struct urb *streamurbs[CXUSB_VIDEO_URBS];
>> +       unsigned long urbcomplete;
>> +       struct work_struct urbwork;
>> +       unsigned int nexturb;
>> +
>> +       struct cxusb_bt656_params bt656;
>> +       struct cxusb_medion_vbuffer *vbuf;
>> +
>> +       struct list_head buflist;
>> +
>> +       struct completion v4l2_release, videodev_release;
>> +};
>> +
>> +struct cxusb_medion_vbuffer {
>> +       struct vb2_buffer vb2;
>> +       struct list_head list;
>> +};
>> +
>> +/* defines for "debug" module parameter */
>> +#define CXUSB_DBG_RC (1 << 0)
>> +#define CXUSB_DBG_I2C (1 << 1)
>> +#define CXUSB_DBG_MISC (1 << 2)
>> +#define CXUSB_DBG_BT656 (1 << 3)
>> +#define CXUSB_DBG_URB (1 << 4)
>> +#define CXUSB_DBG_OPS (1 << 5)
>> +#define CXUSB_DBG_AUXB (1 << 6)
>> +
>> +extern int dvb_usb_cxusb_debug;
>> +
>> +#define cxusb_vprintk(dvbdev, lvl, ...) do { \
>> +               struct cxusb_medion_dev *_cxdev = (dvbdev)->priv;       \
>> +               if (dvb_usb_cxusb_debug & CXUSB_DBG_##lvl)              \
>> +                       v4l2_printk(KERN_DEBUG,                         \
>> +                               &_cxdev->v4l2dev, __VA_ARGS__);         \
>> +       } while (0)
>> +
>> +int cxusb_ctrl_msg(struct dvb_usb_device *d,
>> +               u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen);
>> +
>> +int cxusb_medion_analog_init(struct dvb_usb_device *dvbdev);
>> +int cxusb_medion_register_analog(struct dvb_usb_device *dvbdev);
>> +void cxusb_medion_unregister_analog(struct dvb_usb_device *dvbdev);
>> +
>> +int cxusb_medion_get(struct dvb_usb_device *dvbdev,
>> +               enum cxusb_open_type open_type);
>> +void cxusb_medion_put(struct dvb_usb_device *dvbdev);
>> +
>>  #endif
>> diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
>> index b7ee2ae..d6f264b 100644
>> --- a/drivers/media/video/cx25840/cx25840-core.c
>> +++ b/drivers/media/video/cx25840/cx25840-core.c
>> @@ -18,6 +18,9 @@
>>  * CX2388[578] IRQ handling, IO Pin mux configuration and other small fixes are
>>  * Copyright (C) 2010 Andy Walls <awalls@md.metrocast.net>
>>  *
>> + * CX2384x pin to pad mapping and output format configuration support are
>> + * Copyright (C) 2011 Maciej Szmigiero <mhej@o2.pl>
>> + *
>>  * This program is free software; you can redistribute it and/or
>>  * modify it under the terms of the GNU General Public License
>>  * as published by the Free Software Foundation; either version 2
>> @@ -316,6 +319,277 @@ static int cx23885_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
>>        return 0;
>>  }
>>
>> +static u8 cx25840_function_to_pad(u8 function)
>> +{
>> +       switch (function) {
>> +       case CX25840_PAD_ACTIVE:
>> +               return 1;
>> +
>> +       case CX25840_PAD_VACTIVE:
>> +               return 2;
>> +
>> +       case CX25840_PAD_CBFLAG:
>> +               return 3;
>> +
>> +       case CX25840_PAD_VID_DATA_EXT0:
>> +               return 4;
>> +
>> +       case CX25840_PAD_VID_DATA_EXT1:
>> +               return 5;
>> +
>> +       case CX25840_PAD_GPO0:
>> +               return 6;
>> +
>> +       case CX25840_PAD_GPO1:
>> +               return 7;
>> +
>> +       case CX25840_PAD_GPO2:
>> +               return 8;
>> +
>> +       case CX25840_PAD_GPO3:
>> +               return 9;
>> +
>> +       case CX25840_PAD_IRQ_N:
>> +               return 10;
>> +
>> +       case CX25840_PAD_AC_SYNC:
>> +               return 11;
>> +
>> +       case CX25840_PAD_AC_SDOUT:
>> +               return 12;
>> +
>> +       case CX25840_PAD_PLL_CLK:
>> +               return 13;
>> +
>> +       case CX25840_PAD_VRESET:
>> +               return 14;
>> +
>> +       default:
>> +               if (function != CX25840_PAD_DEFAULT)
>> +                       printk(KERN_ERR "cx25840: invalid function "
>> +                               "%u, assuming default\n",
>> +                               (unsigned int)function);
>> +               return 0;
>> +       }
>> +}
>> +
>> +static void cx25840_set_invert(u8 *pinctrl3, u8 *voutctrl4, u8 function,
>> +                       u8 pin, bool invert)
>> +{
>> +       if (function != CX25840_PAD_DEFAULT)
>> +               switch (function) {
>> +               case CX25840_PAD_IRQ_N:
>> +                       if (invert)
>> +                               *pinctrl3 &= ~2;
>> +                       else
>> +                               *pinctrl3 |= 2;
>> +                       break;
>> +
>> +               case CX25840_PAD_ACTIVE:
>> +                       if (invert)
>> +                               *voutctrl4 |= (1 << 2);
>> +                       else
>> +                               *voutctrl4 &= ~(1 << 2);
>> +                       break;
>> +
>> +               case CX25840_PAD_VACTIVE:
>> +                       if (invert)
>> +                               *voutctrl4 |= (1 << 5);
>> +                       else
>> +                               *voutctrl4 &= ~(1 << 5);
>> +                       break;
>> +
>> +               case CX25840_PAD_CBFLAG:
>> +                       if (invert)
>> +                               *voutctrl4 |= (1 << 4);
>> +                       else
>> +                               *voutctrl4 &= ~(1 << 4);
>> +                       break;
>> +
>> +               case CX25840_PAD_VRESET:
>> +                       if (invert)
>> +                               *voutctrl4 |= (1 << 0);
>> +                       else
>> +                               *voutctrl4 &= ~(1 << 0);
>> +                       break;
>> +
>> +               default:
>> +                       break;
>> +               }
>> +       else
>> +               switch (pin) {
>> +               case CX25840_PIN_DVALID_PRGM0:
>> +                       if (invert)
>> +                               *voutctrl4 |= (1 << 6);
>> +                       else
>> +                               *voutctrl4 &= ~(1 << 6);
>> +                       break;
>> +
>> +               case CX25840_PIN_FIELD_PRGM1:
>> +                       if (invert)
>> +                               *voutctrl4 |= (1 << 3);
>> +                       else
>> +                               *voutctrl4 &= ~(1 << 3);
>> +                       break;
>> +
>> +               case CX25840_PIN_HRESET_PRGM2:
>> +                       if (invert)
>> +                               *voutctrl4 |= (1 << 1);
>> +                       else
>> +                               *voutctrl4 &= ~(1 << 1);
>> +                       break;
>> +
>> +               case CX25840_PIN_VRESET_HCTL_PRGM3:
>> +                       if (invert)
>> +                               *voutctrl4 |= (1 << 0);
>> +                       else
>> +                               *voutctrl4 &= ~(1 << 0);
>> +                       break;
>> +
>> +               default:
>> +                       break;
>> +               }
>> +}
>> +
>> +#define CX25840_PIN(pin, enable_reg, enable_bit, config_reg, config_msb, strength_reg, strength_shift) \
>> +       case pin: \
>> +               if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE) \
>> +                       pinctrl[enable_reg] &= ~(1 << enable_bit); \
>> +               else \
>> +                       pinctrl[enable_reg] |= 1 << enable_bit; \
>> +\
>> +               function = cx25840_function_to_pad(p[i].function); \
>> +\
>> +               pinconf[config_reg] &= ~(config_msb ? 0xf0 : 0x0f); \
>> +               pinconf[config_reg] |= function << (config_msb ? 4 : 0); \
>> +\
>> +               cx25840_set_invert(&(pinctrl[3]), &voutctrl4, function, pin, \
>> +                               p[i].flags & V4L2_SUBDEV_IO_PIN_ACTIVE_LOW); \
>> +\
>> +\
>> +               if (pin == CX25840_PIN_CHIP_SEL_VIPCLK) \
>> +                       break; \
>> +\
>> +               pinctrl[strength_reg] &= ~(3 << strength_shift); \
>> +               switch (strength) { \
>> +               case CX25840_PIN_DRIVE_SLOW: \
>> +                       pinctrl[strength_reg] |= (1 << strength_shift); \
>> +                       break; \
>> +\
>> +               case CX25840_PIN_DRIVE_MEDIUM: \
>> +                       pinctrl[strength_reg] |= (0 << strength_shift); \
>> +                       break; \
>> +\
>> +               case CX25840_PIN_DRIVE_FAST: \
>> +                       pinctrl[strength_reg] |= (2 << strength_shift); \
>> +                       break; \
>> +               } \
>> +               break;
>> +
>> +static int cx25840_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
>> +                                     struct v4l2_subdev_io_pin_config *p)
>> +{
>> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +       unsigned int i;
>> +       u8 pinctrl[6], pinconf[10], voutctrl4;
>> +
>> +       for (i = 0; i < 6; i++)
>> +               pinctrl[i] = cx25840_read(client, 0x114 + i);
>> +
>> +       for (i = 0; i < 10; i++)
>> +               pinconf[i] = cx25840_read(client, 0x11c + i);
>> +
>> +       voutctrl4 = cx25840_read(client, 0x407);
>> +
>> +       for (i = 0; i < n; i++) {
>> +               u8 function;
>> +               u8 strength = p[i].strength;
>> +               if (strength != CX25840_PIN_DRIVE_SLOW &&
>> +                       strength != CX25840_PIN_DRIVE_MEDIUM &&
>> +                       strength != CX25840_PIN_DRIVE_FAST) {
>> +
>> +                       dev_err(sd->v4l2_dev->dev, "cx25840: invalid drive speed for "
>> +                               "pin %u (%u), assuming fast\n",
>> +                               (unsigned int)(p[i].pin),
>> +                               (unsigned int)strength);
>> +
>> +                       strength = CX25840_PIN_DRIVE_FAST;
>> +               }
>> +
>> +               switch (p[i].pin) {
>> +                       CX25840_PIN(CX25840_PIN_DVALID_PRGM0,
>> +                               0, 6, 3, 0, 4, 2);
>> +                       CX25840_PIN(CX25840_PIN_FIELD_PRGM1,
>> +                               0, 7, 3, 1, 4, 2);
>> +                       CX25840_PIN(CX25840_PIN_HRESET_PRGM2,
>> +                               1, 0, 4, 0, 4, 2);
>> +                       CX25840_PIN(CX25840_PIN_VRESET_HCTL_PRGM3,
>> +                               1, 1, 4, 1, 5, 0);
>> +                       CX25840_PIN(CX25840_PIN_IRQ_N_PRGM4,
>> +                               0, 3, 1, 1, 5, 0);
>> +                       CX25840_PIN(CX25840_PIN_IR_RX_PRGM5,
>> +                               0, 4, 2, 0, 5, 0);
>> +                       CX25840_PIN(CX25840_PIN_IR_TX_PRGM6,
>> +                               0, 5, 2, 1, 5, 0);
>> +                       CX25840_PIN(CX25840_PIN_GPIO0_PRGM8,
>> +                               0, 0, 0, 0, 5, 0);
>> +                       CX25840_PIN(CX25840_PIN_GPIO1_PRGM9,
>> +                               0, 1, 0, 1, 5, 0);
>> +                       CX25840_PIN(CX25840_PIN_CHIP_SEL_VIPCLK,
>> +                               0, 2, 1, 0, 0, 0);
>> +
>> +               case CX25840_PIN_PLL_CLK_PRGM7:
>> +                       if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
>> +                               pinctrl[2] &= ~(1 << 2);
>> +                       else
>> +                               pinctrl[2] |= 1 << 2;
>> +
>> +                       switch (p[i].function) {
>> +                       case CX25840_PAD_XTI_X5_DLL:
>> +                               pinconf[6] = 0;
>> +                               break;
>> +
>> +                       case CX25840_PAD_AUX_PLL:
>> +                               pinconf[6] = 1;
>> +                               break;
>> +
>> +                       case CX25840_PAD_VID_PLL:
>> +                               pinconf[6] = 5;
>> +                               break;
>> +
>> +                       case CX25840_PAD_XTI:
>> +                               pinconf[6] = 2;
>> +                               break;
>> +
>> +                       default:
>> +                               pinconf[6] = 3;
>> +                               pinconf[6] |=
>> +                                       cx25840_function_to_pad(
>> +                                               p[i].function) << 4;
>> +                       }
>> +
>> +                       break;
>> +
>> +               default:
>> +                       dev_err(sd->v4l2_dev->dev,
>> +                               "cx25840: invalid pin %u\n",
>> +                               (unsigned int)(p[i].pin));
>> +                       break;
>> +               }
>> +       }
>> +
>> +       cx25840_write(client, 0x407, voutctrl4);
>> +
>> +       for (i = 0; i < 6; i++)
>> +               cx25840_write(client, 0x114 + i, pinctrl[i]);
>> +
>> +       for (i = 0; i < 10; i++)
>> +               cx25840_write(client, 0x11c + i, pinconf[i]);
>> +
>> +       return 0;
>> +}
>> +#undef CX25840_PIN
>> +
>>  static int common_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
>>                                      struct v4l2_subdev_io_pin_config *pincfg)
>>  {
>> @@ -323,6 +597,8 @@ static int common_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
>>
>>        if (is_cx2388x(state))
>>                return cx23885_s_io_pin_config(sd, n, pincfg);
>> +       else if (is_cx2584x(state))
>> +               return cx25840_s_io_pin_config(sd, n, pincfg);
>>        return 0;
>>  }
>>
>> @@ -453,6 +729,20 @@ static void cx25840_initialize(struct i2c_client *client)
>>        /* (re)set input */
>>        set_input(client, state->vid_input, state->aud_input);
>>
>> +       /* set datasheet video output defaults */
>> +       cx25840_vconfig(client, CX25840_VCONFIG_FMT_BT656|
>> +                       CX25840_VCONFIG_RES_8BIT|
>> +                       CX25840_VCONFIG_VBIRAW_DISABLED|
>> +                       CX25840_VCONFIG_ANCDATA_ENABLED|
>> +                       CX25840_VCONFIG_TASKBIT_ONE|
>> +                       CX25840_VCONFIG_ACTIVE_HORIZONTAL|
>> +                       CX25840_VCONFIG_VALID_NORMAL|
>> +                       CX25840_VCONFIG_HRESETW_NORMAL|
>> +                       CX25840_VCONFIG_CLKGATE_NONE|
>> +                       CX25840_VCONFIG_DCMODE_DWORDS|
>> +                       CX25840_VCONFIG_IDID0S_NORMAL|
>> +                       CX25840_VCONFIG_VIPCLAMP_DISABLED);
>> +
>>        /* start microcontroller */
>>        cx25840_and_or(client, 0x803, ~0x10, 0x10);
>>  }
>> @@ -1174,7 +1464,9 @@ static int cx25840_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
>>        Hsrc = (cx25840_read(client, 0x472) & 0x3f) << 4;
>>        Hsrc |= (cx25840_read(client, 0x471) & 0xf0) >> 4;
>>
>> -       Vlines = fmt->height + (is_50Hz ? 4 : 7);
>> +       Vlines = fmt->height;
>> +       if (!is_cx2584x(state))
>> +               Vlines += is_50Hz ? 4 : 7;
>>
>>        if ((fmt->width * 16 < Hsrc) || (Hsrc < fmt->width) ||
>>                        (Vlines * 8 < Vsrc) || (Vsrc < Vlines)) {
>> @@ -1403,6 +1695,112 @@ static void log_audio_status(struct i2c_client *client)
>>        }
>>  }
>>
>> +#define CX25480_VCONFIG_OPTION(option_mask) \
>> +       if (config_in & option_mask) { \
>> +               state->vid_config &= ~(option_mask); \
>> +               state->vid_config |= config_in & option_mask; \
>> +       } \
>> +
>> +#define CX25480_VCONFIG_SET_BIT(optionmask, reg, bit, oneval) \
>> +       if (state->vid_config & optionmask) { \
>> +               if ((state->vid_config & optionmask) == \
>> +                       oneval) \
>> +                       voutctrl[reg] |= 1 << bit; \
>> +               else \
>> +                       voutctrl[reg] &= ~(1 << bit); \
>> +       } \
>> +
>> +int cx25840_vconfig(struct i2c_client *client, u32 config_in)
>> +{
>> +       struct cx25840_state *state = to_state(i2c_get_clientdata(client));
>> +       u8 voutctrl[3];
>> +       unsigned int i;
>> +
>> +       /* apply incoming options to curent state */
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_FMT_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_RES_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_VBIRAW_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_ANCDATA_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_TASKBIT_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_ACTIVE_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_VALID_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_HRESETW_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_CLKGATE_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_DCMODE_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_IDID0S_MASK);
>> +       CX25480_VCONFIG_OPTION(CX25840_VCONFIG_VIPCLAMP_MASK);
>> +
>> +       for (i = 0; i < 3; i++)
>> +               voutctrl[i] = cx25840_read(client, 0x404 + i);
>> +
>> +       /* apply state to hardware regs */
>> +       if (state->vid_config & CX25840_VCONFIG_FMT_MASK)
>> +               voutctrl[0] &= ~(3);
>> +       switch (state->vid_config & CX25840_VCONFIG_FMT_MASK) {
>> +       case CX25840_VCONFIG_FMT_BT656:
>> +               voutctrl[0] |= 1;
>> +               break;
>> +
>> +       case CX25840_VCONFIG_FMT_VIP11:
>> +               voutctrl[0] |= 2;
>> +               break;
>> +
>> +       case CX25840_VCONFIG_FMT_VIP2:
>> +               voutctrl[0] |= 3;
>> +               break;
>> +
>> +       case CX25840_VCONFIG_FMT_BT601: /* zero */
>> +       default:
>> +               break;
>> +       }
>> +
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_RES_MASK, 0, 2,
>> +                               CX25840_VCONFIG_RES_10BIT);
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_VBIRAW_MASK, 0, 3,
>> +                               CX25840_VCONFIG_VBIRAW_ENABLED);
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_ANCDATA_MASK, 0, 4,
>> +                               CX25840_VCONFIG_ANCDATA_ENABLED);
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_TASKBIT_MASK, 0, 5,
>> +                               CX25840_VCONFIG_TASKBIT_ONE);
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_ACTIVE_MASK, 1, 2,
>> +                               CX25840_VCONFIG_ACTIVE_HORIZONTAL);
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_VALID_MASK, 1, 3,
>> +                               CX25840_VCONFIG_VALID_ANDACTIVE);
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_HRESETW_MASK, 1, 4,
>> +                               CX25840_VCONFIG_HRESETW_PIXCLK);
>> +
>> +       if (state->vid_config & CX25840_VCONFIG_CLKGATE_MASK)
>> +               voutctrl[1] &= ~(3 << 6);
>> +       switch (state->vid_config & CX25840_VCONFIG_CLKGATE_MASK) {
>> +       case CX25840_VCONFIG_CLKGATE_VALID:
>> +               voutctrl[1] |= 2;
>> +               break;
>> +
>> +       case CX25840_VCONFIG_CLKGATE_VALIDACTIVE:
>> +               voutctrl[1] |= 3;
>> +               break;
>> +
>> +       case CX25840_VCONFIG_CLKGATE_NONE: /* zero */
>> +       default:
>> +               break;
>> +       }
>> +
>> +
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_DCMODE_MASK, 2, 0,
>> +                               CX25840_VCONFIG_DCMODE_BYTES);
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_IDID0S_MASK, 2, 1,
>> +                               CX25840_VCONFIG_IDID0S_LINECNT);
>> +       CX25480_VCONFIG_SET_BIT(CX25840_VCONFIG_VIPCLAMP_MASK, 2, 4,
>> +                               CX25840_VCONFIG_VIPCLAMP_ENABLED);
>> +
>> +       for (i = 0; i < 3; i++)
>> +               cx25840_write(client, 0x404 + i, voutctrl[i]);
>> +
>> +       return 0;
>> +}
>> +#undef CX25480_VCONFIG_SET_BIT
>> +#undef CX25480_VCONFIG_OPTION
>> +
>>  /* ----------------------------------------------------------------------- */
>>
>>  /* This load_fw operation must be called to load the driver's firmware.
>> @@ -1546,6 +1944,9 @@ static int cx25840_s_video_routing(struct v4l2_subdev *sd,
>>        struct cx25840_state *state = to_state(sd);
>>        struct i2c_client *client = v4l2_get_subdevdata(sd);
>>
>> +       if (is_cx2584x(state))
>> +               cx25840_vconfig(client, config);
>> +
>>        return set_input(client, input, state->aud_input);
>>  }
>>
>> @@ -1877,7 +2278,7 @@ static int cx25840_probe(struct i2c_client *client,
>>        u16 device_id;
>>
>>        /* Check if the adapter supports the needed features */
>> -       if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>> +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
>>                return -EIO;
>>
>>        v4l_dbg(1, cx25840_debug, client, "detecting cx25840 client on address 0x%x\n", client->addr << 1);
>> diff --git a/drivers/media/video/cx25840/cx25840-core.h b/drivers/media/video/cx25840/cx25840-core.h
>> index bd4ada2..c9136cd 100644
>> --- a/drivers/media/video/cx25840/cx25840-core.h
>> +++ b/drivers/media/video/cx25840/cx25840-core.h
>> @@ -42,6 +42,7 @@ struct cx25840_state {
>>        int radio;
>>        v4l2_std_id std;
>>        enum cx25840_video_input vid_input;
>> +       u32 vid_config;
>>        enum cx25840_audio_input aud_input;
>>        u32 audclk_freq;
>>        int audmode;
>> @@ -70,6 +71,14 @@ static inline bool is_cx2583x(struct cx25840_state *state)
>>               state->id == V4L2_IDENT_CX25837;
>>  }
>>
>> +static inline bool is_cx2584x(struct cx25840_state *state)
>> +{
>> +       return state->id == V4L2_IDENT_CX25840 ||
>> +              state->id == V4L2_IDENT_CX25841 ||
>> +              state->id == V4L2_IDENT_CX25842 ||
>> +              state->id == V4L2_IDENT_CX25843;
>> +}
>> +
>>  static inline bool is_cx231xx(struct cx25840_state *state)
>>  {
>>        return state->id == V4L2_IDENT_CX2310X_AV;
>> @@ -107,6 +116,7 @@ int cx25840_and_or(struct i2c_client *client, u16 addr, unsigned mask, u8 value)
>>  int cx25840_and_or4(struct i2c_client *client, u16 addr, u32 and_mask,
>>                    u32 or_value);
>>  void cx25840_std_setup(struct i2c_client *client);
>> +int cx25840_vconfig(struct i2c_client *client, u32 config_in);
>>
>>  /* ----------------------------------------------------------------------- */
>>  /* cx25850-firmware.c                                                      */
>> diff --git a/drivers/media/video/cx25840/cx25840-vbi.c b/drivers/media/video/cx25840/cx25840-vbi.c
>> index 64a4004..462cccc 100644
>> --- a/drivers/media/video/cx25840/cx25840-vbi.c
>> +++ b/drivers/media/video/cx25840/cx25840-vbi.c
>> @@ -97,9 +97,20 @@ int cx25840_g_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
>>        int i;
>>
>>        memset(svbi, 0, sizeof(*svbi));
>> +
>>        /* we're done if raw VBI is active */
>> -       if ((cx25840_read(client, 0x404) & 0x10) == 0)
>> -               return 0;
>> +       if (is_cx2584x(state)) {
>> +               if ((state->vid_config & CX25840_VCONFIG_VBIRAW_MASK) ==
>> +                       CX25840_VCONFIG_VBIRAW_ENABLED)
>> +                       return 0;
>> +       } else  /* this seems to be wrong - 0x10 is an ancillary data bit,
>> +                * not an raw VBI bit (which is 0x08 in datasheet)
>> +                * what this actually does is check if ancillary data
>> +                * insertion is disabled (can be enabled for other reasons
>> +                * than sliced VBI; for example for audio sampling)
>> +                */
>> +               if ((cx25840_read(client, 0x404) & 0x10) == 0)
>> +                       return 0;
>>
>>        if (is_pal) {
>>                for (i = 7; i <= 23; i++) {
>> @@ -135,7 +146,22 @@ int cx25840_s_raw_fmt(struct v4l2_subdev *sd, struct v4l2_vbi_format *fmt)
>>
>>        /* VBI Offset */
>>        cx25840_write(client, 0x47f, vbi_offset);
>> -       cx25840_write(client, 0x404, 0x2e);
>> +
>> +       if (is_cx2584x(state))
>> +               /* Im not sure if VBI code should switch output format to
>> +                * VIP 1.1, resolution to 10bit and disable ancillary data
>> +                * but this is what orginal code (bellow for non-cx254x
>> +                * chips) does. Likely this will break hw which relies
>> +                * on ancillary data to capture audio (like Medion 95700)
>> +                */
>> +               cx25840_vconfig(client, CX25840_VCONFIG_FMT_VIP11|
>> +                       CX25840_VCONFIG_RES_10BIT|
>> +                       CX25840_VCONFIG_VBIRAW_ENABLED|
>> +                       CX25840_VCONFIG_ANCDATA_DISABLED|
>> +                       CX25840_VCONFIG_TASKBIT_ONE);
>> +       else
>> +               cx25840_write(client, 0x404, 0x2e);
>> +
>>        return 0;
>>  }
>>
>> @@ -155,8 +181,20 @@ int cx25840_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
>>        cx25840_std_setup(client);
>>
>>        /* Sliced VBI */
>> -       cx25840_write(client, 0x404, 0x32);     /* Ancillary data */
>> -       cx25840_write(client, 0x406, 0x13);
>> +       if (is_cx2584x(state)) /* see comment in cx25840_s_raw_fmt() */
>> +               cx25840_vconfig(client, CX25840_VCONFIG_FMT_VIP11|
>> +                       CX25840_VCONFIG_RES_8BIT|
>> +                       CX25840_VCONFIG_VBIRAW_DISABLED|
>> +                       CX25840_VCONFIG_ANCDATA_ENABLED|
>> +                       CX25840_VCONFIG_TASKBIT_ONE|
>> +                       CX25840_VCONFIG_DCMODE_BYTES|
>> +                       CX25840_VCONFIG_IDID0S_LINECNT|
>> +                       CX25840_VCONFIG_VIPCLAMP_ENABLED);
>> +       else {
>> +               cx25840_write(client, 0x404, 0x32);     /* Ancillary data */
>> +               cx25840_write(client, 0x406, 0x13);
>> +       }
>> +
>>        cx25840_write(client, 0x47f, vbi_offset);
>>
>>        if (is_pal) {
>> diff --git a/include/media/cx25840.h b/include/media/cx25840.h
>> index 46d1a14..9e56a36 100644
>> --- a/include/media/cx25840.h
>> +++ b/include/media/cx25840.h
>> @@ -87,6 +87,70 @@ enum cx25840_video_input {
>>        CX25840_COMPONENT_ON = 0x80000200,
>>  };
>>
>> +/* arguments to video s_routing config param */
>> +#define CX25840_VCONFIG_FMT_SHIFT 0
>> +#define CX25840_VCONFIG_FMT_MASK 7
>> +#define CX25840_VCONFIG_FMT_BT601 1
>> +#define CX25840_VCONFIG_FMT_BT656 2
>> +#define CX25840_VCONFIG_FMT_VIP11 3
>> +#define CX25840_VCONFIG_FMT_VIP2 4
>> +
>> +#define CX25840_VCONFIG_RES_SHIFT 3
>> +#define CX25840_VCONFIG_RES_MASK (3 << 3)
>> +#define CX25840_VCONFIG_RES_8BIT (1 << 3)
>> +#define CX25840_VCONFIG_RES_10BIT (2 << 3)
>> +
>> +#define CX25840_VCONFIG_VBIRAW_SHIFT 5
>> +#define CX25840_VCONFIG_VBIRAW_MASK (3 << 5)
>> +#define CX25840_VCONFIG_VBIRAW_DISABLED (1 << 5)
>> +#define CX25840_VCONFIG_VBIRAW_ENABLED (2 << 5)
>> +
>> +#define CX25840_VCONFIG_ANCDATA_SHIFT 7
>> +#define CX25840_VCONFIG_ANCDATA_MASK (3 << 7)
>> +#define CX25840_VCONFIG_ANCDATA_DISABLED (1 << 7)
>> +#define CX25840_VCONFIG_ANCDATA_ENABLED (2 << 7)
>> +
>> +#define CX25840_VCONFIG_TASKBIT_SHIFT 9
>> +#define CX25840_VCONFIG_TASKBIT_MASK (3 << 9)
>> +#define CX25840_VCONFIG_TASKBIT_ZERO (1 << 9)
>> +#define CX25840_VCONFIG_TASKBIT_ONE (2 << 9)
>> +
>> +#define CX25840_VCONFIG_ACTIVE_SHIFT 11
>> +#define CX25840_VCONFIG_ACTIVE_MASK (3 << 11)
>> +#define CX25840_VCONFIG_ACTIVE_COMPOSITE (1 << 11)
>> +#define CX25840_VCONFIG_ACTIVE_HORIZONTAL (2 << 11)
>> +
>> +#define CX25840_VCONFIG_VALID_SHIFT 13
>> +#define CX25840_VCONFIG_VALID_MASK (3 << 13)
>> +#define CX25840_VCONFIG_VALID_NORMAL (1 << 13)
>> +#define CX25840_VCONFIG_VALID_ANDACTIVE (2 << 13)
>> +
>> +#define CX25840_VCONFIG_HRESETW_SHIFT 15
>> +#define CX25840_VCONFIG_HRESETW_MASK (3 << 15)
>> +#define CX25840_VCONFIG_HRESETW_NORMAL (1 << 15)
>> +#define CX25840_VCONFIG_HRESETW_PIXCLK (2 << 15)
>> +
>> +#define CX25840_VCONFIG_CLKGATE_SHIFT 17
>> +#define CX25840_VCONFIG_CLKGATE_MASK (3 << 17)
>> +#define CX25840_VCONFIG_CLKGATE_NONE (1 << 17)
>> +#define CX25840_VCONFIG_CLKGATE_VALID (2 << 17)
>> +#define CX25840_VCONFIG_CLKGATE_VALIDACTIVE (3 << 17)
>> +
>> +#define CX25840_VCONFIG_DCMODE_SHIFT 19
>> +#define CX25840_VCONFIG_DCMODE_MASK (3 << 19)
>> +#define CX25840_VCONFIG_DCMODE_DWORDS (1 << 19)
>> +#define CX25840_VCONFIG_DCMODE_BYTES (2 << 19)
>> +
>> +#define CX25840_VCONFIG_IDID0S_SHIFT 21
>> +#define CX25840_VCONFIG_IDID0S_MASK (3 << 21)
>> +#define CX25840_VCONFIG_IDID0S_NORMAL (1 << 21)
>> +#define CX25840_VCONFIG_IDID0S_LINECNT (2 << 21)
>> +
>> +#define CX25840_VCONFIG_VIPCLAMP_SHIFT 23
>> +#define CX25840_VCONFIG_VIPCLAMP_MASK (3 << 23)
>> +#define CX25840_VCONFIG_VIPCLAMP_ENABLED (1 << 23)
>> +#define CX25840_VCONFIG_VIPCLAMP_DISABLED (2 << 23)
>> +
>>  enum cx25840_audio_input {
>>        /* Audio inputs: serial or In4-In8 */
>>        CX25840_AUDIO_SERIAL,
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

