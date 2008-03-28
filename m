Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SLpG5b022107
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 17:51:16 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SLp2nA004066
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 17:51:02 -0400
Message-ID: <47ED6827.2020500@hhs.nl>
Date: Fri, 28 Mar 2008 22:50:31 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: spca50x-devs@lists.sourceforge.net, video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="------------070002070508040808040808"
Cc: fedora-kernel-list@redhat.com
Subject: [New Driver]: stand alone pac207 v4l2 driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------070002070508040808040808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

As explained in my introduction mail I've been working on a standalone v4l2 
driver for pac207 based usb webcams. I've attached the hopefully pretty clean 
result to this mail.

Note that I've also done a version which is split in a generic simple usb 
webcam core and a cam/controller IC specific driver, the split version is the 
one I would like to move forward with.

I'm currently posting these as .c files for easy reading and compilation /
testing, but I still hope to get a lot of feedback / a thorough review, esp of
the core <-> pac207 split version as I hope to submit that as a patch for
mainline inclusion soon.

Thanks & Regards,

Hans


--------------070002070508040808040808
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Makefile"

obj-m += pac207.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

--------------070002070508040808040808
Content-Type: text/plain;
 name="pac207.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pac207.c"

/***************************************************************************
 * Video4Linux2 driver for Pixart PAC207BCA Camera bridge and sensor       *
 *                                                                         *
 * Copyright (C) 2008 by Hans de Goede <j.w.r.degoede@hhs.nl>              *
 * Buffer management code taken from the Video4Linux2 zc030x driver:       *
 * Copyright (C) 2006-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
 * PAC207BCA code derived from the gspca Pixart PAC207BCA library:         *
 * Copyright (C) 2005 Thomas Kaiser thomas@kaiser-linux.li                 *
 * Copyright (C) 2005 Bertrik.Sikken                                       *
 * Copyleft (C) 2005 Michel Xhaard mxhaard@magic.fr                        *
 *                                                                         *
 * This program is free software; you can redistribute it and/or modify    *
 * it under the terms of the GNU General Public License as published by    *
 * the Free Software Foundation; either version 2 of the License, or       *
 * (at your option) any later version.                                     *
 *                                                                         *
 * This program is distributed in the hope that it will be useful,         *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 * GNU General Public License for more details.                            *
 *                                                                         *
 * You should have received a copy of the GNU General Public License       *
 * along with this program; if not, write to the Free Software             *
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
 ***************************************************************************/

#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/param.h>
#include <linux/errno.h>
#include <linux/slab.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/delay.h>
#include <linux/compiler.h>
#include <linux/ioctl.h>
#include <linux/poll.h>
#include <linux/stat.h>
#include <linux/mm.h>
#include <linux/vmalloc.h>
#include <linux/page-flags.h>
#include <linux/byteorder/generic.h>
#include <asm/page.h>
#include <asm/uaccess.h>

#include "pac207.h"

/*****************************************************************************/

static __devinitdata struct usb_device_id pac207_id_table[] = {
	{ USB_DEVICE(0x041E, 0x4028) }, /* Creative VistaPlus */
	{ USB_DEVICE(0x093a, 0x2460) }, /* Qtec Wb100 */
	{ USB_DEVICE(0x093a, 0x2463) }, /* Philips SPC220NC */
	{ USB_DEVICE(0x093a, 0x2468) }, /* Generic PAC 207 */
	{ USB_DEVICE(0x093a, 0x2470) }, /* Genius GF112 */   
	{ USB_DEVICE(0x093a, 0x2471) }, /* Genius GF111 */   
	{ USB_DEVICE(0x093a, 0x2472) }, /* Genius GF111 */
	{ 0 }
};

/*****************************************************************************/

MODULE_DEVICE_TABLE(usb, pac207_id_table);
MODULE_AUTHOR("Hans de Goede <j.w.r.degoede@hhs.nl>");
MODULE_DESCRIPTION("Pixart PAC207BCA Camera Driver");
MODULE_LICENSE("GPL");

static unsigned short debug = PAC207_DEBUG_LEVEL;
module_param(debug, ushort, 0644);
MODULE_PARM_DESC(debug,
		 "\n<n> Debugging information level, from 0 to 3:"
		 "\n0 = none (use carefully)"
		 "\n1 = critical errors"
		 "\n2 = significant informations"
		 "\n3 = more verbose messages"
		 "\nLevel 3 is useful for testing only, when only "
		 "one device is used."
		 "\nDefault value is "__MODULE_STRING(PAC207_DEBUG_LEVEL)"."
		 "\n");

/*****************************************************************************/

static const char pac207_sof_marker[5] = { 0xFF, 0xFF, 0x00, 0xFF, 0x96 };

static const u8 pac207_sensor_init[][8] = {
    {0x10, 0x12, 0x0d, 0x12, 0x0c, 0x01, 0x29, 0xf0}, /* 2  */
/*  {0x10, 0x24, 0x06, 0x12, 0x0c, 0x01, 0x29, 0xf0}, ** 2 increase the times exposure decrease frame rate */
    {0x00, 0x64, 0x64, 0x64, 0x04, 0x10, 0xF0, 0x30}, /* a reg_10 digital gain Red Green Blue Ggain */
    {0x00, 0x00, 0x00, 0x70, 0xA0, 0xF8, 0x00, 0x00}, /* 12 */
    {0x00, 0x00, 0x32, 0x00, 0x96, 0x00, 0xA2, 0x02}, /* 40 */
    {0x32, 0x00, 0x96, 0x00, 0xA2, 0x02, 0xAF, 0x00}, /* 42 reg_66 rate control */
};

static const u8 PacReg72[] = { 0x00, 0x00, 0x36, 0x00 }; /* 48 reg_72 Rate Control end BalSize_4a =0x36 */

static const struct v4l2_pix_format pac207_pix_fmt[2] = { {
	.width = 352,
	.height = 288,
	.pixelformat = V4L2_PIX_FMT_SBGGR8,
	.field = V4L2_FIELD_NONE,
	.bytesperline = 0,
	.sizeimage = 352 * 288,
	.colorspace = V4L2_COLORSPACE_SRGB,
	.priv = 8,
}, {
	.width = 176,
	.height = 144,
	.pixelformat = V4L2_PIX_FMT_SBGGR8,
	.field = V4L2_FIELD_NONE,
	.bytesperline = 0,
	.sizeimage = 176 * 144,
	.colorspace = V4L2_COLORSPACE_SRGB,
	.priv = 8,
} };

static struct pac207_decompress_table_t pac207_decompress_table[256];

/*****************************************************************************/

static u32
pac207_request_buffers(struct pac207_device* cam, u32 count)
{
	const struct v4l2_pix_format* p = &pac207_pix_fmt[cam->mode];
	const size_t imagesize = p->width * p->height;
	void* buff = NULL;
	u32 i;

	if (count > PAC207_MAX_FRAMES)
		count = PAC207_MAX_FRAMES;

	cam->nbuffers = count;
	while (cam->nbuffers) {
		if ((buff = vmalloc_32_user(cam->nbuffers *
						PAGE_ALIGN(imagesize))))
			break;
		cam->nbuffers--;
	}

	for (i = 0; i < cam->nbuffers; i++) {
		cam->frame[i].bufmem = buff + i*PAGE_ALIGN(imagesize);
		cam->frame[i].buf.index = i;
		cam->frame[i].buf.m.offset = i*PAGE_ALIGN(imagesize);
		cam->frame[i].buf.length = imagesize;
		cam->frame[i].buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		cam->frame[i].buf.sequence = 0;
		cam->frame[i].buf.field = V4L2_FIELD_NONE;
		cam->frame[i].buf.memory = V4L2_MEMORY_MMAP;
		cam->frame[i].buf.flags = 0;
		cam->frame[i].buf.bytesused = 0;
		cam->frame[i].state = F_UNUSED;
	}

	return cam->nbuffers;
}


static void pac207_release_buffers(struct pac207_device* cam)
{
	if (cam->nbuffers) {
		vfree(cam->frame[0].bufmem);
		cam->nbuffers = 0;
	}
}


