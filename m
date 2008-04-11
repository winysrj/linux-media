Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3B1smwu025602
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 21:54:48 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3B1scWg028042
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 21:54:39 -0400
Received: by yw-out-2324.google.com with SMTP id 3so98269ywj.81
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 18:54:34 -0700 (PDT)
Message-ID: <998e4a820804101854l77e702d9j78d16afc59d807a@mail.gmail.com>
Date: Fri, 11 Apr 2008 09:54:34 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0804100749310.3693@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Disposition: inline
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804042027140.7761@axis700.grange>
	<998e4a820804070417w7cf71869h5f36c2ec18c8584c@mail.gmail.com>
	<Pine.LNX.4.64.0804071322490.5585@axis700.grange>
	<998e4a820804071849s60e883f9ne2d8ad6a2f48bd42@mail.gmail.com>
	<Pine.LNX.4.64.0804090104190.4987@axis700.grange>
	<998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
	<Pine.LNX.4.64.0804091616470.5671@axis700.grange>
	<998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
	<Pine.LNX.4.64.0804100749310.3693@axis700.grange>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: question for soc-camera driver
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

2008/4/10 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > Thanks,I test it already. if I request 4 buffers,wrong frames will
> > appear sometimes and get the partially inverted frame sequence too.
>
>  can you describe more precisely what you mean by "wrong frames?" Is it the
>  same problem as what I'm seeing here: misplaced start of frame, i.e., your
>  frame looks divided into four rectangles?

The wrong frame is divided two portion,top and bottom. the top is
right of the bottom.

>  > I request 2 buffers,there is not wrong frames.But some frames will be
>  > lost,like 1,2,3,4,7,8,9,10,14,...
>
>  This is good. This means those frames had buffer overruns and have been
>  dropped. Above you mean, that frames 5, 6, 11, 12, and 13 have been
>  dropped, not that all frames you listed have been dropped?

yes, the frames 5, 6, 11, 12, and 13 have been dropped. The frames I
listed is right.

>  I will see if I can further improve the algorithm and identify why the
>  frame sequence gets inverted with 4 buffers, but I don't know when I will
>  get time for this.

I have a driver got frome MontaVista Software. Now this driver can
work well on my pxa270.This driver work on linux-2.6.20.I will give
you this driver, and I hope this driver can help you.there is 4
files,mainstone.c,mt9v022.c,mainstone.h,mt9v022.h

1、-----------------This is mainstone.c-----------------
/*
 * linux/drivers/media/video/mainstone.c
 *
 * Driver for Intel Mainstone Camera
 *
 * Author: Aleskey Makarov <amakarov@ru.mvista.com>
 *         (ci_xxx routines : Intel Corporation)
 *
 * 2003 (c) Intel Corporation
 * 2003-2005 (c) MontaVista Software, Inc. This file is licensed under
 * the terms of the GNU General Public License version 2. This program
 * is licensed "as is" without any warranty of any kind, whether express
 * or implied.
 */
#undef  CONFIG_FB_PXA

//#include <linux/config.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/device.h>
#include <linux/videodev.h>
#include <linux/fs.h>
#include <linux/spinlock.h>
#include <linux/list.h>
#include <linux/wait.h>
#include <linux/interrupt.h>
#include <linux/dma-mapping.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>
#include <linux/stringify.h>
#include <linux/delay.h>
#include <linux/rwsem.h>

#if CONFIG_FB_PXA
# include <linux/fb.h>
#endif

#include <media/video-buf.h>

#include <asm/io.h>
#include <asm/scatterlist.h>
#include <asm/semaphore.h>

#include <asm/arch/hardware.h>
#include <asm/arch/dma.h>
#include <asm/arch/mainstone.h>

#include <media/v4l2-dev.h>
#include <linux/platform_device.h>
#include <asm/arch/pxa-regs.h>
#include <linux/version.h>

#include "mt9v022.h"
#include "mainstone.h"

#define F(string) __stringify(KBUILD_BASENAME) ":" \
	__stringify(__LINE__) " (%s) : " string "\n", __FUNCTION__
#define F0 F("@")

/* for registration */
#define DEVICE_NAME "mainstone_video_device"
#define DRIVER_NAME "mainstone_video"

#define VIDEOBUF_BUFFER(x) list_entry( x, struct videobuf_buffer, queue )
#define VIDEOBUF_INDEX(x) ( ((x) == mainstone_queue.read_buf) ? -1 : (x)->i )

#define CAMERA_WIDTH_DEFAULT	752
#define CAMERA_HEIGHT_DEFAULT	480
#define CAMERA_WIDTH_MAX	752
#define CAMERA_HEIGHT_MAX	480
#define CAMERA_WIDTH_MIN	88
#define CAMERA_HEIGHT_MIN	72

#define CTRL_CAMERA_WIDTH	(V4L2_CID_PRIVATE_BASE + 0)
#define CTRL_CAMERA_HEIGHT	(V4L2_CID_PRIVATE_BASE + 1)


/* BEGIN capture interface */

static unsigned long ci_regs_base;

static struct platform_device mainstone_device;

static void ci_set_image_format(int input_format, int output_format)
{
	unsigned int value = 0, tbit = 0, rgbt_conv = 0, rgb_conv = 0;
	unsigned int rgb_f = 0, ycbcr_f = 0, rgb_bpp = 0, raw_bpp = 0;
	unsigned int cspace = 0;

	value = CICR1;
	value &= ((CI_CICR1_PPL_SMASK << CI_CICR1_PPL_SHIFT) |
		  (CI_CICR1_DW_SMASK << CI_CICR1_DW_SHIFT));

	switch (input_format) {
	case CI_RAW8:
		cspace = 0;
		raw_bpp = 0;
		break;
	case CI_RAW9:
		cspace = 0;
		raw_bpp = 1;
		break;
	case CI_RAW10:
		cspace = 0;
		raw_bpp = 2;
		break;
	case CI_YCBCR422:
	case CI_YCBCR422_PLANAR:
		cspace = 2;
		if (output_format == CI_YCBCR422_PLANAR) {
			ycbcr_f = 1;
		}
		break;
	case CI_RGB444:
		cspace = 1;
		rgb_bpp = 0;
		break;
	case CI_RGB555:
		cspace = 1;
		rgb_bpp = 1;
		if (output_format == CI_RGBT555_0) {
			rgbt_conv = 2;
			tbit = 0;
		} else if (output_format == CI_RGBT555_1) {
			rgbt_conv = 2;
			tbit = 1;
		}
		break;
	case CI_RGB565:
		cspace = 1;
		rgb_bpp = 2;
		rgb_f = 1;
		break;
	case CI_RGB666:
		cspace = 1;
		rgb_bpp = 3;
		if (output_format == CI_RGB666_PACKED) {
			rgb_f = 1;
		}
		break;
	case CI_RGB888:
	case CI_RGB888_PACKED:
		cspace = 1;
		rgb_bpp = 4;
		switch (output_format) {
		case CI_RGB888_PACKED:
			rgb_f = 1;
			break;
		case CI_RGBT888_0:
			rgbt_conv = 1;
			tbit = 0;
			break;
		case CI_RGBT888_1:
			rgbt_conv = 1;
			tbit = 1;
			break;
		case CI_RGB666:
			rgb_conv = 1;
			break;
		case CI_RGB666_PACKED:
			rgb_conv = 1;
			rgb_f = 1;
			break;
		case CI_RGB565:
			rgb_conv = 2;
			break;
		case CI_RGB555:
			rgb_conv = 3;
			break;
		case CI_RGB444:
			rgb_conv = 4;
			break;
		default:
			break;
		}
		break;
	default:
		break;
	}
	value |= (tbit == 1) ? CI_CICR1_TBIT : 0;
	value |= rgbt_conv << CI_CICR1_RGBT_CONV_SHIFT;
	value |= rgb_conv << CI_CICR1_RGB_CONV_SHIFT;
	value |= (rgb_f == 1) ? CI_CICR1_RBG_F : 0;
	value |= (ycbcr_f == 1) ? CI_CICR1_YCBCR_F : 0;
	value |= rgb_bpp << CI_CICR1_RGB_BPP_SHIFT;
	value |= raw_bpp << CI_CICR1_RAW_BPP_SHIFT;
	value |= cspace << CI_CICR1_COLOR_SP_SHIFT;

	CICR1 = value;
}

static void ci_configure_mp(unsigned int ppl, unsigned int lpf,
			    unsigned int bfw, unsigned int blw)
{
	unsigned int value;

	/* write ppl field in cicr1 (pixel per line) */
	value = CICR1;
	value &= ~(CI_CICR1_PPL_SMASK << CI_CICR1_PPL_SHIFT);
	value |= (ppl & CI_CICR1_PPL_SMASK) << CI_CICR1_PPL_SHIFT;
	CICR1 = value;

	/* write BLW, ELW in cicr2  (Beginning/End of Line)) */
	value = CICR2;
	value &=
	    ~(CI_CICR2_BLW_SMASK << CI_CICR2_BLW_SHIFT | CI_CICR2_ELW_SMASK <<
	      CI_CICR2_ELW_SHIFT);
	value |= (blw & CI_CICR2_BLW_SMASK) << CI_CICR2_BLW_SHIFT;
	CICR2 = value;

	/* write BFW, LPF in cicr3 (Beginning of Frame, Lines per Frame) */
	value = CICR3;
	value &=
	    ~(CI_CICR3_BFW_SMASK << CI_CICR3_BFW_SHIFT | CI_CICR3_LPF_SMASK <<
	      CI_CICR3_LPF_SHIFT);
	value |= (bfw & CI_CICR3_BFW_SMASK) << CI_CICR3_BFW_SHIFT;
	value |= (lpf & CI_CICR3_LPF_SMASK) << CI_CICR3_LPF_SHIFT;
	CICR3 = value;
}

static void camera_gpio_init(void)
{
	pxa_gpio_mode(27 | GPIO_ALT_FN_3_IN);	/* CIF_DD[0] */
	pxa_gpio_mode(114 | GPIO_ALT_FN_1_IN);	/* CIF_DD[1] */
	pxa_gpio_mode(116 | GPIO_ALT_FN_1_IN);	/* CIF_DD[2] */
	pxa_gpio_mode(115 | GPIO_ALT_FN_2_IN);	/* CIF_DD[3] */

	pxa_gpio_mode(  90 | GPIO_OUT); /*general purpose Out */
	pxa_gpio_mode(  91 | GPIO_OUT); /*general purpose Out */
	pxa_gpio_mode(  52 | GPIO_ALT_FN_1_IN); /* CIF_DD[4] */
	pxa_gpio_mode(  82 | GPIO_ALT_FN_3_IN); /* CIF_DD[5] */

	pxa_gpio_mode(17 | GPIO_ALT_FN_2_IN);	/* CIF_DD[6] */
	pxa_gpio_mode(12 | GPIO_ALT_FN_2_IN);	/* CIF_DD[7] */
	pxa_gpio_mode(23 | GPIO_ALT_FN_1_OUT);	/* CIF_MCLK */
	pxa_gpio_mode(26 | GPIO_ALT_FN_2_IN);	/* CIF_PCLK */
	pxa_gpio_mode(25 | GPIO_ALT_FN_1_IN);	/* CIF_LV */
	pxa_gpio_mode(24 | GPIO_ALT_FN_1_IN);	/* CIF_FV */
	return;
}

static int ci_init(void)
{
	ci_regs_base = (unsigned long)ioremap(CI_REGS_PHYS, CI_REG_SIZE);
	if (!ci_regs_base) {
		pr_debug(F("can't remap I/O registers at %x"), CI_REGS_PHYS);
		return -1;
	}

	/* clear all CI registers */
	CICR0 = 0x3FF;		/* disable all interrupts */
	CICR1 = 0;
	CICR2 = 0;
	CICR3 = 0;
	CICR4 = 0;
	CISR = ~0;
	CIFR = 0;
	CITOR = 0;

	/* enable CI clock */
	CKEN |= CKEN24_CAMERA;
	return 0;
}

static int ci_disable_quick(void)
{
	int i;
	CICR0 &= ~CI_CICR0_ENB;
	for (i = 0; 1; i++) {
		if (CISR & CI_CISR_CQD) {
			CISR |= CI_CISR_CQD;
			return 0;
		}
		if (i >= 500) {
			pr_debug(F("timeout; giving up"));
			return -EIO;
		}
		msleep(10);
	}
}

/* END capture interface */

/* protects mainstone_xxxing, pix_format */
static DECLARE_MUTEX(mainstone_video_sema);

/*
 * mainstone_xxxing != 0 iff this descriptor is used to
 * read, stream or overlay videodata.
 * - reading is triggered when user read() or select for first time;
 * - streaming mode is selected when user does REQBUFS ioctl and
 * is triggered in STREAMON ioctl
 * - overlay mode is triggered in OVERLAY ioctl
 */
