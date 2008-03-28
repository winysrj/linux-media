Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SLsSU3023315
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 17:54:28 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SLsBMp005626
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 17:54:13 -0400
Message-ID: <47ED68E3.7040400@hhs.nl>
Date: Fri, 28 Mar 2008 22:53:39 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: spca50x-devs@lists.sourceforge.net, video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="------------080201090902030007030801"
Cc: fedora-kernel-list@redhat.com
Subject: [New Driver]: usbvideo2 webcam core + pac207 driver using it.
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
--------------080201090902030007030801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

<Sorry, this time with attachments>

Hi All,

As explained in my introduction mail I've been working on a standalone v4l2
driver for pac207 based usb webcams. I've attached the hopefully pretty clean
result to this mail.

This is the promised split version of the pac207 driver I've been working on, I
would like to ask everyone to take a good look at this, as I plan to base a
number of other (gspca derived) v4l2 drivers on this same core.

I'm currently posting these as .c files for easy reading and compilation /
testing, but I still hope to get a lot of feedback / a thorough review, esp of
the core <-> pac207 split version as I hope to submit that as a patch for
mainline inclusion soon.

Thanks & Regards,

Hans



--------------080201090902030007030801
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Makefile"

obj-m += usbvideo2.o pac207.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

--------------080201090902030007030801
Content-Type: text/plain;
 name="TODO"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="TODO"

-unlock fileop_mutex while waiting for frame in dqbuf, since when unlocked
 the v4ldev could be unregistered (disconnect) this means that dqbuf should
 be handled outside video2_ioctl()

--------------080201090902030007030801
Content-Type: text/plain;
 name="pac207.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pac207.c"

/***************************************************************************
 * Video4Linux2 driver for Pixart PAC207BCA Camera bridge and sensor       *
 *                                                                         *
 * Copyright (C) 2008 by Hans de Goede <j.w.r.degoede@hhs.nl>              *
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

#include "usbvideo2.h"

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

/*****************************************************************************/

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

struct pac207_data {
	struct pac207_decoder_state decoder_state;

	u8 mode;

	u8 brightness;
	u8 exposure;
	u8 autogain;
	u8 gain;

	u8 sof_read;
	u8 autogain_ignore_frames;

	atomic_t avg_lum;
};

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

int pac207_write_regs(struct usbvideo2_device* cam, u16 index,
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
			0x00, index, kbuffer, length, USBVIDEO2_CTRL_TIMEOUT);
	if (err < 0)
		DBG(1, "Failed to write registers to index 0x%04X, error %d)",
			index, err);

	kfree(kbuffer);

	return err;
}


int pac207_write_reg(struct usbvideo2_device* cam, u16 index, u16 value)
{
	struct usb_device* udev = cam->usbdev;
	int err;

	err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x00, 
			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
			value, index, NULL, 0, USBVIDEO2_CTRL_TIMEOUT);
	if (err && err != -ENODEV)
		DBG(1, "Failed to write a register (index 0x%04X, "
			   "value 0x%02X, error %d)",index, value, err);

	return err;
}


int pac207_read_reg(struct usbvideo2_device* cam, u16 index)
{
	struct usb_device* udev = cam->usbdev;
	u8* buff = cam->control_buffer;
	int res;

	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00,
			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
			0x00, index, buff, 1, USBVIDEO2_CTRL_TIMEOUT);
	if (res < 0)
		DBG(1, "Failed to read a register (index 0x%04X, error %d)",
			index, res);

	return (res >= 0) ? (int)(*buff) : res;
}

/*****************************************************************************/

/* auto gain and exposure algorithm based on the knee algorithm described here:
   http://ytse.tricolour.net/docs/LowLightOptimization.html */
static void pac207_do_auto_gain(struct usbvideo2_device* cam)
{
	int i, steps, desired_avg_lum;
	struct pac207_data *data = cam->cam_data;
	int orig_gain = data->gain;
	int orig_exposure = data->exposure;
	int avg_lum = atomic_read(&data->avg_lum);

	if (!data->autogain || avg_lum == -1)
		return;

	if (data->autogain_ignore_frames > 0) {
		data->autogain_ignore_frames--;
		return;
	}

	/* correct desired lumination for the configured brightness */
	desired_avg_lum = 100 + data->brightness / 2;

	/* If we are of a multiple of deadzone, do multiple step to reach the
	   desired lumination fast (with the risc of a slight overshoot */
	steps = abs(desired_avg_lum - avg_lum) / PAC207_AUTOGAIN_DEADZONE;

	for (i = 0; i < steps; i++) {
		if (avg_lum > desired_avg_lum) {
			if (data->gain > PAC207_GAIN_KNEE) {
				data->gain--;
			} else if (data->exposure > PAC207_EXPOSURE_KNEE) {
				data->exposure--;
			} else if (data->gain > PAC207_GAIN_DEFAULT) {
				data->gain--;
			} else if (data->exposure > PAC207_EXPOSURE_MIN) {
				data->exposure--;
			} else if (data->gain > PAC207_GAIN_MIN) {
				data->gain--;
			} else
				break;
		} else { 
			if (data->gain < PAC207_GAIN_DEFAULT) {
				data->gain++;
			} else if (data->exposure < PAC207_EXPOSURE_KNEE) {
				data->exposure++;
			} else if (data->gain < PAC207_GAIN_KNEE) {
				data->gain++;
			} else if (data->exposure < PAC207_EXPOSURE_MAX) {
				data->exposure++;
			} else if (data->gain < PAC207_GAIN_MAX) {
				data->gain++;
			} else
				break;
		}
	}

	if (data->exposure != orig_exposure || data->gain != orig_gain) {
		if (data->exposure != orig_exposure)
			pac207_write_reg(cam, 0x0002, data->exposure);
		else
			pac207_write_reg(cam, 0x000e, data->gain);
		pac207_write_reg(cam, 0x13, 0x01); /* load registers to sen. */
		pac207_write_reg(cam, 0x1c, 0x01); /* not documented */
		data->autogain_ignore_frames = PAC207_AUTOGAIN_IGNORE_FRAMES;
	}
}

/*****************************************************************************/

static u8 *pac207_find_sof(struct usbvideo2_device* cam, u8 *m,
	unsigned int len, int repeat)
{
	struct pac207_data *data = cam->cam_data;
	unsigned int i;

	/* Search for the SOF marker (fixed part) in the header */
	for (i = 0; i < len; i++) {
		if (m[i] == pac207_sof_marker[data->sof_read]) {
			data->sof_read++;
			if (data->sof_read == sizeof(pac207_sof_marker)) {
				DBG(3, "SOF found, bytes to analyze: %u. Frame"
					"starts at byte #%u", len, i + 1);
				data->sof_read = 0;
				return m + i + 1;
			}
		} else
			data->sof_read = 0;
	}

	return NULL;
}

#define CLIP(color) (unsigned char)(((color)>0xFF)?0xff:(((color)<0)?0:(color)))

/* Note len is deliberately signed here, where it is unsigned everywhere else
   as it gets compared with the signed bitpos and can even become negative! */