static void pac207_empty_framequeues(struct pac207_device* cam)
{
	u32 i;

	INIT_LIST_HEAD(&cam->inqueue);
	INIT_LIST_HEAD(&cam->outqueue);

	for (i = 0; i < PAC207_MAX_FRAMES; i++) {
		cam->frame[i].state = F_UNUSED;
		cam->frame[i].buf.bytesused = 0;
	}
}


static void pac207_queue_unusedframes(struct pac207_device* cam)
{
	unsigned long lock_flags;
	u32 i;

	for (i = 0; i < cam->nbuffers; i++)
		if (cam->frame[i].state == F_UNUSED) {
			cam->frame[i].state = F_QUEUED;
			spin_lock_irqsave(&cam->queue_lock, lock_flags);
			list_add_tail(&cam->frame[i].frame, &cam->inqueue);
			spin_unlock_irqrestore(&cam->queue_lock, lock_flags);
		}
}

/*****************************************************************************/

int pac207_write_regs(struct pac207_device* cam, u16 index,
	const u8 *buffer, u16 length)
{
	struct usb_device* udev = cam->usbdev;
	int err = 0;
	u8 *kbuffer;

	kbuffer = (u8 *) kmalloc(length, GFP_KERNEL);
	if (!kbuffer) {
		DBG(1, "Not enough memory");
		return -ENOMEM;
	}
	memcpy(kbuffer, buffer, length);

	err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x01, 
			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
			0x00, index, kbuffer, length, PAC207_CTRL_TIMEOUT);
	if (err < 0)
		DBG(1, "Failed to write registers to index 0x%04X, error %d)",
			index, err);

	kfree(kbuffer);

	return err;
}


int pac207_write_reg(struct pac207_device* cam, u16 index, u16 value)
{
	struct usb_device* udev = cam->usbdev;
	int err;

	err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x00, 
			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
			value, index, NULL, 0, PAC207_CTRL_TIMEOUT);
	if (err && err != -ENODEV)
		DBG(1, "Failed to write a register (index 0x%04X, "
			   "value 0x%02X, error %d)",index, value, err);

	return err;
}


int pac207_read_reg(struct pac207_device* cam, u16 index)
{
	struct usb_device* udev = cam->usbdev;
	u8* buff = cam->control_buffer;
	int res;

	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00,
			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
			0x00, index, buff, 1, PAC207_CTRL_TIMEOUT);
	if (res < 0)
		DBG(1, "Failed to read a register (index 0x%04X, error %d)",
			index, res);

	return (res >= 0) ? (int)(*buff) : res;
}

/*****************************************************************************/

/* auto gain and exposure algorithm based on the knee algorithm described here:
   http://ytse.tricolour.net/docs/LowLightOptimization.html */
static void pac207_do_auto_gain(struct pac207_device* cam)
{
	int i, steps, desired_avg_lum;
	int orig_gain = cam->gain;
	int orig_exposure = cam->exposure;
	int avg_lum = atomic_read(&cam->avg_lum);

	if (!cam->autogain || avg_lum == -1)
		return;

	if (cam->autogain_ignore_frames > 0) {
		cam->autogain_ignore_frames--;
		return;
	}

	/* correct desired lumination for the configured brightness */
	desired_avg_lum = 100 + cam->brightness / 2;

	/* If we are of a multiple of deadzone, do multiple step to reach the
	   desired lumination fast (with the risc of a slight overshoot */
	steps = abs(desired_avg_lum - avg_lum) / PAC207_AUTOGAIN_DEADZONE;

	for (i = 0; i < steps; i++) {
		if (avg_lum > desired_avg_lum) {
			if (cam->gain > PAC207_GAIN_KNEE) {
				cam->gain--;
			} else if (cam->exposure > PAC207_EXPOSURE_KNEE) {
				cam->exposure--;
			} else if (cam->gain > PAC207_GAIN_DEFAULT) {
				cam->gain--;
			} else if (cam->exposure > PAC207_EXPOSURE_MIN) {
				cam->exposure--;
			} else if (cam->gain > PAC207_GAIN_MIN) {
				cam->gain--;
			} else
				break;
		} else { 
			if (cam->gain < PAC207_GAIN_DEFAULT) {
				cam->gain++;
			} else if (cam->exposure < PAC207_EXPOSURE_KNEE) {
				cam->exposure++;
			} else if (cam->gain < PAC207_GAIN_KNEE) {
				cam->gain++;
			} else if (cam->exposure < PAC207_EXPOSURE_MAX) {
				cam->exposure++;
			} else if (cam->gain < PAC207_GAIN_MAX) {
				cam->gain++;
			} else
				break;
		}
	}

	if (cam->exposure != orig_exposure || cam->gain != orig_gain) {
		if (cam->exposure != orig_exposure)
			pac207_write_reg(cam, 0x0002, cam->exposure);
		else
			pac207_write_reg(cam, 0x000e, cam->gain);
		pac207_write_reg(cam, 0x13, 0x01); /* load registers to sen. */
		pac207_write_reg(cam, 0x1c, 0x01); /* not documented */
		cam->autogain_ignore_frames = PAC207_AUTOGAIN_IGNORE_FRAMES;
	}
}

/*****************************************************************************/

static void *pac207_find_sof(struct pac207_device* cam, void* mem,
	unsigned int len)
{
	char *m = mem;
	unsigned int i;

	/* Search for the SOF marker (fixed part) in the header */
	for (i = 0; i < len; i++) {
		if (m[i] == pac207_sof_marker[cam->sof_read]) {
			cam->sof_read++;
			if (cam->sof_read == sizeof(pac207_sof_marker)) {
				DBG(3, "SOF found, bytes to analyze: %u. Frame"
					"starts at byte #%u", len, i + 1);
				cam->sof_read = 0;
				return m + i + 1;
			}
		} else
			cam->sof_read = 0;
	}

	return NULL;
}

#define CLIP(color) (unsigned char)(((color)>0xFF)?0xff:(((color)<0)?0:(color)))

/* Note len is deliberately signed here, where it is unsigned everywhere else
   as it gets compared with the signed bitpos and can even become negative! */
static int pac207_decompress_row(struct pac207_device* cam,
	struct pac207_frame_t* f, u8 *cdata, int len)
{
	const struct v4l2_pix_format *pix_format = &pac207_pix_fmt[cam->mode];
	struct pac207_decoder_state *decoder_state = &cam->decoder_state;
	u8 *outp = f->bufmem + f->buf.bytesused;
	int val, bitlen, bitpos = -decoder_state->no_remaining_bits;
	u8 code;

	/* first two pixels are stored as raw 8-bit */
	while (decoder_state->line_read < 2) {
		*outp++ = *cdata++;
		decoder_state->line_read++;
		len--;
		if (len == 0)
			goto decompress_exit;
	}

	while (decoder_state->line_read < pix_format->width) {
		if (bitpos < 0) {
			code = decoder_state->remaining_bits << (8 + bitpos) |
				cdata[0] >> -bitpos;
		} else {
			u8 *addr = cdata + bitpos / 8;
			code = addr[0] << (bitpos & 7) |
				addr[1] >> (8 - (bitpos & 7));
		}

		bitlen = decoder_state->get_abs ?
				6 : pac207_decompress_table[code].len;

		/* Stop decompressing if we're out of input data */
		if ((bitpos + bitlen) > (len * 8))
			break;

		if (decoder_state->get_abs) {
			*outp++ = code & 0xFC;
			decoder_state->line_read++;
			decoder_state->get_abs = 0;
		} else {
			if (pac207_decompress_table[code].is_abs)
				decoder_state->get_abs = 1;
			else {
				/* relative to left pixel */
				val = outp[-2] +
					pac207_decompress_table[code].val;
				*outp++ = CLIP(val);
				decoder_state->line_read++;
			}
		}
		bitpos += bitlen;
	}