#if CONFIG_FB_PXA
static struct file *mainstone_previewing;
#else
# define mainstone_previewing 0
#endif
static struct file *mainstone_streaming;
static struct file *mainstone_reading;
static int mainstone_streaming_streamon;
static struct v4l2_pix_format pix_format;

static int video_nr;
static struct videobuf_queue mainstone_queue;

static unsigned int mclk_khz = CI_MCLK_DEFT;

static unsigned int camera_width = CAMERA_WIDTH_DEFAULT;
static unsigned int camera_height = CAMERA_HEIGHT_DEFAULT;

static void camera_find_size(unsigned int *width, unsigned int *height)
{
	pr_debug(F("size requested : %dx%d"), *width, *height);

	/* dma chunk size must be a multiple of 8 */
	*width -= *width & 7;

	if (!*width)
		*width = 8;

	if (*width > CAMERA_WIDTH_MAX)
		*width = CAMERA_WIDTH_MAX;

	if (!*height)
		*height = 8;

	if (*height > CAMERA_HEIGHT_MAX)
		*height = CAMERA_HEIGHT_MAX;

	pr_debug(F("size granted : %dx%d"), *width, *height);
}

/*
 * list of image formats
 */
/* *INDENT-OFF* */
static const struct {

	/* the same as in struct v4l2_pix_format */
	__u32 pixelformat;
	__u8 description[32];
	enum v4l2_colorspace colorspace;

	/* for packed formats, how many pixels are in one packet */
	unsigned int pixels;
	/* how many bytes takes one pixel (for packed formats -- one packet) */
	unsigned int bytes;

	/* value to be programmed into camera's control register */
	//unsigned int capture_format;

	/* values programmed into ci control registers */
	unsigned int ci_in_format;
	unsigned int ci_out_format;

} camera_formats[] = {
	{
		/* first entry is default */
		.pixelformat    = V4L2_PIX_FMT_RGB565,
		.description    = "565 RGB",
		.colorspace     = V4L2_COLORSPACE_SRGB,
		.pixels         = 1,
		.bytes          = 2,
		//.capture_format = ADCM2650_O_FORMAT_888RGB,
		.ci_in_format   = CI_RGB888_PACKED,
		.ci_out_format  = CI_RGB565,
	}, {
		.pixelformat    = V4L2_PIX_FMT_RGB24,
		.description    = "888 RGB Packed",
		.colorspace     = V4L2_COLORSPACE_SRGB,
		.pixels         = 2,
		.bytes          = 6,
		//.capture_format = ADCM2650_O_FORMAT_888RGB,
		.ci_in_format   = CI_RGB888_PACKED,
		.ci_out_format  = CI_RGB888_PACKED,
	}, {
		.pixelformat    = V4L2_PIX_FMT_RGB32,
		.description    = "888 RGB",
		.colorspace     = V4L2_COLORSPACE_SRGB,
		.pixels         = 1,
		.bytes          = 4,
		//.capture_format = ADCM2650_O_FORMAT_888RGB,
		.ci_in_format   = CI_RGB888_PACKED,
		.ci_out_format  = CI_RGB888,
	}, {
		.pixelformat    = V4L2_PIX_FMT_RGB555,
		.description    = "555 RGB",
		.colorspace     = V4L2_COLORSPACE_SRGB,
		.pixels         = 1,
		.bytes          = 2,
		//.capture_format = ADCM2650_O_FORMAT_888RGB,
		.ci_in_format   = CI_RGB888_PACKED,
		.ci_out_format  = CI_RGB555,
	}, {
		.pixelformat    = V4L2_PIX_FMT_YUYV,
		.description    = "4:2:2 YCbCr",
		.colorspace     = V4L2_COLORSPACE_JPEG,
		.pixels         = 2,
		.bytes          = 4,
		//.capture_format = ADCM2650_O_FORMAT_422_A_YCbYCr,
		.ci_in_format   = CI_YCBCR422,
		.ci_out_format  = CI_YCBCR422,
	}, {
		.pixelformat    = V4L2_PIX_FMT_GREY,
		.description    = "GREY",
		.colorspace     = V4L2_COLORSPACE_SRGB,
		.pixels         = 1,
		.bytes          = 1,
		//.capture_format = ADCM2650_O_FORMAT_888RGB,
		.ci_in_format   = CI_RAW8,
		.ci_out_format  = CI_RAW8,
	}
	
};

const struct v4l2_queryctrl mt9v022_controls[] = {
	{
		.id		= V4L2_CID_VFLIP,
		.type		= V4L2_CTRL_TYPE_BOOLEAN,
		.name		= "Flip Vertically",
		.minimum	= 0,
		.maximum	= 1,
		.step		= 1,
		.default_value	= 0,
	}, {
		.id		= V4L2_CID_HFLIP,
		.type		= V4L2_CTRL_TYPE_BOOLEAN,
		.name		= "Flip Horizontally",
		.minimum	= 0,
		.maximum	= 1,
		.step		= 1,
		.default_value	= 0,
	}, {
		.id		= V4L2_CID_GAIN,
		.type		= V4L2_CTRL_TYPE_INTEGER,
		.name		= "Analog Gain",
		.minimum	= 64,
		.maximum	= 127,
		.step		= 1,
		.default_value	= 64,
		.flags		= V4L2_CTRL_FLAG_SLIDER,
	}, {
		.id		= V4L2_CID_EXPOSURE,
		.type		= V4L2_CTRL_TYPE_INTEGER,
		.name		= "Exposure",
		.minimum	= 1,
		.maximum	= 255,
		.step		= 1,
		.default_value	= 255,
		.flags		= V4L2_CTRL_FLAG_SLIDER,
	}, {
		.id		= V4L2_CID_AUTOGAIN,
		.type		= V4L2_CTRL_TYPE_BOOLEAN,
		.name		= "Automatic Gain",
		.minimum	= 0,
		.maximum	= 1,
		.step		= 1,
		.default_value	= 1,
	}, {
		.id		= V4L2_CID_EXPOSURE_AUTO,
		.type		= V4L2_CTRL_TYPE_BOOLEAN,
		.name		= "Automatic Exposure",
		.minimum	= 0,
		.maximum	= 1,
		.step		= 1,
		.default_value	= 1,
	}
};

static struct v4l2_queryctrl const *soc_camera_find_qctrl(int id)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(mt9v022_controls); i++)
	{
		if (mt9v022_controls[i].id == id)
			return &mt9v022_controls[i];
	}
	return NULL;
}

/* *INDENT-ON* */

static int camera_find_format(unsigned int pixelformat)
{
	unsigned int i;

	for (i = 0; i < ARRAY_SIZE(camera_formats); i++) {
		if (pixelformat == camera_formats[i].pixelformat)
			break;
	}
	if (i == ARRAY_SIZE(camera_formats)) {
		i = 0;
	}

	return i;
}

static void try_pix_format(struct v4l2_pix_format *format)
{
	int i;

	camera_find_size(&format->width, &format->height);

	i = camera_find_format(format->pixelformat);
	format->pixelformat = camera_formats[i].pixelformat;
	format->field = V4L2_FIELD_NONE;
	format->bytesperline =
	    (format->width / camera_formats[i].pixels) *
	    camera_formats[i].bytes;
	format->sizeimage = format->bytesperline * format->height;
	format->colorspace = camera_formats[i].colorspace;
	format->priv = 0;

}

/* BEGIN void units */

/*
 * these units (dma chains for length of one image) are used
 * when there are no buffers to fill got from user
 */

/* how many void units must be allocated */
#define VOID_UNITS_NUMBER 3
/* how many bytes can be transferred by one descriptor */
#define BYTES_PER_DMA_DESCRIPTOR_TRANSFER ((unsigned int)(8 * 1024 - 32))

struct void_unit {
	struct pxa_dma_desc *begin;
	struct pxa_dma_desc *end;
	dma_addr_t begin_phys;
	dma_addr_t end_phys;
};

/* registry of all the free units */
static struct void_unit void_units[VOID_UNITS_NUMBER];
static unsigned int void_unit_descriptors_per_unit;
static unsigned int void_unit_descriptors_memory_length;
static unsigned int void_unit_next_free;

/*
 * Allocate VOID_UNITS_NUMBER number of void units
 * Each to thansfer 'pix_format.sizeimage' bytes
 */
static int void_unit_allocate(void)
{
	unsigned int i;
	unsigned int j;
	struct pxa_dma_desc *chain;
	dma_addr_t chain_phys;
	dma_addr_t dev_null_phys;
	unsigned int length_remained;
	unsigned int descriptor_length;
	unsigned int length = pix_format.sizeimage;

	pr_debug(F0);

	void_unit_descriptors_per_unit =
	    (length + BYTES_PER_DMA_DESCRIPTOR_TRANSFER - 1) /
	    BYTES_PER_DMA_DESCRIPTOR_TRANSFER;

	void_unit_descriptors_memory_length =
	    void_unit_descriptors_per_unit * sizeof(pxa_dma_desc) *
	    VOID_UNITS_NUMBER + sizeof(unsigned int);

	/*
	 * allocate VOID_UNITS_NUMBER void units each 'length'
	 * descriptors length plus a place where data will go
	 * (analog of /dev/null)
	 */
	void_units[0].begin =
	    dma_alloc_coherent(0, void_unit_descriptors_memory_length,
			       &void_units[0].begin_phys, GFP_KERNEL | GFP_DMA);
	if (!void_units[0].begin) {
		pr_debug(F("dma_alloc_coherent()"));
		return -ENOMEM;
	}

	dev_null_phys = void_units[0].begin_phys +
	    void_unit_descriptors_per_unit *
	    sizeof(pxa_dma_desc) * VOID_UNITS_NUMBER;

	for (i = 0; i < VOID_UNITS_NUMBER; i++) {

		void_units[i].begin = void_units[0].begin +
		    void_unit_descriptors_per_unit * i;

		void_units[i].end = void_units[0].begin +
		    void_unit_descriptors_per_unit * (i + 1) - 1;

		void_units[i].begin_phys = void_units[0].begin_phys +
		    void_unit_descriptors_per_unit * i *
		    sizeof(struct pxa_dma_desc);

		void_units[i].end_phys = void_units[0].begin_phys +
		    (void_unit_descriptors_per_unit * (i + 1) - 1) *
		    sizeof(struct pxa_dma_desc);

		chain = void_units[i].begin;
		chain_phys = void_units[i].begin_phys;
		length_remained = length;

		for (j = 0; j < void_unit_descriptors_per_unit; j++) {

			descriptor_length =
			    min(length_remained,
				BYTES_PER_DMA_DESCRIPTOR_TRANSFER);

			chain->ddadr = chain_phys + sizeof(struct pxa_dma_desc);
			chain->dsadr = CIBR0_PHY;
			chain->dtadr = dev_null_phys;
			chain->dcmd =
			    descriptor_length | DCMD_FLOWSRC | DCMD_BURST32;

			chain += 1;
			chain_phys += sizeof(struct pxa_dma_desc);
			length_remained -= descriptor_length;

		}

		void_units[i].end->dcmd |= DCMD_ENDIRQEN;
	}

	void_unit_next_free = 0;

	return 0;
}

/*
 * Free all the void units allocated by void_units_allocate()
 */
static void void_unit_free(void)
{
	pr_debug(F0);

	if (void_units[0].begin) {
		dma_free_coherent(0, void_unit_descriptors_memory_length,
				  void_units[0].begin,
				  void_units[0].begin_phys);
		void_units[0].begin = 0;
	}
}

/* END void units */

/* BEGIN videobuffer units */

struct videobuffer {

	/* this must be the first entry */
	struct videobuf_buffer buffer;

	/*
	 * A unit of dma descriptors for videobuffer
	 * allocated in prepare() callback
	 */
	struct pxa_dma_desc *begin;
	struct pxa_dma_desc *end;
	dma_addr_t begin_phys;

};