static int pac207_decompress_row(struct usbvideo2_device* cam,
	struct usbvideo2_frame_t* f, u8 *cdata, int len)
{
	struct pac207_data *data = cam->cam_data;
	const struct v4l2_pix_format *pix_format = &pac207_pix_fmt[data->mode];
	struct pac207_decoder_state *decoder_state = &data->decoder_state;
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

static void pac207_decode_line_init(struct usbvideo2_device* cam)
{
	struct pac207_data *data = cam->cam_data;
	struct pac207_decoder_state *decoder_state = &data->decoder_state;

	decoder_state->line_read = 0;
	decoder_state->line_state = LINE_HEADER1;
	decoder_state->no_remaining_bits = 0;
	decoder_state->get_abs = 0; 
}

static void pac207_decode_frame_init(struct usbvideo2_device* cam)
{
	struct pac207_data *data = cam->cam_data;
	struct pac207_decoder_state *decoder_state = &data->decoder_state;

	decoder_state->header_read = 0;
	decoder_state->discard_byte = 0;

	pac207_decode_line_init(cam);
}

static int pac207_decode(struct usbvideo2_device *cam,
	struct usbvideo2_frame_t *f, u8 *data, unsigned int len)
{
	struct pac207_data *cam_data = cam->cam_data;
	struct pac207_decoder_state *decoder_state = &cam_data->decoder_state;
	const struct v4l2_pix_format *pix_format =
					&pac207_pix_fmt[cam_data->mode];
	unsigned int needed = 0;

	/* first 11 bytes after sof marker: frame header */
	if (decoder_state->header_read < 11 ) {
		/* get average lumination from frame header (byte 5) */
		if (decoder_state->header_read < 5 ) {
			needed = 5 - decoder_state->header_read;
			if (len >= needed)
				atomic_set(&cam_data->avg_lum, data[needed-1]);
		}
		/* skip the rest of the header */
		needed = 11 - decoder_state->header_read;
		if (len <= needed) {
			decoder_state->header_read += len;
			return 0;
		}
		data += needed;
		len -= needed;
		decoder_state->header_read = 11;
	}

	while (len) {
		if (decoder_state->discard_byte) {
			data++;
			len--;
			decoder_state->discard_byte = 0;
			continue;
		}

		switch (decoder_state->line_state) {
		case LINE_HEADER1:
			decoder_state->line_marker = data[0] << 8;
			decoder_state->line_state = LINE_HEADER2;
			needed = 1;
			break;
		case LINE_HEADER2:
			decoder_state->line_marker |= data[0];
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
			memcpy(f->bufmem + f->buf.bytesused, data, needed);
			f->buf.bytesused += needed;
			decoder_state->line_read += needed;
			break;
		case LINE_COMPRESSED:
			needed = len -
				pac207_decompress_row(cam, f, data, len);
			break;
		}

		data += needed;
		len -= needed;

		if (decoder_state->line_read == pix_format->width) {
			if (f->buf.bytesused == cam->imagesize) {
				/* eureka we've got a frame */
				f->state = F_DONE;
				return 1;
			}
			pac207_decode_line_init(cam);
		}
	}