	if (decoder_state->line_read == pix_format->width) {
		/* completely decompressed line, round pos to nearest word */
		len -= 2 * ((bitpos + 15) / 16);
		if (len < 0) {
			decoder_state->discard_byte = 1;
			len = 0;
		}
	} else {
		decoder_state->remaining_bits = cdata[bitpos/8];
		decoder_state->no_remaining_bits = (8 - bitpos) & 7;
		len = 0;
	}

decompress_exit:
	f->buf.bytesused = outp - (u8 *)f->bufmem;
	
	return len;
}

static void pac207_decode_line_init(struct pac207_device* cam)
{
	struct pac207_decoder_state *decoder_state = &cam->decoder_state;

	decoder_state->line_read = 0;
	decoder_state->line_state = LINE_HEADER1;
	decoder_state->no_remaining_bits = 0;
	decoder_state->get_abs = 0; 
}

static void pac207_decode_frame_init(struct pac207_device* cam)
{
	struct pac207_decoder_state *decoder_state = &cam->decoder_state;

	decoder_state->header_read = 0;
	decoder_state->discard_byte = 0;

	pac207_decode_line_init(cam);
}

static int pac207_decode(struct pac207_device* cam, struct pac207_frame_t* f,
	u8 *cdata, unsigned int len)
{
	struct pac207_decoder_state *decoder_state = &cam->decoder_state;
	const struct v4l2_pix_format *pix_format = &pac207_pix_fmt[cam->mode];
	unsigned int needed;

	/* first 11 bytes after sof marker: frame header */
	if (decoder_state->header_read < 11 ) {
		/* get average lumination from frame header (byte 5) */
		if (decoder_state->header_read < 5 ) {
			needed = 5 - decoder_state->header_read;
			if (len >= needed)
				atomic_set(&cam->avg_lum, cdata[needed-1]);
		}
		/* skip the rest of the header */
		needed = 11 - decoder_state->header_read;
		if (len <= needed) {
			decoder_state->header_read += len;
			return 0;
		}
		cdata += needed;
		len -= needed;
		decoder_state->header_read = 11;
	}

	while (len) {
		if (decoder_state->discard_byte) {
			cdata++;
			len--;
			decoder_state->discard_byte = 0;
			continue;
		}

		switch (decoder_state->line_state) {
		case LINE_HEADER1:
			decoder_state->line_marker = cdata[0] << 8;
			decoder_state->line_state = LINE_HEADER2;
			needed = 1;
			break;
		case LINE_HEADER2:
			decoder_state->line_marker |= cdata[0];
			switch (decoder_state->line_marker) {
			case 0x0FF0:
				decoder_state->line_state = LINE_UNCOMPRESSED;
				break;
			case 0x1EE1:
				decoder_state->line_state = LINE_COMPRESSED;
				break;
			default:
				DBG(3, "Error unknown line-header %04X",
					(int)decoder_state->line_marker);
				f->state = F_ERROR;
				return 0;
			}
			needed = 1;
			break;
		case LINE_UNCOMPRESSED:
			needed = pix_format->width - decoder_state->line_read;
			if (needed > len)
				needed = len;
			memcpy(f->bufmem + f->buf.bytesused, cdata, needed);
			f->buf.bytesused += needed;
			decoder_state->line_read += needed;
			break;
		case LINE_COMPRESSED:
			needed = len -
				pac207_decompress_row(cam, f, cdata, len);
			break;
		}

		cdata += needed;
		len -= needed;

		if (decoder_state->line_read == pix_format->width) {
			if (f->buf.bytesused ==
					pix_format->width *
					pix_format->height) {
				/* eureka we've got a frame */
				f->state = F_DONE;
				return 1;
			}
			pac207_decode_line_init(cam);
		}
	}

	return 0;
}

static void pac207_urb_complete(struct urb *urb)
{
	struct pac207_device* cam = urb->context;
	struct pac207_frame_t** f;
	int i, ret;

	switch (urb->status) {
		case 0:
			break;
		case -ENOENT:		/* usb_kill_urb() called. */
		case -ECONNRESET:	/* usb_unlink_urb() called. */
		case -ESHUTDOWN:	/* The endpoint is being disabled. */
			return;
		default:
			goto resubmit_urb;
	}

	f = &cam->frame_current;

	if (!(*f)) {
		if (list_empty(&cam->inqueue))
			goto resubmit_urb;

		(*f) = list_entry(cam->inqueue.next, struct pac207_frame_t,
					frame);
	} 

	for (i = 0; i < urb->number_of_packets; i++) {
		unsigned int len, status;
		void *pos, *sof;

		len = urb->iso_frame_desc[i].actual_length;
		status = urb->iso_frame_desc[i].status;
		pos = urb->iso_frame_desc[i].offset + urb->transfer_buffer;

		if (status) {
			DBG(3, "Error in isochronous frame");
			(*f)->state = F_ERROR;
			continue;
		}

		while (len) {
			sof = pac207_find_sof(cam, pos, len);
			
			if (((*f)->state == F_QUEUED ||
					(*f)->state == F_ERROR) && sof) {
start_of_frame:
				(*f)->state = F_GRABBING;
				(*f)->buf.bytesused = 0;
				do_gettimeofday(&(*f)->buf.timestamp);
				pac207_decode_frame_init(cam);
				len -= sof - pos;
				pos = sof;
				continue; /* check for another sof in packet */
			}

			if ((*f)->state == F_GRABBING) {
				unsigned int n;

				/* If sof decode until sof */
				if (sof) {
					n = sof - pos;
					if (n > sizeof(pac207_sof_marker))
						n -= sizeof(pac207_sof_marker);
					else
						n = 0;
				} else
					n = len;

				if ((ret = pac207_decode(cam, *f, pos, n))) {
					(*f)->buf.sequence= ++cam->frame_count;
					spin_lock(&cam->queue_lock);
					list_move_tail(&(*f)->frame,
						&cam->outqueue);
					if (!list_empty(&cam->inqueue))
						(*f) = list_entry(
							cam->inqueue.next,
							struct pac207_frame_t,
							frame);
					else
						(*f) = NULL;
					spin_unlock(&cam->queue_lock);
					wake_up_interruptible(&cam->wait_frame);
					DBG(3, "Video frame captured");

					if (!(*f))
						goto resubmit_urb;
				}

				if (sof) {
					if (!ret)
						DBG(3, "Incomplete frame");
					goto start_of_frame;
				}

				len -= n;
				pos += n;
			}
			else
				break;
		}
	}

resubmit_urb:
	urb->dev = cam->usbdev;
	ret = usb_submit_urb(urb, GFP_ATOMIC);
	if (ret < 0)
		DBG(1, "usb_submit_urb() failed, error: %d", ret);
}

static void pac207_kill_and_free_urbs(struct pac207_device* cam)
{
	int i;
	struct urb* urb;
	struct usb_device *udev = cam->usbdev;
	
	for (i = 0; i < PAC207_URBS; i++) {
		if (!(urb = cam->urb[i]))
			continue;

		/* Note: usb_kill_urb() is harmless on a not submitted urb */
		usb_kill_urb(urb);

		if (urb->transfer_buffer) {
			usb_buffer_free(udev, urb->transfer_buffer_length,
				urb->transfer_buffer, urb->transfer_dma);
		}
		usb_free_urb(urb);
		cam->urb[i] = NULL;
	}	
}

static void pac207_stop_transfer(struct pac207_device* cam);