static int videobuffer_unit_allocate(struct videobuffer *vb)
{
	unsigned int i;
	unsigned int unit_length = pix_format.sizeimage;

	pr_debug(F("buffer : %d"), VIDEOBUF_INDEX(&vb->buffer));

	/* already allocated */
	BUG_ON(vb->begin);

	/*
	 * dma.pages : memory from user-space pointers,
	 * allocated in userland and splitted to series of pages
	 * in videobuf_dma_init_user() (using get_user_pages())
	 * and then by videobuf_pages_to_sg() each page
	 * becomes an element of scatterlist.
	 *
	 * dma.vmalloc : allocated in kernelspace,
	 * in videobuf_dma_init_kernel() using vmalloc()
	 * and splitted to pages in videobuf_vmalloc_to_sg()
	 *
	 * so, in either case each element of dma.sglist
	 * has length <= PAGE_SIZE and vb->dma.sglen == nr_pages
	 * It depends on the current implementation of
	 * videobuffer
	 *
	 * dma.bus_addr : memory comes from framebuffer,
	 * scatterlist built in videobuf_dma_pci_map()
	 * and consists of exactly 1 element that describes all
	 * the continuous buffer.
	 */

	BUG_ON(!(vb->buffer.dma.pages || vb->buffer.dma.vmalloc) ||
	       vb->buffer.dma.bus_addr);

	BUG_ON(vb->buffer.dma.sglen != vb->buffer.dma.nr_pages);

	BUG_ON(mainstone_previewing);

	vb->begin =
	    dma_alloc_coherent(0,
			       vb->buffer.dma.nr_pages * sizeof(pxa_dma_desc),
			       &vb->begin_phys, GFP_KERNEL | GFP_DMA);
	if (!vb->begin) {
		pr_debug(F("dma_alloc_coherent()"));
		return -ENOMEM;
	}

	vb->end = vb->begin + vb->buffer.dma.nr_pages - 1;

	for (i = 0; i < vb->buffer.dma.sglen; i++) {

		struct pxa_dma_desc *dr = vb->begin + i;
		struct scatterlist *sl = vb->buffer.dma.sglist + i;
		unsigned int burst_size;
		unsigned int chunk_length =
		    min((unsigned int)(PAGE_SIZE - sl->offset), unit_length);

		if (!(sl->offset & 31))
			burst_size = DCMD_BURST32;
		else if (!(sl->offset & 15))
			burst_size = DCMD_BURST16;
		else if (!(sl->offset & 7))
			burst_size = DCMD_BURST8;
		else {
			/*
			 * we've checked in QBUF ioctl that
			 * userpointer is aligned
			 */
			burst_size = 0;	/* to prevent warning */
			BUG();
		}

		dr->ddadr =
		    vb->begin_phys + (i + 1) * sizeof(struct pxa_dma_desc);
		dr->dsadr = CIBR0_PHY;
		dr->dtadr = sl->dma_address;
		dr->dcmd =
		    chunk_length | DCMD_FLOWSRC | DCMD_INCTRGADDR | burst_size;

		unit_length -= chunk_length;

	}

	vb->end->dcmd |= DCMD_ENDIRQEN;

	return 0;
}

static void videobuffer_unit_free(struct videobuffer *vb)
{

	pr_debug(F("buffer : %d"), VIDEOBUF_INDEX(&vb->buffer));

	if (!vb->begin) {
		pr_debug(F("already free"));
		return;
	}

	dma_free_coherent(0, vb->buffer.dma.nr_pages * sizeof(pxa_dma_desc),
			  vb->begin, vb->begin_phys);

	vb->begin = 0;
}

/* END videobuffer units */

/* BEGIN units */

static int dma_channel_number = -1;
static __u32 sequence;

static DEFINE_SPINLOCK(mainstone_irq_lock);
static LIST_HEAD(queued_buffers);

/*
 * Any time we have three 'units' ready to dma.
 * Each of the 'units' is a part of running dma chain,
 * and each 'unit' is next in this chain to the other.
 * Each of the 'units' represent either a buffer
 * for one frame where pixel data goes or 'void chain'.
 *
 * Interrupt routine is triggered when the first unit
 * completely ends. At this time the second unit
 * becomes the first, third becomes the second and
 * the routine makes a new third unit either
 * from queued_buffers or, if queued_buffers is empty,
 * from void chains.
 */

struct unit {
	struct pxa_dma_desc *end;
	struct videobuf_buffer *videobuffer;
};

#define UNITS_LENGTH 3
static struct unit units[UNITS_LENGTH];
static unsigned int last_unit;

/*
 * All buffers that are in units array also go here.
 * This list is needed because videobuffer in
 * videobuf_queue_cancel() calls list_del(&q->bufs[i]->queue);
 * for each buffer with STATE_QUEUED.
 */
static LIST_HEAD(units_buffers);

#define UNIT_1 units[(last_unit - 2) % UNITS_LENGTH]
#define UNIT_2 units[(last_unit - 1) % UNITS_LENGTH]
#define UNIT_3 units[(last_unit - 0) % UNITS_LENGTH]

/* waitqueue to wait dma stop */
static DECLARE_WAIT_QUEUE_HEAD(dma_stop_waitqueue);

/*
 * Adds new unit to the dma chain.
 * Returns phys address of first descriptor of added unit
 * Call under mainstone_irq_lock held
 */
static dma_addr_t add_unit3(void)
{

	dma_addr_t retval;

	if (list_empty(&queued_buffers)) {

		unsigned int void_unit_index =
		    void_unit_next_free++ % VOID_UNITS_NUMBER;

		pr_debug(F("void"));

		UNIT_3.end = void_units[void_unit_index].end;
		UNIT_3.videobuffer = 0;

		retval = void_units[void_unit_index].begin_phys;

	} else {

		struct videobuffer *vb =
		    (struct videobuffer *)VIDEOBUF_BUFFER(queued_buffers.next);

		pr_debug(F("buffer : %d"), VIDEOBUF_INDEX(&vb->buffer));

		BUG_ON(!vb->begin);

		list_del(&vb->buffer.queue);
		list_add(&vb->buffer.queue, &units_buffers);

		UNIT_3.end = vb->end;
		UNIT_3.videobuffer = &vb->buffer;

		retval = vb->begin_phys;

	}

	return retval;
}

/*
 * Set up units from queued_buffers and void chains and run dma.
 */
static void units_start(void)
{
	unsigned int flags;

	pr_debug(F0);

	spin_lock_irqsave(&mainstone_irq_lock, flags);

	DCSR(dma_channel_number) = 0;
	DDADR(dma_channel_number) = add_unit3();

	last_unit++;
	UNIT_2.end->ddadr = add_unit3();

	last_unit++;
	UNIT_2.end->ddadr = add_unit3();

	DCSR(dma_channel_number) &= ~DCSR_STOPIRQEN;
	DCSR(dma_channel_number) |= DCSR_RUN;

	spin_unlock_irqrestore(&mainstone_irq_lock, flags);
}

static struct pxa_dma_desc *stop_descriptor;
static u32 stop_descriptor_ddadr;

/*
 * Stop dma and wait while the current unit ends.
 */
static void units_stop(void)
{
	DECLARE_WAITQUEUE(wait, current);
	unsigned int flags;

	pr_debug(F0);

	spin_lock_irqsave(&mainstone_irq_lock, flags);

	DCSR(dma_channel_number) |= DCSR_STOPIRQEN;

	stop_descriptor = UNIT_3.end;
	stop_descriptor_ddadr = UNIT_3.end->ddadr;
	UNIT_3.end->ddadr = DDADR_STOP;

	spin_unlock_irqrestore(&mainstone_irq_lock, flags);

	/* wait when dma controller stops */
	add_wait_queue(&dma_stop_waitqueue, &wait);
	set_current_state(TASK_UNINTERRUPTIBLE);

	while (1) {
		if (DCSR(dma_channel_number) & DCSR_STOPSTATE)
			break;
		schedule();
	}

	set_current_state(TASK_RUNNING);
	remove_wait_queue(&dma_stop_waitqueue, &wait);

}

static void dma_irq(int channel, void *data, struct pt_regs *regs)
{
	unsigned long flags;
	unsigned int dcsr;

	spin_lock_irqsave(&mainstone_irq_lock, flags);

	dcsr = DCSR(dma_channel_number);

	pr_debug(F("dcsr : %08x"), dcsr);

	if (dcsr & DCSR_ENDINTR) {

		/* reset interrupt */
		DCSR(dma_channel_number) = dcsr | DCSR_ENDINTR;

		if (UNIT_1.videobuffer) {

			struct videobuf_buffer *vb = UNIT_1.videobuffer;

			pr_debug(F("buffer : %d"), VIDEOBUF_INDEX(vb));

			list_del(&vb->queue);
			do_gettimeofday(&vb->ts);
			vb->field_count = sequence++;
			vb->state = STATE_DONE;
			wake_up(&vb->done);

		} else {
			pr_debug(F("void"));
		}

		last_unit++;
		if (UNIT_2.end->ddadr != DDADR_STOP) {
			UNIT_2.end->ddadr = add_unit3();
		} else {
			UNIT_3.videobuffer = 0;
			/*
			 * Let the new last descriptor has
			 * ddadr == DDADR_STOP just not to forget
			 * on the next irq that we are shutting down
			 */
			UNIT_3.end = UNIT_2.end;
		}

	}

	if (dcsr & DCSR_STOPSTATE) {

		pr_debug(F("stop (%08x)"), dcsr);

		if (stop_descriptor_ddadr) {
			stop_descriptor->ddadr = stop_descriptor_ddadr;
			stop_descriptor_ddadr = 0;
		}

		DCSR(dma_channel_number) = (dcsr & ~DCSR_STOPIRQEN);
		wake_up_all(&dma_stop_waitqueue);
	}

	spin_unlock_irqrestore(&mainstone_irq_lock, flags);

}

/* END units */

#ifdef CONFIG_FB_PXA
/* BEGIN overlay */

static struct v4l2_window window_format;
static struct v4l2_framebuffer framebuffer_format;

static struct pxa_dma_desc *overlay_descr_begin;
static dma_addr_t overlay_descr_begin_phys;
static unsigned int overlay_descr_number;

/* Round to the nearest 8-aligned signed integer */
static inline void align_8(__s32 * v)
{
	__s32 shift = *v & 7;
	if (shift >= 4)
		shift = shift - 8;
	*v -= shift;
}

/*
 * Height and width must be one of the standard values
 * Offset of upper left corner must be an integer multiple of 8
 * No chroma-key, clips etc.
 */
static void try_window_format(struct v4l2_window *format)
{

	unsigned int width;
	unsigned int height;

	pr_debug(F0);

	if (format->w.width > 0)
		width = format->w.width;
	else
		width = -format->w.width;

	if (format->w.height > 0)
		height = format->w.height;
	else
		height = -format->w.height;

	camera_find_size(&width, &height);

	align_8(&format->w.left);

	format->w.width = width;
	format->w.height = height;

	format->field = V4L2_FIELD_NONE;
	format->chromakey = 0;
	format->clips = 0;
	format->clipcount = 0;
	format->bitmap = 0;
}

static void try_framebuffer_format(struct v4l2_framebuffer *format)
{
	format->capability = 0;
	format->flags = V4L2_FBUF_FLAG_PRIMARY;
	/* agree with user's base and fmt -- it's superuser */
}

static inline int aligned_8(unsigned int v)
{
	return !(v & 7);
}