	return 0;
}

/*****************************************************************************/

static int pac207_start_transfer(struct usbvideo2_device* cam)
{
	u8 mode;
	struct pac207_data *data = cam->cam_data;

	pac207_write_reg(cam, 0x0f, 0x10); /* Power control (Bit 6-0) */
	pac207_write_regs(cam, 0x0002, pac207_sensor_init[0], 8);
	pac207_write_regs(cam, 0x000a, pac207_sensor_init[1], 8);
	pac207_write_regs(cam, 0x0012, pac207_sensor_init[2], 8);
	pac207_write_regs(cam, 0x0040, pac207_sensor_init[3], 8);
	pac207_write_regs(cam, 0x0042, pac207_sensor_init[4], 8);
	pac207_write_regs(cam, 0x0048, PacReg72, 4);
		
	pac207_write_reg(cam, 0x4a, 0x88); /* Compression Balance size */
	pac207_write_reg(cam, 0x4b, 0x00); /* Sram test value */
	pac207_write_reg(cam, 0x08, data->brightness);
	pac207_write_reg(cam, 0x0e, data->gain); /* PGA global gain (Bit 4-0) */
	pac207_write_reg(cam, 0x02, data->exposure); /* PXCK = 12MHz /n */

	mode = 0x02; /* Image Format (Bit 0), LED (1), Compr. test mode (2) */
	if (data->mode) { /* 176x144 */
		mode |= 0x01;
		DBG(3, "pac207_start mode 176x144");
	} else /* 352x288 */
		DBG(3, "pac207_start mode 352x288");
	pac207_write_reg(cam, 0x41, mode);

	pac207_write_reg(cam, 0x13, 0x01); /* load registers to sensor (Bit 0, auto clear) */
	pac207_write_reg(cam, 0x1c, 0x01); /* not documented */
	udelay(1000); /* taken from gspca */
	pac207_write_reg(cam, 0x40, 0x01); /* Start ISO pipe */

	data->sof_read = 0;
	data->autogain_ignore_frames = 0;
	atomic_set (&data->avg_lum, -1);		

	return 0;
}


static void pac207_stop_transfer_pre_kill_urbs(struct usbvideo2_device* cam)
{
	pac207_write_reg(cam, 0x40, 0x00); /* Stop ISO pipe */
	pac207_write_reg(cam, 0x41, 0x00); /* Turn of LED */
	pac207_write_reg(cam, 0x0f, 0x00); /* Power Control */
}


/*****************************************************************************/


static int pac207_open(struct usbvideo2_device* cam)
{
	struct pac207_data *data = cam->cam_data;

	data->mode = 0;
	cam->imagesize = 352 * 288;

	data->brightness = PAC207_BRIGHTNESS_DEFAULT;
	data->exposure = PAC207_EXPOSURE_DEFAULT;
	data->gain = PAC207_GAIN_DEFAULT;
	data->autogain = 1;

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
	struct usbvideo2_device* cam = fh;
	struct pac207_data *data = cam->cam_data;

	switch (a->id) {
		case V4L2_CID_BRIGHTNESS:
			a->value = data->brightness;
			break;
		case V4L2_CID_EXPOSURE:
			a->value = data->exposure;
			break;
		case V4L2_CID_AUTOGAIN:
			a->value = data->autogain;
			break;
		case V4L2_CID_GAIN:
			a->value = data->gain;
			break;
		default:
			return -EINVAL;
	}

	return 0;
}


static int
pac207_vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
{
	struct usbvideo2_device* cam = fh;
	struct pac207_data *data = cam->cam_data;
	int new_value = a->value;
	int err;

	if ((err = pac207_vidioc_g_ctrl(file, fh, a)))
		return err;

	if (a->value == new_value)
		return 0;

	/* don't allow mucking with gain / exposure when using autogain */
	if (data->autogain && (a->id == V4L2_CID_GAIN ||
			a->id == V4L2_CID_EXPOSURE))
		return -EINVAL;

	switch (a->id) {
		case V4L2_CID_BRIGHTNESS:
			data->brightness = new_value;
			pac207_write_reg(cam, 0x0008, data->brightness);
			/* give brightness change time to take effect before
			   doing autogain based on the new brightness */
			data->autogain_ignore_frames =
						PAC207_AUTOGAIN_IGNORE_FRAMES;
			break;

		case V4L2_CID_EXPOSURE:
			data->exposure = new_value;
			pac207_write_reg(cam, 0x0002, data->exposure);
			break;

		case V4L2_CID_AUTOGAIN:
			data->autogain = new_value;
			/* when switching to autogain set defaults to make sure
			   we are on a valid point of the autogain gain /
			   exposure knee graph, and give this change time to
			   take effect before doing autogain. */
			if (data->autogain) {
				data->exposure = PAC207_EXPOSURE_DEFAULT;
				data->gain = PAC207_GAIN_DEFAULT;
				data->autogain_ignore_frames =
						PAC207_AUTOGAIN_IGNORE_FRAMES;
				pac207_write_reg(cam, 0x0002, data->exposure);
				pac207_write_reg(cam, 0x000e, data->gain);
			}
			break;

		case V4L2_CID_GAIN:
			data->gain = new_value;
			pac207_write_reg(cam, 0x000e, data->gain);
			break;
	
		/* no default needed already checked in pac207_vidioc_g_ctrl */
	}

	pac207_write_reg(cam, 0x13, 0x01); /* load registers to sensor */
	pac207_write_reg(cam, 0x1c, 0x01); /* not documented */

	return 0;
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
	struct usbvideo2_device* cam = fh;
	struct pac207_data *data = cam->cam_data;

	memcpy(&(f->fmt.pix), &pac207_pix_fmt[data->mode],
		sizeof(pac207_pix_fmt[0]));

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
	struct usbvideo2_device* cam = fh;
	struct pac207_data *data = cam->cam_data;

	if (f->fmt.pix.width == pac207_pix_fmt[0].width) {
		data->mode = 0;
		cam->imagesize = 352 * 288;
	} else {
		data->mode = 1;
		cam->imagesize = 176 * 144;
	}

	return 0;
}


/*****************************************************************************/

static int
pac207_probe(struct usbvideo2_device* cam, const struct usb_device_id* id)
{
	u8 idreg[2];

	idreg[0] = pac207_read_reg(cam, 0x0000);
	idreg[1] = pac207_read_reg(cam, 0x0001);
	idreg[0] = ((idreg[0] & 0x0F) << 4) | ((idreg[1] & 0xf0) >> 4);
	idreg[1] = idreg[1] & 0x0f;
	DBG(2, "Pixart Sensor ID 0x%02X Chips ID 0x%02X", idreg[0],
		idreg[1]);

	if (idreg[0] != 0x27) {
		DBG(1, "Error invalid sensor ID!");
		return -ENODEV;
	}
		
	pac207_write_reg(cam, 0x41, 0x00); /* 00 Bit_0=Image Format, Bit_1=LED, Bit_2=Compression test mode enable */
	pac207_write_reg(cam, 0x0f, 0x00); /* Power Control */
	pac207_write_reg(cam, 0x11, 0x30); /* Analog Bias */

	DBG(2, "Pixart PAC207BCA Image Processor and Control Chip detected "
		   "(vid/pid 0x%04X:0x%04X)",id->idVendor, id->idProduct);


	cam->imagesize = 352 * 288;
	strcpy(cam->driver, PAC207_NAME);
	strcpy(cam->name, "Pixart PAC207BCA USB Camera");
	cam->sof_marker_size = sizeof(pac207_sof_marker);
	cam->endpoint_address = 0x85;

	return 0;
}

const struct usbvideo2_cam_funcs pac207_funcs = {
	.owner = THIS_MODULE,
	.probe = pac207_probe,
	.find_sof = pac207_find_sof,
	.decode_frame_init = pac207_decode_frame_init,
	.decode_frame_data = pac207_decode,
	.start_transfer = pac207_start_transfer,
	.stop_transfer_pre_kill_urbs = pac207_stop_transfer_pre_kill_urbs,
	.open = pac207_open,
	.frame_dequeued = pac207_do_auto_gain,
	.vidioc_query_ctrl = pac207_vidioc_query_ctrl,
	.vidioc_s_ctrl = pac207_vidioc_s_ctrl,
	.vidioc_g_ctrl = pac207_vidioc_g_ctrl,
	.vidioc_enum_fmt_cap = pac207_vidioc_enum_fmt_cap,
	.vidioc_g_fmt_cap = pac207_vidioc_g_fmt_cap,
	.vidioc_try_fmt_cap = pac207_vidioc_try_fmt_cap,
	.vidioc_s_fmt_cap = pac207_vidioc_s_fmt_cap,
};

static int
pac207_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
{
	return usbvideo2_probe(intf, id, &pac207_funcs,
						sizeof(struct pac207_data));
}

static struct usb_driver pac207_usb_driver = {
	.name =	PAC207_NAME,
	.id_table = pac207_id_table,
	.probe = pac207_usb_probe,
	.disconnect = usbvideo2_disconnect,
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

--------------080201090902030007030801
Content-Type: text/plain;
 name="usbvideo2.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usbvideo2.c"

/* Video4Linux2 framework for usb video devices (webcams)                  *
 *                                                                         *
 * Copyright (C) 2008 by Hans de Goede <j.w.r.degoede@hhs.nl>              *
 * Buffer management code taken from the Video4Linux2 zc030x driver:       *
 * Copyright (C) 2006-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
 * Many ideas and code snippets taken from the gspca driver:               *
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

#include "usbvideo2.h"

/*****************************************************************************/

MODULE_AUTHOR("Hans de Goede <j.w.r.degoede@hhs.nl>");
MODULE_DESCRIPTION("Video4Linux2 framework for usb video devices (webcams)");
MODULE_LICENSE("GPL");

static unsigned short debug = USBVIDEO2_DEBUG_LEVEL;
module_param(debug, ushort, 0644);
MODULE_PARM_DESC(debug,
		 "\n<n> Debugging information level, from 0 to 3:"
		 "\n0 = none (use carefully)"
		 "\n1 = critical errors"
		 "\n2 = significant informations"
		 "\n3 = more verbose messages"
		 "\nLevel 3 is useful for testing only, when only "
		 "one device is used."
		 "\nDefault value is "__MODULE_STRING(USBVIDEO2_DEBUG_LEVEL)"."
		 "\n");

/*****************************************************************************/

static DEFINE_MUTEX(usbvideo2_dev_lock);

/*****************************************************************************/

static u32
usbvideo2_request_buffers(struct usbvideo2_device* cam, u32 count)
{
	void* buff = NULL;
	u32 i;

	if (count > USBVIDEO2_MAX_FRAMES)
		count = USBVIDEO2_MAX_FRAMES;

	cam->nbuffers = count;
	while (cam->nbuffers) {
		if ((buff = vmalloc_32_user(cam->nbuffers *
						PAGE_ALIGN(cam->imagesize))))
			break;
		cam->nbuffers--;
	}

	for (i = 0; i < cam->nbuffers; i++) {
		cam->frame[i].bufmem = buff + i*PAGE_ALIGN(cam->imagesize);
		cam->frame[i].buf.index = i;
		cam->frame[i].buf.m.offset = i*PAGE_ALIGN(cam->imagesize);
		cam->frame[i].buf.length = cam->imagesize;
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


static void usbvideo2_release_buffers(struct usbvideo2_device* cam)
{
	if (cam->nbuffers) {
		vfree(cam->frame[0].bufmem);
		cam->nbuffers = 0;
	}
}


static void usbvideo2_empty_framequeues(struct usbvideo2_device* cam)
{
	u32 i;

	INIT_LIST_HEAD(&cam->inqueue);
	INIT_LIST_HEAD(&cam->outqueue);

	for (i = 0; i < USBVIDEO2_MAX_FRAMES; i++) {
		cam->frame[i].state = F_UNUSED;
		cam->frame[i].buf.bytesused = 0;
	}
}


static void usbvideo2_queue_unusedframes(struct usbvideo2_device* cam)
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

static void usbvideo2_urb_complete(struct urb *urb)
{
	struct usbvideo2_device* cam = urb->context;
	struct usbvideo2_frame_t** f;
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

		(*f) = list_entry(cam->inqueue.next, struct usbvideo2_frame_t,
					frame);
	} 

	for (i = 0; i < urb->number_of_packets; i++) {
		unsigned int len, repeat = 0;
		u8 *pos, *sof;

		len = urb->iso_frame_desc[i].actual_length;
		pos = urb->iso_frame_desc[i].offset + urb->transfer_buffer;

		if (urb->iso_frame_desc[i].status) {
			DBG(3, "Error in isochronous frame");
			(*f)->state = F_ERROR;
			continue;
		}

		while (len) {
			sof = cam->funcs->find_sof(cam, pos, len, repeat++);

			if (((*f)->state == F_QUEUED ||
					(*f)->state == F_ERROR) && sof) {
start_of_frame:
				(*f)->state = F_GRABBING;
				(*f)->buf.bytesused = 0;
				do_gettimeofday(&(*f)->buf.timestamp);
				cam->funcs->decode_frame_init(cam);
				len -= sof - pos;
				pos = sof;
				continue; /* check for another sof in packet */
			}

			if ((*f)->state == F_GRABBING) {
				unsigned int n;

				/* If sof decode until sof */
				if (sof) {
					n = sof - pos;
					if (n > cam->sof_marker_size)
						n -= cam->sof_marker_size;
					else
						n = 0;
				} else
					n = len;

				if ((ret = cam->funcs->decode_frame_data(cam,
						*f, pos, n))) {
					(*f)->buf.sequence= ++cam->frame_count;
					spin_lock(&cam->queue_lock);
					list_move_tail(&(*f)->frame,
						&cam->outqueue);
					if (!list_empty(&cam->inqueue))
						(*f) = list_entry(
							cam->inqueue.next,
							struct usbvideo2_frame_t,
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

static void usbvideo2_kill_and_free_urbs(struct usbvideo2_device* cam)
{
	int i;
	struct urb* urb;
	struct usb_device *udev = cam->usbdev;
	
	for (i = 0; i < USBVIDEO2_URBS; i++) {
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

static void usbvideo2_stop_transfer(struct usbvideo2_device* cam);

static int usbvideo2_start_transfer(struct usbvideo2_device* cam)
{
	struct usb_device *udev = cam->usbdev;
	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
	struct usb_host_interface* altsetting;
	unsigned int psz;
	struct urb* urb;
	int i, j, alt, err = -ENOSPC;

	if (cam->stream == STREAM_ON)
		return -EBUSY;

	for (alt = intf->num_altsetting - 1; alt && err == -ENOSPC; alt--) {
		altsetting = usb_altnum_to_altsetting(intf, alt);

		/* Find our endpoint to determine the packetsize */
		for (i = 0; i < altsetting->desc.bNumEndpoints; i++) {
			if (altsetting->endpoint[i].desc.bEndpointAddress ==
					cam->endpoint_address)
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

		for (i = 0; i < USBVIDEO2_URBS; i++) {
			urb = usb_alloc_urb(USBVIDEO2_ISO_PACKETS, GFP_KERNEL);
			if (!urb) {
				DBG(1, "usb_alloc_urb() failed");
				usbvideo2_kill_and_free_urbs(cam);
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
							 USBVIDEO2_ISO_PACKETS,
							 GFP_KERNEL,
							 &urb->transfer_dma);
			if (!urb->transfer_buffer) {
				DBG(1, "usb_buffer_alloc() failed");
				usbvideo2_kill_and_free_urbs(cam);
				return -ENOMEM;
			}
			urb->dev = udev;
			urb->context = cam;
			urb->pipe = usb_rcvisocpipe(udev,
							cam->endpoint_address);
			urb->transfer_flags = URB_ISO_ASAP |
						URB_NO_TRANSFER_DMA_MAP;
			urb->number_of_packets = USBVIDEO2_ISO_PACKETS;
			urb->complete = usbvideo2_urb_complete;
			urb->transfer_buffer_length = (psz + 1) *
							USBVIDEO2_ISO_PACKETS;
			urb->interval = 1;
			for (j = 0; j < USBVIDEO2_ISO_PACKETS; j++) {
				urb->iso_frame_desc[j].offset = (psz + 1) * j;
				urb->iso_frame_desc[j].length = psz;
			}
		}
		
		err = cam->funcs->start_transfer(cam);
		if (err) {
			DBG(1, "camera specific start_transfer() failed");
			usbvideo2_kill_and_free_urbs(cam);
			return err;
		}

		cam->stream = STREAM_ON;
		DBG(3, "Stream on");

		for (i = 0; i < USBVIDEO2_URBS; i++) {
			err = usb_submit_urb(cam->urb[i], GFP_KERNEL);
			if (err) {
				DBG(1, "usb_submit_urb() failed, error %d",
					err);
				usbvideo2_stop_transfer(cam);
				break;
			}
		}
	}

	return err;
}


static void usbvideo2_stop_transfer(struct usbvideo2_device* cam)
{
	struct usb_device *udev = cam->usbdev;

	if (cam->stream == STREAM_OFF)
		return;

	if (cam->funcs->stop_transfer_pre_kill_urbs)
		cam->funcs->stop_transfer_pre_kill_urbs(cam);

	usbvideo2_kill_and_free_urbs(cam);

	if (!cam->disconnected) {
		int err = usb_set_interface(udev, 0, 0); /* 0 Mb/s */
		if (err)
			DBG(1, "usb_set_interface( 0 ) error: %d\n", err);
	}

	if (cam->funcs->stop_transfer_post_kill_urbs)
		cam->funcs->stop_transfer_post_kill_urbs(cam);

	cam->frame_current = NULL;
	cam->stream = STREAM_OFF;
	DBG(3, "Stream off");
}

/*****************************************************************************/

static void usbvideo2_release_resources(struct kref *kref)
{
	struct usbvideo2_device *cam = container_of(kref,
						struct usbvideo2_device, kref);
	kfree(cam);
}


static int usbvideo2_open(struct inode* inode, struct file* filp)
{
	struct usbvideo2_device* cam;
	int err = 0;

	/* usb driver disconnect may be running and waiting in
	   video_unregister_device() for the videodev_lock (from videodev.c),
	   which we hold when being called! */
	if (!mutex_trylock(&usbvideo2_dev_lock))
		return -EAGAIN;

	cam = video_get_drvdata(video_devdata(filp));

	if (cam->users) {
		err = -EBUSY;
		goto out;
	}

	if (!try_module_get(cam->funcs->owner)) {
		/* Our cam specific module is being removed ! */
		err = -ENODEV;
		goto out;
	}

	kref_get(&cam->kref);

	filp->private_data = cam;
	cam->users++;
	cam->io = IO_NONE;
	cam->nreadbuffers = USBVIDEO2_DEFAULT_READBUFFERS;
	cam->frame_count = 0;
	/* init the frame queues */
	usbvideo2_empty_framequeues(cam);

	err = cam->funcs->open(cam);
	if (err) {
		DBG(1, "Cam specific open() failed");
		module_put(cam->funcs->owner);
		kref_put(&cam->kref, usbvideo2_release_resources);
	}
out:
	mutex_unlock(&usbvideo2_dev_lock);
	return err;
}


static int usbvideo2_release(struct inode* inode, struct file* filp)
{
	struct usbvideo2_device* cam;

	mutex_lock(&usbvideo2_dev_lock);

	cam = filp->private_data;

	usbvideo2_stop_transfer(cam);
	usbvideo2_release_buffers(cam);
	cam->users--;

	module_put(cam->funcs->owner);
	kref_put(&cam->kref, usbvideo2_release_resources);

 	mutex_unlock(&usbvideo2_dev_lock);

	return 0;
}


static ssize_t
usbvideo2_read(struct file* filp, char __user * buf, size_t count, loff_t* f_pos)
{
	struct usbvideo2_device *cam = filp->private_data;
	struct usbvideo2_frame_t *f;
	unsigned long lock_flags;
	long timeout;
	int err = 0;


	if (cam->disconnected) {
		err = -ENODEV;
		goto out;
	}

	if (cam->io == IO_MMAP) {
		DBG(2, "Close and open the device again to choose the read "
			"method");
		err = -EBUSY;
		goto out;
	}

	if (cam->io == IO_NONE) {
		if (!usbvideo2_request_buffers(cam, cam->nreadbuffers)) {
			DBG(1, "read() failed, not enough memory");
			err = -ENOMEM;
			goto out;
		}

		usbvideo2_queue_unusedframes(cam);

		if ((err = usbvideo2_start_transfer(cam)))
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
		usbvideo2_queue_unusedframes(cam);
	}

	if (!count)
		goto out;

	/* loop until we get a frame or error, the frame we've been waiting
	   for may be stolen from underneed us, as we release the lock while
	   waiting */ 
	while (list_empty(&cam->outqueue)) {
		if (filp->f_flags & O_NONBLOCK) {
			err = -EAGAIN;
			goto out;
		}

		mutex_unlock(&cam->fileop_mutex);
		timeout = wait_event_interruptible_timeout(cam->wait_frame,
				!list_empty(&cam->outqueue) ||
				cam->disconnected,
				msecs_to_jiffies(USBVIDEO2_FRAME_TIMEOUT) );
		if (mutex_lock_interruptible(&cam->fileop_mutex))
			return -ERESTARTSYS;
		
		if (cam->disconnected) {
			err = -ENODEV;
			goto out;
		}
		if (timeout <= 0) {
			err = (timeout < 0)? timeout : -EIO;
			goto out;
		}
	}

	if (cam->funcs->frame_dequeued)
		cam->funcs->frame_dequeued(cam);

	spin_lock_irqsave(&cam->queue_lock, lock_flags);
	f = list_entry(cam->outqueue.next, struct usbvideo2_frame_t, frame);
	list_del(cam->outqueue.next);
	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);

	if (count > f->buf.bytesused)
		count = f->buf.bytesused;

	if (copy_to_user(buf, f->bufmem, count))
		err = -EFAULT;
	else
		*f_pos += count;

	f->state = F_UNUSED;
	usbvideo2_queue_unusedframes(cam);

out:
	mutex_unlock(&cam->fileop_mutex);

	return err ? err : count;
}


static unsigned int usbvideo2_poll(struct file *filp, poll_table *wait)
{
	struct usbvideo2_device* cam = filp->private_data;
	struct usbvideo2_frame_t* f;
	unsigned long lock_flags;
	unsigned int mask = 0;

	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return POLLERR;

	if (cam->disconnected) {
		mask = POLLERR;
		goto out;
	}

	if (cam->io == IO_NONE) {
		if (!usbvideo2_request_buffers(cam, cam->nreadbuffers)) {
			DBG(1, "poll() failed, not enough memory");
			mask = POLLERR;
			goto out;
		}

		usbvideo2_queue_unusedframes(cam);

		if (usbvideo2_start_transfer(cam)) {
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
			usbvideo2_queue_unusedframes(cam);
		}
	}

	poll_wait(filp, &cam->wait_frame, wait);

	if (!list_empty(&cam->outqueue))
		mask |= POLLIN | POLLRDNORM;

out:
	mutex_unlock(&cam->fileop_mutex);
	return mask;
}


static void usbvideo2_vm_open(struct vm_area_struct* vma)
{
	struct usbvideo2_frame_t* f = vma->vm_private_data;
	f->vma_use_count++;
}


static void usbvideo2_vm_close(struct vm_area_struct* vma)
{
	/* NOTE: buffers are not freed here */
	struct usbvideo2_frame_t* f = vma->vm_private_data;
	f->vma_use_count--;
}


static struct vm_operations_struct usbvideo2_vm_ops = {
	.open = usbvideo2_vm_open,
	.close = usbvideo2_vm_close,
};


static int usbvideo2_mmap(struct file* filp, struct vm_area_struct *vma)
{
	struct usbvideo2_device* cam = filp->private_data;
	unsigned long size = vma->vm_end - vma->vm_start,
			  start = vma->vm_start;
	void *pos;
	u32 i;
	int err = 0;

	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (cam->disconnected) {
		err = -ENODEV;
		goto out;
	}

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

	vma->vm_ops = &usbvideo2_vm_ops;
	vma->vm_private_data = &cam->frame[i];
	usbvideo2_vm_open(vma);

out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}

static int usbvideo2_ioctl(struct inode *inode, struct file *filp,
			  unsigned int cmd, unsigned long arg)
{
	struct usbvideo2_device* cam = filp->private_data;
	int err;

	if (mutex_lock_interruptible(&cam->fileop_mutex))
		return -ERESTARTSYS;

	if (cam->disconnected) {
		err = -ENODEV;
		goto out;
	}

	err = video_ioctl2(inode, filp, cmd, arg);
out:
	mutex_unlock(&cam->fileop_mutex);

	return err;
}

static const struct file_operations usbvideo2_fops = {
	.owner = THIS_MODULE,
	.open =	usbvideo2_open,
	.release = usbvideo2_release,
	.ioctl = usbvideo2_ioctl,
	.compat_ioctl = v4l_compat_ioctl32,
	.read =	usbvideo2_read,
	.poll =	usbvideo2_poll,
	.mmap =	usbvideo2_mmap,
	.llseek = no_llseek,
};

/*****************************************************************************/

static int
usbvideo2_vidioc_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
{
	struct usbvideo2_device* cam = fh;

	cap->version = LINUX_VERSION_CODE;
	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
				V4L2_CAP_STREAMING;
	strcpy(cap->driver, cam->driver);
	strlcpy(cap->card, cam->name, sizeof(cap->card));
	if (usb_make_path(cam->usbdev, cap->bus_info, sizeof(cap->bus_info))
			< 0)
		strlcpy(cap->bus_info, cam->usbdev->dev.bus_id,
			sizeof(cap->bus_info));

	return 0;
}


static int
usbvideo2_vidioc_enuminput(struct file *file, void *fh, struct v4l2_input *inp)
{
	if (inp->index)
		return -EINVAL;

	memset(inp, 0, sizeof(*inp));
	strcpy(inp->name, "Camera");
	inp->type = V4L2_INPUT_TYPE_CAMERA;

	return 0;
}


static int
usbvideo2_vidioc_g_input(struct file *file, void *fh, unsigned int *i)
{
	*i = 0;

	return 0;
}


static int
usbvideo2_vidioc_s_input(struct file *file, void *fh, unsigned int i)
{
	if (i != 0)
		return -EINVAL;

	return 0;
}


static int
usbvideo2_vidioc_s_fmt_cap(struct file *file, void *fh, struct v4l2_format *f)
{
	struct usbvideo2_device* cam = fh;
	int err;

	if ((err = cam->funcs->vidioc_try_fmt_cap(file, fh, f)))
		return err;

	if (cam->stream != STREAM_OFF)
		return -EBUSY;

	return cam->funcs->vidioc_s_fmt_cap(file, fh, f);
}


static int
usbvideo2_vidioc_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *b)
{
	u32 i;
	struct usbvideo2_device* cam = fh;

	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
			b->memory != V4L2_MEMORY_MMAP)
		return -EINVAL;

	if (cam->io == IO_READ) {
		DBG(2, "Close and open the device again to choose the "
			"mmap I/O method");
		return -EBUSY;
	}

	if (cam->stream == STREAM_ON)
		return -EBUSY;

	for (i = 0; i < cam->nbuffers; i++)
		if (cam->frame[i].vma_use_count) {
			DBG(2, "VIDIOC_REQBUFS failed. "
				   "Previous buffers are still mapped.");
			return -EBUSY;
		}

	usbvideo2_release_buffers(cam);
	if (b->count)
		b->count = usbvideo2_request_buffers(cam, b->count);

	cam->io = b->count ? IO_MMAP : IO_NONE;

	return 0;
}


static int
usbvideo2_vidioc_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
{
	struct usbvideo2_device* cam = fh;

	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
			b->index >= cam->nbuffers || cam->io != IO_MMAP)
		return -EINVAL;

	memcpy(b, &cam->frame[b->index].buf, sizeof(*b));

	if (cam->frame[b->index].vma_use_count)
		b->flags |= V4L2_BUF_FLAG_MAPPED;

	if (cam->frame[b->index].state == F_DONE)
		b->flags |= V4L2_BUF_FLAG_DONE;
	else if (cam->frame[b->index].state != F_UNUSED)
		b->flags |= V4L2_BUF_FLAG_QUEUED;

	return 0;
}


static int
usbvideo2_vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
{
	struct usbvideo2_device* cam = fh;
	unsigned long lock_flags;

	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
			b->index >= cam->nbuffers ||
			cam->io != IO_MMAP ||
			cam->frame[b->index].state != F_UNUSED)
		return -EINVAL;

	cam->frame[b->index].state = F_QUEUED;

	spin_lock_irqsave(&cam->queue_lock, lock_flags);
	list_add_tail(&cam->frame[b->index].frame, &cam->inqueue);
	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);

	return 0;
}


static int
usbvideo2_vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
{
	struct usbvideo2_device* cam = fh;
	struct usbvideo2_frame_t *f;
	unsigned long lock_flags;
	long timeout;

	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP ||
			cam->stream == STREAM_OFF)
		return -EINVAL;

	if (list_empty(&cam->outqueue)) {
		if (file->f_flags & O_NONBLOCK)
			return -EAGAIN;

		timeout = wait_event_interruptible_timeout(cam->wait_frame,
				!list_empty(&cam->outqueue) ||
				cam->disconnected,
				msecs_to_jiffies(USBVIDEO2_FRAME_TIMEOUT) );
		if (cam->disconnected)
			return -ENODEV;

		if (timeout <= 0)
			return (timeout < 0)? timeout : -EIO;
	}

	if (cam->funcs->frame_dequeued)
		cam->funcs->frame_dequeued(cam);

	spin_lock_irqsave(&cam->queue_lock, lock_flags);
	f = list_entry(cam->outqueue.next, struct usbvideo2_frame_t, frame);
	list_del(cam->outqueue.next);
	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);

	f->state = F_UNUSED;

	memcpy(b, &f->buf, sizeof(*b));
	if (f->vma_use_count)
		b->flags |= V4L2_BUF_FLAG_MAPPED;

	return 0;
}


static int
usbvideo2_vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
{
	struct usbvideo2_device* cam = fh;

	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP)
		return -EINVAL;

	return usbvideo2_start_transfer(cam);
}


static int
usbvideo2_vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
{
	struct usbvideo2_device* cam = fh;

	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP)
		return -EINVAL;

	usbvideo2_stop_transfer(cam);
	usbvideo2_empty_framequeues(cam);

	return 0;
}


static int
usbvideo2_vidioc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
{
	struct usbvideo2_device* cam = fh;

	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
		return -EINVAL;

	a->parm.capture.extendedmode = 0;
	a->parm.capture.readbuffers = cam->nreadbuffers;

	return 0;
}


static int
usbvideo2_vidioc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
{
	struct usbvideo2_device* cam = fh;

	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
		return -EINVAL;

	a->parm.capture.extendedmode = 0;

	if (a->parm.capture.readbuffers == 0)
		a->parm.capture.readbuffers = cam->nreadbuffers;

	if (a->parm.capture.readbuffers > USBVIDEO2_MAX_FRAMES)
		a->parm.capture.readbuffers = USBVIDEO2_MAX_FRAMES;

	cam->nreadbuffers = a->parm.capture.readbuffers;

	return 0;
}

/*****************************************************************************/

int
usbvideo2_probe(struct usb_interface* intf, const struct usb_device_id* id,
	const struct usbvideo2_cam_funcs *funcs, int cam_specific_data_size)
{
	struct usb_device *udev = interface_to_usbdev(intf);
	struct usbvideo2_device* cam;
	int err = -ENOMEM;

	if (!(cam = kzalloc(sizeof(struct usbvideo2_device), GFP_KERNEL)))
		return -ENOMEM;

	if (!(cam->control_buffer = kzalloc(4, GFP_KERNEL)))
		goto fail;

	if (!(cam->cam_data = kzalloc(cam_specific_data_size, GFP_KERNEL)))
		goto fail;

	if (!(cam->v4ldev = video_device_alloc())) {
		DBG(1, "video_device_alloc() failed");
		goto fail;
	}

	cam->usbdev = udev;
	cam->funcs = funcs;
	cam->debug = debug;

	if ((err = funcs->probe(cam, id))) {
		DBG(1, "Error cam initialization failed");
		goto fail;
	}

	cam->v4ldev->owner = THIS_MODULE;
	cam->v4ldev->fops = &usbvideo2_fops; 
	cam->v4ldev->type = VID_TYPE_CAPTURE | VID_TYPE_SCALES;
	cam->v4ldev->release = video_device_release;
/*	cam->v4ldev->debug = V4L2_DEBUG_IOCTL_ARG; */
	cam->v4ldev->vidioc_querycap = usbvideo2_vidioc_querycap;
	cam->v4ldev->vidioc_enum_input = usbvideo2_vidioc_enuminput;
	cam->v4ldev->vidioc_g_input = usbvideo2_vidioc_g_input;
	cam->v4ldev->vidioc_s_input = usbvideo2_vidioc_s_input;
	cam->v4ldev->vidioc_queryctrl = funcs->vidioc_query_ctrl;
	cam->v4ldev->vidioc_g_ctrl = funcs->vidioc_g_ctrl;
	cam->v4ldev->vidioc_s_ctrl = funcs->vidioc_s_ctrl;
	cam->v4ldev->vidioc_enum_fmt_cap = funcs->vidioc_enum_fmt_cap;
	cam->v4ldev->vidioc_g_fmt_cap = funcs->vidioc_g_fmt_cap;
	cam->v4ldev->vidioc_s_fmt_cap = usbvideo2_vidioc_s_fmt_cap;
	cam->v4ldev->vidioc_try_fmt_cap = funcs->vidioc_try_fmt_cap;
	cam->v4ldev->vidioc_reqbufs = usbvideo2_vidioc_reqbufs;
	cam->v4ldev->vidioc_querybuf = usbvideo2_vidioc_querybuf;
	cam->v4ldev->vidioc_qbuf = usbvideo2_vidioc_qbuf;
	cam->v4ldev->vidioc_dqbuf = usbvideo2_vidioc_dqbuf;
	cam->v4ldev->vidioc_streamon = usbvideo2_vidioc_streamon;
	cam->v4ldev->vidioc_streamoff = usbvideo2_vidioc_streamoff;
	cam->v4ldev->vidioc_g_parm = usbvideo2_vidioc_g_parm;
	cam->v4ldev->vidioc_s_parm = usbvideo2_vidioc_s_parm;
	strlcpy(cam->v4ldev->name, cam->name, sizeof(cam->v4ldev->name));
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
	kfree(cam->control_buffer);
	kfree(cam->cam_data);
	if (cam->v4ldev)
		video_device_release(cam->v4ldev);
	kfree(cam);

	return err;
}
EXPORT_SYMBOL_GPL(usbvideo2_probe);

void usbvideo2_disconnect(struct usb_interface* intf)
{
	struct usbvideo2_device* cam;

	mutex_lock(&usbvideo2_dev_lock);

	cam = usb_get_intfdata(intf);

	DBG(2, "Disconnecting %s...", cam->name);
	cam->disconnected = 1;

	if (cam->users) {
		/* The cam device is still open by some app */
		wake_up_interruptible(&cam->wait_frame);
		/* Take the fileop_mutex:
		   1) Because we touch shared resources protected by it
		   2) So that we know any current users of the usbdev / v4ldev
		      will be done, there won't come any new ones as we've set
		      the disconnected flag */
		mutex_lock(&cam->fileop_mutex);
		usbvideo2_stop_transfer(cam);
		mutex_unlock(&cam->fileop_mutex);
	}

	DBG(2, "V4L2 device /dev/video%d deregistered", cam->v4ldev->minor);
	video_set_drvdata(cam->v4ldev, NULL);
	video_unregister_device(cam->v4ldev);
	cam->v4ldev = NULL;

	usb_put_dev(cam->usbdev);
	cam->usbdev = NULL;

	kfree(cam->control_buffer);
	kfree(cam->cam_data);
	cam->control_buffer = NULL;
	cam->cam_data = NULL;

	kref_put(&cam->kref, usbvideo2_release_resources);

	mutex_unlock(&usbvideo2_dev_lock);
}
EXPORT_SYMBOL_GPL(usbvideo2_disconnect);

--------------080201090902030007030801
Content-Type: text/plain;
 name="usbvideo2.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usbvideo2.h"

/* Video4Linux2 framework for usb video devices (webcams)                  *
 *                                                                         *
 * Copyright (C) 2008 by Hans de Goede <j.w.r.degoede@hhs.nl>              *
 * Buffer management code taken from the Video4Linux2 zc030x driver:       *
 * Copyright (C) 2006-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
 * Many ideas and code snippets taken from the gspca driver:               *
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

#ifndef _USBVIDEO2_H_
#define _USBVIDEO2_H_

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

#define USBVIDEO2_DEBUG_LEVEL		2
#define USBVIDEO2_MAX_FRAMES		32
#define USBVIDEO2_URBS			4 /* 2 is problematic on some systems */
#define USBVIDEO2_ISO_PACKETS		16 /* gspca uses 16 */
#define USBVIDEO2_CTRL_TIMEOUT		100  /* ms */
#define USBVIDEO2_FRAME_TIMEOUT		2000 /* ms */
#define USBVIDEO2_DEFAULT_READBUFFERS	3

/*****************************************************************************/

struct usbvideo2_frame_t;
struct usbvideo2_device;

/*****************************************************************************/

/* How to write a cam specific driver:
   1) Implement the below functions (except for those marked optional)
   2) fill an instance of the struct below with pointers to your implementation
   3) Add an usb device id table to your module
   4) Add a simple usb probe function which simply calls the usbvideo2_probe
      function (further below), passing in your cam specific functions and
      the sizeof your cam specific data structure (usbvideo2 will kzalloc and
      free it for you)
   5) Let the disconnect member of your usb_driver struct point to
      usbvideo2_disconnect
*/

/* Cam specific functions structure */
struct usbvideo2_cam_funcs {
	/* set this to THIS_MODULE */
	struct module *owner;

