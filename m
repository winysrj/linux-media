Return-path: <mchehab@gaivota>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3745 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab0L2Kin (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 05:38:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Felipe Sanches <juca@members.fsf.org>
Subject: Re: [PATCH] [media] dabusb: Move it to staging to be deprecated
Date: Wed, 29 Dec 2010 11:37:48 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Deti Fliegl <deti@fliegl.de>
References: <4D19037B.6060904@redhat.com> <AANLkTi=MFVH0b8y7eneaku9sf5x5ZWWiZBK+5Bptx6cE@mail.gmail.com>
In-Reply-To: <AANLkTi=MFVH0b8y7eneaku9sf5x5ZWWiZBK+5Bptx6cE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012291137.49153.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tuesday, December 28, 2010 20:10:17 Felipe Sanches wrote:
> Wait!
> 
> It supports the DRBox1 DAB sold by Terratec:
> http://www.baycom.de/wiki/index.php/Products::dabusbhw

No, it doesn't. The driver in the kernel only supports the prototype board.
The driver on baycom.de *does* support the Terratec product, but that's not
in the kernel.

> I've been working on a free firmware for this device:
> http://libreplanet.org/wiki/LinuxLibre:USB_DABUSB

I don't mind having support for DAB in the kernel, but any DAB API needs to
be properly discussed, designed and documented. And it should probably be a
part of the V4L2 API (since that already supports analog radio and RDS).

By removing this driver from the kernel we open the way for a new DAB API
without breaking support for any existing end-users since the current driver
doesn't support any sold products.

Frankly, I'm quite interested to see support for this and I'd be happy to
work with someone on designing an API for it. Sounds interesting :-)

Regards,

	Hans