static int overlay_allocate(void)
{
	/* in pixels */
	unsigned int left_shaded = 0;
	unsigned int right_shaded = 0;

	unsigned int top_shaded = 0;
	unsigned int bottom_shaded = 0;

	unsigned int view_width;
	unsigned int view_height;

	struct pxa_dma_desc *descr;
	dma_addr_t descr_phys;
	/* in bytes */
	unsigned int descr_length;

	dma_addr_t fb_address;

	unsigned int i;
	dma_addr_t dev_null_phys;

	unsigned int pixels;
	unsigned int bytes;

	pr_debug(F0);

	if (!framebuffer_format.base) {
		int i;

		pr_debug(F
			 ("framebuffer is not configured, trying to initialize by default
value..."));
		for (i = 0; i < FB_MAX; i++) {
			if (!registered_fb[i])
				continue;
			if (!strcmp(registered_fb[i]->fix.id, "PXA"))
				break;
		}

		if (i == FB_MAX) {
			pr_debug(F("could not find pxa framebuffer"));
			return -EINVAL;
		}

		/*
		 * This depends on the current implementation
		 * of pxa framebuffer, namely
		 *
		 * - the id of pxa framebuffer is "PXA"
		 * - it is initialized at the beginning
		 * - memory allocated at initialization is never freed
		 * - the framebuffer geometry never changes
		 * - pixelformat is rgb565 and never changes
		 */

		framebuffer_format.base =
		    (void *)registered_fb[i]->fix.smem_start;
		framebuffer_format.fmt.width = registered_fb[i]->var.xres;
		framebuffer_format.fmt.height = registered_fb[i]->var.yres;
		framebuffer_format.fmt.pixelformat = V4L2_PIX_FMT_RGB565;
		framebuffer_format.fmt.field = V4L2_FIELD_NONE;
		framebuffer_format.fmt.bytesperline =
		    registered_fb[i]->var.xres * 2;
		framebuffer_format.fmt.sizeimage =
		    registered_fb[i]->var.xres * registered_fb[i]->var.xres * 2;
		framebuffer_format.fmt.colorspace = V4L2_COLORSPACE_SRGB;

	}

	{
		unsigned int format_index =
		    camera_find_format(framebuffer_format.fmt.pixelformat);

		if (camera_formats[format_index].pixelformat !=
		    framebuffer_format.fmt.pixelformat) {
			pr_debug(F
				 ("the format of framebuffer is not supported"));
			return -EINVAL;
		}

		pixels = camera_formats[format_index].pixels;
		bytes = camera_formats[format_index].bytes;
	}

	if (window_format.w.left < 0)
		left_shaded = -window_format.w.left;

	if ((window_format.w.left + window_format.w.width) >
	    framebuffer_format.fmt.width)
		right_shaded =
		    window_format.w.left + window_format.w.width -
		    framebuffer_format.fmt.width;

	if (window_format.w.top < 0)
		top_shaded = -window_format.w.top;

	if ((window_format.w.top + window_format.w.height) >
	    framebuffer_format.fmt.height)
		bottom_shaded =
		    window_format.w.top + window_format.w.height -
		    framebuffer_format.fmt.height;

	if (left_shaded >= window_format.w.width ||
	    right_shaded >= window_format.w.width ||
	    top_shaded >= window_format.w.height ||
	    bottom_shaded >= window_format.w.height) {
		pr_debug(F("nothing to show"));
		return -EINVAL;
	}

	view_width = window_format.w.width - left_shaded - right_shaded;
	view_height = window_format.w.height - top_shaded - bottom_shaded;

	overlay_descr_number =
	    top_shaded + bottom_shaded +
	    ((left_shaded ? 1 : 0) + 1 + (right_shaded ? 1 : 0))
	    * view_height;

	/* we must have checked this in ioctls */
	BUG_ON(!aligned_8(left_shaded) || !aligned_8(right_shaded) ||
	       !aligned_8(view_width));

	pr_debug(F
		 ("left_shaded:%u; right_shaded:%u; top_shaded:%u; bottom_shaded:%u;"),
		 left_shaded, right_shaded, top_shaded, bottom_shaded);
	pr_debug(F("view_width:%u; view_height:%u; pixels:%u; bytes:%u;"),
		 view_width, view_height, pixels, bytes);

	overlay_descr_begin =
	    dma_alloc_coherent(0,
			       overlay_descr_number *
			       sizeof(struct pxa_dma_desc)
			       + sizeof(unsigned int),
			       &overlay_descr_begin_phys, GFP_KERNEL | GFP_DMA);
	if (!overlay_descr_begin) {
		pr_debug(F("dma_alloc_coherent()"));
		return -ENOMEM;
	}

	descr = overlay_descr_begin;
	descr_phys = overlay_descr_begin_phys;

	fb_address = (unsigned int)framebuffer_format.base;
	if (window_format.w.top > 0) {
		fb_address +=
		    window_format.w.top * framebuffer_format.fmt.bytesperline;
	}
	if (window_format.w.left > 0) {
		fb_address += (window_format.w.left / pixels) * bytes;
	}

	dev_null_phys = descr_phys +
	    overlay_descr_number * sizeof(struct pxa_dma_desc);

	descr_length = (window_format.w.width / pixels) * bytes;
	for (i = 0; i < top_shaded; i++) {
		descr->ddadr = descr_phys + sizeof(struct pxa_dma_desc);
		descr->dsadr = CIBR0_PHY;
		descr->dtadr = dev_null_phys;
		descr->dcmd =
		    descr_length | DCMD_FLOWSRC | DCMD_INCTRGADDR | DCMD_BURST8;

		descr += 1;
		descr_phys += sizeof(struct pxa_dma_desc);
	}

	for (i = 0; i < view_height; i++) {

		if (left_shaded) {
			descr_length = (left_shaded / pixels) * bytes;

			descr->ddadr = descr_phys + sizeof(struct pxa_dma_desc);
			descr->dsadr = CIBR0_PHY;
			descr->dtadr = dev_null_phys;
			descr->dcmd =
			    descr_length | DCMD_FLOWSRC | DCMD_INCTRGADDR |
			    DCMD_BURST8;

			descr += 1;
			descr_phys += sizeof(struct pxa_dma_desc);
		}

		descr_length = (view_width / pixels) * bytes;

		descr->ddadr = descr_phys + sizeof(struct pxa_dma_desc);
		descr->dsadr = CIBR0_PHY;
		descr->dtadr = fb_address;
		descr->dcmd =
		    descr_length | DCMD_FLOWSRC | DCMD_INCTRGADDR | DCMD_BURST8;

		descr += 1;
		descr_phys += sizeof(struct pxa_dma_desc);
		fb_address += framebuffer_format.fmt.bytesperline;

		if (right_shaded) {
			descr_length = (right_shaded / pixels) * bytes;

			descr->ddadr = descr_phys + sizeof(struct pxa_dma_desc);
			descr->dsadr = CIBR0_PHY;
			descr->dtadr = dev_null_phys;
			descr->dcmd =
			    descr_length | DCMD_FLOWSRC | DCMD_INCTRGADDR |
			    DCMD_BURST8;

			descr += 1;
			descr_phys += sizeof(struct pxa_dma_desc);
		}
	}

	descr_length = (window_format.w.width / pixels) * bytes;
	for (i = 0; i < bottom_shaded; i++) {
		descr->ddadr = descr_phys + sizeof(struct pxa_dma_desc);
		descr->dsadr = CIBR0_PHY;
		descr->dtadr = dev_null_phys;
		descr->dcmd =
		    descr_length | DCMD_FLOWSRC | DCMD_INCTRGADDR | DCMD_BURST8;

		descr += 1;
		descr_phys += sizeof(struct pxa_dma_desc);
	}

	descr -= 1;
	descr->ddadr = overlay_descr_begin_phys;

	return 0;

}

static void overlay_free(void)
{
	pr_debug(F0);

	if (!overlay_descr_begin)
		return;

	dma_free_coherent(0, overlay_descr_number * sizeof(struct pxa_dma_desc)
			  + sizeof(unsigned int), overlay_descr_begin,
			  overlay_descr_begin_phys);

	overlay_descr_begin = 0;
}

static void dma_start_overlay(void)
{
	pr_debug(F0);

	DCSR(dma_channel_number) = 0;
	DDADR(dma_channel_number) = overlay_descr_begin_phys;

	DCSR(dma_channel_number) &= ~DCSR_STOPIRQEN;
	DCSR(dma_channel_number) |= DCSR_RUN;
}

static inline void dma_stop_overlay(void)
{
	DECLARE_WAITQUEUE(wait, current);

	pr_debug(F0);

	/* stop dma controller */
	DCSR(dma_channel_number) |= DCSR_STOPIRQEN;
	DCSR(dma_channel_number) &= ~DCSR_RUN;

	/* wait when dma controller stops */
	add_wait_queue(&dma_stop_waitqueue, &wait);
	set_current_state(TASK_UNINTERRUPTIBLE);

	while (1) {
		if (DCSR(dma_channel_number) & DCSR_STOPSTATE)
			break;
		schedule();
	}

	set_current_state(TASK_RUNNING);
	remove_wait_queue(&dma_stop_waitqueue, &wait);
}
#else
static inline void dma_start_overlay(void)
{
}
static inline void dma_stop_overlay(void)
{
}
static inline int overlay_allocate(void)
{
	return 0;
}
static inline void overlay_free(void)
{
}
#endif

/* END overlay */

/* BEGIN dma */

static int dma_start_x(int resume)
{
	unsigned int format_index = camera_find_format(pix_format.pixelformat);
	unsigned int width = pix_format.width;
	unsigned int height = pix_format.height;

	int err;

	pr_debug(F("%s"), resume ? "resume" : "");

#if CONFIG_FB_PXA
	if (mainstone_previewing) {
		format_index =
		    camera_find_format(framebuffer_format.fmt.pixelformat);
		if (camera_formats[format_index].pixelformat !=
		    framebuffer_format.fmt.pixelformat) {
			pr_debug(F
				 ("the format of framebuffer is not supported"));
			return -EINVAL;
		}
		width = window_format.w.width;
		height = window_format.w.height;
	}
#endif

	if (camera_width < width || camera_height < height) {
		/*
		 * we could possibly check that when setting capture size
		 * or camera 'input' size (camera_[height,width]) but that
		 * would restrict the order in which user set these parameters
		 */
		pr_info
		    ("Camera input size must be greater than image format.\n");
		return -EINVAL;
	}

	sequence = 0;

	/* ci: reset fifo */
	CIFR |= CI_CIFR_RESETF;

	/* ci: clear int status */
	CISR = ~0;

	/* set up dma */

	if (!mainstone_previewing) {

		if (!resume) {
			err = void_unit_allocate();
			if (err)
				return err;
		}
		units_start();

	} else {

		if (!resume) {
			/* allocate and initialize dma descriptors for overlay */
			err = overlay_allocate();
			if (err)
				return err;
		}
		/* run overlay dma */
		dma_start_overlay();
	}

	/* program capture interface with video fromat */
	ci_set_image_format(camera_formats[format_index].ci_in_format,
			    camera_formats[format_index].ci_out_format);

	ci_configure_mp(width - 1, height - 1, 0, 0);

	/* ci: enable interface with dma */
	CICR0 |= (CI_CICR0_ENB | CI_CICR0_DMA_EN);

	if(reg_write(MT9V022_WINDOW_WIDTH, width)!=0)
	{
		printk("set width error\n");
	}
	if(reg_write(MT9V022_WINDOW_HEIGHT, height)!=0)
	{
		printk("set height error\n");
	}

	return 0;
}

static inline int dma_start(void)
{
	return dma_start_x(0);
}

static inline int dma_resume(void)
{
	return dma_start_x(1);
}

static void dma_stop_x(int suspend)
{
	pr_debug(F("%s"), suspend ? "suspend" : "");

	/* stop dma and wait for it */

	if (!mainstone_previewing) {

		units_stop();
		if (!suspend) {
			void_unit_free();
		}

	} else {

		dma_stop_overlay();
		if (!suspend) {
			overlay_free();
		}

	}
	ci_disable_quick();

}

static inline void dma_stop(void)
{
	dma_stop_x(0);
}

static inline void dma_suspend(void)
{
	dma_stop_x(1);
}

/* END dma */

/* BEGIN video buffer callbacks */

static void mainstone_vbq_release(struct videobuf_queue *q,
				  struct videobuf_buffer *vb);

static int mainstone_vbq_setup(struct videobuf_queue *q, unsigned int *count,
			       unsigned int *size)
{
	pr_debug(F0);

	if (*count <= 0)
		*count = VIDEO_MAX_FRAME;

	if (*count > VIDEO_MAX_FRAME)
		*count = VIDEO_MAX_FRAME;

	*size = pix_format.sizeimage;

	pr_debug(F("count : %u; size : %u"), *count, *size);

	return 0;
}

static int mainstone_vbq_prepare(struct videobuf_queue *q,
				 struct videobuf_buffer *vb,
				 enum v4l2_field field)
{
	int err = 0;
	
	pr_debug(F("@ buffer : %d"), VIDEOBUF_INDEX(vb));

	if (vb->baddr && (pix_format.sizeimage > vb->bsize)) {
		/* This is a userspace buffer and it isn't big enough. */
		err = -EINVAL;
	}

	vb->size = pix_format.sizeimage;
	vb->width = pix_format.width;
	vb->height = pix_format.height;
	vb->field = field;
	if (err)
		return err;
	if (vb->state == STATE_NEEDS_INIT) {
		err = videobuf_iolock(q, vb, NULL);
		if (!err)
			err =
			    videobuffer_unit_allocate((struct videobuffer *)vb);
	}

	if (!err)
		vb->state = STATE_PREPARED;
	else
		mainstone_vbq_release(q, vb);

	return err;
}

static void mainstone_vbq_queue(struct videobuf_queue *q,
				struct videobuf_buffer *vb)
{
	pr_debug(F("@ buffer : %d"), VIDEOBUF_INDEX(vb));

	vb->state = STATE_QUEUED;

	list_add_tail(&vb->queue, &queued_buffers);
}

static void mainstone_vbq_release(struct videobuf_queue *q,
				  struct videobuf_buffer *vb)
{
	pr_debug(F("@ buffer : %d"), VIDEOBUF_INDEX(vb));

	videobuf_waiton(vb, 0, 0);
	videobuf_pci_dma_unmap(NULL, &vb->dma);
	videobuf_dma_free(&vb->dma);

	videobuffer_unit_free((struct videobuffer *)vb);
	vb->state = STATE_NEEDS_INIT;
}

struct videobuf_queue_ops mainstone_videobuf_queue_ops = {
	.buf_setup = mainstone_vbq_setup,
	.buf_prepare = mainstone_vbq_prepare,
	.buf_queue = mainstone_vbq_queue,
	.buf_release = mainstone_vbq_release,
};

/* END video buffer callbacks */

/* BEGIN file operations */

#ifdef CONFIG_PM
static DECLARE_RWSEM(suspend_rwsem);
#endif

static int
mainstone_do_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
		   void *arg)
{
	int err = 0;

#ifdef CONFIG_PM
	down_read(&suspend_rwsem);
#endif

	switch (cmd) {
	case VIDIOC_ENUMINPUT:
		{
			struct v4l2_input *input = (struct v4l2_input *)arg;
			int index = input->index;

			pr_debug(F("VIDIOC_ENUMINPUT"));

			if (index != 0) {
				err = -EINVAL;
				break;
			}

			memset(input, 0, sizeof(*input));

			input->index = index;
			strlcpy(input->name, "camera", sizeof(input->name));
			input->type = V4L2_INPUT_TYPE_CAMERA;

			break;
		}

	case VIDIOC_G_INPUT:
		{
			unsigned int *input = arg;

			pr_debug(F("VIDIOC_G_INPUT"));

			*input = 0;

			break;
		}

	case VIDIOC_S_INPUT:
		{
			unsigned int *input = arg;

			pr_debug(F("VIDIOC_S_INPUT"));

			if (*input > 0)
				err = -EINVAL;

			break;
		}

	case VIDIOC_QUERYCAP:
		{
			struct v4l2_capability *cap =
			    (struct v4l2_capability *)arg;

			pr_debug(F("VIDIOC_QUERYCAP"));

			memset(cap, 0, sizeof(*cap));
			strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
			strlcpy(cap->card, DEVICE_NAME, sizeof(cap->card));
			cap->bus_info[0] = '\0';
			cap->version = KERNEL_VERSION(0, 0, 0);
			cap->capabilities =
#if CONFIG_FB_PXA
			    V4L2_CAP_VIDEO_OVERLAY |
#endif
			    V4L2_CAP_VIDEO_CAPTURE |
			    V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;

			break;
		}

	case VIDIOC_G_FMT:
		{
			struct v4l2_format *f = (struct v4l2_format *)arg;

			pr_debug(F("VIDIOC_G_FMT"));

			if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {

				struct v4l2_pix_format *pix = &f->fmt.pix;

				down(&mainstone_video_sema);

				*pix = pix_format;

				/*
				 * in videobuffer, the size of videobuffer is aligned to pagesize,
				 * and userspace buffer length is compared to this aligned length.
				 * I don't know why.
				 */
				pix->sizeimage = PAGE_ALIGN(pix->sizeimage);

				up(&mainstone_video_sema);

#if CONFIG_FB_PXA
			} else if (f->type == V4L2_BUF_TYPE_VIDEO_OVERLAY) {

				struct v4l2_window *win = &f->fmt.win;

				down(&mainstone_video_sema);

				*win = window_format;

				up(&mainstone_video_sema);

#endif
			} else {
				err = -EINVAL;
			}

			break;
		}
	case VIDIOC_TRY_FMT:
		{
			struct v4l2_format *f = (struct v4l2_format *)arg;

			pr_debug(F("VIDIOC_TRY_FMT"));

			if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {

				try_pix_format(&f->fmt.pix);

#if CONFIG_FB_PXA
			} else if (f->type == V4L2_BUF_TYPE_VIDEO_OVERLAY) {

				try_window_format(&f->fmt.win);
#endif
			} else {
				err = -EINVAL;
			}

			break;

		}
	case VIDIOC_S_FMT:
		{
			struct v4l2_format *f = (struct v4l2_format *)arg;
			
			pr_debug(F("VIDIOC_S_FMT"));
			
			if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {

				struct v4l2_pix_format *pix = &f->fmt.pix;

				down(&mainstone_video_sema);

				/* cannot change format on the fly */
				if (mainstone_previewing || mainstone_streaming
				    || mainstone_reading) {
					up(&mainstone_video_sema);
					err = -EBUSY;
					break;
				}
				try_pix_format(pix);		

				pix_format = *pix;
				/* see above */
				pix->sizeimage = PAGE_ALIGN(pix->sizeimage);
				up(&mainstone_video_sema);

#if CONFIG_FB_PXA
			} else if (f->type == V4L2_BUF_TYPE_VIDEO_OVERLAY) {

				struct v4l2_window *win = &f->fmt.win;

				down(&mainstone_video_sema);

				/* cannot change format on the fly */
				if (mainstone_previewing || mainstone_streaming
				    || mainstone_reading) {
					up(&mainstone_video_sema);
					err = -EBUSY;
					break;
				}

				try_window_format(win);

				window_format = *win;

				up(&mainstone_video_sema);
#endif
			} else {
				err = -EINVAL;
			}

			break;
		}

	case VIDIOC_ENUM_FMT:
		{
			struct v4l2_fmtdesc *fmt = (struct v4l2_fmtdesc *)arg;
			int index = fmt->index;
			enum v4l2_buf_type type = fmt->type;

			pr_debug(F("VIDIOC_ENUM_FMT"));

			if (index >= ARRAY_SIZE(camera_formats) ||
			    type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
				err = -EINVAL;
				break;
			}

			memset(fmt, 0, sizeof(*fmt));

			fmt->index = index;
			fmt->type = type;
			fmt->flags = 0;
			strlcpy(fmt->description,
				camera_formats[index].description,
				sizeof(fmt->description)
			    );
			fmt->pixelformat = camera_formats[index].pixelformat;

			break;

		}

#if CONFIG_FB_PXA
	case VIDIOC_G_FBUF:
		{
			struct v4l2_framebuffer *fb =
			    (struct v4l2_framebuffer *)arg;

			pr_debug(F("VIDIOC_G_FBUF"));

			down(&mainstone_video_sema);

			*fb = framebuffer_format;

			up(&mainstone_video_sema);

			break;

		}
	case VIDIOC_S_FBUF:
		{
			struct v4l2_framebuffer *fb =
			    (struct v4l2_framebuffer *)arg;

			pr_debug(F("VIDIOC_S_FBUF"));

			if (current->uid && current->euid
			    && !capable(CAP_SYS_ADMIN)) {
				err = -EPERM;
				break;
			}

			down(&mainstone_video_sema);

			/* cannot change format on the fly */
			if (mainstone_previewing || mainstone_streaming
			    || mainstone_reading) {
				up(&mainstone_video_sema);
				err = -EBUSY;
				break;
			}

			try_framebuffer_format(fb);

			framebuffer_format = *fb;

			up(&mainstone_video_sema);

			break;
		}
	case VIDIOC_OVERLAY:

		pr_debug(F("VIDIOC_OVERLAY %d"), *(int *)arg);

		down(&mainstone_video_sema);

		if (*(int *)arg) {
			if (mainstone_previewing || mainstone_streaming
			    || mainstone_reading) {
				err = -EBUSY;
			} else {
				/* overlay on */
				mainstone_previewing = file;
				err = dma_start();
				if (err)
					mainstone_previewing = 0;
			}
		} else {
			if (mainstone_previewing != file) {
				err = -EBUSY;
			} else {
				/* overlay off */
				dma_stop();
				mainstone_previewing = 0;
			}
		}

		up(&mainstone_video_sema);

		break;

#else
	case VIDIOC_G_FBUF:
	case VIDIOC_S_FBUF:
	case VIDIOC_OVERLAY:
		err = -EINVAL;
		break;
#endif

	case VIDIOC_CROPCAP:
		{
			struct v4l2_cropcap *cropcap =
			    (struct v4l2_cropcap *)arg;
			enum v4l2_buf_type type = cropcap->type;

			pr_debug(F("VIDIOC_CROPCAP"));

			if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
				err = -EINVAL;
				break;
			}

			memset(cropcap, 0, sizeof(*cropcap));
			cropcap->type = type;

			/*
			 * We're required to support the CROPCAP
			 * ioctl even though the G_CROP/S_CROP
			 * ioctls are optional.  We don't support
			 * cropping of captured images.
			 */

			down(&mainstone_video_sema);

			cropcap->bounds.width = pix_format.width;
			cropcap->bounds.height = pix_format.height;

			up(&mainstone_video_sema);

			cropcap->defrect.width = cropcap->bounds.width;
			cropcap->defrect.height = cropcap->bounds.height;
			cropcap->pixelaspect.numerator = 1;
			cropcap->pixelaspect.denominator = 1;

			break;
		}

	case VIDIOC_G_CROP:
	case VIDIOC_S_CROP:

		pr_debug(F("VIDIOC_x_CROP"));
		err = -EINVAL;
		break;

	case VIDIOC_G_PARM:
	case VIDIOC_S_PARM:

		pr_debug(F("VIDIOC_x_PARM"));
		err = -EINVAL;
		break;

	case VIDIOC_REQBUFS:

		pr_debug(F("VIDIOC_REQBUFS"));

		down(&mainstone_video_sema);

		if (mainstone_previewing || mainstone_streaming
		    || mainstone_reading) {
			up(&mainstone_video_sema);
			err = -EBUSY;
			break;
		}

		mainstone_streaming = file;
		mainstone_streaming_streamon = 0;

		videobuf_queue_init(&mainstone_queue,
				    &mainstone_videobuf_queue_ops, 0,
				    &mainstone_irq_lock,
				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
				    V4L2_FIELD_NONE, sizeof(struct videobuffer),
				    0);

		err = videobuf_reqbufs(&mainstone_queue, arg);

		up(&mainstone_video_sema);

		break;

	case VIDIOC_QUERYBUF:

		pr_debug(F("VIDIOC_QUERYBUF"));

		down(&mainstone_video_sema);

		if (mainstone_streaming != file) {
			up(&mainstone_video_sema);
			err = -EBUSY;
			break;
		}

		err = videobuf_querybuf(&mainstone_queue, arg);

		up(&mainstone_video_sema);

		break;

	case VIDIOC_QBUF:

		pr_debug(F("VIDIOC_QBUF"));

		down(&mainstone_video_sema);

		if (mainstone_streaming != file) {
			up(&mainstone_video_sema);
			err = -EBUSY;
			break;
		}

		/*
		 * This driver is not completely v4l2 compliant
		 * --it requires the user pointer for streaming
		 * are 8-byte aligned. This is because of dma controller
		 * can transfer data from capture interface only in
		 * chunks that have length of integer multiple of 8 byte
		 */

		if ((((struct v4l2_buffer *)arg)->memory == V4L2_MEMORY_USERPTR)
		    && (((struct v4l2_buffer *)arg)->m.userptr & 7)
		    ) {
			up(&mainstone_video_sema);
			pr_debug(F("not aligned"));
			err = -EINVAL;
			break;
		}
		err = videobuf_qbuf(&mainstone_queue, arg);
		up(&mainstone_video_sema);

		break;

	case VIDIOC_DQBUF:

		pr_debug(F("VIDIOC_DQBUF"));

		down(&mainstone_video_sema);

		if (mainstone_streaming != file) {
			up(&mainstone_video_sema);
			err = -EBUSY;
			break;
		}
		
		err =
		    videobuf_dqbuf(&mainstone_queue, arg,
				   file->f_flags & O_NONBLOCK);

		up(&mainstone_video_sema);

		break;

	case VIDIOC_STREAMON:

		pr_debug(F("VIDIOC_STREAMON"));

		if (*(int *)arg != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
			err = -EINVAL;
			break;
		}

		down(&mainstone_video_sema);

		if (mainstone_streaming != file) {
			up(&mainstone_video_sema);
			err = -EBUSY;
			break;
		}

		if (mainstone_streaming_streamon) {
			/* already on */
			up(&mainstone_video_sema);
			err = -EBUSY;
			break;
		}

		err = videobuf_streamon(&mainstone_queue);
		if (!err) {

			err = dma_start();
			if (err) {
				videobuf_streamoff(&mainstone_queue);
				up(&mainstone_video_sema);
				break;
			}
			mainstone_streaming_streamon = 1;

		}
		up(&mainstone_video_sema);

		break;

	case VIDIOC_STREAMOFF:

		pr_debug(F("VIDIOC_STREAMOFF"));

		if (*(int *)arg != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
			err = -EINVAL;
			break;
		}

		down(&mainstone_video_sema);

		if (mainstone_streaming != file) {
			up(&mainstone_video_sema);
			err = -EBUSY;
			break;
		}

		if (!mainstone_streaming_streamon) {
			/* already off */
			up(&mainstone_video_sema);
			err = -EBUSY;
			break;
		}

		mainstone_streaming_streamon = 0;
		dma_stop();

		err = videobuf_streamoff(&mainstone_queue);

		up(&mainstone_video_sema);

		break;

	case VIDIOC_G_CTRL:
	{
		struct v4l2_control *ctrl = (struct v4l2_control *)arg;
		int data;
		
		pr_debug(F("VIDIOC_G_CTRL"));

		switch(ctrl->id)
		{
			case V4L2_CID_VFLIP:
				data = reg_read(MT9V022_READ_MODE);
				if (data < 0)
				{
					err = -EIO;
					break;
				}
				ctrl->value = !!(data & 0x10);
				break;
			case V4L2_CID_HFLIP:
				data = reg_read(MT9V022_READ_MODE);
				if (data < 0)
				{
					err = -EIO;
					break;
				}
				ctrl->value = !!(data & 0x20);
				break;
			case V4L2_CID_EXPOSURE_AUTO:
				data = reg_read(MT9V022_AEC_AGC_ENABLE);
				if (data < 0)
				{
					err = -EIO;
					break;
				}
				ctrl->value = !!(data & 0x1);
				break;
			case V4L2_CID_AUTOGAIN:
				data = reg_read(MT9V022_AEC_AGC_ENABLE);
				if (data < 0)
				{
					err = -EIO;
					break;
				}
				ctrl->value = !!(data & 0x2);
				break;
			default :
				err = -EIO;
				break;
		}	
		break;
	}
	
	case VIDIOC_S_CTRL:
	{
		struct v4l2_control *ctrl = (struct v4l2_control *)arg;
		const struct v4l2_queryctrl *qctrl;
		int data;
		
		pr_debug(F("VIDIOC_S_CTRL"));
		
		qctrl = soc_camera_find_qctrl(ctrl->id);

		if (!qctrl)
		{
			err = -EINVAL;
			break;
		}

		down(&mainstone_video_sema);

		if (mainstone_previewing || mainstone_streaming
		    || mainstone_reading) {
			err = -EBUSY;
			goto error;
		}

		switch(ctrl->id)
		{
			case V4L2_CID_VFLIP:
				if (ctrl->value)
					data = reg_set(MT9V022_READ_MODE, 0x10);//overturn
				else
					data = reg_clear(MT9V022_READ_MODE, 0x10);//not overtrun
				if (data < 0)
					err = -EIO;
				break;
				
			case V4L2_CID_HFLIP:
				if (ctrl->value)
					data = reg_set(MT9V022_READ_MODE, 0x20);//overturn
				else
					data = reg_clear(MT9V022_READ_MODE, 0x20);//not overtrun
				if (data < 0)
					err = -EIO;
				break;
				
			case V4L2_CID_GAIN:
				/* mt9v022 has minimum == default */
				if (ctrl->value > qctrl->maximum|| ctrl->value < qctrl->minimum)
				{
					err =  -EINVAL;
					break;
				}
				else
				{
					unsigned long range = qctrl->maximum - qctrl->minimum;
					/* Datasheet says 16 to 64. autogain only works properly
					 * after setting gain to maximum 14. Larger values
					 * produce "white fly" noise effect. On the whole,
					 * manually setting analog gain does no good. */
					unsigned long gain = ((ctrl->value - qctrl->minimum) *
							      10 + range / 2) / range + 4;
					if (gain >= 32)
						gain &= ~1;
					/* The user wants to set gain manually, hope, she
					 * knows, what she's doing... Switch AGC off. */

					if (reg_clear(MT9V022_AEC_AGC_ENABLE, 0x2) < 0)
					{
						err = -EIO;
						break;
					}
					printk("Setting gain from %d to %lu\n",
						 reg_read(MT9V022_ANALOG_GAIN), gain);
					if (reg_write(MT9V022_ANALOG_GAIN, gain) < 0)
					{
						err = -EIO;
						break;
					}
					//icd->gain = ctrl->value;
				}
				break;
				
			case V4L2_CID_EXPOSURE:
				/* mt9v022 has maximum == default */
				if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
				{				
					err = -EINVAL;
					break;
				}
				else
				{
					unsigned long range = qctrl->maximum - qctrl->minimum;
					unsigned long shutter = ((ctrl->value - qctrl->minimum) *
								 479 + range / 2) / range + 1;
					/* The user wants to set shutter width manually, hope,
					 * she knows, what she's doing... Switch AEC off. */

					if (reg_clear(MT9V022_AEC_AGC_ENABLE, 0x1) < 0)
					{
						err = -EIO;
						break;
					}
					printk("Shutter width from %d to %lu\n",
						reg_read(MT9V022_TOTAL_SHUTTER_WIDTH),
						shutter);
					if (reg_write(MT9V022_TOTAL_SHUTTER_WIDTH,
						      shutter) < 0)
					{
						return -EIO;
						break;
					}
					//icd->exposure = ctrl->value;
				}
				break;
				
			case V4L2_CID_AUTOGAIN:
				if (ctrl->value)
					data = reg_set(MT9V022_AEC_AGC_ENABLE, 0x2);//auto
				else
					data = reg_clear(MT9V022_AEC_AGC_ENABLE, 0x2);//manual
				if (data < 0)
					err = -EIO;
				break;
				
			case V4L2_CID_EXPOSURE_AUTO:
				if (ctrl->value)
					data = reg_set(MT9V022_AEC_AGC_ENABLE, 0x1);//auto
				else
					data = reg_clear(MT9V022_AEC_AGC_ENABLE, 0x1);//manual
				if (data < 0)
					err = -EIO;
				break;

			default :
				err = -EIO;
				break;
		}
error:
		up(&mainstone_video_sema);

		break;
	}
	case VIDIOC_QUERYCTRL:
	{
		const struct v4l2_queryctrl *ctrl;
		struct v4l2_queryctrl *c = arg;

		ctrl = soc_camera_find_qctrl(c->id);
		if( NULL == ctrl )
		{
			err = -EINVAL;
			break;
		}
		*c = *ctrl;
		break;
	}
	case VIDIOC_QUERYMENU:

		pr_debug(F("VIDIOC_QUERYMENU"));
		err = -EINVAL;
		break;

	case VIDIOC_ENUMSTD:
	case VIDIOC_G_STD:
	case VIDIOC_S_STD:
	case VIDIOC_QUERYSTD:

		/*
		 * Digital cameras don't have an analog video standard,
		 * so we don't need to implement these ioctls.
		 */
		pr_debug(F("VIDIOC_xSTD"));
		err = -EINVAL;
		break;

	case VIDIOC_ENUMAUDIO:
	case VIDIOC_ENUMAUDOUT:
	case VIDIOC_G_AUDIO:
	case VIDIOC_S_AUDIO:
	case VIDIOC_G_AUDOUT:
	case VIDIOC_S_AUDOUT:

		/* we don't have any audio inputs or outputs */
		pr_debug(F("VIDIOC_xAUDIO"));
		err = -EINVAL;
		break;

	case VIDIOC_G_JPEGCOMP:
	case VIDIOC_S_JPEGCOMP:

		/* JPEG compression is not supported */
		pr_debug(F("VIDIOC_x_JPEGCOMP"));
		err = -EINVAL;
		break;

	case VIDIOC_G_TUNER:
	case VIDIOC_S_TUNER:
	case VIDIOC_G_MODULATOR:
	case VIDIOC_S_MODULATOR:
	case VIDIOC_G_FREQUENCY:
	case VIDIOC_S_FREQUENCY:

		/* we don't have a tuner or modulator */
		pr_debug(F("VIDIOC_x_[TUNER,MODULATOR,FREQUENCY]"));
		err = -EINVAL;
		break;

	case VIDIOC_ENUMOUTPUT:
	case VIDIOC_G_OUTPUT:
	case VIDIOC_S_OUTPUT:

		/* we don't have any video outputs */
		pr_debug(F("VIDIOC_xOUTPUT"));
		err = -EINVAL;
		break;

	case VIDIOC_G_PRIORITY:
	case VIDIOC_S_PRIORITY:

		pr_debug(F("VIDIOC_x_PRIORITY"));
		err = -EINVAL;
		break;

	default:

		/* unrecognized ioctl */
		pr_debug(F("???"));
		err = -ENOIOCTLCMD;
		break;
	}

#ifdef CONFIG_PM
	up_read(&suspend_rwsem);
#endif

	return err;

}