	/* This function gets called from usbvideo2_probe() when a new device
	   matching any of the listed usb ID's is connnected / inserted. This
	   function should:
	   1) Check if the device is supported by the cam specific code
	   2) initialize the device (turn of led, etc.)
	   3) Set the cam specific data in the usbvideo2_device (which data
	      is cam specific is detailed in the struct declaration)
	   4) initialize cam->cam_data as needed, it is already allocated
	      by usbvideo2_probe() when this function gets called,
	      one just needs to fill in any non 0 values */
	int (*probe) (struct usbvideo2_device* cam,
		const struct usb_device_id* id);

	/* Note the 3 sof / decode functions below are called from the urb
	   completion handler and thus must not sleep! No locks are held when
	   they are called! */

	/* Should return NULL when no sof, otherwise a pointer to the first
	   byte after the SOF marker, the repeat param gets set to 0 the first
	   call for one iso packet, to 1 the second call within the same iso
	   packet, etc. This can be used for optimalization when the cam driver
	   knows that there can be only one sof in a frame */
	u8 * (*find_sof) (struct usbvideo2_device* cam, u8* data,
		unsigned int len, int repeat);
	/* This function gets called before the decode_frame_data() gets called
	   for the first time after a sof has been detected, this can be used
	   to reset the decoder state */
	void (*decode_frame_init) (struct usbvideo2_device* cam);
	/* This function gets called when there is iso packet data to decode
	   the first time it gets called after a call to decode_frame_init()
	   the data pointer will point to the first byte after the sof header,
	   iow to the byte returned by find_sof().
	   
	   This function should return 1 if a frame was completely written to
	   f->buf, in all other circumstances it should return 0. It can signal
	   an error in decoding by setting f->state to F_ERROR, and when
	   returning 1 it should also set f->state to F_DONE. */
	int (*decode_frame_data) (struct usbvideo2_device* cam,
		struct usbvideo2_frame_t *f, u8 *data, unsigned int len);
	