static int pac207_start_transfer(struct pac207_device* cam)
{
	struct usb_device *udev = cam->usbdev;
	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
	struct usb_host_interface* altsetting;
	unsigned int psz;
	struct urb* urb;
	int i, j, alt, err = -ENOSPC;
	u8 mode;

	if (cam->stream == STREAM_ON)
		return -EBUSY;

	for (alt = intf->num_altsetting - 1; alt && err == -ENOSPC; alt--) {
		altsetting = usb_altnum_to_altsetting(intf, alt);

		/* Find our endpoint to determine the packetsize */
		for (i = 0; i < altsetting->desc.bNumEndpoints; i++) {
			if (altsetting->endpoint[i].desc.bEndpointAddress ==
					0x85)
				break;
		}

		/* Endpoint not found or not isoc in this altsetting ?? */
		if (i == altsetting->desc.bNumEndpoints ||
			(altsetting->endpoint[i].desc.bmAttributes &
				USB_ENDPOINT_XFERTYPE_MASK) !=
				USB_ENDPOINT_XFER_ISOC)
			continue;

		psz = le16_to_cpu(altsetting->endpoint[i].desc.wMaxPacketSize);

		/* See paragraph 5.9 / table 5-11 of the usb 2.0 spec. */
		psz = (psz & 0x07ff) * (1 + ((psz >> 11) & 3));

		err = usb_set_interface(udev, 0, alt);
		if (err) {
			DBG(1, "usb_set_interface() failed");
			return err;
		}

		for (i = 0; i < PAC207_URBS; i++) {
			urb = usb_alloc_urb(PAC207_ISO_PACKETS, GFP_KERNEL);
			if (!urb) {
				DBG(1, "usb_alloc_urb() failed");
				pac207_kill_and_free_urbs(cam);
				return -ENOMEM;
			}

			cam->urb[i] = urb;
			/* We alloc psz + 1 bytes per packet, because the
			   decompression code reads bytes at bit offsets and
			   thus can peek up to 7 bits ahead (which will not be
			   used if outside of the actual data, but they will
			   be read)! */
			urb->transfer_buffer = usb_buffer_alloc(udev,
							 (psz + 1) *
							 PAC207_ISO_PACKETS,
							 GFP_KERNEL,
							 &urb->transfer_dma);
			if (!urb->transfer_buffer) {
				DBG(1, "usb_buffer_alloc() failed");
				pac207_kill_and_free_urbs(cam);
				return -ENOMEM;
			}
			urb->dev = udev;
			urb->context = cam;
			urb->pipe = usb_rcvisocpipe(udev, 0x85);
			urb->transfer_flags = URB_ISO_ASAP |
						URB_NO_TRANSFER_DMA_MAP;
			urb->number_of_packets = PAC207_ISO_PACKETS;
			urb->complete = pac207_urb_complete;
			urb->transfer_buffer_length = (psz + 1) *
							PAC207_ISO_PACKETS;
			urb->interval = 1;
			for (j = 0; j < PAC207_ISO_PACKETS; j++) {
				urb->iso_frame_desc[j].offset = (psz + 1) * j;
				urb->iso_frame_desc[j].length = psz;
			}
		}

		/* gspca start methode code here */
		pac207_write_reg(cam, 0x0f, 0x10); /* Power control (Bit 6-0) */
		pac207_write_regs(cam, 0x0002, pac207_sensor_init[0], 8);
		pac207_write_regs(cam, 0x000a, pac207_sensor_init[1], 8);
		pac207_write_regs(cam, 0x0012, pac207_sensor_init[2], 8);
		pac207_write_regs(cam, 0x0040, pac207_sensor_init[3], 8);
		pac207_write_regs(cam, 0x0042, pac207_sensor_init[4], 8);
		pac207_write_regs(cam, 0x0048, PacReg72, 4);
			
		pac207_write_reg(cam, 0x4a, 0x88); /* Compression Balance size */
		pac207_write_reg(cam, 0x4b, 0x00); /* Sram test value */
		pac207_write_reg(cam, 0x08, cam->brightness);
		pac207_write_reg(cam, 0x0e, cam->gain); /* PGA global gain (Bit 4-0) */
		pac207_write_reg(cam, 0x02, cam->exposure); /* PXCK = 12MHz /n */

		mode = 0x02; /* Image Format (Bit 0), LED (1), Compr. test mode (2) */
		if (cam->mode) { /* 176x144 */
			mode |= 0x01;
			DBG(3, "pac207_start mode 176x144");
		} else /* 352x288 */
			DBG(3, "pac207_start mode 352x288");
		pac207_write_reg(cam, 0x41, mode);

		pac207_write_reg(cam, 0x13, 0x01); /* load registers to sensor (Bit 0, auto clear) */
		pac207_write_reg(cam, 0x1c, 0x01); /* not documented */
		udelay(1000); /* taken from gspca */
		pac207_write_reg(cam, 0x40, 0x01); /* Start ISO pipe */

		cam->autogain_ignore_frames = 0;
		atomic_set (&cam->avg_lum, -1);		
		/* end camera specific code */

		cam->stream = STREAM_ON;
		DBG(3, "Stream on");

		for (i = 0; i < PAC207_URBS; i++) {
			err = usb_submit_urb(cam->urb[i], GFP_KERNEL);
			if (err) {
				DBG(1, "usb_submit_urb() failed, error %d",
					err);
				pac207_stop_transfer(cam);
				break;
			}
		}
	}

	return err;
}


static void pac207_stop_transfer(struct pac207_device* cam)
{
	struct usb_device *udev = cam->usbdev;
	s8 i;
	int err = 0;

	if (cam->stream == STREAM_OFF)
		return;

	/* gspca stopN methode code here */
	pac207_write_reg(cam, 0x40, 0x00); /* Stop ISO pipe */
	pac207_write_reg(cam, 0x41, 0x00); /* Turn of LED */
	pac207_write_reg(cam, 0x0f, 0x00); /* Power Control */
	/* end camera specific code */

	pac207_kill_and_free_urbs(cam);

	err = usb_set_interface(udev, 0, 0); /* 0 Mb/s */
	if (err && err != -ENODEV)
		DBG(1, "stop_transfer: usb_set_interface() failed, error: %d",
			err);

	/* gspca stop0 methode code here */

	cam->frame_current = NULL;
	cam->stream = STREAM_OFF;
	DBG(3, "Stream off");
}

/*****************************************************************************/

static int pac207_init(struct pac207_device* cam)
{
	/* gspca configure method code here*/
	pac207_write_reg(cam, 0x41, 0x00); /* 00 Bit_0=Image Format, Bit_1=LED, Bit_2=Compression test mode enable */
	pac207_write_reg(cam, 0x0f, 0x00); /* Power Control */
	pac207_write_reg(cam, 0x11, 0x30); /* Analog Bias */

	return 0;
}

/*****************************************************************************/

static void pac207_release_resources(struct kref *kref)
{
	struct pac207_device *cam = container_of(kref, struct pac207_device,
						 kref);
	DBG(2, "V4L2 device /dev/video%d deregistered", cam->v4ldev->minor);
	video_set_drvdata(cam->v4ldev, NULL);
	video_unregister_device(cam->v4ldev);
	usb_put_dev(cam->usbdev);
	kfree(cam->control_buffer);
	kfree(cam);
}


static int pac207_open(struct inode* inode, struct file* filp)
{
	struct pac207_device* cam;
	int err = 0;

	/* usb driver disconnect may be running */
	if (!mutex_trylock(&pac207_dev_lock))
		return -EAGAIN;

	cam = video_get_drvdata(video_devdata(filp));

	kref_get(&cam->kref);

	if (cam->users) {
		err = -EBUSY;
			goto out;
	}

	/* gspca init methode code here */

	filp->private_data = cam;
	cam->users++;
	cam->io = IO_NONE;
	cam->nreadbuffers = PAC207_DEFAULT_READBUFFERS;
	cam->frame_count = 0;
	cam->brightness = PAC207_BRIGHTNESS_DEFAULT;
	cam->exposure = PAC207_EXPOSURE_DEFAULT;
	cam->gain = PAC207_GAIN_DEFAULT;
	cam->autogain = 1;
	/* init the frame queues */
	pac207_empty_framequeues(cam);

	DBG(3, "Video device /dev/video%d is open", cam->v4ldev->minor);

out:
	if (err)
		kref_put(&cam->kref, pac207_release_resources);
	mutex_unlock(&pac207_dev_lock);
	return err;
}


static int pac207_release(struct inode* inode, struct file* filp)
{
	struct pac207_device* cam;

	mutex_lock(&pac207_dev_lock);

	cam = video_get_drvdata(video_devdata(filp));

	pac207_stop_transfer(cam);
	pac207_release_buffers(cam);
	cam->users--;

	DBG(3, "Video device /dev/video%d closed", cam->v4ldev->minor);

	kref_put(&cam->kref, pac207_release_resources);

 	mutex_unlock(&pac207_dev_lock);

	return 0;
}