static unsigned int
mainstone_poll(struct file *file, struct poll_table_struct *wait)
{
	int err = 0;

	pr_debug(F0);

#ifdef CONFIG_PM
	down_read(&suspend_rwsem);
#endif

	if (down_interruptible(&mainstone_video_sema)) {
		err = -ERESTARTSYS;
		goto exit1;
	}

	if (mainstone_previewing) {
		err = -EBUSY;
		goto exit;
	}

	if (!mainstone_streaming) {

		if (mainstone_reading == 0) {

			videobuf_queue_init(&mainstone_queue,
					    &mainstone_videobuf_queue_ops, 0,
					    &mainstone_irq_lock,
					    V4L2_BUF_TYPE_VIDEO_CAPTURE,
					    V4L2_FIELD_NONE,
					    sizeof(struct videobuffer), 0);

			err = dma_start();
			if (err)
				goto exit;
			mainstone_reading = file;

		} else if (mainstone_reading != file) {

			err = -EBUSY;
			goto exit;

		}
	}

	err = videobuf_poll_stream(file, &mainstone_queue, wait);

      exit:
	up(&mainstone_video_sema);
      exit1:
#ifdef CONFIG_PM
	up_read(&suspend_rwsem);
#endif

	return err;
}

static ssize_t
mainstone_read(struct file *file, char *data, size_t count, loff_t * ppos)
{
	int err = 0;

	pr_debug(F0);

#ifdef CONFIG_PM
	down_read(&suspend_rwsem);
#endif

	if (down_interruptible(&mainstone_video_sema)) {
		err = -ERESTARTSYS;
		goto exit1;
	}

	if (mainstone_streaming || mainstone_previewing) {
		err = -EBUSY;
		goto exit;
	}

	if (mainstone_reading == 0) {

		videobuf_queue_init(&mainstone_queue,
				    &mainstone_videobuf_queue_ops, 0,
				    &mainstone_irq_lock,
				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
				    V4L2_FIELD_NONE, sizeof(struct videobuffer),
				    0);

		err = dma_start();
		if (err)
			goto exit;
		mainstone_reading = file;

	} else if (mainstone_reading != file) {

		err = -EBUSY;
		goto exit;

	}

	err =
	    videobuf_read_one(&mainstone_queue, data, count, ppos,
			      file->f_flags & O_NONBLOCK);

      exit:
	up(&mainstone_video_sema);
      exit1:
#ifdef CONFIG_PM
	up_read(&suspend_rwsem);
#endif

	return err;
}