	/* Note all functions below are called with the fileop_mutex locked
	   and thus you can be sure only one of them will be called at a time.
	   Notice that the sof / frame decode functions above may still run
	   simultaniously though! */

	/* Start transfer: activate sampling and start up iso endpoint,
	   return 0 on success, otherwise a negative errorcode */
	int (*start_transfer) (struct usbvideo2_device* cam);

	/* Stop transfer: stop sampling and shut down iso endpoint.
	   This version of stop_transfer gets called _before_ the urbs
	   currently in progress are killed. This function should check
	   cam->disconnected before doing any usb I/O, its still called on
	   a disconnected webcam to free any resources claimed by
	   start_transfer() (optional). */
	void (*stop_transfer_pre_kill_urbs) (struct usbvideo2_device* cam);

	/* Like stop_transfer_pre_kill_urbs, but gets called _after_ the urbs
	   currently in progress are killed (optional). */
	void (*stop_transfer_post_kill_urbs) (struct usbvideo2_device* cam);
	
	/* Open: called when the /dev/videoX device gets opened this function
	   should reset things like contrast and brightness, etc. Back to their
	   defaults. return 0 on success, otherwise a negative errorcode */
	int (*open) (struct usbvideo2_device* cam);

	/* Post frame dequeue (or read) callback, usefull todo things like
	   semi software auto exposure / gain (optional) */
	void (*frame_dequeued) (struct usbvideo2_device* cam);