static ssize_t
pac207_read(struct file* filp, char __user * buf, size_t count, loff_t* f_pos)
{
	struct pac207_device* cam = video_get_drvdata(video_devdata(filp));
	struct pac207_frame_t* f, * i;
	unsigned long lock_flags;
	long timeout;
	int err = 0;

	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (cam->io == IO_MMAP) {
		DBG(2, "Close and open the device again to choose the read "
			"method");
		err = -EBUSY;
		goto out;
	}

	if (cam->io == IO_NONE) {
		if (!pac207_request_buffers(cam, cam->nreadbuffers)) {
			DBG(1, "read() failed, not enough memory");
			err = -ENOMEM;
			goto out;
		}

		pac207_queue_unusedframes(cam);

		if ((err = pac207_start_transfer(cam)))
			goto out;

		cam->io = IO_READ;
	}

	/* If the inqueue is depleted, chances are there are some rather old
	   frames in the outqueue (for example an application doing one read
	   every minute), so flush it. */
	if (list_empty(&cam->inqueue)) {
		spin_lock_irqsave(&cam->queue_lock, lock_flags);
		list_for_each_entry(f, &cam->outqueue, frame)
			f->state = F_UNUSED;
		INIT_LIST_HEAD(&cam->outqueue);
		spin_unlock_irqrestore(&cam->queue_lock, lock_flags);
		pac207_queue_unusedframes(cam);
	}

	if (!count)
		goto out;

	if (list_empty(&cam->outqueue)) {
		if (filp->f_flags & O_NONBLOCK) {
			err = -EAGAIN;
			goto out;
		}
		timeout = wait_event_interruptible_timeout(
				cam->wait_frame, !list_empty(&cam->outqueue),
				msecs_to_jiffies(PAC207_FRAME_TIMEOUT) );
		if (timeout <= 0) {
			err = (timeout < 0)? timeout : -EIO;
			goto out;
		}
	}

	pac207_do_auto_gain(cam);

	spin_lock_irqsave(&cam->queue_lock, lock_flags);
	f = list_entry(cam->outqueue.next, struct pac207_frame_t, frame);
	list_del(cam->outqueue.next);
	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);

	if (count > f->buf.bytesused)
		count = f->buf.bytesused;

	if (copy_to_user(buf, f->bufmem, count))
		err = -EFAULT;
	else
		*f_pos += count;

	f->state = F_UNUSED;
	pac207_queue_unusedframes(cam);

out:
	mutex_unlock(&cam->fileop_mutex);

	return err ? err : count;
}


static unsigned int pac207_poll(struct file *filp, poll_table *wait)
{
	struct pac207_device* cam = video_get_drvdata(video_devdata(filp));
	struct pac207_frame_t* f;
	unsigned long lock_flags;
	unsigned int mask = 0;

	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return POLLERR;

	if (cam->io == IO_NONE) {
		if (!pac207_request_buffers(cam, cam->nreadbuffers)) {
			DBG(1, "poll() failed, not enough memory");
			mask = POLLERR;
			goto out;
		}

		pac207_queue_unusedframes(cam);

		if (pac207_start_transfer(cam)) {
			DBG(1, "poll() failed, start transfer failed");
			mask = POLLERR;
			goto out;
		}

		cam->io = IO_READ;
	}

	if (cam->io == IO_READ) {
		/* If the inqueue is depleted, read will flush the outqueue,
		   so do that here, otherwise read will still block. */
		if (list_empty(&cam->inqueue)) {
			spin_lock_irqsave(&cam->queue_lock, lock_flags);
			list_for_each_entry(f, &cam->outqueue, frame)
				f->state = F_UNUSED;
			INIT_LIST_HEAD(&cam->outqueue);
			spin_unlock_irqrestore(&cam->queue_lock, lock_flags);
			pac207_queue_unusedframes(cam);
		}
	}

	poll_wait(filp, &cam->wait_frame, wait);

	if (!list_empty(&cam->outqueue))
		mask |= POLLIN | POLLRDNORM;

out:
	mutex_unlock(&cam->fileop_mutex);
	return mask;
}


static void pac207_vm_open(struct vm_area_struct* vma)
{
	struct pac207_frame_t* f = vma->vm_private_data;
	f->vma_use_count++;
}


static void pac207_vm_close(struct vm_area_struct* vma)
{
	/* NOTE: buffers are not freed here */
	struct pac207_frame_t* f = vma->vm_private_data;
	f->vma_use_count--;
}


static struct vm_operations_struct pac207_vm_ops = {
	.open = pac207_vm_open,
	.close = pac207_vm_close,
};


static int pac207_mmap(struct file* filp, struct vm_area_struct *vma)
{
	struct pac207_device* cam = video_get_drvdata(video_devdata(filp));
	unsigned long size = vma->vm_end - vma->vm_start,
			  start = vma->vm_start;
	void *pos;
	u32 i;
	int err = 0;

	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (!(vma->vm_flags & (VM_WRITE | VM_READ))) {
		err = -EACCES;
		goto out;
	}

	if (cam->io != IO_MMAP ||
			size != PAGE_ALIGN(cam->frame[0].buf.length)) {
		err = -EINVAL;
		goto out;
	}

	for (i = 0; i < cam->nbuffers; i++) {
		if ((cam->frame[i].buf.m.offset>>PAGE_SHIFT) == vma->vm_pgoff)
			break;
	}
	if (i == cam->nbuffers) {
		err = -EINVAL;
		goto out;
	}

	vma->vm_flags |= VM_IO;
	vma->vm_flags |= VM_RESERVED;

	pos = cam->frame[i].bufmem;
	while (size > 0) { /* size is page-aligned */
		if (vm_insert_page(vma, start, vmalloc_to_page(pos))) {
			err = -EAGAIN;
			goto out;
		}
		start += PAGE_SIZE;
		pos += PAGE_SIZE;
		size -= PAGE_SIZE;
	}

	vma->vm_ops = &pac207_vm_ops;
	vma->vm_private_data = &cam->frame[i];
	pac207_vm_open(vma);

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}

static const struct file_operations pac207_fops = {
	.owner = THIS_MODULE,
	.open =	pac207_open,
	.release = pac207_release,
	.ioctl = video_ioctl2,
	.compat_ioctl = v4l_compat_ioctl32,
	.read =	pac207_read,
	.poll =	pac207_poll,
	.mmap =	pac207_mmap,
	.llseek =  no_llseek,
};

/*****************************************************************************/

static int
pac207_vidioc_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
{
	struct pac207_device* cam = fh;

	cap->version = LINUX_VERSION_CODE;
	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
				V4L2_CAP_STREAMING;
	strcpy(cap->driver, PAC207_NAME);
	strlcpy(cap->card, cam->v4ldev->name, sizeof(cap->card));
	if (usb_make_path(cam->usbdev, cap->bus_info, sizeof(cap->bus_info))
			< 0)
		strlcpy(cap->bus_info, cam->usbdev->dev.bus_id,
			sizeof(cap->bus_info));

	return 0;
}


static int
pac207_vidioc_enuminput(struct file *file, void *fh, struct v4l2_input *inp)
{
	if (inp->index)
		return -EINVAL;

	memset(inp, 0, sizeof(*inp));
	strcpy(inp->name, "Camera");
	inp->type = V4L2_INPUT_TYPE_CAMERA;

	return 0;
}


static int
pac207_vidioc_g_input(struct file *file, void *fh, unsigned int *i)
{
	*i = 0;

	return 0;
}


static int
pac207_vidioc_s_input(struct file *file, void *fh, unsigned int i)
{
	if (i != 0)
		return -EINVAL;

	return 0;
}