static int mainstone_mmap(struct file *file, struct vm_area_struct *vma)
{
	int err = 0;

	pr_debug(F0);

#ifdef CONFIG_PM
	down_read(&suspend_rwsem);
#endif
	err = videobuf_mmap_mapper(&mainstone_queue, vma);
#ifdef CONFIG_PM
	up_read(&suspend_rwsem);
#endif

	return err;
}

static int
mainstone_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
		unsigned long arg)
{
	return video_usercopy(inode, file, cmd, arg, mainstone_do_ioctl);
}

static int mainstone_release(struct inode *inode, struct file *file)
{
	int err = 0;

	pr_debug(F0);

#ifdef CONFIG_PM
	down_read(&suspend_rwsem);
#endif
	if (down_interruptible(&mainstone_video_sema)) {
		err = -ERESTARTSYS;
		goto exit1;
	}
#if CONFIG_FB_PXA
	if (mainstone_previewing == file) {
		dma_stop();
		mainstone_previewing = 0;
	}
#endif

	if (mainstone_streaming == file) {

		if (mainstone_streaming_streamon) {
			dma_stop();
			mainstone_streaming_streamon = 0;
		}

		mainstone_streaming = 0;
		videobuf_streamoff(&mainstone_queue);
		videobuf_mmap_free(&mainstone_queue);
	}

	if (mainstone_reading) {
		dma_stop();
		mainstone_reading = 0;
		if (mainstone_queue.read_buf) {
			mainstone_vbq_release(&mainstone_queue,
					      mainstone_queue.read_buf);
			kfree(mainstone_queue.read_buf);
			mainstone_queue.read_buf = 0;
		}
	}

	up(&mainstone_video_sema);
      exit1:
#ifdef CONFIG_PM
	up_read(&suspend_rwsem);
#endif

	return err;
}

static struct video_device mainstone_video_device;

static int mainstone_open(struct inode *inode, struct file *file)
{
	int minor = iminor(inode);

	pr_debug(F0);

	if (mainstone_video_device.minor != minor)
		return -ENODEV;

	file->private_data = 0;

	return 0;
}

static struct file_operations mainstone_fops = {
	.owner = THIS_MODULE,
	.llseek = no_llseek,
	.read = mainstone_read,
	.poll = mainstone_poll,
	.ioctl = mainstone_ioctl,
	.mmap = mainstone_mmap,
	.open = mainstone_open,
	.release = mainstone_release,
};