	/* Below are standard v4l2 ioctl handlers */

	int (*vidioc_query_ctrl) (struct file *file, void *fh,
		struct v4l2_queryctrl *a);

	int (*vidioc_g_ctrl) (struct file *file, void *fh,
		struct v4l2_control *a);

	int (*vidioc_s_ctrl) (struct file *file, void *fh,
		struct v4l2_control *a);

	int (*vidioc_enum_fmt_cap) (struct file *file, void *fh,
		struct v4l2_fmtdesc *f);

	int (*vidioc_g_fmt_cap) (struct file *file, void *fh,
		struct v4l2_format *f);

	int (*vidioc_try_fmt_cap) (struct file *file, void *fh,
		struct v4l2_format *f);

	/* Note some sanity checks (try_fmt_cap, not streaming) are already
	   done when this gets called */
	int (*vidioc_s_fmt_cap) (struct file *file, void *fh,
		struct v4l2_format *f);
};

/* Use as explained above in "How to write a cam specific driver" */
int usbvideo2_probe(struct usb_interface* intf, const struct usb_device_id* id,
	const struct usbvideo2_cam_funcs *funcs, int cam_specific_data_size);

void usbvideo2_disconnect(struct usb_interface* intf);

/*****************************************************************************/

enum usbvideo2_frame_state {
	F_UNUSED,
	F_QUEUED,
	F_GRABBING,
	F_DONE,
	F_ERROR,
};

struct usbvideo2_frame_t {
	void* bufmem;
	struct v4l2_buffer buf;
	enum usbvideo2_frame_state state;
	struct list_head frame;
	unsigned long vma_use_count;
};

enum usbvideo2_io_method {
	IO_NONE,
	IO_READ,
	IO_MMAP,
};

enum usbvideo2_stream_state {
	STREAM_OFF,
	STREAM_ON,
};

struct usbvideo2_device {
	const struct usbvideo2_cam_funcs *funcs;
	void *cam_data; /* cam specific functions private data */