static int
pac207_vidioc_query_ctrl(struct file *file, void *fh, struct v4l2_queryctrl *a)
{
	const struct v4l2_queryctrl qctl[] = { {
		.id = V4L2_CID_BRIGHTNESS,
		.type = V4L2_CTRL_TYPE_INTEGER,
		.name = "brightness",
		.minimum = PAC207_BRIGHTNESS_MIN,
		.maximum = PAC207_BRIGHTNESS_MAX,
		.step = 1,
		.default_value = PAC207_BRIGHTNESS_DEFAULT,
		.flags = 0,
	}, {
		.id = V4L2_CID_EXPOSURE,
		.type = V4L2_CTRL_TYPE_INTEGER,
		.name = "exposure",
		.minimum = PAC207_EXPOSURE_MIN,
		.maximum = PAC207_EXPOSURE_MAX,
		.step = 1,
		.default_value = PAC207_EXPOSURE_DEFAULT,
		.flags = 0,
	}, {
		.id = V4L2_CID_AUTOGAIN,
		.type = V4L2_CTRL_TYPE_BOOLEAN,
		.name = "autogain",
		.minimum = 0,
		.maximum = 1,
		.step = 1,
		.default_value = 1,
		.flags = 0,
	}, {
		.id = V4L2_CID_GAIN,
		.type = V4L2_CTRL_TYPE_INTEGER,
		.name = "gain",
		.minimum = PAC207_GAIN_MIN,
		.maximum = PAC207_GAIN_MAX,
		.step = 1,
		.default_value = PAC207_GAIN_DEFAULT,
		.flags = 0,
	} };
	int i;
	
	for (i = 0; i < ARRAY_SIZE(qctl); i++)
		if (qctl[i].id == a->id) {
			memcpy(a, &qctl[i], sizeof(qctl[0]));
			return 0;
		}

	return -EINVAL;
}


static int
pac207_vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *a)
{
	struct pac207_device* cam = fh;

	switch (a->id) {
		case V4L2_CID_BRIGHTNESS:
			a->value = cam->brightness;
			break;
		case V4L2_CID_EXPOSURE:
			a->value = cam->exposure;
			break;
		case V4L2_CID_AUTOGAIN:
			a->value = cam->autogain;
			break;
		case V4L2_CID_GAIN:
			a->value = cam->gain;
			break;
		default:
			return -EINVAL;
	}

	return 0;
}


static int
pac207_vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
{
	struct pac207_device* cam = fh;
	int new_value = a->value;
	int err = 0;
	
	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if ((err = pac207_vidioc_g_ctrl(file, fh, a)))
		goto out;
	
	if (a->value == new_value)
		goto out;

	/* don't allow mucking with gain / exposure when using autogain */
	if (cam->autogain && (a->id == V4L2_CID_GAIN ||
			a->id == V4L2_CID_EXPOSURE)) {
		err = -EINVAL;
		goto out;
	}

	switch (a->id) {
		case V4L2_CID_BRIGHTNESS:
			cam->brightness = new_value;
			pac207_write_reg(cam, 0x0008, cam->brightness);
			/* give brightness change time to take effect before
			   doing autogain based on the new brightness */
			cam->autogain_ignore_frames =
						PAC207_AUTOGAIN_IGNORE_FRAMES;
			break;

		case V4L2_CID_EXPOSURE:
			cam->exposure = new_value;
			pac207_write_reg(cam, 0x0002, cam->exposure);
			break;

		case V4L2_CID_AUTOGAIN:
			cam->autogain = new_value;
			/* when switching to autogain set defaults to make sure
			   we are on a valid point of the autogain gain /
			   exposure knee graph, and give this change time to
			   take effect before doing autogain. */
			if (cam->autogain) {
				cam->exposure = PAC207_EXPOSURE_DEFAULT;
				cam->gain = PAC207_GAIN_DEFAULT;
				cam->autogain_ignore_frames =
						PAC207_AUTOGAIN_IGNORE_FRAMES;
				pac207_write_reg(cam, 0x0002, cam->exposure);
				pac207_write_reg(cam, 0x000e, cam->gain);
			}
			break;

		case V4L2_CID_GAIN:
			cam->gain = new_value;
			pac207_write_reg(cam, 0x000e, cam->gain);
			break;
	
		/* no default needed already checked in pac207_vidioc_g_ctrl */
	}

	pac207_write_reg(cam, 0x13, 0x01); /* load registers to sensor */
	pac207_write_reg(cam, 0x1c, 0x01); /* not documented */

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}


static int
pac207_vidioc_enum_fmt_cap(struct file *file, void *fh, struct v4l2_fmtdesc *f)
{
	if (f->index != 0)
		return -EINVAL;

	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	f->flags = 0;
	strcpy(f->description, "bayer rgb");
	f->pixelformat = V4L2_PIX_FMT_SBGGR8;
	memset(&f->reserved, 0, sizeof(f->reserved));

	return 0;
}


static int
pac207_vidioc_g_fmt_cap(struct file *file, void *fh, struct v4l2_format *f)
{
	struct pac207_device* cam = fh;
	
	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	memcpy(&(f->fmt.pix), &pac207_pix_fmt[cam->mode],
		sizeof(pac207_pix_fmt[0]));

	mutex_unlock(&cam->fileop_mutex);

	return 0;
}


static int
pac207_vidioc_try_fmt_cap(struct file *file, void *fh, struct v4l2_format *f)
{
	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_SBGGR8)
		return -EINVAL;

	if (f->fmt.pix.width >= 352 && f->fmt.pix.height >= 288)
		memcpy(&(f->fmt.pix), &pac207_pix_fmt[0],
			sizeof(pac207_pix_fmt[0]));
	else
		memcpy(&(f->fmt.pix), &pac207_pix_fmt[1],
			sizeof(pac207_pix_fmt[0]));

	return 0;
}


static int
pac207_vidioc_s_fmt_cap(struct file *file, void *fh, struct v4l2_format *f)
{
	struct pac207_device* cam = fh;
	int err = 0;

	if ((err = pac207_vidioc_try_fmt_cap(file, fh, f)))
		return err;

	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (cam->stream != STREAM_OFF) {
		err = -EBUSY;
		goto out;
	}

	if (f->fmt.pix.width == pac207_pix_fmt[0].width)
		cam->mode = 0;
	else
		cam->mode = 1;

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}


static int
pac207_vidioc_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *b)
{
	u32 i;
	struct pac207_device* cam = fh;
	int err = 0;

	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
			b->memory != V4L2_MEMORY_MMAP)
		return -EINVAL;

	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (cam->io == IO_READ || cam->stream == STREAM_ON) {
		if (cam->io == IO_READ)
			DBG(2, "Close and open the device again to choose the "
				"mmap I/O method");
		err = -EBUSY;
		goto out;
	}

	for (i = 0; i < cam->nbuffers; i++)
		if (cam->frame[i].vma_use_count) {
			DBG(2, "VIDIOC_REQBUFS failed. "
				   "Previous buffers are still mapped.");
			err = -EBUSY;
			goto out;
		}

	pac207_release_buffers(cam);
	if (b->count)
		b->count = pac207_request_buffers(cam, b->count);

	cam->io = b->count ? IO_MMAP : IO_NONE;

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}


static int
pac207_vidioc_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
{
	struct pac207_device* cam = fh;
	int err = 0;
	
	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
			b->index >= cam->nbuffers || cam->io != IO_MMAP) {
		err = -EINVAL;
		goto out;
	}

	memcpy(b, &cam->frame[b->index].buf, sizeof(*b));

	if (cam->frame[b->index].vma_use_count)
		b->flags |= V4L2_BUF_FLAG_MAPPED;

	if (cam->frame[b->index].state == F_DONE)
		b->flags |= V4L2_BUF_FLAG_DONE;
	else if (cam->frame[b->index].state != F_UNUSED)
		b->flags |= V4L2_BUF_FLAG_QUEUED;

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}


static int
pac207_vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
{
	struct pac207_device* cam = fh;
	unsigned long lock_flags;
	int err = 0;
	
	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
			b->index >= cam->nbuffers ||
			cam->io != IO_MMAP ||
			cam->frame[b->index].state != F_UNUSED) {
		err = -EINVAL;
		goto out;
	}

	cam->frame[b->index].state = F_QUEUED;

	spin_lock_irqsave(&cam->queue_lock, lock_flags);
	list_add_tail(&cam->frame[b->index].frame, &cam->inqueue);
	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}