/* END file operations */

/*
 * We need this, see drivers/media/video/videodev.c
 * video_register_device()
 */

static void mainstone_video_device_release(struct video_device *device)
{
}

static struct video_device mainstone_video_device = {
	.dev = 0,
	.name = DEVICE_NAME,
	.type = VID_TYPE_CAPTURE,
	.hardware = 0,
	.minor = -1,
	.fops = &mainstone_fops,
	.release = &mainstone_video_device_release,
};

/**
 * Initialize  Mainstone camera (ADCM2650) using I2C (SMBus) protocol
 * and PXA27x QuickCapture interface using memory mapped registers.
 * The dma_channel_number should be alredy valid before calling this
 * function.
 */
static int hardware_init(int first_time){

	unsigned int v;

	if (dma_channel_number < 0) {
		pr_debug(F("internal error dma_channel_number"
			" is not allocated yet"));
		return -ENXIO;
	}

	/* enable hardware */
	camera_gpio_init();

	/* This routes QuickCapture DMA requests to
	 * the selected DMA channel (2800002.pdf 5.5.1 and Table 5-22),
	 * so that DMA transfer of video may work.
	 * The camera interface must be powered on yet.
	 */
	DRCMR68 = dma_channel_number | DRCMR_MAPVLD;

	/* initialize capture interface */
	ci_init();

	/* set master parallel mode */
	v = CICR0;
	v &= ~(CI_CICR0_SIM_SMASK << CI_CICR0_SIM_SHIFT);
	v |= CI_CICR0_SIM_MODE_MP << CI_CICR0_SIM_SHIFT;
	CICR0 = v;

	/* set 8 data pins */
	v = CICR1;
	v &= ~(CI_CICR1_DW_SMASK << CI_CICR1_DW_SHIFT);
	v |= CI_CICR1_DW8 << CI_CICR1_DW_SHIFT;
	CICR1 = v;

	/* enable pixel clock(sensor will provide pclock) and master clock */
	{
		unsigned int ciclk, div, cccr_l, K;

		/* determine the LCLK frequency programmed into the CCCR. */
		cccr_l = (CCCR & 0x0000001F);

		if (cccr_l < 8)
			K = 1;
		else if (cccr_l < 17)
			K = 2;
		else
			K = 3;

		/* in kHz */
		ciclk = (13 * cccr_l * 1000) / K;

		for (div = 1; 1; div++) {

			mclk_khz = ciclk / (2 * (div + 1));

			if (mclk_khz <= CI_MCLK_DEFT)
				break;

		}

		pr_debug(F("ciclk : %d; div : %d; mclk_khz : %d"),
			 ciclk, div, mclk_khz);

		v = CICR4;
		v &= ~(CI_CICR4_DIV_SMASK << CI_CICR4_DIV_SHIFT);
		v |= CI_CICR4_PCLK_EN | CI_CICR4_MCLK_EN | (div <<
							    CI_CICR4_DIV_SHIFT);
		CICR4 = v;
	}

	/* data sample on rising and vsync active high */
	CICR4 &= ~(CI_CICR4_PCP | CI_CICR4_HSP | CI_CICR4_VSP);

	/* setup fifo (don't enable fifo1 and fifo2), 32 byte threshold */
	v = CIFR;
	v &= ~(CI_CIFR_FEN1 | CI_CIFR_FEN2 | CI_CIFR_THL_SMASK <<
	       CI_CIFR_THL_SHIFT);
	v |= CI_CIFR_THL_32 << CI_CIFR_THL_SHIFT;
	v |= CI_CIFR_RESETF | CI_CIFR_FEN0;
	CIFR = v;

	/* set timeout = 0 */
	CITOR = 0;

	/* Camera interface power on (Mainstone II User Guide 3.2.2.5),
	 * camera select MUX control. After this the camera may be
	 * set up through I2C interface.
	 */
	MST_MSCWR1 |= (MST_MSCWR1_CAMERA_ON | MST_MSCWR1_CAMERA_SEL);
	msleep(50);

	/*
	 * Register adcm2650 I2C device, if not yet registered only.
	 * For probbing the device while registering it all
	 * register setup which done above should be completed
	 * successfully.
	 */

	if(first_time){
		mt9v022_init();
	}	

	return 0;
}

/**
 * Reverts what is done by hardware_init(), including
 * deregistering of the I2C device.
 */
void hardware_done(void){

	DRCMR68 = 0;

	mt9v022_exit();

	/* cut down at Board Level */
	MST_MSCWR1 &= ~(MST_MSCWR1_CAMERA_ON | MST_MSCWR1_CAMERA_SEL);

	CKEN &= ~CKEN24_CAMERA;

}

static int mainstone_initialize(struct device *dev)
{
	int err;

	pr_debug(F0);

	/* initialize dma */
	err = -ENXIO;
	dma_channel_number =
	    pxa_request_dma("capture_interface", DMA_PRIO_HIGH, dma_irq, 0);
	if (dma_channel_number < 0) {
		return err;
	}
	DCSR(dma_channel_number) = 0;


	/* initialise pixel format by default values */
	pix_format.width = camera_width;
	pix_format.height = camera_height;
	pix_format.pixelformat = camera_formats[0].pixelformat;
	try_pix_format(&pix_format);

#if CONFIG_FB_PXA
	window_format.w.left = 0;
	window_format.w.top = 0;
	window_format.w.width = camera_width;
	window_format.w.height = camera_height;
	try_window_format(&window_format);

	memset(&framebuffer_format, 0, sizeof(framebuffer_format));
	try_framebuffer_format(&framebuffer_format);
#endif

	/* Initialize QuickCapture and camera*/

	err = hardware_init(1);
	if(err!=0){
		pr_debug(F(" error initialising QuickCapture and ADCM2650 camera"));
		return err;
	}

	video_set_drvdata(&mainstone_video_device, 0);

	err =
	    video_register_device(&mainstone_video_device, VFL_TYPE_GRABBER,
				  video_nr);
	if (err) {
		goto error;
	}

	err = reg_write(MT9V022_READ_MODE, 0x300);

	/* All defaults */
	if (err >= 0)
		/* AEC, AGC on */
		err = reg_set(MT9V022_AEC_AGC_ENABLE, 0x3);
	if (err >= 0)
		err = reg_write(MT9V022_MAX_TOTAL_SHUTTER_WIDTH, 480);
	if (err >= 0)
		/* default - auto */
		err = reg_clear(MT9V022_BLACK_LEVEL_CALIB_CTRL, 1);
	if (err >= 0)
		err = reg_write(MT9V022_DIGITAL_TEST_PATTERN, 0);	

	pr_info("registered device video%d [v4l2]\n",
		mainstone_video_device.minor);

	return 0;

      error:
	hardware_done();

	pxa_free_dma(dma_channel_number);

	return err;
}

static int mainstone_cleanup(struct device *dev)
{
	pr_debug(F0);

	video_unregister_device(&mainstone_video_device);

	hardware_done();

	if (dma_channel_number >= 0)
		pxa_free_dma(dma_channel_number);

	/* may be mapped in int ci_init() */
	if (ci_regs_base)
		iounmap((unsigned long *)ci_regs_base);

	return 0;
}

static int mainstone_suspend(struct device *dev, u32 state, u32 level)
{
	pr_debug(F("state : %u; level : %u"), state, level);

	//if (level != SUSPEND_DISABLE){
	if (level != 2) {//SUSPEND_DISABLE not define
	  return 0;
	}

#ifdef CONFIG_PM
	switch (level) {
	case SUSPEND_POWER_DOWN:
		pr_debug(F("suspend"));
		down_write(&suspend_rwsem);
		if (mainstone_previewing || mainstone_streaming
		    || mainstone_reading)
			dma_suspend();
		break;
	}
#endif

	return 0;
}

static int mainstone_resume(struct device *dev, u32 level)
{
	//if (level != RESUME_ENABLE) {
	if (level != 2) {//RESUME_ENABLE not define
	  return 0;
	}

	hardware_init(0);

#ifdef CONFIG_PM
	switch (level) {
	case RESUME_POWER_ON:
		pr_debug(F("resume"));
		if (mainstone_previewing || mainstone_streaming
		    || mainstone_reading)
			dma_resume();
		up_write(&suspend_rwsem);
		break;
	}
#endif

	return 0;
}

/*
 * We need this, see drivers/base/core.c, device_release()
 */
static void mainstone_platform_release(struct device *device)
{
}

static struct device_driver mainstone_driver = {
	.name = DRIVER_NAME,
	.bus = &platform_bus_type,
	.probe = mainstone_initialize,
	.remove = mainstone_cleanup,
	.suspend = mainstone_suspend,
	.resume = mainstone_resume,
};

static struct platform_device mainstone_device = {
	.name = DRIVER_NAME,
	.id = 0,
	.dev = {
		.release = mainstone_platform_release,
		}
};

static int __init mainstone_init(void)
{
	int err;

	pr_info("Mainstone camera\n");

	err = driver_register(&mainstone_driver);
	if (err)
		return err;

	err = platform_device_register(&mainstone_device);
	if (err) {
		driver_unregister(&mainstone_driver);
		return err;
	}
	return 0;
}

#ifdef MODULE
static void __exit mainstone_exit(void)
{
	pr_info("Mainstone camera exit\n");

	platform_device_unregister(&mainstone_device);
	driver_unregister(&mainstone_driver);
}

module_exit(mainstone_exit);
#endif

module_init(mainstone_init);

MODULE_AUTHOR("MontaVista Software Inc.");
MODULE_DESCRIPTION("Intel PXA27x Mainstone camera driver");
MODULE_LICENSE("GPL");

static int video_nr = -1;
module_param(video_nr, int, 0);
MODULE_PARM_DESC(video_nr,
		 "Minor number for video device (-1 ==> auto assign)");

2、-----------------This is mt9v022.c-----------------
/*
 * drivers/media/video/mt9v022.c
 *
 * mt9v022 Camera Module driver.
 *
 * Author: Intel Corporation
 *
 * 2003 (c) Intel Corporation
 * 2003-2005 (c) MontaVista Software, Inc. This file is licensed under
 * the terms of the GNU General Public License version 2. This program
 * is licensed "as is" without any warranty of any kind, whether express
 * or implied.
 */

#include <linux/types.h>
#include <asm/mach-types.h>
#include <asm/io.h>
#include <asm/semaphore.h>
#include <asm/hardware.h>
#include <asm/mach-types.h>
#include <asm/dma.h>
#include <asm/irq.h>

#include <linux/types.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/i2c.h>
#include <linux/delay.h>

#include "mt9v022.h"

#define LINE_STRING __stringify(KBUILD_BASENAME) ":" __stringify(__LINE__) " : "

int mt9v022_client_id = -1;

static struct i2c_driver mt9v022_driver;
static DECLARE_MUTEX(i2c_lock);

/*
 * support only one client (= exemplar of the sensor)
 * per whole system so far
 */
struct i2c_client mt9v022_client = {
	.flags = 0x01,
	.driver = &mt9v022_driver,
	.name = "mt9v022-0",
};

int reg_read(const u8 reg)
{
	s32 data = i2c_smbus_read_word_data(&mt9v022_client, reg);
	return data < 0 ? data : swab16(data);
}

int reg_write(const u8 reg,
		     const u16 data)
{
	return i2c_smbus_write_word_data(&mt9v022_client, reg, swab16(data));
}

int reg_set(const u8 reg,
		   const u16 data)
{
	int ret;
	
	ret = reg_read(reg);
	if (ret < 0)
		return ret;
	return reg_write(reg, ret | data);
}

int reg_clear(const u8 reg,
		     const u16 data)
{
	int ret;

	ret = reg_read(reg);
	if (ret < 0)
		return ret;
	return reg_write(reg, ret & ~data);
}

static int i2c_mt9v022_detect_client(struct i2c_adapter *adapter, int address,
				      int kind)
{
	int err;

	pr_debug(LINE_STRING "\n");

	pr_info("ADCM2650: i2c-bus:%s; address:0x%x... ",
		adapter->name, address);

	if (mt9v022_client_id != -1) {
		pr_info("the sensor is already initialized.\n");
		/*
		 * anyway, return 0 or else
		 * the detection cycle will be broken
		 */
		return 0;
	}

	/* returns true if the functionality is supported */
	err = i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA);
	if (!err) {
		pr_info("word operations is not permited.\n");
		return 0;
	}

	mt9v022_client.addr = address;
	mt9v022_client.adapter = adapter;

	/*
	 * don't pay attention to kind argument --
	 * we make the lists of addresses ourselves
	 */
	err = reg_read(MT9V022_CHIP_VERSION);
	if (err != 0x1313) {
		pr_info("failed.\n");
		return 0;
	} else {
		pr_info("detected.\n");
	}

	mt9v022_client_id = 0;

	err = i2c_attach_client(&mt9v022_client);
	if (err) {
		pr_debug(LINE_STRING "i2c_attach_client()\n");
		mt9v022_client_id = -1;
	}

	return 0;
}