	struct usb_device* usbdev;
	/* 4 kmalloc-ed bytes for cam read / write register methods */
	u8* control_buffer;

	/* These should not be touched by the cam specific code */
	struct video_device* v4ldev;
	struct urb* urb[USBVIDEO2_URBS];
	struct usbvideo2_frame_t *frame_current, frame[USBVIDEO2_MAX_FRAMES];
	struct list_head inqueue, outqueue;
	struct kref kref;
	struct mutex fileop_mutex;
	spinlock_t queue_lock;
	wait_queue_head_t wait_frame;
	u32 frame_count, nbuffers, nreadbuffers;
	/* End usbvideo2 core private data */

	/* These should be initialised by the cam specific code in its probe
	   function and be updated as necessary */
	u32 imagesize;
	char driver[16];
	char name[32];
	u8 sof_marker_size;
	u8 endpoint_address;
	/* end cam specific data */

	/* Thse should only be read by the cam specific code */
	u8 debug;
	u8 disconnected;

	/* These should not be touched by the cam specific code */
	u8 users;
	u8 io;
	u8 stream;
};

/*****************************************************************************/

#undef DBG
#define DBG(level, fmt, args...)                                              \
do {                                                                          \
	if (cam->debug >= (level)) {                                          \
		if ((level) == 1)                                             \
			dev_err(&cam->usbdev->dev, fmt "\n", ## args);        \
		else if ((level) == 2)                                        \
			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
		else if ((level) >= 3)                                        \
			dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n",   \
				 __FILE__, __FUNCTION__, __LINE__ , ## args); \
	}                                                                     \
} while (0)

#endif /* _USBVIDEO2_H_ */

--------------080201090902030007030801
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080201090902030007030801--