static int
pac207_vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
{
	struct pac207_device* cam = fh;
	struct pac207_frame_t *f;
	unsigned long lock_flags;
	long timeout;
	int err = 0;
	
	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP ||
			cam->stream == STREAM_OFF) {
		err = -EINVAL;
		goto out;
	}

	if (list_empty(&cam->outqueue)) {
		if (file->f_flags & O_NONBLOCK) {
			err = -EAGAIN;
			goto out;
		}
		timeout = wait_event_interruptible_timeout(cam->wait_frame,
				!list_empty(&cam->outqueue),
				msecs_to_jiffies(PAC207_FRAME_TIMEOUT) );
		if (timeout <= 0) {
			err = (timeout < 0)? timeout : -EIO;
			goto out;
		}
	}

	pac207_do_auto_gain(cam);

	spin_lock_irqsave(&cam->queue_lock, lock_flags);
	f = list_entry(cam->outqueue.next, struct pac207_frame_t, frame);
	list_del(cam->outqueue.next);
	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);

	f->state = F_UNUSED;

	memcpy(b, &f->buf, sizeof(*b));
	if (f->vma_use_count)
		b->flags |= V4L2_BUF_FLAG_MAPPED;

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}


static int
pac207_vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
{
	struct pac207_device* cam = fh;
	int err = 0;
	
	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP) {
		err = -EINVAL;
		goto out;
	}

	err = pac207_start_transfer(cam);

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}


static int
pac207_vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
{
	struct pac207_device* cam = fh;
	int err = 0;
	
	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP) {
		err = -EINVAL;
		goto out;
	}

	pac207_stop_transfer(cam);
	pac207_empty_framequeues(cam);

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}


static int
pac207_vidioc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
{
	struct pac207_device* cam = fh;

	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
		return -EINVAL;

	a->parm.capture.extendedmode = 0;
	a->parm.capture.readbuffers = cam->nreadbuffers;

	return 0;
}


static int
pac207_vidioc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
{
	struct pac207_device* cam = fh;

	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
		return -EINVAL;

	a->parm.capture.extendedmode = 0;

	if (a->parm.capture.readbuffers == 0)
		a->parm.capture.readbuffers = cam->nreadbuffers;

	if (a->parm.capture.readbuffers > PAC207_MAX_FRAMES)
		a->parm.capture.readbuffers = PAC207_MAX_FRAMES;

	cam->nreadbuffers = a->parm.capture.readbuffers;

	return 0;
}

/*****************************************************************************/

static int
pac207_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
{
	struct usb_device *udev = interface_to_usbdev(intf);
	struct pac207_device* cam;
	int err = 0;
	u8 idreg[] = { 0, 0 };

	if (!(cam = kzalloc(sizeof(struct pac207_device), GFP_KERNEL)))
		return -ENOMEM;

	cam->usbdev = udev;

	if (!(cam->control_buffer = kzalloc(4, GFP_KERNEL))) {
		err = -ENOMEM;
		goto fail;
	}

	idreg[0] = pac207_read_reg(cam, 0x0000);
	idreg[1] = pac207_read_reg(cam, 0x0001);
	idreg[0] = ((idreg[0] & 0x0F) << 4) | ((idreg[1] & 0xf0) >> 4);
	idreg[1] = idreg[1] & 0x0f;
	DBG(2, "Pixart Sensor ID 0x%02X Chips ID 0x%02X !!\n", idreg[0],
		idreg[1]);

	if (idreg[0] != 0x27) {
		DBG(1, "Error invalid sensor ID!");
		err = -ENODEV;
		goto fail;
	}
		
	if (pac207_init(cam)) {
		DBG(1, "Error cam initialization failed");
		err = -ENODEV;
		goto fail;
	}

	if (!(cam->v4ldev = video_device_alloc())) {
		DBG(1, "video_device_alloc() failed");
		err = -ENOMEM;
		goto fail;
	}

	DBG(2, "Pixart PAC207BCA Image Processor and Control Chip detected "
		   "(vid/pid 0x%04X:0x%04X)",id->idVendor, id->idProduct);

	strcpy(cam->v4ldev->name, "Pixart PAC207BCA USB Camera");
	cam->v4ldev->owner = THIS_MODULE;
	cam->v4ldev->type = VID_TYPE_CAPTURE | VID_TYPE_SCALES;
	cam->v4ldev->fops = &pac207_fops;
	cam->v4ldev->release = video_device_release;
/*	cam->v4ldev->debug = V4L2_DEBUG_IOCTL_ARG; */
	cam->v4ldev->vidioc_querycap = pac207_vidioc_querycap;
	cam->v4ldev->vidioc_enum_input = pac207_vidioc_enuminput;
	cam->v4ldev->vidioc_g_input = pac207_vidioc_g_input;
	cam->v4ldev->vidioc_s_input = pac207_vidioc_s_input;
	cam->v4ldev->vidioc_queryctrl = pac207_vidioc_query_ctrl;
	cam->v4ldev->vidioc_g_ctrl = pac207_vidioc_g_ctrl;
	cam->v4ldev->vidioc_s_ctrl = pac207_vidioc_s_ctrl;
	cam->v4ldev->vidioc_enum_fmt_cap = pac207_vidioc_enum_fmt_cap;
	cam->v4ldev->vidioc_g_fmt_cap = pac207_vidioc_g_fmt_cap;
	cam->v4ldev->vidioc_s_fmt_cap = pac207_vidioc_s_fmt_cap;
	cam->v4ldev->vidioc_try_fmt_cap = pac207_vidioc_try_fmt_cap;
	cam->v4ldev->vidioc_reqbufs = pac207_vidioc_reqbufs;
	cam->v4ldev->vidioc_querybuf = pac207_vidioc_querybuf;
	cam->v4ldev->vidioc_qbuf = pac207_vidioc_qbuf;
	cam->v4ldev->vidioc_dqbuf = pac207_vidioc_dqbuf;
	cam->v4ldev->vidioc_streamon = pac207_vidioc_streamon;
	cam->v4ldev->vidioc_streamoff = pac207_vidioc_streamoff;
	cam->v4ldev->vidioc_g_parm = pac207_vidioc_g_parm;
	cam->v4ldev->vidioc_s_parm = pac207_vidioc_s_parm;
	video_set_drvdata(cam->v4ldev, cam);

	mutex_init(&cam->fileop_mutex);
	spin_lock_init(&cam->queue_lock);
	init_waitqueue_head(&cam->wait_frame);
	kref_init(&cam->kref);

	usb_get_dev(cam->usbdev);

	err = video_register_device(cam->v4ldev, VFL_TYPE_GRABBER, -1);
	if (err) {
		DBG(1, "V4L2 device registration failed");
		usb_put_dev(cam->usbdev);
		goto fail;
	}

	DBG(2, "V4L2 device registered as /dev/video%d", cam->v4ldev->minor);

	usb_set_intfdata(intf, cam);

	return 0;

fail:
	if (cam) {
		kfree(cam->control_buffer);
		if (cam->v4ldev)
			video_device_release(cam->v4ldev);
		kfree(cam);
	}
	return err;
}


static void pac207_usb_disconnect(struct usb_interface* intf)
{
	struct pac207_device* cam;

	mutex_lock(&pac207_dev_lock);

	cam = usb_get_intfdata(intf);

	DBG(2, "Disconnecting %s...", cam->v4ldev->name);

	/* No need to keep the urbs and their buffers allocated
	   (no-op when not open and streaming) */
	mutex_lock(&cam->fileop_mutex);
	pac207_stop_transfer(cam);
	mutex_unlock(&cam->fileop_mutex);

	kref_put(&cam->kref, pac207_release_resources);

	mutex_unlock(&pac207_dev_lock);
}


static struct usb_driver pac207_usb_driver = {
	.name =	PAC207_NAME,
	.id_table = pac207_id_table,
	.probe = pac207_usb_probe,
	.disconnect = pac207_usb_disconnect,
};

/*****************************************************************************/