static unsigned short normal_i2c[] = {MT9V022_SENSOR_SLAVE_ADDR,
I2C_CLIENT_END};
static unsigned short probe = I2C_CLIENT_END;
static unsigned short ignore = I2C_CLIENT_END;
//static unsigned short forces = I2C_CLIENT_END;

static struct i2c_client_address_data addr_data = {
	.normal_i2c = normal_i2c,
	.probe = &probe,
	.ignore = &ignore,
//	.forces = forces,
};

static int i2c_mt9v022_probe(struct i2c_adapter *adap)
{
	pr_debug(LINE_STRING "\n");
	return i2c_probe(adap, &addr_data, i2c_mt9v022_detect_client);
}

static int i2c_mt9v022_detach(struct i2c_client *client)
{
	int err;

	pr_debug(LINE_STRING "\n");
	err = i2c_detach_client(client);
	if (err) {
		pr_debug(LINE_STRING "i2c_detach_client()\n");
		return err;
	}
	
	return 0;
}

#define I2C_DRIVERID_ADCM2650   I2C_DRIVERID_EXP1

static struct i2c_driver mt9v022_driver = {
	.driver = {
		.name	= "mt9v022",
	},
	.id = MT9V022_SENSOR_SLAVE_ADDR,
	.attach_adapter = &i2c_mt9v022_probe,
	.detach_client = &i2c_mt9v022_detach,
};

int mt9v022_init(void)
{
	pr_debug(LINE_STRING "\n");

	return i2c_add_driver(&mt9v022_driver);
}

void mt9v022_exit(void)
{
	pr_debug(LINE_STRING "\n");
	i2c_del_driver(&mt9v022_driver);
}

3、-----------------This is mainstone.h-----------------
/*
 * linux/drivers/media/video/mainstone.h
 *
 * Driver for Intel Mainstone Camera
 *
 * Author: Aleskey Makarov <amakarov@ru.mvista.com>
 *
 * 2003 (c) Intel Corporation
 * 2003-2005 (c) MontaVista Software, Inc. This file is licensed under
 * the terms of the GNU General Public License version 2. This program
 * is licensed "as is" without any warranty of any kind, whether express
 * or implied.
 */

#ifndef _MAINSTONE_CAMERA_H__
#define _MAINSTONE_CAMERA_H__

/* MCLK, kHz */
#define CI_MCLK_DEFT 13000

/* phys addreses of ci registers CIBR */
#define CIBR0_PHY       (0x50000000 + 0x28)
#define CIBR1_PHY       (0x50000000 + 0x30)
#define CIBR2_PHY       (0x50000000 + 0x38)

#define CI_REG_SIZE             0x40	/* 0x5000_0000 --- 0x5000_0038 * 64K */
#define CI_REGS_PHYS            0x50000000

/* CICR0 */
#define CI_CICR0_FOM            (1 << 0)
#define CI_CICR0_EOFM           (1 << 1)
#define CI_CICR0_SOFM           (1 << 2)
#define CI_CICR0_CDM            (1 << 3)
#define CI_CICR0_QDM            (1 << 4)
#define CI_CICR0_PERRM          (1 << 5)
#define CI_CICR0_EOLM           (1 << 6)
#define CI_CICR0_FEM            (1 << 7)
#define CI_CICR0_RDAVM          (1 << 8)
#define CI_CICR0_TOM            (1 << 9)
#define CI_CICR0_SIM_SHIFT              24
#define CI_CICR0_SIM_SMASK              0x7

#define CI_CICR0_SIM_MODE_MP            0	/* Master-Parallel */
#define CI_CICR0_SIM_MODE_SP            1	/* Slave-Parallel */
#define CI_CICR0_SIM_MODE_MS            2	/* Master-Serial */
#define CI_CICR0_SIM_MODE_EP            3	/* Embedded-Parallel */
#define CI_CICR0_SIM_MODE_ES            4	/* Embedded-Serial */

#define CI_CICR0_DIS                    (1 << 27)
#define CI_CICR0_ENB                    (1 << 28)
#define CI_CICR0_SL_CAP_EN              (1 << 29)
#define CI_CICR0_PAR_EN                 (1 << 30)
#define CI_CICR0_DMA_EN                 (1 << 31)
#define CI_CICR0_INTERRUPT_MASK         0x3FF

/* CICR1 */
#define CI_CICR1_TBIT                   (1 << 31)
#define CI_CICR1_RGBT_CONV_SHIFT        29
#define CI_CICR1_RGBT_CONV_SMASK        0x3
#define CI_CICR1_PPL_SHIFT              15
#define CI_CICR1_PPL_SMASK              0x7FF
#define CI_CICR1_RGB_CONV_SHIFT         12
#define CI_CICR1_RGB_CONV_SMASK         0x7
#define CI_CICR1_RBG_F                  (1 << 11)
#define CI_CICR1_YCBCR_F                (1 << 10)
#define CI_CICR1_RGB_BPP_SHIFT          7
#define CI_CICR1_RGB_BPP_SMASK          0x7
#define CI_CICR1_RAW_BPP_SHIFT          5
#define CI_CICR1_RAW_BPP_SMASK          0x3
#define CI_CICR1_COLOR_SP_SHIFT         3
#define CI_CICR1_COLOR_SP_SMASK         0x3
#define CI_CICR1_DW_SHIFT               0
#define CI_CICR1_DW_SMASK               0x7

#define CI_CICR1_DW4  0x0
#define CI_CICR1_DW5  0x1
#define CI_CICR1_DW8  0x2
#define CI_CICR1_DW9  0x3,
#define CI_CICR1_DW10 0x4

/* CICR2 */
#define CI_CICR2_FSW_SHIFT      0
#define CI_CICR2_FSW_SMASK      0x3
#define CI_CICR2_BFPW_SHIFT     3
#define CI_CICR2_BFPW_SMASK     0x3F
#define CI_CICR2_HSW_SHIFT      10
#define CI_CICR2_HSW_SMASK      0x3F
#define CI_CICR2_ELW_SHIFT      16
#define CI_CICR2_ELW_SMASK      0xFF
#define CI_CICR2_BLW_SHIFT      24
#define CI_CICR2_BLW_SMASK      0xFF

/* CICR3 */
#define CI_CICR3_LPF_SHIFT      0
#define CI_CICR3_LPF_SMASK      0x7FF
#define CI_CICR3_VSW_SHIFT      11
#define CI_CICR3_VSW_SMASK      0x1F
#define CI_CICR3_EFW_SHIFT      16
#define CI_CICR3_EFW_SMASK      0xFF
#define CI_CICR3_BFW_SHIFT      24
#define CI_CICR3_BFW_SMASK      0xFF

/* CICR4 */
#define CI_CICR4_DIV_SHIFT      0
#define CI_CICR4_DIV_SMASK      0xFF
#define CI_CICR4_FR_RATE_SHIFT  8
#define CI_CICR4_FR_RATE_SMASK  0x7
#define CI_CICR4_MCLK_EN        (1 << 19)
#define CI_CICR4_VSP            (1 << 20)
#define CI_CICR4_HSP            (1 << 21)
#define CI_CICR4_PCP            (1 << 22)
#define CI_CICR4_PCLK_EN        (1 << 23)

/* CISR */
#define CI_CISR_IFO_0           (1 << 0)
#define CI_CISR_IFO_1           (1 << 1)
#define CI_CISR_IFO_2           (1 << 2)
#define CI_CISR_EOF             (1 << 3)
#define CI_CISR_SOF             (1 << 4)
#define CI_CISR_CDD             (1 << 5)
#define CI_CISR_CQD             (1 << 6)
#define CI_CISR_PAR_ERR         (1 << 7)
#define CI_CISR_EOL             (1 << 8)
#define CI_CISR_FEMPTY_0        (1 << 9)
#define CI_CISR_FEMPTY_1        (1 << 10)
#define CI_CISR_FEMPTY_2        (1 << 11)
#define CI_CISR_RDAV_0          (1 << 12)
#define CI_CISR_RDAV_1          (1 << 13)
#define CI_CISR_RDAV_2          (1 << 14)
#define CI_CISR_FTO             (1 << 15)

/* CIFR */
#define CI_CIFR_FEN0            (1 << 0)
#define CI_CIFR_FEN1            (1 << 1)
#define CI_CIFR_FEN2            (1 << 2)
#define CI_CIFR_RESETF          (1 << 3)
#define CI_CIFR_THL_SHIFT       4
#define CI_CIFR_THL_SMASK       0x3

#define CI_CIFR_THL_32          0
#define CI_CIFR_THL_64          1
#define CI_CIFR_THL_96          2

#define CI_CIFR_FLVL0_SHIFT     8
#define CI_CIFR_FLVL0_SMASK     0xFF
#define CI_CIFR_FLVL1_SHIFT     16
#define CI_CIFR_FLVL1_SMASK     0x7F
#define CI_CIFR_FLVL2_SHIFT     23
#define CI_CIFR_FLVL2_SMASK     0x7F

/* formats */
#define CI_RAW8                 0	/* RAW */
#define CI_RAW9                 1
#define CI_RAW10                2
#define CI_YCBCR422             3	/* YCBCR */
#define CI_YCBCR422_PLANAR      4	/* YCBCR Planaried */
#define CI_RGB444               5	/* RGB */
#define CI_RGB555               6
#define CI_RGB565               7
#define CI_RGB666               8
#define CI_RGB888               9
#define CI_RGBT555_0            10	/* RGB+Transparent bit 0 */
#define CI_RGBT888_0            11
#define CI_RGBT555_1            12	/* RGB+Transparent bit 1 */
#define CI_RGBT888_1            13
#define CI_RGB666_PACKED        14	/* RGB Packed */
#define CI_RGB888_PACKED        15
#define CI_INVALID_FORMAT       0xFF

#endif

4、-----------------This is mt9v022.h-----------------
/*
 * drivers/media/video/mt9v022.h
 *
 * mt9v022 Camera Module driver.
 *
 * Author: Intel Corporation
 *
 * 2003 (c) Intel Corporation
 * 2003-2005 (c) MontaVista Software, Inc. This file is licensed under
 * the terms of the GNU General Public License version 2. This program
 * is licensed "as is" without any warranty of any kind, whether express
 * or implied.
 */

#define MT9V022_SENSOR_SLAVE_ADDR   0x48

/* mt9v022 selected register addresses */
#define MT9V022_CHIP_VERSION		0x00
#define MT9V022_COLUMN_START		0x01
#define MT9V022_ROW_START		0x02
#define MT9V022_WINDOW_HEIGHT		0x03
#define MT9V022_WINDOW_WIDTH		0x04
#define MT9V022_HORIZONTAL_BLANKING	0x05
#define MT9V022_VERTICAL_BLANKING	0x06
#define MT9V022_CHIP_CONTROL		0x07
#define MT9V022_SHUTTER_WIDTH1		0x08
#define MT9V022_SHUTTER_WIDTH2		0x09
#define MT9V022_SHUTTER_WIDTH_CTRL	0x0a
#define MT9V022_TOTAL_SHUTTER_WIDTH	0x0b
#define MT9V022_RESET			0x0c
#define MT9V022_READ_MODE		0x0d
#define MT9V022_MONITOR_MODE		0x0e
#define MT9V022_PIXEL_OPERATION_MODE	0x0f
#define MT9V022_LED_OUT_CONTROL		0x1b
#define MT9V022_ADC_MODE_CONTROL	0x1c
#define MT9V022_ANALOG_GAIN		0x34
#define MT9V022_BLACK_LEVEL_CALIB_CTRL	0x47
#define MT9V022_PIXCLK_FV_LV		0x74
#define MT9V022_DIGITAL_TEST_PATTERN	0x7f
#define MT9V022_AEC_AGC_ENABLE		0xAF
#define MT9V022_MAX_TOTAL_SHUTTER_WIDTH	0xBD
#define MT9V022_CAPTURE_MODE 0X20

/* Progressive scan, master, defaults */
#define MT9V022_CHIP_CONTROL_DEFAULT	0x188

extern int mt9v022_init(void);
extern void mt9v022_exit(void);

/* Read and Write from/to Image Pipeline Registers */
extern int reg_read(const u8 reg);
extern int reg_write(const u8 reg, const u16 data);
extern int reg_set(const u8 reg, const u16 data);
extern int reg_clear(const u8 reg, const u16 data);

>  In general, for your real application, you should really consider doing
>  something like what mplayer is doing - an own thread for video data
>  read-out, preferably with a real-time priority.

Thanks maybe I will try.

Thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