> 
> Felipe Sanches
> 
> On Mon, Dec 27, 2010 at 7:22 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > From cd1b06628baa2cc4780e70922623aac310d890e1 Mon Sep 17 00:00:00 2001
> > From: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Date: Mon, 27 Dec 2010 19:17:12 -0200
> > Subject: [PATCH] [media] dabusb: Move it to staging to be deprecated
> >
> > dabusb driver were conceived as an experimental driver for a test
> > device. The driver never supported any shipped product, and, while
> > there were some updates on it in 2003, for an ancient product,
> > those changes were never submitted upstream.
> >
> > Also, there's no DocBook for its API, nor any upstream discussion.
> >
> > So, better to remove it, on .39. If later needed, we may rescue it
> > from git logs. For now, let's move it to staging.
> >
> > Acked-by: Deti Fliegl <deti@fliegl.de>
> > gned-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >
> > diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> > index 147c92b..81b3ba8 100644
> > --- a/drivers/media/Kconfig
> > +++ b/drivers/media/Kconfig
> > @@ -92,26 +92,4 @@ source "drivers/media/radio/Kconfig"
> >
> >  source "drivers/media/dvb/Kconfig"
> >
> > -config DAB
> > -       boolean "DAB adapters"
> > -       ---help---
> > -         Allow selecting support for Digital Audio Broadcasting (DAB)
> > -         Receiver adapters.
> > -
> > -if DAB
> > -config USB_DABUSB
> > -       tristate "DABUSB driver"
> > -       depends on USB
> > -       ---help---
> > -         A Digital Audio Broadcasting (DAB) Receiver for USB and Linux
> > -         brought to you by the DAB-Team
> > -         <http://wwwbode.cs.tum.edu/Par/arch/dab/>.  This driver can be taken
> > -         as an example for URB-based bulk, control, and isochronous
> > -         transactions. URB's are explained in
> > -         <Documentation/usb/URB.txt>.
> > -
> > -         To compile this driver as a module, choose M here: the
> > -         module will be called dabusb.
> > -endif # DAB
> > -
> >  endif # MEDIA_SUPPORT
> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index fd684dd..98825e7 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -121,7 +121,6 @@ obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
> >
> >  obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
> >
> > -obj-$(CONFIG_USB_DABUSB)        += dabusb.o
> >  obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
> >  obj-$(CONFIG_USB_STKWEBCAM)     += stkwebcam.o
> >
> > diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
> > deleted file mode 100644
> > index f3e25e9..0000000
> > --- a/drivers/media/video/dabusb.c
> > +++ /dev/null
> > @@ -1,914 +0,0 @@
> > -/*****************************************************************************/
> > -
> > -/*
> > - *      dabusb.c  --  dab usb driver.
> > - *
> > - *      Copyright (C) 1999  Deti Fliegl (deti@fliegl.de)
> > - *
> > - *      This program is free software; you can redistribute it and/or modify
> > - *      it under the terms of the GNU General Public License as published by
> > - *      the Free Software Foundation; either version 2 of the License, or
> > - *      (at your option) any later version.
> > - *
> > - *      This program is distributed in the hope that it will be useful,
> > - *      but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - *      GNU General Public License for more details.
> > - *
> > - *      You should have received a copy of the GNU General Public License
> > - *      along with this program; if not, write to the Free Software
> > - *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > - *
> > - *
> > - *
> > - *  $Id: dabusb.c,v 1.54 2000/07/24 21:39:39 deti Exp $
> > - *
> > - */
> > -
> > -/*****************************************************************************/
> > -
> > -#include <linux/module.h>
> > -#include <linux/socket.h>
> > -#include <linux/list.h>
> > -#include <linux/vmalloc.h>
> > -#include <linux/slab.h>
> > -#include <linux/init.h>
> > -#include <asm/uaccess.h>
> > -#include <asm/atomic.h>
> > -#include <linux/delay.h>
> > -#include <linux/usb.h>
> > -#include <linux/mutex.h>
> > -#include <linux/firmware.h>
> > -#include <linux/ihex.h>
> > -
> > -#include "dabusb.h"
> > -
> > -/*
> > - * Version Information
> > - */
> > -#define DRIVER_VERSION "v1.54"
> > -#define DRIVER_AUTHOR "Deti Fliegl, deti@fliegl.de"
> > -#define DRIVER_DESC "DAB-USB Interface Driver for Linux (c)1999"
> > -
> > -/* --------------------------------------------------------------------- */
> > -
> > -#ifdef CONFIG_USB_DYNAMIC_MINORS
> > -#define NRDABUSB 256
> > -#else
> > -#define NRDABUSB 4
> > -#endif
> > -
> > -/*-------------------------------------------------------------------*/
> > -
> > -static dabusb_t dabusb[NRDABUSB];
> > -static int buffers = 256;
> > -static struct usb_driver dabusb_driver;
> > -
> > -/*-------------------------------------------------------------------*/
> > -
> > -static int dabusb_add_buf_tail (pdabusb_t s, struct list_head *dst, struct list_head *src)
> > -{
> > -       unsigned long flags;
> > -       struct list_head *tmp;
> > -       int ret = 0;
> > -
> > -       spin_lock_irqsave (&s->lock, flags);
> > -
> > -       if (list_empty (src)) {
> > -               // no elements in source buffer
> > -               ret = -1;
> > -               goto err;
> > -       }
> > -       tmp = src->next;
> > -       list_move_tail (tmp, dst);
> > -
> > -  err: spin_unlock_irqrestore (&s->lock, flags);
> > -       return ret;
> > -}
> > -/*-------------------------------------------------------------------*/
> > -#ifdef DEBUG
> > -static void dump_urb (struct urb *urb)
> > -{
> > -       dbg("urb                   :%p", urb);
> > -       dbg("dev                   :%p", urb->dev);
> > -       dbg("pipe                  :%08X", urb->pipe);
> > -       dbg("status                :%d", urb->status);
> > -       dbg("transfer_flags        :%08X", urb->transfer_flags);
> > -       dbg("transfer_buffer       :%p", urb->transfer_buffer);
> > -       dbg("transfer_buffer_length:%d", urb->transfer_buffer_length);
> > -       dbg("actual_length         :%d", urb->actual_length);
> > -       dbg("setup_packet          :%p", urb->setup_packet);
> > -       dbg("start_frame           :%d", urb->start_frame);
> > -       dbg("number_of_packets     :%d", urb->number_of_packets);
> > -       dbg("interval              :%d", urb->interval);
> > -       dbg("error_count           :%d", urb->error_count);
> > -       dbg("context               :%p", urb->context);
> > -       dbg("complete              :%p", urb->complete);
> > -}
> > -#endif
> > -/*-------------------------------------------------------------------*/
> > -static int dabusb_cancel_queue (pdabusb_t s, struct list_head *q)
> > -{
> > -       unsigned long flags;
> > -       pbuff_t b;
> > -
> > -       dbg("dabusb_cancel_queue");
> > -
> > -       spin_lock_irqsave (&s->lock, flags);
> > -
> > -       list_for_each_entry(b, q, buff_list) {
> > -#ifdef DEBUG
> > -               dump_urb(b->purb);
> > -#endif
> > -               usb_unlink_urb (b->purb);
> > -       }
> > -       spin_unlock_irqrestore (&s->lock, flags);
> > -       return 0;
> > -}
> > -/*-------------------------------------------------------------------*/
> > -static int dabusb_free_queue (struct list_head *q)
> > -{
> > -       struct list_head *tmp;
> > -       struct list_head *p;
> > -       pbuff_t b;
> > -
> > -       dbg("dabusb_free_queue");
> > -       for (p = q->next; p != q;) {
> > -               b = list_entry (p, buff_t, buff_list);
> > -
> > -#ifdef DEBUG
> > -               dump_urb(b->purb);
> > -#endif
> > -               kfree(b->purb->transfer_buffer);
> > -               usb_free_urb(b->purb);
> > -               tmp = p->next;
> > -               list_del (p);
> > -               kfree (b);
> > -               p = tmp;
> > -       }
> > -
> > -       return 0;
> > -}
> > -/*-------------------------------------------------------------------*/
> > -static int dabusb_free_buffers (pdabusb_t s)
> > -{
> > -       unsigned long flags;
> > -       dbg("dabusb_free_buffers");
> > -
> > -       spin_lock_irqsave(&s->lock, flags);
> > -
> > -       dabusb_free_queue (&s->free_buff_list);
> > -       dabusb_free_queue (&s->rec_buff_list);
> > -
> > -       spin_unlock_irqrestore(&s->lock, flags);
> > -
> > -       s->got_mem = 0;
> > -       return 0;
> > -}
> > -/*-------------------------------------------------------------------*/
> > -static void dabusb_iso_complete (struct urb *purb)
> > -{
> > -       pbuff_t b = purb->context;
> > -       pdabusb_t s = b->s;
> > -       int i;
> > -       int len;
> > -       int dst = 0;
> > -       void *buf = purb->transfer_buffer;
> > -
> > -       dbg("dabusb_iso_complete");
> > -
> > -       // process if URB was not killed
> > -       if (purb->status != -ENOENT) {
> > -               unsigned int pipe = usb_rcvisocpipe (purb->dev, _DABUSB_ISOPIPE);
> > -               int pipesize = usb_maxpacket (purb->dev, pipe, usb_pipeout (pipe));
> > -               for (i = 0; i < purb->number_of_packets; i++)
> > -                       if (!purb->iso_frame_desc[i].status) {
> > -                               len = purb->iso_frame_desc[i].actual_length;
> > -                               if (len <= pipesize) {
> > -                                       memcpy (buf + dst, buf + purb->iso_frame_desc[i].offset, len);
> > -                                       dst += len;
> > -                               }
> > -                               else
> > -                                       dev_err(&purb->dev->dev,
> > -                                               "dabusb_iso_complete: invalid len %d\n", len);
> > -                       }
> > -                       else
> > -                               dev_warn(&purb->dev->dev, "dabusb_iso_complete: corrupted packet status: %d\n", purb->iso_frame_desc[i].status);
> > -               if (dst != purb->actual_length)
> > -                       dev_err(&purb->dev->dev,
> > -                               "dst!=purb->actual_length:%d!=%d\n",
> > -                                       dst, purb->actual_length);
> > -       }
> > -
> > -       if (atomic_dec_and_test (&s->pending_io) && !s->remove_pending && s->state != _stopped) {
> > -               s->overruns++;
> > -               dev_err(&purb->dev->dev, "overrun (%d)\n", s->overruns);
> > -       }
> > -       wake_up (&s->wait);
> > -}
> > -/*-------------------------------------------------------------------*/
> > -static int dabusb_alloc_buffers (pdabusb_t s)
> > -{
> > -       int transfer_len = 0;
> > -       pbuff_t b;
> > -       unsigned int pipe = usb_rcvisocpipe (s->usbdev, _DABUSB_ISOPIPE);
> > -       int pipesize = usb_maxpacket (s->usbdev, pipe, usb_pipeout (pipe));
> > -       int packets = _ISOPIPESIZE / pipesize;
> > -       int transfer_buffer_length = packets * pipesize;
> > -       int i;
> > -
> > -       dbg("dabusb_alloc_buffers pipesize:%d packets:%d transfer_buffer_len:%d",
> > -                pipesize, packets, transfer_buffer_length);
> > -
> > -       while (transfer_len < (s->total_buffer_size << 10)) {
> > -               b = kzalloc(sizeof (buff_t), GFP_KERNEL);
> > -               if (!b) {
> > -                       dev_err(&s->usbdev->dev,
> > -                               "kzalloc(sizeof(buff_t))==NULL\n");
> > -                       goto err;
> > -               }
> > -               b->s = s;
> > -               b->purb = usb_alloc_urb(packets, GFP_KERNEL);
> > -               if (!b->purb) {
> > -                       dev_err(&s->usbdev->dev, "usb_alloc_urb == NULL\n");
> > -                       kfree (b);
> > -                       goto err;
> > -               }
> > -
> > -               b->purb->transfer_buffer = kmalloc (transfer_buffer_length, GFP_KERNEL);
> > -               if (!b->purb->transfer_buffer) {
> > -                       kfree (b->purb);
> > -                       kfree (b);
> > -                       dev_err(&s->usbdev->dev,
> > -                               "kmalloc(%d)==NULL\n", transfer_buffer_length);
> > -                       goto err;
> > -               }
> > -
> > -               b->purb->transfer_buffer_length = transfer_buffer_length;
> > -               b->purb->number_of_packets = packets;
> > -               b->purb->complete = dabusb_iso_complete;
> > -               b->purb->context = b;
> > -               b->purb->dev = s->usbdev;
> > -               b->purb->pipe = pipe;
> > -               b->purb->transfer_flags = URB_ISO_ASAP;
> > -
> > -               for (i = 0; i < packets; i++) {
> > -                       b->purb->iso_frame_desc[i].offset = i * pipesize;
> > -                       b->purb->iso_frame_desc[i].length = pipesize;
> > -               }
> > -
> > -               transfer_len += transfer_buffer_length;
> > -               list_add_tail (&b->buff_list, &s->free_buff_list);
> > -       }
> > -       s->got_mem = transfer_len;
> > -
> > -       return 0;
> > -
> > -       err:
> > -       dabusb_free_buffers (s);
> > -       return -ENOMEM;
> > -}
> > -/*-------------------------------------------------------------------*/
> > -static int dabusb_bulk (pdabusb_t s, pbulk_transfer_t pb)
> > -{
> > -       int ret;
> > -       unsigned int pipe;
> > -       int actual_length;
> > -
> > -       dbg("dabusb_bulk");
> > -
> > -       if (!pb->pipe)
> > -               pipe = usb_rcvbulkpipe (s->usbdev, 2);
> > -       else
> > -               pipe = usb_sndbulkpipe (s->usbdev, 2);
> > -
> > -       ret=usb_bulk_msg(s->usbdev, pipe, pb->data, pb->size, &actual_length, 100);
> > -       if(ret<0) {
> > -               dev_err(&s->usbdev->dev,
> > -                       "usb_bulk_msg failed(%d)\n", ret);
> > -
> > -               if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
> > -                       dev_err(&s->usbdev->dev, "set_interface failed\n");
> > -                       return -EINVAL;
> > -               }
> > -
> > -       }
> > -
> > -       if( ret == -EPIPE ) {
> > -               dev_warn(&s->usbdev->dev, "CLEAR_FEATURE request to remove STALL condition.\n");
> > -               if(usb_clear_halt(s->usbdev, usb_pipeendpoint(pipe)))
> > -                       dev_err(&s->usbdev->dev, "request failed\n");
> > -       }
> > -
> > -       pb->size = actual_length;
> > -       return ret;
> > -}
> > -/* --------------------------------------------------------------------- */
> > -static int dabusb_writemem (pdabusb_t s, int pos, const unsigned char *data,
> > -                           int len)
> > -{
> > -       int ret;
> > -       unsigned char *transfer_buffer =  kmalloc (len, GFP_KERNEL);
> > -
> > -       if (!transfer_buffer) {
> > -               dev_err(&s->usbdev->dev,
> > -                       "dabusb_writemem: kmalloc(%d) failed.\n", len);
> > -               return -ENOMEM;
> > -       }
> > -
> > -       memcpy (transfer_buffer, data, len);
> > -
> > -       ret=usb_control_msg(s->usbdev, usb_sndctrlpipe( s->usbdev, 0 ), 0xa0, 0x40, pos, 0, transfer_buffer, len, 300);
> > -
> > -       kfree (transfer_buffer);
> > -       return ret;
> > -}
> > -/* --------------------------------------------------------------------- */
> > -static int dabusb_8051_reset (pdabusb_t s, unsigned char reset_bit)
> > -{
> > -       dbg("dabusb_8051_reset: %d",reset_bit);
> > -       return dabusb_writemem (s, CPUCS_REG, &reset_bit, 1);
> > -}
> > -/* --------------------------------------------------------------------- */
> > -static int dabusb_loadmem (pdabusb_t s, const char *fname)
> > -{
> > -       int ret;
> > -       const struct ihex_binrec *rec;
> > -       const struct firmware *uninitialized_var(fw);
> > -
> > -       dbg("Enter dabusb_loadmem (internal)");
> > -
> > -       ret = request_ihex_firmware(&fw, "dabusb/firmware.fw", &s->usbdev->dev);
> > -       if (ret) {
> > -               dev_err(&s->usbdev->dev,
> > -                       "Failed to load \"dabusb/firmware.fw\": %d\n", ret);
> > -               goto out;
> > -       }
> > -       ret = dabusb_8051_reset (s, 1);
> > -
> > -       for (rec = (const struct ihex_binrec *)fw->data; rec;
> > -            rec = ihex_next_binrec(rec)) {
> > -               dbg("dabusb_writemem: %04X %p %d)", be32_to_cpu(rec->addr),
> > -                   rec->data, be16_to_cpu(rec->len));
> > -
> > -               ret = dabusb_writemem(s, be32_to_cpu(rec->addr), rec->data,
> > -                                      be16_to_cpu(rec->len));
> > -               if (ret < 0) {
> > -                       dev_err(&s->usbdev->dev,
> > -                               "dabusb_writemem failed (%d %04X %p %d)\n",
> > -                               ret, be32_to_cpu(rec->addr),
> > -                               rec->data, be16_to_cpu(rec->len));
> > -                       break;
> > -               }
> > -       }
> > -       ret = dabusb_8051_reset (s, 0);
> > -       release_firmware(fw);
> > - out:
> > -       dbg("dabusb_loadmem: exit");
> > -
> > -       return ret;
> > -}
> > -/* --------------------------------------------------------------------- */
> > -static int dabusb_fpga_clear (pdabusb_t s, pbulk_transfer_t b)
> > -{
> > -       b->size = 4;
> > -       b->data[0] = 0x2a;
> > -       b->data[1] = 0;
> > -       b->data[2] = 0;
> > -       b->data[3] = 0;
> > -
> > -       dbg("dabusb_fpga_clear");
> > -
> > -       return dabusb_bulk (s, b);
> > -}
> > -/* --------------------------------------------------------------------- */
> > -static int dabusb_fpga_init (pdabusb_t s, pbulk_transfer_t b)
> > -{
> > -       b->size = 4;
> > -       b->data[0] = 0x2c;
> > -       b->data[1] = 0;
> > -       b->data[2] = 0;
> > -       b->data[3] = 0;
> > -
> > -       dbg("dabusb_fpga_init");
> > -
> > -       return dabusb_bulk (s, b);
> > -}
> > -/* --------------------------------------------------------------------- */
> > -static int dabusb_fpga_download (pdabusb_t s, const char *fname)
> > -{
> > -       pbulk_transfer_t b = kmalloc (sizeof (bulk_transfer_t), GFP_KERNEL);
> > -       const struct firmware *fw;
> > -       unsigned int blen, n;
> > -       int ret;
> > -
> > -       dbg("Enter dabusb_fpga_download (internal)");
> > -
> > -       if (!b) {
> > -               dev_err(&s->usbdev->dev,
> > -                       "kmalloc(sizeof(bulk_transfer_t))==NULL\n");
> > -               return -ENOMEM;
> > -       }
> > -
> > -       ret = request_firmware(&fw, "dabusb/bitstream.bin", &s->usbdev->dev);
> > -       if (ret) {
> > -               dev_err(&s->usbdev->dev,
> > -                       "Failed to load \"dabusb/bitstream.bin\": %d\n", ret);
> > -               kfree(b);
> > -               return ret;
> > -       }
> > -
> > -       b->pipe = 1;
> > -       ret = dabusb_fpga_clear (s, b);
> > -       mdelay (10);
> > -       blen = fw->data[73] + (fw->data[72] << 8);
> > -
> > -       dbg("Bitstream len: %i", blen);
> > -
> > -       b->data[0] = 0x2b;
> > -       b->data[1] = 0;
> > -       b->data[2] = 0;
> > -       b->data[3] = 60;
> > -
> > -       for (n = 0; n <= blen + 60; n += 60) {
> > -               // some cclks for startup
> > -               b->size = 64;
> > -               memcpy (b->data + 4, fw->data + 74 + n, 60);
> > -               ret = dabusb_bulk (s, b);
> > -               if (ret < 0) {
> > -                       dev_err(&s->usbdev->dev, "dabusb_bulk failed.\n");
> > -                       break;
> > -               }
> > -               mdelay (1);
> > -       }
> > -
> > -       ret = dabusb_fpga_init (s, b);
> > -       kfree (b);
> > -       release_firmware(fw);
> > -
> > -       dbg("exit dabusb_fpga_download");
> > -
> > -       return ret;
> > -}
> > -
> > -static int dabusb_stop (pdabusb_t s)
> > -{
> > -       dbg("dabusb_stop");
> > -
> > -       s->state = _stopped;
> > -       dabusb_cancel_queue (s, &s->rec_buff_list);
> > -
> > -       dbg("pending_io: %d", s->pending_io.counter);
> > -
> > -       s->pending_io.counter = 0;
> > -       return 0;
> > -}
> > -
> > -static int dabusb_startrek (pdabusb_t s)
> > -{
> > -       if (!s->got_mem && s->state != _started) {
> > -
> > -               dbg("dabusb_startrek");
> > -
> > -               if (dabusb_alloc_buffers (s) < 0)
> > -                       return -ENOMEM;
> > -               dabusb_stop (s);
> > -               s->state = _started;
> > -               s->readptr = 0;
> > -       }
> > -
> > -       if (!list_empty (&s->free_buff_list)) {
> > -               pbuff_t end;
> > -               int ret;
> > -
> > -       while (!dabusb_add_buf_tail (s, &s->rec_buff_list, &s->free_buff_list)) {
> > -
> > -                       dbg("submitting: end:%p s->rec_buff_list:%p", s->rec_buff_list.prev, &s->rec_buff_list);
> > -
> > -                       end = list_entry (s->rec_buff_list.prev, buff_t, buff_list);
> > -
> > -                       ret = usb_submit_urb (end->purb, GFP_KERNEL);
> > -                       if (ret) {
> > -                               dev_err(&s->usbdev->dev,
> > -                                       "usb_submit_urb returned:%d\n", ret);
> > -                               if (dabusb_add_buf_tail (s, &s->free_buff_list, &s->rec_buff_list))
> > -                                       dev_err(&s->usbdev->dev,
> > -                                               "startrek: dabusb_add_buf_tail failed\n");
> > -                               break;
> > -                       }
> > -                       else
> > -                               atomic_inc (&s->pending_io);
> > -               }
> > -               dbg("pending_io: %d",s->pending_io.counter);
> > -       }
> > -
> > -       return 0;
> > -}
> > -
> > -static ssize_t dabusb_read (struct file *file, char __user *buf, size_t count, loff_t * ppos)
> > -{
> > -       pdabusb_t s = (pdabusb_t) file->private_data;
> > -       unsigned long flags;
> > -       unsigned ret = 0;
> > -       int rem;
> > -       int cnt;
> > -       pbuff_t b;
> > -       struct urb *purb = NULL;
> > -
> > -       dbg("dabusb_read");
> > -
> > -       if (*ppos)
> > -               return -ESPIPE;
> > -
> > -       if (s->remove_pending)
> > -               return -EIO;
> > -
> > -
> > -       if (!s->usbdev)
> > -               return -EIO;
> > -
> > -       while (count > 0) {
> > -               dabusb_startrek (s);
> > -
> > -               spin_lock_irqsave (&s->lock, flags);
> > -
> > -               if (list_empty (&s->rec_buff_list)) {
> > -
> > -                       spin_unlock_irqrestore(&s->lock, flags);
> > -
> > -                       dev_err(&s->usbdev->dev,
> > -                               "error: rec_buf_list is empty\n");
> > -                       goto err;
> > -               }
> > -
> > -               b = list_entry (s->rec_buff_list.next, buff_t, buff_list);
> > -               purb = b->purb;
> > -
> > -               spin_unlock_irqrestore(&s->lock, flags);
> > -
> > -               if (purb->status == -EINPROGRESS) {
> > -                       if (file->f_flags & O_NONBLOCK)         // return nonblocking
> > -                        {
> > -                               if (!ret)
> > -                                       ret = -EAGAIN;
> > -                               goto err;
> > -                       }
> > -
> > -                       interruptible_sleep_on (&s->wait);
> > -
> > -                       if (signal_pending (current)) {
> > -                               if (!ret)
> > -                                       ret = -ERESTARTSYS;
> > -                               goto err;
> > -                       }
> > -
> > -                       spin_lock_irqsave (&s->lock, flags);
> > -
> > -                       if (list_empty (&s->rec_buff_list)) {
> > -                               spin_unlock_irqrestore(&s->lock, flags);
> > -                               dev_err(&s->usbdev->dev,
> > -                                       "error: still no buffer available.\n");
> > -                               goto err;
> > -                       }
> > -                       spin_unlock_irqrestore(&s->lock, flags);
> > -                       s->readptr = 0;
> > -               }
> > -               if (s->remove_pending) {
> > -                       ret = -EIO;
> > -                       goto err;
> > -               }
> > -
> > -               rem = purb->actual_length - s->readptr;         // set remaining bytes to copy
> > -
> > -               if (count >= rem)
> > -                       cnt = rem;
> > -               else
> > -                       cnt = count;
> > -
> > -               dbg("copy_to_user:%p %p %d",buf, purb->transfer_buffer + s->readptr, cnt);
> > -
> > -               if (copy_to_user (buf, purb->transfer_buffer + s->readptr, cnt)) {
> > -                       dev_err(&s->usbdev->dev, "read: copy_to_user failed\n");
> > -                       if (!ret)
> > -                               ret = -EFAULT;
> > -                       goto err;
> > -               }
> > -
> > -               s->readptr += cnt;
> > -               count -= cnt;
> > -               buf += cnt;
> > -               ret += cnt;
> > -
> > -               if (s->readptr == purb->actual_length) {
> > -                       // finished, take next buffer
> > -                       if (dabusb_add_buf_tail (s, &s->free_buff_list, &s->rec_buff_list))
> > -                               dev_err(&s->usbdev->dev,
> > -                                       "read: dabusb_add_buf_tail failed\n");
> > -                       s->readptr = 0;
> > -               }
> > -       }
> > -      err:                     //mutex_unlock(&s->mutex);
> > -       return ret;
> > -}
> > -
> > -static int dabusb_open (struct inode *inode, struct file *file)
> > -{
> > -       int devnum = iminor(inode);
> > -       pdabusb_t s;
> > -       int r;
> > -
> > -       if (devnum < DABUSB_MINOR || devnum >= (DABUSB_MINOR + NRDABUSB))
> > -               return -EIO;
> > -
> > -       s = &dabusb[devnum - DABUSB_MINOR];
> > -
> > -       dbg("dabusb_open");
> > -       mutex_lock(&s->mutex);
> > -
> > -       while (!s->usbdev || s->opened) {
> > -               mutex_unlock(&s->mutex);
> > -
> > -               if (file->f_flags & O_NONBLOCK)
> > -                       return -EBUSY;
> > -               msleep_interruptible(500);
> > -
> > -               if (signal_pending (current))
> > -                       return -EAGAIN;
> > -               mutex_lock(&s->mutex);
> > -       }
> > -       if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
> > -               mutex_unlock(&s->mutex);
> > -               dev_err(&s->usbdev->dev, "set_interface failed\n");
> > -               return -EINVAL;
> > -       }
> > -       s->opened = 1;
> > -       mutex_unlock(&s->mutex);
> > -
> > -       file->f_pos = 0;
> > -       file->private_data = s;
> > -
> > -       r = nonseekable_open(inode, file);
> > -       return r;
> > -}
> > -
> > -static int dabusb_release (struct inode *inode, struct file *file)
> > -{
> > -       pdabusb_t s = (pdabusb_t) file->private_data;
> > -
> > -       dbg("dabusb_release");
> > -
> > -       mutex_lock(&s->mutex);
> > -       dabusb_stop (s);
> > -       dabusb_free_buffers (s);
> > -       mutex_unlock(&s->mutex);
> > -
> > -       if (!s->remove_pending) {
> > -               if (usb_set_interface (s->usbdev, _DABUSB_IF, 0) < 0)
> > -                       dev_err(&s->usbdev->dev, "set_interface failed\n");
> > -       }
> > -       else
> > -               wake_up (&s->remove_ok);
> > -
> > -       s->opened = 0;
> > -       return 0;
> > -}
> > -
> > -static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
> > -{
> > -       pdabusb_t s = (pdabusb_t) file->private_data;
> > -       pbulk_transfer_t pbulk;
> > -       int ret = 0;
> > -       int version = DABUSB_VERSION;
> > -
> > -       dbg("dabusb_ioctl");
> > -
> > -       if (s->remove_pending)
> > -               return -EIO;
> > -
> > -       mutex_lock(&s->mutex);
> > -
> > -       if (!s->usbdev) {
> > -               mutex_unlock(&s->mutex);
> > -               return -EIO;
> > -       }
> > -
> > -       switch (cmd) {
> > -
> > -       case IOCTL_DAB_BULK:
> > -               pbulk = memdup_user((void __user *)arg,
> > -                                   sizeof(bulk_transfer_t));
> > -
> > -               if (IS_ERR(pbulk)) {
> > -                       ret = PTR_ERR(pbulk);
> > -                       break;
> > -               }
> > -
> > -               ret=dabusb_bulk (s, pbulk);
> > -               if(ret==0)
> > -                       if (copy_to_user((void __user *)arg, pbulk,
> > -                                        sizeof(bulk_transfer_t)))
> > -                               ret = -EFAULT;
> > -               kfree (pbulk);
> > -               break;
> > -
> > -       case IOCTL_DAB_OVERRUNS:
> > -               ret = put_user (s->overruns, (unsigned int __user *) arg);
> > -               break;
> > -
> > -       case IOCTL_DAB_VERSION:
> > -               ret = put_user (version, (unsigned int __user *) arg);
> > -               break;
> > -
> > -       default:
> > -               ret = -ENOIOCTLCMD;
> > -               break;
> > -       }
> > -       mutex_unlock(&s->mutex);
> > -       return ret;
> > -}
> > -
> > -static const struct file_operations dabusb_fops =
> > -{
> > -       .owner =        THIS_MODULE,
> > -       .llseek =       no_llseek,
> > -       .read =         dabusb_read,
> > -       .unlocked_ioctl =       dabusb_ioctl,
> > -       .open =         dabusb_open,
> > -       .release =      dabusb_release,
> > -};
> > -
> > -static char *dabusb_devnode(struct device *dev, mode_t *mode)
> > -{
> > -       return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
> > -}
> > -
> > -static struct usb_class_driver dabusb_class = {
> > -       .name =         "dabusb%d",
> > -       .devnode =      dabusb_devnode,
> > -       .fops =         &dabusb_fops,
> > -       .minor_base =   DABUSB_MINOR,
> > -};
> > -
> > -
> > -/* --------------------------------------------------------------------- */
> > -static int dabusb_probe (struct usb_interface *intf,
> > -                        const struct usb_device_id *id)
> > -{
> > -       struct usb_device *usbdev = interface_to_usbdev(intf);
> > -       int retval;
> > -       pdabusb_t s;
> > -
> > -       dbg("dabusb: probe: vendor id 0x%x, device id 0x%x ifnum:%d",
> > -           le16_to_cpu(usbdev->descriptor.idVendor),
> > -           le16_to_cpu(usbdev->descriptor.idProduct),
> > -           intf->altsetting->desc.bInterfaceNumber);
> > -
> > -       /* We don't handle multiple configurations */
> > -       if (usbdev->descriptor.bNumConfigurations != 1)
> > -               return -ENODEV;
> > -
> > -       if (intf->altsetting->desc.bInterfaceNumber != _DABUSB_IF &&
> > -           le16_to_cpu(usbdev->descriptor.idProduct) == 0x9999)
> > -               return -ENODEV;
> > -
> > -
> > -
> > -       s = &dabusb[intf->minor];
> > -
> > -       mutex_lock(&s->mutex);
> > -       s->remove_pending = 0;
> > -       s->usbdev = usbdev;
> > -       s->devnum = intf->minor;
> > -
> > -       if (usb_reset_configuration (usbdev) < 0) {
> > -               dev_err(&intf->dev, "reset_configuration failed\n");
> > -               goto reject;
> > -       }
> > -       if (le16_to_cpu(usbdev->descriptor.idProduct) == 0x2131) {
> > -               dabusb_loadmem (s, NULL);
> > -               goto reject;
> > -       }
> > -       else {
> > -               dabusb_fpga_download (s, NULL);
> > -
> > -               if (usb_set_interface (s->usbdev, _DABUSB_IF, 0) < 0) {
> > -                       dev_err(&intf->dev, "set_interface failed\n");
> > -                       goto reject;
> > -               }
> > -       }
> > -       dbg("bound to interface: %d", intf->altsetting->desc.bInterfaceNumber);
> > -       usb_set_intfdata (intf, s);
> > -       mutex_unlock(&s->mutex);
> > -
> > -       retval = usb_register_dev(intf, &dabusb_class);
> > -       if (retval) {
> > -               usb_set_intfdata (intf, NULL);
> > -               return -ENOMEM;
> > -       }
> > -
> > -       return 0;
> > -
> > -      reject:
> > -       mutex_unlock(&s->mutex);
> > -       s->usbdev = NULL;
> > -       return -ENODEV;
> > -}
> > -
> > -static void dabusb_disconnect (struct usb_interface *intf)
> > -{
> > -       wait_queue_t __wait;
> > -       pdabusb_t s = usb_get_intfdata (intf);
> > -
> > -       dbg("dabusb_disconnect");
> > -
> > -       init_waitqueue_entry(&__wait, current);
> > -
> > -       usb_set_intfdata (intf, NULL);
> > -       if (s) {
> > -               usb_deregister_dev (intf, &dabusb_class);
> > -               s->remove_pending = 1;
> > -               wake_up (&s->wait);
> > -               add_wait_queue(&s->remove_ok, &__wait);
> > -               set_current_state(TASK_UNINTERRUPTIBLE);
> > -               if (s->state == _started)
> > -                       schedule();
> > -               current->state = TASK_RUNNING;
> > -               remove_wait_queue(&s->remove_ok, &__wait);
> > -
> > -               s->usbdev = NULL;
> > -               s->overruns = 0;
> > -       }
> > -}
> > -
> > -static struct usb_device_id dabusb_ids [] = {
> > -       // { USB_DEVICE(0x0547, 0x2131) },      /* An2131 chip, no boot ROM */
> > -       { USB_DEVICE(0x0547, 0x9999) },
> > -       { }                                             /* Terminating entry */
> > -};
> > -
> > -MODULE_DEVICE_TABLE (usb, dabusb_ids);
> > -
> > -static struct usb_driver dabusb_driver = {
> > -       .name =         "dabusb",
> > -       .probe =        dabusb_probe,
> > -       .disconnect =   dabusb_disconnect,
> > -       .id_table =     dabusb_ids,
> > -};
> > -
> > -/* --------------------------------------------------------------------- */
> > -
> > -static int __init dabusb_init (void)
> > -{
> > -       int retval;
> > -       unsigned u;
> > -
> > -       /* initialize struct */
> > -       for (u = 0; u < NRDABUSB; u++) {
> > -               pdabusb_t s = &dabusb[u];
> > -               memset (s, 0, sizeof (dabusb_t));
> > -               mutex_init (&s->mutex);
> > -               s->usbdev = NULL;
> > -               s->total_buffer_size = buffers;
> > -               init_waitqueue_head (&s->wait);
> > -               init_waitqueue_head (&s->remove_ok);
> > -               spin_lock_init (&s->lock);
> > -               INIT_LIST_HEAD (&s->free_buff_list);
> > -               INIT_LIST_HEAD (&s->rec_buff_list);
> > -       }
> > -
> > -       /* register misc device */
> > -       retval = usb_register(&dabusb_driver);
> > -       if (retval)
> > -               goto out;
> > -
> > -       dbg("dabusb_init: driver registered");
> > -
> > -       printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
> > -              DRIVER_DESC "\n");
> > -
> > -out:
> > -       return retval;
> > -}
> > -
> > -static void __exit dabusb_cleanup (void)
> > -{
> > -       dbg("dabusb_cleanup");
> > -
> > -       usb_deregister (&dabusb_driver);
> > -}
> > -
> > -/* --------------------------------------------------------------------- */
> > -
> > -MODULE_AUTHOR( DRIVER_AUTHOR );
> > -MODULE_DESCRIPTION( DRIVER_DESC );
> > -MODULE_LICENSE("GPL");
> > -MODULE_FIRMWARE("dabusb/firmware.fw");
> > -MODULE_FIRMWARE("dabusb/bitstream.bin");
> > -
> > -module_param(buffers, int, 0);
> > -MODULE_PARM_DESC (buffers, "Number of buffers (default=256)");
> > -
> > -module_init (dabusb_init);
> > -module_exit (dabusb_cleanup);
> > -
> > -/* --------------------------------------------------------------------- */
> > diff --git a/drivers/media/video/dabusb.h b/drivers/media/video/dabusb.h
> > deleted file mode 100644
> > index 00eb34c..0000000
> > --- a/drivers/media/video/dabusb.h
> > +++ /dev/null
> > @@ -1,85 +0,0 @@
> > -#define _BULK_DATA_LEN 64
> > -typedef struct
> > -{
> > -       unsigned char data[_BULK_DATA_LEN];
> > -       unsigned int size;
> > -       unsigned int pipe;
> > -}bulk_transfer_t,*pbulk_transfer_t;
> > -
> > -#define DABUSB_MINOR 240               /* some unassigned USB minor */
> > -#define DABUSB_VERSION 0x1000
> > -#define IOCTL_DAB_BULK              _IOWR('d', 0x30, bulk_transfer_t)
> > -#define IOCTL_DAB_OVERRUNS         _IOR('d',  0x15, int)
> > -#define IOCTL_DAB_VERSION           _IOR('d', 0x3f, int)
> > -
> > -#ifdef __KERNEL__
> > -
> > -typedef enum { _stopped=0, _started } driver_state_t;
> > -
> > -typedef struct
> > -{
> > -       struct mutex mutex;
> > -       struct usb_device *usbdev;
> > -       wait_queue_head_t wait;
> > -       wait_queue_head_t remove_ok;
> > -       spinlock_t lock;
> > -       atomic_t pending_io;
> > -       driver_state_t state;
> > -       int remove_pending;
> > -       int got_mem;
> > -       int total_buffer_size;
> > -       unsigned int overruns;
> > -       int readptr;
> > -       int opened;
> > -       int devnum;
> > -       struct list_head free_buff_list;
> > -       struct list_head rec_buff_list;
> > -} dabusb_t,*pdabusb_t;
> > -
> > -typedef struct
> > -{
> > -       pdabusb_t s;
> > -       struct urb *purb;
> > -       struct list_head buff_list;
> > -} buff_t,*pbuff_t;
> > -
> > -typedef struct
> > -{
> > -       wait_queue_head_t wait;
> > -} bulk_completion_context_t, *pbulk_completion_context_t;
> > -
> > -
> > -#define _DABUSB_IF 2
> > -#define _DABUSB_ISOPIPE 0x09
> > -#define _ISOPIPESIZE   16384
> > -
> > -#define _BULK_DATA_LEN 64
> > -// Vendor specific request code for Anchor Upload/Download
> > -// This one is implemented in the core
> > -#define ANCHOR_LOAD_INTERNAL  0xA0
> > -
> > -// EZ-USB Control and Status Register.  Bit 0 controls 8051 reset
> > -#define CPUCS_REG    0x7F92
> > -#define _TOTAL_BUFFERS 384
> > -
> > -#define MAX_INTEL_HEX_RECORD_LENGTH 16
> > -
> > -#ifndef _BYTE_DEFINED
> > -#define _BYTE_DEFINED
> > -typedef unsigned char BYTE;
> > -#endif // !_BYTE_DEFINED
> > -
> > -#ifndef _WORD_DEFINED
> > -#define _WORD_DEFINED
> > -typedef unsigned short WORD;
> > -#endif // !_WORD_DEFINED
> > -
> > -typedef struct _INTEL_HEX_RECORD
> > -{
> > -   BYTE  Length;
> > -   WORD  Address;
> > -   BYTE  Type;
> > -   BYTE  Data[MAX_INTEL_HEX_RECORD_LENGTH];
> > -} INTEL_HEX_RECORD, *PINTEL_HEX_RECORD;
> > -
> > -#endif
> > diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> > index 7e7b27b..648142e 100644
> > --- a/drivers/staging/Kconfig
> > +++ b/drivers/staging/Kconfig
> > @@ -51,6 +51,8 @@ source "drivers/staging/cx25821/Kconfig"
> >
> >  source "drivers/staging/tm6000/Kconfig"
> >
> > +source "drivers/staging/dabusb/Kconfig"
> > +
> >  source "drivers/staging/se401/Kconfig"
> >
> >  source "drivers/staging/usbvideo/Kconfig"
> > diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> > index 72e0c83..8185c00 100644
> > --- a/drivers/staging/Makefile
> > +++ b/drivers/staging/Makefile
> > @@ -8,6 +8,7 @@ obj-$(CONFIG_SLICOSS)           += slicoss/
> >  obj-$(CONFIG_VIDEO_GO7007)     += go7007/
> >  obj-$(CONFIG_VIDEO_CX25821)    += cx25821/
> >  obj-$(CONFIG_VIDEO_TM6000)     += tm6000/
> > +obj-$(CONFIG_USB_DABUSB)        += dabusb/
> >  obj-$(CONFIG_USB_VICAM)         += usbvideo/
> >  obj-$(CONFIG_USB_SE401)         += se401/
> >  obj-$(CONFIG_LIRC_STAGING)     += lirc/
> > diff --git a/drivers/staging/dabusb/Kconfig b/drivers/staging/dabusb/Kconfig
> > new file mode 100644
> > index 0000000..87bdc42
> > --- /dev/null
> > +++ b/drivers/staging/dabusb/Kconfig
> > @@ -0,0 +1,14 @@
> > +config USB_DABUSB
> > +       tristate "DABUSB driver"
> > +       depends on USB
> > +       ---help---
> > +         A Digital Audio Broadcasting (DAB) Receiver for USB and Linux
> > +         brought to you by the DAB-Team
> > +         <http://wwwbode.cs.tum.edu/Par/arch/dab/>.  This driver can be taken
> > +         as an example for URB-based bulk, control, and isochronous
> > +         transactions. URB's are explained in
> > +         <Documentation/usb/URB.txt>.
> > +
> > +         To compile this driver as a module, choose M here: the
> > +         module will be called dabusb.
> > +
> > diff --git a/drivers/staging/dabusb/Makefile b/drivers/staging/dabusb/Makefile
> > new file mode 100644
> > index 0000000..2ff2f22
> > --- /dev/null
> > +++ b/drivers/staging/dabusb/Makefile
> > @@ -0,0 +1,2 @@
> > +obj-$(CONFIG_USB_DABUSB)        += dabusb.o
> > +
> > diff --git a/drivers/staging/dabusb/TODO b/drivers/staging/dabusb/TODO
> > new file mode 100644
> > index 0000000..f9c0314
> > --- /dev/null
> > +++ b/drivers/staging/dabusb/TODO
> > @@ -0,0 +1,5 @@
> > +This is a driver for an experimental sample developed in 2003. The driver
> > +never supported any commercial product, nor had any known user.
> > +If nobody takes care on it, the driver will be removed for 2.6.39.
> > +
> > +Please send patches to linux-media@vger.kernel.org
> > diff --git a/drivers/staging/dabusb/dabusb.c b/drivers/staging/dabusb/dabusb.c
> > new file mode 100644
> > index 0000000..f3e25e9
> > --- /dev/null
> > +++ b/drivers/staging/dabusb/dabusb.c
> > @@ -0,0 +1,914 @@
> > +/*****************************************************************************/
> > +
> > +/*
> > + *      dabusb.c  --  dab usb driver.
> > + *
> > + *      Copyright (C) 1999  Deti Fliegl (deti@fliegl.de)
> > + *
> > + *      This program is free software; you can redistribute it and/or modify
> > + *      it under the terms of the GNU General Public License as published by
> > + *      the Free Software Foundation; either version 2 of the License, or
> > + *      (at your option) any later version.
> > + *
> > + *      This program is distributed in the hope that it will be useful,
> > + *      but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *      GNU General Public License for more details.
> > + *
> > + *      You should have received a copy of the GNU General Public License
> > + *      along with this program; if not, write to the Free Software
> > + *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + *
> > + *
> > + *  $Id: dabusb.c,v 1.54 2000/07/24 21:39:39 deti Exp $
> > + *
> > + */
> > +
> > +/*****************************************************************************/
> > +
> > +#include <linux/module.h>
> > +#include <linux/socket.h>
> > +#include <linux/list.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/slab.h>
> > +#include <linux/init.h>
> > +#include <asm/uaccess.h>
> > +#include <asm/atomic.h>
> > +#include <linux/delay.h>
> > +#include <linux/usb.h>
> > +#include <linux/mutex.h>
> > +#include <linux/firmware.h>
> > +#include <linux/ihex.h>
> > +
> > +#include "dabusb.h"
> > +
> > +/*
> > + * Version Information
> > + */
> > +#define DRIVER_VERSION "v1.54"
> > +#define DRIVER_AUTHOR "Deti Fliegl, deti@fliegl.de"
> > +#define DRIVER_DESC "DAB-USB Interface Driver for Linux (c)1999"
> > +
> > +/* --------------------------------------------------------------------- */
> > +
> > +#ifdef CONFIG_USB_DYNAMIC_MINORS
> > +#define NRDABUSB 256
> > +#else
> > +#define NRDABUSB 4
> > +#endif
> > +
> > +/*-------------------------------------------------------------------*/
> > +
> > +static dabusb_t dabusb[NRDABUSB];
> > +static int buffers = 256;
> > +static struct usb_driver dabusb_driver;
> > +
> > +/*-------------------------------------------------------------------*/
> > +
> > +static int dabusb_add_buf_tail (pdabusb_t s, struct list_head *dst, struct list_head *src)
> > +{
> > +       unsigned long flags;
> > +       struct list_head *tmp;
> > +       int ret = 0;
> > +
> > +       spin_lock_irqsave (&s->lock, flags);
> > +
> > +       if (list_empty (src)) {
> > +               // no elements in source buffer
> > +               ret = -1;
> > +               goto err;
> > +       }
> > +       tmp = src->next;
> > +       list_move_tail (tmp, dst);
> > +
> > +  err: spin_unlock_irqrestore (&s->lock, flags);
> > +       return ret;
> > +}
> > +/*-------------------------------------------------------------------*/
> > +#ifdef DEBUG
> > +static void dump_urb (struct urb *urb)
> > +{
> > +       dbg("urb                   :%p", urb);
> > +       dbg("dev                   :%p", urb->dev);
> > +       dbg("pipe                  :%08X", urb->pipe);
> > +       dbg("status                :%d", urb->status);
> > +       dbg("transfer_flags        :%08X", urb->transfer_flags);
> > +       dbg("transfer_buffer       :%p", urb->transfer_buffer);
> > +       dbg("transfer_buffer_length:%d", urb->transfer_buffer_length);
> > +       dbg("actual_length         :%d", urb->actual_length);
> > +       dbg("setup_packet          :%p", urb->setup_packet);
> > +       dbg("start_frame           :%d", urb->start_frame);
> > +       dbg("number_of_packets     :%d", urb->number_of_packets);
> > +       dbg("interval              :%d", urb->interval);
> > +       dbg("error_count           :%d", urb->error_count);
> > +       dbg("context               :%p", urb->context);
> > +       dbg("complete              :%p", urb->complete);
> > +}
> > +#endif
> > +/*-------------------------------------------------------------------*/
> > +static int dabusb_cancel_queue (pdabusb_t s, struct list_head *q)
> > +{
> > +       unsigned long flags;
> > +       pbuff_t b;
> > +
> > +       dbg("dabusb_cancel_queue");
> > +
> > +       spin_lock_irqsave (&s->lock, flags);
> > +
> > +       list_for_each_entry(b, q, buff_list) {
> > +#ifdef DEBUG
> > +               dump_urb(b->purb);
> > +#endif
> > +               usb_unlink_urb (b->purb);
> > +       }
> > +       spin_unlock_irqrestore (&s->lock, flags);
> > +       return 0;
> > +}
> > +/*-------------------------------------------------------------------*/
> > +static int dabusb_free_queue (struct list_head *q)
> > +{
> > +       struct list_head *tmp;
> > +       struct list_head *p;
> > +       pbuff_t b;
> > +
> > +       dbg("dabusb_free_queue");
> > +       for (p = q->next; p != q;) {
> > +               b = list_entry (p, buff_t, buff_list);
> > +
> > +#ifdef DEBUG
> > +               dump_urb(b->purb);
> > +#endif
> > +               kfree(b->purb->transfer_buffer);
> > +               usb_free_urb(b->purb);
> > +               tmp = p->next;
> > +               list_del (p);
> > +               kfree (b);
> > +               p = tmp;
> > +       }
> > +
> > +       return 0;
> > +}
> > +/*-------------------------------------------------------------------*/
> > +static int dabusb_free_buffers (pdabusb_t s)
> > +{
> > +       unsigned long flags;
> > +       dbg("dabusb_free_buffers");
> > +
> > +       spin_lock_irqsave(&s->lock, flags);
> > +
> > +       dabusb_free_queue (&s->free_buff_list);
> > +       dabusb_free_queue (&s->rec_buff_list);
> > +
> > +       spin_unlock_irqrestore(&s->lock, flags);
> > +
> > +       s->got_mem = 0;
> > +       return 0;
> > +}
> > +/*-------------------------------------------------------------------*/
> > +static void dabusb_iso_complete (struct urb *purb)
> > +{
> > +       pbuff_t b = purb->context;
> > +       pdabusb_t s = b->s;
> > +       int i;
> > +       int len;
> > +       int dst = 0;
> > +       void *buf = purb->transfer_buffer;
> > +
> > +       dbg("dabusb_iso_complete");
> > +
> > +       // process if URB was not killed
> > +       if (purb->status != -ENOENT) {
> > +               unsigned int pipe = usb_rcvisocpipe (purb->dev, _DABUSB_ISOPIPE);
> > +               int pipesize = usb_maxpacket (purb->dev, pipe, usb_pipeout (pipe));
> > +               for (i = 0; i < purb->number_of_packets; i++)
> > +                       if (!purb->iso_frame_desc[i].status) {
> > +                               len = purb->iso_frame_desc[i].actual_length;
> > +                               if (len <= pipesize) {
> > +                                       memcpy (buf + dst, buf + purb->iso_frame_desc[i].offset, len);
> > +                                       dst += len;
> > +                               }
> > +                               else
> > +                                       dev_err(&purb->dev->dev,
> > +                                               "dabusb_iso_complete: invalid len %d\n", len);
> > +                       }
> > +                       else
> > +                               dev_warn(&purb->dev->dev, "dabusb_iso_complete: corrupted packet status: %d\n", purb->iso_frame_desc[i].status);
> > +               if (dst != purb->actual_length)
> > +                       dev_err(&purb->dev->dev,
> > +                               "dst!=purb->actual_length:%d!=%d\n",
> > +                                       dst, purb->actual_length);
> > +       }
> > +
> > +       if (atomic_dec_and_test (&s->pending_io) && !s->remove_pending && s->state != _stopped) {
> > +               s->overruns++;
> > +               dev_err(&purb->dev->dev, "overrun (%d)\n", s->overruns);
> > +       }
> > +       wake_up (&s->wait);
> > +}
> > +/*-------------------------------------------------------------------*/
> > +static int dabusb_alloc_buffers (pdabusb_t s)
> > +{
> > +       int transfer_len = 0;
> > +       pbuff_t b;
> > +       unsigned int pipe = usb_rcvisocpipe (s->usbdev, _DABUSB_ISOPIPE);
> > +       int pipesize = usb_maxpacket (s->usbdev, pipe, usb_pipeout (pipe));
> > +       int packets = _ISOPIPESIZE / pipesize;
> > +       int transfer_buffer_length = packets * pipesize;
> > +       int i;
> > +
> > +       dbg("dabusb_alloc_buffers pipesize:%d packets:%d transfer_buffer_len:%d",
> > +                pipesize, packets, transfer_buffer_length);
> > +
> > +       while (transfer_len < (s->total_buffer_size << 10)) {
> > +               b = kzalloc(sizeof (buff_t), GFP_KERNEL);
> > +               if (!b) {
> > +                       dev_err(&s->usbdev->dev,
> > +                               "kzalloc(sizeof(buff_t))==NULL\n");
> > +                       goto err;
> > +               }
> > +               b->s = s;
> > +               b->purb = usb_alloc_urb(packets, GFP_KERNEL);
> > +               if (!b->purb) {
> > +                       dev_err(&s->usbdev->dev, "usb_alloc_urb == NULL\n");
> > +                       kfree (b);
> > +                       goto err;
> > +               }
> > +
> > +               b->purb->transfer_buffer = kmalloc (transfer_buffer_length, GFP_KERNEL);
> > +               if (!b->purb->transfer_buffer) {
> > +                       kfree (b->purb);
> > +                       kfree (b);
> > +                       dev_err(&s->usbdev->dev,
> > +                               "kmalloc(%d)==NULL\n", transfer_buffer_length);
> > +                       goto err;
> > +               }
> > +
> > +               b->purb->transfer_buffer_length = transfer_buffer_length;
> > +               b->purb->number_of_packets = packets;
> > +               b->purb->complete = dabusb_iso_complete;
> > +               b->purb->context = b;
> > +               b->purb->dev = s->usbdev;
> > +               b->purb->pipe = pipe;
> > +               b->purb->transfer_flags = URB_ISO_ASAP;
> > +
> > +               for (i = 0; i < packets; i++) {
> > +                       b->purb->iso_frame_desc[i].offset = i * pipesize;
> > +                       b->purb->iso_frame_desc[i].length = pipesize;
> > +               }
> > +
> > +               transfer_len += transfer_buffer_length;
> > +               list_add_tail (&b->buff_list, &s->free_buff_list);
> > +       }
> > +       s->got_mem = transfer_len;
> > +
> > +       return 0;
> > +
> > +       err:
> > +       dabusb_free_buffers (s);
> > +       return -ENOMEM;
> > +}
> > +/*-------------------------------------------------------------------*/
> > +static int dabusb_bulk (pdabusb_t s, pbulk_transfer_t pb)
> > +{
> > +       int ret;
> > +       unsigned int pipe;
> > +       int actual_length;
> > +
> > +       dbg("dabusb_bulk");
> > +
> > +       if (!pb->pipe)
> > +               pipe = usb_rcvbulkpipe (s->usbdev, 2);
> > +       else
> > +               pipe = usb_sndbulkpipe (s->usbdev, 2);
> > +
> > +       ret=usb_bulk_msg(s->usbdev, pipe, pb->data, pb->size, &actual_length, 100);
> > +       if(ret<0) {
> > +               dev_err(&s->usbdev->dev,
> > +                       "usb_bulk_msg failed(%d)\n", ret);
> > +
> > +               if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
> > +                       dev_err(&s->usbdev->dev, "set_interface failed\n");
> > +                       return -EINVAL;
> > +               }
> > +
> > +       }
> > +
> > +       if( ret == -EPIPE ) {
> > +               dev_warn(&s->usbdev->dev, "CLEAR_FEATURE request to remove STALL condition.\n");
> > +               if(usb_clear_halt(s->usbdev, usb_pipeendpoint(pipe)))
> > +                       dev_err(&s->usbdev->dev, "request failed\n");
> > +       }
> > +
> > +       pb->size = actual_length;
> > +       return ret;
> > +}
> > +/* --------------------------------------------------------------------- */
> > +static int dabusb_writemem (pdabusb_t s, int pos, const unsigned char *data,
> > +                           int len)
> > +{
> > +       int ret;
> > +       unsigned char *transfer_buffer =  kmalloc (len, GFP_KERNEL);
> > +
> > +       if (!transfer_buffer) {
> > +               dev_err(&s->usbdev->dev,
> > +                       "dabusb_writemem: kmalloc(%d) failed.\n", len);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       memcpy (transfer_buffer, data, len);
> > +
> > +       ret=usb_control_msg(s->usbdev, usb_sndctrlpipe( s->usbdev, 0 ), 0xa0, 0x40, pos, 0, transfer_buffer, len, 300);
> > +
> > +       kfree (transfer_buffer);
> > +       return ret;
> > +}
> > +/* --------------------------------------------------------------------- */
> > +static int dabusb_8051_reset (pdabusb_t s, unsigned char reset_bit)
> > +{
> > +       dbg("dabusb_8051_reset: %d",reset_bit);
> > +       return dabusb_writemem (s, CPUCS_REG, &reset_bit, 1);
> > +}
> > +/* --------------------------------------------------------------------- */
> > +static int dabusb_loadmem (pdabusb_t s, const char *fname)
> > +{
> > +       int ret;
> > +       const struct ihex_binrec *rec;
> > +       const struct firmware *uninitialized_var(fw);
> > +
> > +       dbg("Enter dabusb_loadmem (internal)");
> > +
> > +       ret = request_ihex_firmware(&fw, "dabusb/firmware.fw", &s->usbdev->dev);
> > +       if (ret) {
> > +               dev_err(&s->usbdev->dev,
> > +                       "Failed to load \"dabusb/firmware.fw\": %d\n", ret);
> > +               goto out;
> > +       }
> > +       ret = dabusb_8051_reset (s, 1);
> > +
> > +       for (rec = (const struct ihex_binrec *)fw->data; rec;
> > +            rec = ihex_next_binrec(rec)) {
> > +               dbg("dabusb_writemem: %04X %p %d)", be32_to_cpu(rec->addr),
> > +                   rec->data, be16_to_cpu(rec->len));
> > +
> > +               ret = dabusb_writemem(s, be32_to_cpu(rec->addr), rec->data,
> > +                                      be16_to_cpu(rec->len));
> > +               if (ret < 0) {
> > +                       dev_err(&s->usbdev->dev,
> > +                               "dabusb_writemem failed (%d %04X %p %d)\n",
> > +                               ret, be32_to_cpu(rec->addr),
> > +                               rec->data, be16_to_cpu(rec->len));
> > +                       break;
> > +               }
> > +       }
> > +       ret = dabusb_8051_reset (s, 0);
> > +       release_firmware(fw);
> > + out:
> > +       dbg("dabusb_loadmem: exit");
> > +
> > +       return ret;
> > +}
> > +/* --------------------------------------------------------------------- */
> > +static int dabusb_fpga_clear (pdabusb_t s, pbulk_transfer_t b)
> > +{
> > +       b->size = 4;
> > +       b->data[0] = 0x2a;
> > +       b->data[1] = 0;
> > +       b->data[2] = 0;
> > +       b->data[3] = 0;
> > +
> > +       dbg("dabusb_fpga_clear");
> > +
> > +       return dabusb_bulk (s, b);
> > +}
> > +/* --------------------------------------------------------------------- */
> > +static int dabusb_fpga_init (pdabusb_t s, pbulk_transfer_t b)
> > +{
> > +       b->size = 4;
> > +       b->data[0] = 0x2c;
> > +       b->data[1] = 0;
> > +       b->data[2] = 0;
> > +       b->data[3] = 0;
> > +
> > +       dbg("dabusb_fpga_init");
> > +
> > +       return dabusb_bulk (s, b);
> > +}
> > +/* --------------------------------------------------------------------- */
> > +static int dabusb_fpga_download (pdabusb_t s, const char *fname)
> > +{
> > +       pbulk_transfer_t b = kmalloc (sizeof (bulk_transfer_t), GFP_KERNEL);
> > +       const struct firmware *fw;
> > +       unsigned int blen, n;
> > +       int ret;
> > +
> > +       dbg("Enter dabusb_fpga_download (internal)");
> > +
> > +       if (!b) {
> > +               dev_err(&s->usbdev->dev,
> > +                       "kmalloc(sizeof(bulk_transfer_t))==NULL\n");
> > +               return -ENOMEM;
> > +       }
> > +
> > +       ret = request_firmware(&fw, "dabusb/bitstream.bin", &s->usbdev->dev);
> > +       if (ret) {
> > +               dev_err(&s->usbdev->dev,
> > +                       "Failed to load \"dabusb/bitstream.bin\": %d\n", ret);
> > +               kfree(b);
> > +               return ret;
> > +       }
> > +
> > +       b->pipe = 1;
> > +       ret = dabusb_fpga_clear (s, b);
> > +       mdelay (10);
> > +       blen = fw->data[73] + (fw->data[72] << 8);
> > +
> > +       dbg("Bitstream len: %i", blen);
> > +
> > +       b->data[0] = 0x2b;
> > +       b->data[1] = 0;
> > +       b->data[2] = 0;
> > +       b->data[3] = 60;
> > +
> > +       for (n = 0; n <= blen + 60; n += 60) {
> > +               // some cclks for startup
> > +               b->size = 64;
> > +               memcpy (b->data + 4, fw->data + 74 + n, 60);
> > +               ret = dabusb_bulk (s, b);
> > +               if (ret < 0) {
> > +                       dev_err(&s->usbdev->dev, "dabusb_bulk failed.\n");
> > +                       break;
> > +               }
> > +               mdelay (1);
> > +       }
> > +
> > +       ret = dabusb_fpga_init (s, b);
> > +       kfree (b);
> > +       release_firmware(fw);
> > +
> > +       dbg("exit dabusb_fpga_download");
> > +
> > +       return ret;
> > +}
> > +
> > +static int dabusb_stop (pdabusb_t s)
> > +{
> > +       dbg("dabusb_stop");
> > +
> > +       s->state = _stopped;
> > +       dabusb_cancel_queue (s, &s->rec_buff_list);
> > +
> > +       dbg("pending_io: %d", s->pending_io.counter);
> > +
> > +       s->pending_io.counter = 0;
> > +       return 0;
> > +}
> > +
> > +static int dabusb_startrek (pdabusb_t s)
> > +{
> > +       if (!s->got_mem && s->state != _started) {
> > +
> > +               dbg("dabusb_startrek");
> > +
> > +               if (dabusb_alloc_buffers (s) < 0)
> > +                       return -ENOMEM;
> > +               dabusb_stop (s);
> > +               s->state = _started;
> > +               s->readptr = 0;
> > +       }
> > +
> > +       if (!list_empty (&s->free_buff_list)) {
> > +               pbuff_t end;
> > +               int ret;
> > +
> > +       while (!dabusb_add_buf_tail (s, &s->rec_buff_list, &s->free_buff_list)) {
> > +
> > +                       dbg("submitting: end:%p s->rec_buff_list:%p", s->rec_buff_list.prev, &s->rec_buff_list);
> > +
> > +                       end = list_entry (s->rec_buff_list.prev, buff_t, buff_list);
> > +
> > +                       ret = usb_submit_urb (end->purb, GFP_KERNEL);
> > +                       if (ret) {
> > +                               dev_err(&s->usbdev->dev,
> > +                                       "usb_submit_urb returned:%d\n", ret);
> > +                               if (dabusb_add_buf_tail (s, &s->free_buff_list, &s->rec_buff_list))
> > +                                       dev_err(&s->usbdev->dev,
> > +                                               "startrek: dabusb_add_buf_tail failed\n");
> > +                               break;
> > +                       }
> > +                       else
> > +                               atomic_inc (&s->pending_io);
> > +               }
> > +               dbg("pending_io: %d",s->pending_io.counter);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static ssize_t dabusb_read (struct file *file, char __user *buf, size_t count, loff_t * ppos)
> > +{
> > +       pdabusb_t s = (pdabusb_t) file->private_data;
> > +       unsigned long flags;
> > +       unsigned ret = 0;
> > +       int rem;
> > +       int cnt;
> > +       pbuff_t b;
> > +       struct urb *purb = NULL;
> > +
> > +       dbg("dabusb_read");
> > +
> > +       if (*ppos)
> > +               return -ESPIPE;
> > +
> > +       if (s->remove_pending)
> > +               return -EIO;
> > +
> > +
> > +       if (!s->usbdev)
> > +               return -EIO;
> > +
> > +       while (count > 0) {
> > +               dabusb_startrek (s);
> > +
> > +               spin_lock_irqsave (&s->lock, flags);
> > +
> > +               if (list_empty (&s->rec_buff_list)) {
> > +
> > +                       spin_unlock_irqrestore(&s->lock, flags);
> > +
> > +                       dev_err(&s->usbdev->dev,
> > +                               "error: rec_buf_list is empty\n");
> > +                       goto err;
> > +               }
> > +
> > +               b = list_entry (s->rec_buff_list.next, buff_t, buff_list);
> > +               purb = b->purb;
> > +
> > +               spin_unlock_irqrestore(&s->lock, flags);
> > +
> > +               if (purb->status == -EINPROGRESS) {
> > +                       if (file->f_flags & O_NONBLOCK)         // return nonblocking
> > +                        {
> > +                               if (!ret)
> > +                                       ret = -EAGAIN;
> > +                               goto err;
> > +                       }
> > +
> > +                       interruptible_sleep_on (&s->wait);
> > +
> > +                       if (signal_pending (current)) {
> > +                               if (!ret)
> > +                                       ret = -ERESTARTSYS;
> > +                               goto err;
> > +                       }
> > +
> > +                       spin_lock_irqsave (&s->lock, flags);
> > +
> > +                       if (list_empty (&s->rec_buff_list)) {
> > +                               spin_unlock_irqrestore(&s->lock, flags);
> > +                               dev_err(&s->usbdev->dev,
> > +                                       "error: still no buffer available.\n");
> > +                               goto err;
> > +                       }
> > +                       spin_unlock_irqrestore(&s->lock, flags);
> > +                       s->readptr = 0;
> > +               }
> > +               if (s->remove_pending) {
> > +                       ret = -EIO;
> > +                       goto err;
> > +               }
> > +
> > +               rem = purb->actual_length - s->readptr;         // set remaining bytes to copy
> > +
> > +               if (count >= rem)
> > +                       cnt = rem;
> > +               else
> > +                       cnt = count;
> > +
> > +               dbg("copy_to_user:%p %p %d",buf, purb->transfer_buffer + s->readptr, cnt);
> > +
> > +               if (copy_to_user (buf, purb->transfer_buffer + s->readptr, cnt)) {
> > +                       dev_err(&s->usbdev->dev, "read: copy_to_user failed\n");
> > +                       if (!ret)
> > +                               ret = -EFAULT;
> > +                       goto err;
> > +               }
> > +
> > +               s->readptr += cnt;
> > +               count -= cnt;
> > +               buf += cnt;
> > +               ret += cnt;
> > +
> > +               if (s->readptr == purb->actual_length) {
> > +                       // finished, take next buffer
> > +                       if (dabusb_add_buf_tail (s, &s->free_buff_list, &s->rec_buff_list))
> > +                               dev_err(&s->usbdev->dev,
> > +                                       "read: dabusb_add_buf_tail failed\n");
> > +                       s->readptr = 0;
> > +               }
> > +       }
> > +      err:                     //mutex_unlock(&s->mutex);
> > +       return ret;
> > +}
> > +
> > +static int dabusb_open (struct inode *inode, struct file *file)
> > +{
> > +       int devnum = iminor(inode);
> > +       pdabusb_t s;
> > +       int r;
> > +
> > +       if (devnum < DABUSB_MINOR || devnum >= (DABUSB_MINOR + NRDABUSB))
> > +               return -EIO;
> > +
> > +       s = &dabusb[devnum - DABUSB_MINOR];
> > +
> > +       dbg("dabusb_open");
> > +       mutex_lock(&s->mutex);
> > +
> > +       while (!s->usbdev || s->opened) {
> > +               mutex_unlock(&s->mutex);
> > +
> > +               if (file->f_flags & O_NONBLOCK)
> > +                       return -EBUSY;
> > +               msleep_interruptible(500);
> > +
> > +               if (signal_pending (current))
> > +                       return -EAGAIN;
> > +               mutex_lock(&s->mutex);
> > +       }
> > +       if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
> > +               mutex_unlock(&s->mutex);
> > +               dev_err(&s->usbdev->dev, "set_interface failed\n");
> > +               return -EINVAL;
> > +       }
> > +       s->opened = 1;
> > +       mutex_unlock(&s->mutex);
> > +
> > +       file->f_pos = 0;
> > +       file->private_data = s;
> > +
> > +       r = nonseekable_open(inode, file);
> > +       return r;
> > +}
> > +
> > +static int dabusb_release (struct inode *inode, struct file *file)
> > +{
> > +       pdabusb_t s = (pdabusb_t) file->private_data;
> > +
> > +       dbg("dabusb_release");
> > +
> > +       mutex_lock(&s->mutex);
> > +       dabusb_stop (s);
> > +       dabusb_free_buffers (s);
> > +       mutex_unlock(&s->mutex);
> > +
> > +       if (!s->remove_pending) {
> > +               if (usb_set_interface (s->usbdev, _DABUSB_IF, 0) < 0)
> > +                       dev_err(&s->usbdev->dev, "set_interface failed\n");
> > +       }
> > +       else
> > +               wake_up (&s->remove_ok);
> > +
> > +       s->opened = 0;
> > +       return 0;
> > +}
> > +
> > +static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
> > +{
> > +       pdabusb_t s = (pdabusb_t) file->private_data;
> > +       pbulk_transfer_t pbulk;
> > +       int ret = 0;
> > +       int version = DABUSB_VERSION;
> > +
> > +       dbg("dabusb_ioctl");
> > +
> > +       if (s->remove_pending)
> > +               return -EIO;
> > +
> > +       mutex_lock(&s->mutex);
> > +
> > +       if (!s->usbdev) {
> > +               mutex_unlock(&s->mutex);
> > +               return -EIO;
> > +       }
> > +
> > +       switch (cmd) {
> > +
> > +       case IOCTL_DAB_BULK:
> > +               pbulk = memdup_user((void __user *)arg,
> > +                                   sizeof(bulk_transfer_t));
> > +
> > +               if (IS_ERR(pbulk)) {
> > +                       ret = PTR_ERR(pbulk);
> > +                       break;
> > +               }
> > +
> > +               ret=dabusb_bulk (s, pbulk);
> > +               if(ret==0)
> > +                       if (copy_to_user((void __user *)arg, pbulk,
> > +                                        sizeof(bulk_transfer_t)))
> > +                               ret = -EFAULT;
> > +               kfree (pbulk);
> > +               break;
> > +
> > +       case IOCTL_DAB_OVERRUNS:
> > +               ret = put_user (s->overruns, (unsigned int __user *) arg);
> > +               break;
> > +
> > +       case IOCTL_DAB_VERSION:
> > +               ret = put_user (version, (unsigned int __user *) arg);
> > +               break;
> > +
> > +       default:
> > +               ret = -ENOIOCTLCMD;
> > +               break;
> > +       }
> > +       mutex_unlock(&s->mutex);
> > +       return ret;
> > +}
> > +
> > +static const struct file_operations dabusb_fops =
> > +{
> > +       .owner =        THIS_MODULE,
> > +       .llseek =       no_llseek,
> > +       .read =         dabusb_read,
> > +       .unlocked_ioctl =       dabusb_ioctl,
> > +       .open =         dabusb_open,
> > +       .release =      dabusb_release,
> > +};
> > +
> > +static char *dabusb_devnode(struct device *dev, mode_t *mode)
> > +{
> > +       return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
> > +}
> > +
> > +static struct usb_class_driver dabusb_class = {
> > +       .name =         "dabusb%d",
> > +       .devnode =      dabusb_devnode,
> > +       .fops =         &dabusb_fops,
> > +       .minor_base =   DABUSB_MINOR,
> > +};
> > +
> > +
> > +/* --------------------------------------------------------------------- */
> > +static int dabusb_probe (struct usb_interface *intf,
> > +                        const struct usb_device_id *id)
> > +{
> > +       struct usb_device *usbdev = interface_to_usbdev(intf);
> > +       int retval;
> > +       pdabusb_t s;
> > +
> > +       dbg("dabusb: probe: vendor id 0x%x, device id 0x%x ifnum:%d",
> > +           le16_to_cpu(usbdev->descriptor.idVendor),
> > +           le16_to_cpu(usbdev->descriptor.idProduct),
> > +           intf->altsetting->desc.bInterfaceNumber);
> > +
> > +       /* We don't handle multiple configurations */
> > +       if (usbdev->descriptor.bNumConfigurations != 1)
> > +               return -ENODEV;
> > +
> > +       if (intf->altsetting->desc.bInterfaceNumber != _DABUSB_IF &&
> > +           le16_to_cpu(usbdev->descriptor.idProduct) == 0x9999)
> > +               return -ENODEV;
> > +
> > +
> > +
> > +       s = &dabusb[intf->minor];
> > +
> > +       mutex_lock(&s->mutex);
> > +       s->remove_pending = 0;
> > +       s->usbdev = usbdev;
> > +       s->devnum = intf->minor;
> > +
> > +       if (usb_reset_configuration (usbdev) < 0) {
> > +               dev_err(&intf->dev, "reset_configuration failed\n");
> > +               goto reject;
> > +       }
> > +       if (le16_to_cpu(usbdev->descriptor.idProduct) == 0x2131) {
> > +               dabusb_loadmem (s, NULL);
> > +               goto reject;
> > +       }
> > +       else {
> > +               dabusb_fpga_download (s, NULL);
> > +
> > +               if (usb_set_interface (s->usbdev, _DABUSB_IF, 0) < 0) {
> > +                       dev_err(&intf->dev, "set_interface failed\n");
> > +                       goto reject;
> > +               }
> > +       }
> > +       dbg("bound to interface: %d", intf->altsetting->desc.bInterfaceNumber);
> > +       usb_set_intfdata (intf, s);
> > +       mutex_unlock(&s->mutex);
> > +
> > +       retval = usb_register_dev(intf, &dabusb_class);
> > +       if (retval) {
> > +               usb_set_intfdata (intf, NULL);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       return 0;
> > +
> > +      reject:
> > +       mutex_unlock(&s->mutex);
> > +       s->usbdev = NULL;
> > +       return -ENODEV;
> > +}
> > +
> > +static void dabusb_disconnect (struct usb_interface *intf)
> > +{
> > +       wait_queue_t __wait;
> > +       pdabusb_t s = usb_get_intfdata (intf);
> > +
> > +       dbg("dabusb_disconnect");
> > +
> > +       init_waitqueue_entry(&__wait, current);
> > +
> > +       usb_set_intfdata (intf, NULL);
> > +       if (s) {
> > +               usb_deregister_dev (intf, &dabusb_class);
> > +               s->remove_pending = 1;
> > +               wake_up (&s->wait);
> > +               add_wait_queue(&s->remove_ok, &__wait);
> > +               set_current_state(TASK_UNINTERRUPTIBLE);
> > +               if (s->state == _started)
> > +                       schedule();
> > +               current->state = TASK_RUNNING;
> > +               remove_wait_queue(&s->remove_ok, &__wait);
> > +
> > +               s->usbdev = NULL;
> > +               s->overruns = 0;
> > +       }
> > +}
> > +
> > +static struct usb_device_id dabusb_ids [] = {
> > +       // { USB_DEVICE(0x0547, 0x2131) },      /* An2131 chip, no boot ROM */
> > +       { USB_DEVICE(0x0547, 0x9999) },
> > +       { }                                             /* Terminating entry */
> > +};
> > +
> > +MODULE_DEVICE_TABLE (usb, dabusb_ids);
> > +
> > +static struct usb_driver dabusb_driver = {
> > +       .name =         "dabusb",
> > +       .probe =        dabusb_probe,
> > +       .disconnect =   dabusb_disconnect,
> > +       .id_table =     dabusb_ids,
> > +};
> > +
> > +/* --------------------------------------------------------------------- */
> > +
> > +static int __init dabusb_init (void)
> > +{
> > +       int retval;
> > +       unsigned u;
> > +
> > +       /* initialize struct */
> > +       for (u = 0; u < NRDABUSB; u++) {
> > +               pdabusb_t s = &dabusb[u];
> > +               memset (s, 0, sizeof (dabusb_t));
> > +               mutex_init (&s->mutex);
> > +               s->usbdev = NULL;
> > +               s->total_buffer_size = buffers;
> > +               init_waitqueue_head (&s->wait);
> > +               init_waitqueue_head (&s->remove_ok);
> > +               spin_lock_init (&s->lock);
> > +               INIT_LIST_HEAD (&s->free_buff_list);
> > +               INIT_LIST_HEAD (&s->rec_buff_list);
> > +       }
> > +
> > +       /* register misc device */
> > +       retval = usb_register(&dabusb_driver);
> > +       if (retval)
> > +               goto out;
> > +
> > +       dbg("dabusb_init: driver registered");
> > +
> > +       printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
> > +              DRIVER_DESC "\n");
> > +
> > +out:
> > +       return retval;
> > +}
> > +
> > +static void __exit dabusb_cleanup (void)
> > +{
> > +       dbg("dabusb_cleanup");
> > +
> > +       usb_deregister (&dabusb_driver);
> > +}
> > +
> > +/* --------------------------------------------------------------------- */
> > +
> > +MODULE_AUTHOR( DRIVER_AUTHOR );
> > +MODULE_DESCRIPTION( DRIVER_DESC );
> > +MODULE_LICENSE("GPL");
> > +MODULE_FIRMWARE("dabusb/firmware.fw");
> > +MODULE_FIRMWARE("dabusb/bitstream.bin");
> > +
> > +module_param(buffers, int, 0);
> > +MODULE_PARM_DESC (buffers, "Number of buffers (default=256)");
> > +
> > +module_init (dabusb_init);
> > +module_exit (dabusb_cleanup);
> > +
> > +/* --------------------------------------------------------------------- */
> > diff --git a/drivers/staging/dabusb/dabusb.h b/drivers/staging/dabusb/dabusb.h
> > new file mode 100644
> > index 0000000..00eb34c
> > --- /dev/null
> > +++ b/drivers/staging/dabusb/dabusb.h
> > @@ -0,0 +1,85 @@
> > +#define _BULK_DATA_LEN 64
> > +typedef struct
> > +{
> > +       unsigned char data[_BULK_DATA_LEN];
> > +       unsigned int size;
> > +       unsigned int pipe;
> > +}bulk_transfer_t,*pbulk_transfer_t;
> > +
> > +#define DABUSB_MINOR 240               /* some unassigned USB minor */
> > +#define DABUSB_VERSION 0x1000
> > +#define IOCTL_DAB_BULK              _IOWR('d', 0x30, bulk_transfer_t)
> > +#define IOCTL_DAB_OVERRUNS         _IOR('d',  0x15, int)
> > +#define IOCTL_DAB_VERSION           _IOR('d', 0x3f, int)
> > +
> > +#ifdef __KERNEL__
> > +
> > +typedef enum { _stopped=0, _started } driver_state_t;
> > +
> > +typedef struct
> > +{
> > +       struct mutex mutex;
> > +       struct usb_device *usbdev;
> > +       wait_queue_head_t wait;
> > +       wait_queue_head_t remove_ok;
> > +       spinlock_t lock;
> > +       atomic_t pending_io;
> > +       driver_state_t state;
> > +       int remove_pending;
> > +       int got_mem;
> > +       int total_buffer_size;
> > +       unsigned int overruns;
> > +       int readptr;
> > +       int opened;
> > +       int devnum;
> > +       struct list_head free_buff_list;
> > +       struct list_head rec_buff_list;
> > +} dabusb_t,*pdabusb_t;
> > +
> > +typedef struct
> > +{
> > +       pdabusb_t s;
> > +       struct urb *purb;
> > +       struct list_head buff_list;
> > +} buff_t,*pbuff_t;
> > +
> > +typedef struct
> > +{
> > +       wait_queue_head_t wait;
> > +} bulk_completion_context_t, *pbulk_completion_context_t;
> > +
> > +
> > +#define _DABUSB_IF 2
> > +#define _DABUSB_ISOPIPE 0x09
> > +#define _ISOPIPESIZE   16384
> > +
> > +#define _BULK_DATA_LEN 64
> > +// Vendor specific request code for Anchor Upload/Download
> > +// This one is implemented in the core
> > +#define ANCHOR_LOAD_INTERNAL  0xA0
> > +
> > +// EZ-USB Control and Status Register.  Bit 0 controls 8051 reset
> > +#define CPUCS_REG    0x7F92
> > +#define _TOTAL_BUFFERS 384
> > +
> > +#define MAX_INTEL_HEX_RECORD_LENGTH 16
> > +
> > +#ifndef _BYTE_DEFINED
> > +#define _BYTE_DEFINED
> > +typedef unsigned char BYTE;
> > +#endif // !_BYTE_DEFINED
> > +
> > +#ifndef _WORD_DEFINED
> > +#define _WORD_DEFINED
> > +typedef unsigned short WORD;
> > +#endif // !_WORD_DEFINED
> > +
> > +typedef struct _INTEL_HEX_RECORD
> > +{
> > +   BYTE  Length;
> > +   WORD  Address;
> > +   BYTE  Type;
> > +   BYTE  Data[MAX_INTEL_HEX_RECORD_LENGTH];
> > +} INTEL_HEX_RECORD, *PINTEL_HEX_RECORD;
> > +
> > +#endif
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