static void pac207_init_decompress_table(void)
{
	int i;
	u8 is_abs, len;
	s8 val;

	for (i = 0; i < 256; i++) {
		is_abs = 0;
		val = 0;
		len = 0;
		if ((i & 0xC0) == 0) {
			/* code 00 */
			val = 0;
			len = 2;
		} else if ((i & 0xC0) == 0x40) {
			/* code 01 */
			val = -5;
			len = 2;
		} else if ((i & 0xC0) == 0x80) {
			/* code 10 */
			val = +5;
			len = 2;
		} else if ((i & 0xF0) == 0xC0) {
			/* code 1100 */
			val = -10;
			len = 4;
		} else if ((i & 0xF0) == 0xD0) {
			/* code 1101 */
			val = +10;
			len = 4;
		} else if ((i & 0xF8) == 0xE0) {
			/* code 11100 */
			val = -15;
			len = 5;
		} else if ((i & 0xF8) == 0xE8) {
			/* code 11101 */
			val = +15;
			len = 5;
		} else if ((i & 0xFC) == 0xF0) {
			/* code 111100 */
			val = -20;
			len = 6;
		} else if ((i & 0xFC) == 0xF4) {
			/* code 111101 */
			val = +20;
			len = 6;
		} else if ((i & 0xF8) == 0xF8) {
			/* code 11111xxxxxx */
			is_abs = 1;
			val = 0;
			len = 5;
		}
		pac207_decompress_table[i].is_abs = is_abs;
		pac207_decompress_table[i].val = val;
		pac207_decompress_table[i].len = len;
	}
}

/*****************************************************************************/

static int __init pac207_module_init(void)
{
	int err = 0;

	pac207_init_decompress_table();

	if ((err = usb_register(&pac207_usb_driver)))
		printk(KERN_ERR PAC207_NAME
			": usb_register() failed, error: %d", err);

	return err;
}


static void __exit pac207_module_exit(void)
{
	usb_deregister(&pac207_usb_driver);
}


module_init(pac207_module_init);
module_exit(pac207_module_exit);

--------------070002070508040808040808
Content-Type: text/plain;
 name="pac207.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pac207.h"

/***************************************************************************
 * Video4Linux2 driver for Pixart PAC207BCA Camera bridge and sensor       *
 *                                                                         *
 * Copyright (C) 2008 by Hans de Goede <j.w.r.degoede@hhs.nl>              *
 * Buffer management code taken from the Video4Linux2 zc030x driver:       *
 * Copyright (C) 2006-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
 * PAC207BCA code derived from the gspca Pixart PAC207BCA library:         *
 * Copyright (C) 2005 Thomas Kaiser thomas@kaiser-linux.li                 *
 * Copyleft (C) 2005 Michel Xhaard mxhaard@magic.fr                        *
 *                                                                         *
 * This program is free software; you can redistribute it and/or modify    *
 * it under the terms of the GNU General Public License as published by    *
 * the Free Software Foundation; either version 2 of the License, or       *
 * (at your option) any later version.                                     *
 *                                                                         *
 * This program is distributed in the hope that it will be useful,         *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 * GNU General Public License for more details.                            *
 *                                                                         *
 * You should have received a copy of the GNU General Public License       *
 * along with this program; if not, write to the Free Software             *
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
 ***************************************************************************/

#ifndef _PAC207_H_
#define _PAC207_H_

#include <linux/version.h>
#include <linux/usb.h>
#include <linux/videodev2.h>
#include <media/v4l2-common.h>
#include <linux/device.h>
#include <linux/list.h>
#include <linux/spinlock.h>
#include <linux/time.h>
#include <linux/wait.h>
#include <linux/types.h>
#include <linux/param.h>
#include <linux/mutex.h>
#include <linux/rwsem.h>
#include <linux/stddef.h>
#include <linux/string.h>
#include <linux/kref.h>

/*****************************************************************************/

#define PAC207_DEBUG_LEVEL		2
#define PAC207_MAX_FRAMES		32
#define PAC207_URBS			4 /* 2 is problematic on some systems */
#define PAC207_ISO_PACKETS		16 /* was 7, gspca uses 16 */
#define PAC207_URB_TIMEOUT		msecs_to_jiffies(2 * PAC207_ISO_PACKETS)
#define PAC207_CTRL_TIMEOUT		100
#define PAC207_FRAME_TIMEOUT		2000 /* ms */
#define PAC207_NAME			"pac207"

#define PAC207_BRIGHTNESS_MIN		0
#define PAC207_BRIGHTNESS_MAX		255
#define PAC207_BRIGHTNESS_DEFAULT	4 /* power on default: 4 */

#define PAC207_EXPOSURE_MIN		4
#define PAC207_EXPOSURE_MAX		26
#define PAC207_EXPOSURE_DEFAULT		4 /* power on default: 3 ?? */
#define PAC207_EXPOSURE_KNEE		15

#define PAC207_GAIN_MIN			0
#define PAC207_GAIN_MAX			31
#define PAC207_GAIN_DEFAULT         	9 /* power on default: 9 */
#define PAC207_GAIN_KNEE		20

#define PAC207_AUTOGAIN_DEADZONE	10
/* We calculating the autogain at the end of the transfer of a frame, at this
   moment a frame with the old settings is being transmitted, and a frame is
   being captured with the old settings. So if we adjust the autogain we must
   ignore atleast the 2 next frames for the new settings to come into effect
   before doing any other adjustments */
#define PAC207_AUTOGAIN_IGNORE_FRAMES	3

#define PAC207_DEFAULT_READBUFFERS	3
/*****************************************************************************/

enum pac207_frame_state {
	F_UNUSED,
	F_QUEUED,
	F_GRABBING,
	F_DONE,
	F_ERROR,
};

struct pac207_frame_t {
	void* bufmem;
	struct v4l2_buffer buf;
	enum pac207_frame_state state;
	struct list_head frame;
	unsigned long vma_use_count;
};

enum pac207_io_method {
	IO_NONE,
	IO_READ,
	IO_MMAP,
};

enum pac207_stream_state {
	STREAM_OFF,
	STREAM_ON,
};

enum pac207_line_state {
	LINE_HEADER1,
	LINE_HEADER2,
	LINE_UNCOMPRESSED,
	LINE_COMPRESSED,
};

struct pac207_decompress_table_t {
	u8 is_abs;
	u8 len;
	s8 val;
};
                        
struct pac207_decoder_state {
	u16 line_read;
	u16 line_marker;
	u8 line_state;
	u8 header_read;
	u8 remaining_bits;
	s8 no_remaining_bits;
	u8 get_abs;
	u8 discard_byte;
};

static DEFINE_MUTEX(pac207_dev_lock);

struct pac207_device {
	struct video_device* v4ldev;

	struct usb_device* usbdev;
	struct urb* urb[PAC207_URBS];
	u8* control_buffer;

	struct pac207_frame_t *frame_current, frame[PAC207_MAX_FRAMES];
	struct list_head inqueue, outqueue;
	struct kref kref;
	struct mutex fileop_mutex;
	spinlock_t queue_lock;
	wait_queue_head_t wait_frame;

	struct pac207_decoder_state decoder_state;

	u32 frame_count, nbuffers, nreadbuffers;

	u8 users;
	u8 mode;

	u8 io;
	u8 stream;

	u8 brightness;
	u8 exposure;
	u8 autogain;
	u8 gain;

	u8 sof_read;
	u8 autogain_ignore_frames;

	atomic_t avg_lum;
};

/*****************************************************************************/

#undef DBG
#define DBG(level, fmt, args...)                                              \
do {                                                                          \
	if (debug >= (level)) {                                               \
		if ((level) == 1)                                             \
			dev_err(&cam->usbdev->dev, fmt "\n", ## args);        \
		else if ((level) == 2)                                        \
			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
		else if ((level) >= 3)                                        \
			dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n",   \
				 __FILE__, __FUNCTION__, __LINE__ , ## args); \
	}                                                                     \
} while (0)

#endif /* _PAC207_H_ */

--------------070002070508040808040808
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------070002070508040808040808--
