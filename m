Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8653 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2JJPdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:33:11 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO004FTOJSWU30@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 16:33:28 +0100 (BST)
Received: from [106.116.147.108] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MBO00CR9OJ86270@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 16:33:08 +0100 (BST)
Message-id: <50759533.3060009@samsung.com>
Date: Wed, 10 Oct 2012 17:33:07 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>,
	=?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Subject: Test application for DMABUF support in V4L2
Content-type: multipart/mixed; boundary=------------060906070401060709050107
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060906070401060709050107
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello everyone,
This mail contains an application to test DMABUF support
in V4L2 for VIVI and S5P-FIMC drivers. The application was
tested on linux-media for 3.7 with applied patchset
"[PATCHv10 */26] Integration of videobuf2 with DMABUF"
on Universal C210 board.

Compilation:
1. Fetch media-next, apply patchset [PATCHv10 */26] Integration of videobuf2 with DMABUF
2. Execute 'make headers_install' in kernel source
3. arm-linux-gnueabi-gcc v4l-dbuf.c -o v4l-dbuf -O2 -std=gnu99 -I kernel/usr/include/

This app creates a simple pipeline between VIVI and two FIMC instances.
The scenario goes as follows:

1. FIMC0 creates an MMAP buffer at its OUTPUT queue. (testing vb2_dc_alloc)
2. The buffer from 1. is exported using VIDIOC_EXPBUF. (testing exporting in vb2-dma-config)
3. The DMABUF from 2. is imported to VIVI at CAPTURE queue. (testing importing in vb2-vmalloc)
4. Single frame is grabbed from VIVI into the DMABUF. (testing vb2_dc_dmabuf_ops_vmap)
5. FIMC1 creates an MMAP buffer at its OUTPUT queue. (testing vb2_dc_alloc)
6. he buffer from 5. is exported using VIDIOC_EXPBUF. (testing exporting in vb2-dma-config)
7. The DMABUF from 6. is imported by FIMC0 at CAPTURE queue. (testing importing in vb2-dma-contig)
8. FIMC0 is used to process a frame (format conversion/scaling/rotation).
9. USERPTR is created from an anonymous or file mapping.
10. The USERPTR from 9. is passed to FIMC1 at CAPTURE queue. (testing vb2_dc_get_userptr)
11. FIMC1 is used to process a frame (format conversion/scaling/rotation).

In the result, the USERPTR contains a frame from VIVI processed by
two FIMCs. The app should produce 'Test passed' text on finish.

The command line options allow to control the stages of the process

	-v path    path to vivi [default /dev/video0]
	-f path    path to fimc0 [default /dev/video1]
	-F path    path to fimc1 [default /dev/video3]
	-0 4cc@WxH format between VIVI and FIMC0
	-1 4cc@WxH format between FIMC0 and FIMC1
	-2 4cc@WxH format between FIMC1 and destination
	-V         vertical flip on FIMC0
	-H         horizontal flip on FIMC0
	-R angle   rotation by angle [default 0] on FIMC0
	-m size[@file[+offset]]  destination mapping,
                                 size 0 is adjusted automatically,
                                 no file indicate anonymous mapping
	-h         print this help

For example:
v4l-dbuf -0 RGBP@320x200 -H -R 90 -1 RGB4@96x96 -2 YUYV@32x32 -m 0@/dev/fb0

does:

- grab frame from VIVI 320x200 in RGBP (RGB565) format
- convert this frame to 96x96 RGB4 (RGB32) format using FIMC0,
  apply horizontal flip and 90 degree rotation
- convert result frame to 32x32 YUYV format using FIMC1
- store result in a framebuffer at /dev/fb0

Please, notice if destination file is missing, then anonymous mapping
is used. On platforms that support no SYSMMU for FIMC it is very likely
that VIDIOC_QBUF will fail if the size of the result image is larger
than a single page.

Please use -v, -f, -F options to setup proper paths to VIVI, FIMC0-M2M,
and FIMC1-M2M nodes.

At each stage the result frames are dumped in PPM format (Netpbm format).
Currently, dumping is supported only for RGB565, RGB32 and YUYV formats.
The app is not aborted if a format is not supported.

Please let us know if you have any further questions.

Regards,
Tomasz Stanislawski

--------------060906070401060709050107
Content-Type: text/x-csrc;
 name="v4l-dbuf.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v4l-dbuf.c"

/*
 * V4L2 VIVI + FIMC + DMABUF sharing Test Application
 *
 * This application is used to test DMABUF sharing between VIVI and FIMC
 * device.
 *
 * Authors:
 *	Tomasz Stanislawski <t.stanislaws@samsung.com>
 *
 * Date:
 *      08.10.2012
 *
 */

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <linux/videodev2.h>

#define ARRAY_SIZE(tab) \
	(sizeof(tab) / sizeof(*tab))

#define CLEAR(s) memset(&s, 0, sizeof(s))

#define MIN(x,y) ((x) < (y) ? (x) : (y))
#define MAX(x,y) ((x) > (y) ? (x) : (y))
#define CLAMP(x,l,h) ((x) < (l) ? (l) : ((x) > (h) ? (h) : (x)))

static inline int __info(const char *prefix, const char *file, int line,
	const char *fmt, ...)
{
	int errsv = errno;
	va_list va;

	va_start(va, fmt);
	fprintf(stderr, "%s(%s:%d): ", prefix, file, line);
	vfprintf(stderr, fmt, va);
	va_end(va);
	errno = errsv;

	return 1;
}

#define ERRSTR strerror(errno)

#define LOG(...) fprintf(stderr, __VA_ARGS__)

#define ERR(...) __info("Error", __FILE__, __LINE__, __VA_ARGS__)
#define ERR_ON(cond, ...) ((cond) ? ERR(__VA_ARGS__) : 0)

#define CRIT(...) \
	do { \
		__info("Critical", __FILE__, __LINE__, __VA_ARGS__); \
		exit(EXIT_FAILURE); \
	} while(0)
#define CRIT_ON(cond, ...) do { if (cond) CRIT(__VA_ARGS__); } while(0)

struct format {
	unsigned long fourcc;
	unsigned long width;
	unsigned long height;
};

struct config {
	char vivi_path[256];
	char fimc0_path[256];
	char fimc1_path[256];
	int rotate;
	bool hflip;
	bool vflip;
	bool help;
	char dst_path[256];
	int dst_size;
	int dst_offset;
	struct format fmt[3];
};

struct state {
	struct config config;
	int vivi_fd;
	int fimc0_fd;
	int fimc1_fd;
	void *dst_ptr;
	unsigned long dst_size;
};

static void usage(void)
{
#define HELP(...) fprintf(stderr, __VA_ARGS__)
	HELP("Usage:\n");
	HELP("\t-v path    path to vivi [default /dev/video0]\n");
	HELP("\t-f path    path to fimc0 [default /dev/video1]\n");
	HELP("\t-F path    path to fimc1 [default /dev/video3]\n");
	HELP("\t-0 4cc@WxH format between VIVI and FIMC0\n");
	HELP("\t-1 4cc@WxH format between FIMC0 and FIMC1\n");
	HELP("\t-2 4cc@WxH format between FIMC1 and destination\n");
	HELP("\t-V         vertical flip\n");
	HELP("\t-H         horizontal flip\n");
	HELP("\t-R angle   rotation by angle [default 0]\n");
	HELP("\t-m size[@file[+offset]]  destination mapping\n");
	HELP("\t-h         print this help\n");
	HELP("\n");
#undef HELP
}

int parse_format(char *s, struct format *fmt)
{
	char fourcc[5] = "";
	int ret = sscanf(s, "%4[^@]@%lux%lu", fourcc,
		&fmt->width, &fmt->height);

	if (ERR_ON(ret != 3, "'%s' is not in 4cc@WxH format\n", s)) {
		CLEAR(*fmt);
		return -EILSEQ;
	}

	fmt->fourcc = ((unsigned)fourcc[0] << 0) |
		((unsigned)fourcc[1] << 8) |
		((unsigned)fourcc[2] << 16) |
		((unsigned)fourcc[3] << 24);

	return 0;
}

static int config_create(struct config *config, int argc, char *argv[])
{
	int opt, ret = -EINVAL;

	CLEAR(*config);
	strcpy(config->vivi_path, "/dev/video0");
	strcpy(config->fimc0_path, "/dev/video1");
	strcpy(config->fimc1_path, "/dev/video3");

	/* parse options */
	while ((opt = getopt(argc, argv, ":v:f:F:0:1:2:VHR:m:h")) != -1) {
		switch (opt) {
		case 'v':
			strcpy(config->vivi_path, optarg);
			break;
		case 'f':
			strcpy(config->fimc0_path, optarg);
			break;
		case 'F':
			strcpy(config->fimc1_path, optarg);
			break;
		case '0':
		case '1':
		case '2':
			ret = parse_format(optarg, &config->fmt[opt - '0']);
			if (ERR_ON(ret < 0, "invalid format\n"))
				return ret;
			break;
		case 'V':
			config->vflip = true;
			break;
		case 'H':
			config->hflip = true;
			break;
		case 'R':
			ret = sscanf(optarg, "%d", &config->rotate);
			if (ERR_ON(ret != 1, "invalid rotation\n"))
				return -EILSEQ;
			break;
		case 'h':
			config->help = true;
			break;
		case 'm':
			ret = sscanf(optarg, "%i@%255[^+-]%i", &config->dst_size,
				config->dst_path, &config->dst_offset);
			if (ERR_ON(ret < 1, "invalid mapping\n"))
				return -EILSEQ;
			break;
		case ':':
			ERR("missing argument for option %c\n", optopt);
			return -EINVAL;
		default: /* '?' */
			ERR("invalid option %c\n", optopt);
			return -EINVAL;
		}
	}

	return 0;
}

void dump_format(char *str, struct v4l2_format *fmt)
{
	if (V4L2_TYPE_IS_MULTIPLANAR(fmt->type)) {
		struct v4l2_pix_format_mplane *pix = &fmt->fmt.pix_mp;
		LOG("%s: width=%u height=%u format=%.4s bpl=%u\n", str,
			pix->width, pix->height, (char*)&pix->pixelformat,
			pix->plane_fmt[0].bytesperline);
	} else {
		struct v4l2_pix_format *pix = &fmt->fmt.pix;
		LOG("%s: width=%u height=%u format=%.4s bpl=%u\n", str,
			pix->width, pix->height, (char*)&pix->pixelformat,
			pix->bytesperline);
	}
}

int dump_yuyv(int fd, uint8_t *src, int w, int h)
{
	uint8_t buf[6 * 256], *dst = buf;
	for (int wh = w * h; wh; wh--) {
		int y0, y1, u, v;
		int r, g, b;
		y0 = *src++;
		u  = *src++;
		y1 = *src++;
		v  = *src++;
		r = (298 * y0 + 409 * v - 56992) >> 8;
		g = (298 * y0 - 100 * u - 208 * v + 34784) >> 8;
		b = (298 * y0 + 516 * u - 70688) >> 8;
		*dst++ = CLAMP(r, 0, 255);
		*dst++ = CLAMP(g, 0, 255);
		*dst++ = CLAMP(b, 0, 255);
		r = (298 * y1 + 409 * v - 56992) >> 8;
		g = (298 * y1 - 100 * u - 208 * v + 34784) >> 8;
		b = (298 * y1 + 516 * u - 70688) >> 8;
		*dst++ = CLAMP(r, 0, 255);
		*dst++ = CLAMP(g, 0, 255);
		*dst++ = CLAMP(b, 0, 255);
		if (dst - buf < ARRAY_SIZE(buf))
			continue;
		int ret = write(fd, buf, dst - buf);
		if (ERR_ON(ret < 0, "write: %s\n", ERRSTR))
			return -errno;
		dst = buf;
	}
	int ret = write(fd, buf, dst - buf);
	if (ERR_ON(ret < 0, "write: %s\n", ERRSTR))
		return -errno;
	return 0;
}

static inline uint8_t expand8(int v, int size)
{
	switch (size) {
		case 0:
			return 0xff;
		case 1:
			return v & 0x01 ? 0xff : 0;
		case 2:
			v &= 0x03;
			return (v << 6) | (v << 4) | (v << 2) | v;
		case 3:
			v &= 0x07;
			return (v << 5) | (v << 2) | (v >> 1);
		case 4:
			v &= 0x0f;
			return (v << 4) | v;
		case 5:
			v &= 0x1f;
			return (v << 3) | (v >> 2);
		case 6:
			v &= 0x3f;
			return (v << 2) | (v >> 4);
		case 7:
			v &= 0x7f;
			return (v << 1) | (v >> 6);
		default:
			return v;
	}
}

int dump_rgb565(int fd, uint8_t *src, int w, int h)
{
	uint8_t buf[3 * 256], *dst = buf;
	for (int wh = w * h; wh; wh--) {
		int v = 0;
		v |= (int)(*src++);
		v |= (int)(*src++) << 8;
		*dst++ = expand8(v, 5);
		*dst++ = expand8(v >> 5, 6);
		*dst++ = expand8(v >> 11, 5);
		if (dst - buf < ARRAY_SIZE(buf))
			continue;
		int ret = write(fd, buf, dst - buf);
		if (ERR_ON(ret < 0, "write: %s\n", ERRSTR))
			return -errno;
		dst = buf;
	}
	int ret = write(fd, buf, dst - buf);
	if (ERR_ON(ret < 0, "write: %s\n", ERRSTR))
		return -errno;
	return 0;
}

int dump_rgb32(int fd, uint8_t *src, int w, int h)
{
	uint8_t buf[3 * 256], *dst = buf;
	for (int wh = w * h; wh; wh--) {
		++src;
		*dst++ = *src++;
		*dst++ = *src++;
		*dst++ = *src++;
		if (dst - buf < ARRAY_SIZE(buf))
			continue;
		int ret = write(fd, buf, dst - buf);
		if (ERR_ON(ret < 0, "write: %s\n", ERRSTR))
			return -errno;
		dst = buf;
	}
	int ret = write(fd, buf, dst - buf);
	if (ERR_ON(ret < 0, "write: %s\n", ERRSTR))
		return -errno;
	return 0;
}

int dump_image(char *name, unsigned long fourcc, int w, int h, void *data)
{
	LOG("dump=%s w=%d h=%d 4cc=%.4s\n", name, w, h, (char*)&fourcc);
	int fd = open(name, O_WRONLY | O_CREAT, 0644);
	if (ERR_ON(fd < 0, "open: %s\n", ERRSTR))
		return -errno;
	char buf[64];
	sprintf(buf, "P6\n%d %d\n255\n", w, h);
	int ret = write(fd, buf, strlen(buf));
	if (ERR_ON(ret < 0, "write: %s\n", ERRSTR))
		return -errno;
	ret = 0;
	switch (fourcc) {
	case V4L2_PIX_FMT_YUYV:
		ret = dump_yuyv(fd, data, w, h);
		break;
	case V4L2_PIX_FMT_RGB565:
		ret = dump_rgb565(fd, data, w, h);
		break;
	case V4L2_PIX_FMT_RGB32:
		ret = dump_rgb32(fd, data, w, h);
		break;
	default:
		ERR("format %.4s not supported\n", (char*)&fourcc);
		ret = -EINVAL;
	}
	close(fd);
	if (ret)
		ERR("failed to dump %s\n", name);
	else
		LOG("%s dumped successfully\n", name);
	return ret;
}

int setup_formats(struct state *st)
{
	int ret = 0;
	struct v4l2_format fmt;
	CLEAR(fmt);
	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

	/* apply cmdline format if available */
	if (st->config.fmt[0].fourcc) {
		struct v4l2_pix_format *pix = &fmt.fmt.pix;
		pix->pixelformat = st->config.fmt[0].fourcc;
		pix->width = st->config.fmt[0].width;
		pix->height = st->config.fmt[0].height;
		ret = ioctl(st->vivi_fd, VIDIOC_S_FMT, &fmt);
		if (ERR_ON(ret < 0, "vivi: VIDIOC_G_FMT: %s\n", ERRSTR))
			return -errno;
		dump_format("pre-vivi-capture", &fmt);
	}

	/* get format from VIVI */
	ret = ioctl(st->vivi_fd, VIDIOC_G_FMT, &fmt);
	if (ERR_ON(ret < 0, "vivi: VIDIOC_G_FMT: %s\n", ERRSTR))
		return -errno;
	dump_format("vivi-capture", &fmt);

	/* setup format for FIMC 0 */
	/* keep copy of format for to-mplane conversion */
	struct v4l2_pix_format pix = fmt.fmt.pix;

	CLEAR(fmt);
	fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	struct v4l2_pix_format_mplane *pix_mp = &fmt.fmt.pix_mp;

	pix_mp->width = pix.width;
	pix_mp->height = pix.height;
	pix_mp->pixelformat = pix.pixelformat;
	pix_mp->num_planes = 1;
	pix_mp->plane_fmt[0].bytesperline = pix.bytesperline;

	ret = ioctl(st->fimc0_fd, VIDIOC_S_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_S_FMT: %s\n", ERRSTR))
		return -errno;
	dump_format("fimc0-output", &fmt);

	/* setup image conversion */
	struct v4l2_control ctrl;

	if (st->config.hflip) {
		CLEAR(ctrl);
		ctrl.id = V4L2_CID_HFLIP;
		ctrl.value = 1;
		ret = ioctl(st->fimc0_fd, VIDIOC_S_CTRL, &ctrl);
		if (ERR_ON(ret < 0, "fimc0: VIDIOC_S_CTRL(hflip): %s\n",
		           ERRSTR))
			return -errno;
	}

	if (st->config.vflip) {
		CLEAR(ctrl);
		ctrl.id = V4L2_CID_VFLIP;
		ctrl.value = 1;
		ret = ioctl(st->fimc0_fd, VIDIOC_S_CTRL, &ctrl);
		if (ERR_ON(ret < 0, "fimc0: VIDIOC_S_CTRL(vflip): %s\n",
		           ERRSTR))
			return -errno;
	}

	if (st->config.rotate) {
		CLEAR(ctrl);
		ctrl.id = V4L2_CID_ROTATE;
		ctrl.value = st->config.rotate;
		ret = ioctl(st->fimc0_fd, VIDIOC_S_CTRL, &ctrl);
		if (ERR_ON(ret < 0, "fimc0: VIDIOC_S_CTRL(rotate): %s\n",
		           ERRSTR))
			return -errno;
	}

	/* set format on fimc0 capture */
	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	/* try cmdline format, or use fimc0-output instead */
	if (st->config.fmt[1].fourcc) {
		struct v4l2_pix_format_mplane *pix = &fmt.fmt.pix_mp;
		CLEAR(*pix);
		pix->pixelformat = st->config.fmt[1].fourcc;
		pix->width = st->config.fmt[1].width;
		pix->height = st->config.fmt[1].height;
		pix->plane_fmt[0].bytesperline = 0;
	}

	dump_format("pre-fimc0-capture", &fmt);
	ret = ioctl(st->fimc0_fd, VIDIOC_S_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_S_FMT: %s\n", ERRSTR))
		return -errno;

	/* copy format from fimc0 capture to fimc1 output */
	CLEAR(fmt);
	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	ret = ioctl(st->fimc0_fd, VIDIOC_G_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_G_FMT: %s\n", ERRSTR))
		return -errno;
	dump_format("fimc0-capture", &fmt);

	fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	ret = ioctl(st->fimc1_fd, VIDIOC_S_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_S_FMT: %s\n", ERRSTR))
		return -errno;
	ret = ioctl(st->fimc1_fd, VIDIOC_G_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_G_FMT: %s\n", ERRSTR))
		return -errno;
	dump_format("fimc1-output", &fmt);

	/* set format on fimc1 capture */
	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	/* try cmdline format, or use fimc1-output instead */
	if (st->config.fmt[2].fourcc) {
		struct v4l2_pix_format_mplane *pix = &fmt.fmt.pix_mp;
		pix->pixelformat = st->config.fmt[2].fourcc;
		pix->width = st->config.fmt[2].width;
		pix->height = st->config.fmt[2].height;
		pix->plane_fmt[0].bytesperline = 0;
	}

	ret = ioctl(st->fimc1_fd, VIDIOC_S_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_S_FMT: %s\n", ERRSTR))
		return -errno;

	ret = ioctl(st->fimc1_fd, VIDIOC_G_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_G_FMT: %s\n", ERRSTR))
		return -errno;
	dump_format("fimc1-capture", &fmt);

	return 0;
}

int allocate_buffers(struct state *st)
{
	int ret;
	struct v4l2_requestbuffers rb;
	CLEAR(rb);

	/* request buffers for VIVI */
	rb.count = 1;
	rb.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	rb.memory = V4L2_MEMORY_DMABUF;
	ret = ioctl(st->vivi_fd, VIDIOC_REQBUFS, &rb);
	if (ERR_ON(ret < 0, "vivi: VIDIOC_REQBUFS: %s\n", ERRSTR))
		return -errno;

	/* request buffers for FIMC0 */
	rb.count = 1;
	rb.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	rb.memory = V4L2_MEMORY_MMAP;
	ret = ioctl(st->fimc0_fd, VIDIOC_REQBUFS, &rb);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_REQBUFS: %s\n", ERRSTR))
		return -errno;

	rb.count = 1;
	rb.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	rb.memory = V4L2_MEMORY_DMABUF;
	ret = ioctl(st->fimc0_fd, VIDIOC_REQBUFS, &rb);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_REQBUFS: %s\n", ERRSTR))
		return -errno;

	/* request buffers for FIMC1 */
	rb.count = 1;
	rb.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	rb.memory = V4L2_MEMORY_MMAP;
	ret = ioctl(st->fimc1_fd, VIDIOC_REQBUFS, &rb);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_REQBUFS: %s\n", ERRSTR))
		return -errno;

	rb.count = 1;
	rb.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	rb.memory = V4L2_MEMORY_USERPTR;
	ret = ioctl(st->fimc1_fd, VIDIOC_REQBUFS, &rb);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_REQBUFS: %s\n", ERRSTR))
		return -errno;

	/* allocate memory for destination data */
	int fd = -1; /* assume anonymous mapping */
	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
	if (st->config.dst_path[0]) {
		fd = open(st->config.dst_path, O_RDWR);
		if (ERR_ON(fd < 0, "open: %s\n", ERRSTR))
			return -errno;
		flags = MAP_SHARED;
	}

	LOG("dst_path=%s dst_size=%i dst_offset=%i\n",
		st->config.dst_path, st->config.dst_size,
		st->config.dst_offset);

	size_t size = st->config.dst_size;
	/* get size from FIMC1 format if none is given at cmdline */
	if (!size) {
		struct v4l2_format fmt;
		CLEAR(fmt);
		fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
		ret = ioctl(st->fimc1_fd, VIDIOC_G_FMT, &fmt);
		if (ERR_ON(ret < 0, "fimc1: VIDIOC_G_FMT: %s\n", ERRSTR))
			return -errno;
		/* someone should be shot for the layout of v4l2_format */
		size = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
	}

	st->dst_ptr = mmap(NULL, size, PROT_READ, flags, fd,
		st->config.dst_offset);

	if (ERR_ON(st->dst_ptr == MAP_FAILED, "mmap: %s\n", ERRSTR))
		return -errno;

	st->dst_size = size;

	close(fd);

	return 0;
}

int process_vivi(struct state *st)
{
	int ret;
	struct v4l2_exportbuffer eb;
	CLEAR(eb);

	/* export buffer index=0 from FIMC0 */
	eb.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	ret = ioctl(st->fimc0_fd, VIDIOC_EXPBUF, &eb);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_EXPBUF: %s\n", ERRSTR))
		return -errno;

	/* enqueue the dmabuf to vivi */
	struct v4l2_buffer b;
	CLEAR(b);

	b.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	b.memory = V4L2_MEMORY_DMABUF;
	b.m.fd = eb.fd;
	ret = ioctl(st->vivi_fd, VIDIOC_QBUF, &b);
	if (ERR_ON(ret < 0, "vivi: VIDIOC_QBUF: %s\n", ERRSTR))
		return -errno;

	int type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	ret = ioctl(st->vivi_fd, VIDIOC_STREAMON, &type);
	if (ERR_ON(ret < 0, "vivi: VIDIOC_STREAMON: %s\n", ERRSTR))
		return -errno;

	/* dequeue buffer from VIVI */
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	b.memory = V4L2_MEMORY_DMABUF;
	
	ret = ioctl(st->vivi_fd, VIDIOC_DQBUF, &b);
	if (ERR_ON(ret < 0, "vivi: VIDIOC_DQBUF: %s\n", ERRSTR))
		return -errno;

	/* stop streaming */
	ret = ioctl(st->vivi_fd, VIDIOC_STREAMOFF, &type);
	if (ERR_ON(ret < 0, "vivi: VIDIOC_STREAMOFF: %s\n", ERRSTR))
		return -errno;

	LOG("VIVI worked correctly\n");

	/* mmap DMABUF and dump result */
	struct v4l2_plane plane;
	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	b.memory = V4L2_MEMORY_MMAP;
	b.index = 0;
	b.m.planes = &plane;
	b.length = 1;

	ret = ioctl(st->fimc0_fd, VIDIOC_QUERYBUF, &b);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_QUERYBUF: %s\n", ERRSTR))
		return -errno;

	struct v4l2_format fmt;
	CLEAR(fmt);
	fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;

	ret = ioctl(st->fimc0_fd, VIDIOC_G_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_G_FMT: %s\n", ERRSTR))
		return -errno;

	/* mapping DMABUF for dumping */
	void *ptr = mmap(NULL, plane.length, PROT_READ, MAP_SHARED, eb.fd, 0);
	if (ERR_ON(ptr == MAP_FAILED, "mmap: %s\n", ERRSTR))
		return -errno;

	LOG("DMABUF from FIMC0 OUTPUT mmapped correctly\n");

	/* dump image, ignore errors */
	dump_image("dmabuf-fimc0-output.ppm", fmt.fmt.pix_mp.pixelformat,
		fmt.fmt.pix_mp.width, fmt.fmt.pix_mp.height, ptr);

	/* small cleanup */
	munmap(ptr, fmt.fmt.pix.sizeimage);
	close(eb.fd);

	/* mmap FIMC0 output and dump it */
	ptr = mmap(NULL, plane.length,
		PROT_READ | PROT_WRITE, MAP_SHARED, st->fimc0_fd,
		plane.m.mem_offset);
	if (ERR_ON(ptr == MAP_FAILED, "mmap: %s\n", ERRSTR))
		return -errno;

	LOG("FIMC0 output mmapped correctly\n");

	/* dump image, ignore result */
	dump_image("mmap-fimc0-output.ppm", fmt.fmt.pix_mp.pixelformat,
		fmt.fmt.pix_mp.width, fmt.fmt.pix_mp.height, ptr);

	munmap(ptr, plane.length);

	return 0;
}

int process_fimc0(struct state *st)
{
	int ret;
	struct v4l2_buffer b;
	struct v4l2_plane plane;

	/* enqueue buffer to fimc0 output */
	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	b.memory = V4L2_MEMORY_MMAP;
	b.index = 0;
	b.m.planes = &plane;
	b.length = 1;

	ret = ioctl(st->fimc0_fd, VIDIOC_QBUF, &b);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_QBUF: %s\n", ERRSTR))
		return -errno;

	/* export the first buffer from FIMC1 */
	struct v4l2_exportbuffer eb;
	CLEAR(eb);
	eb.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	ret = ioctl(st->fimc1_fd, VIDIOC_EXPBUF, &eb);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_EXPBUF: %s\n", ERRSTR))
		return -errno;

	/* enqueue the DMABUF as FIMC0's cature */
	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	b.memory = V4L2_MEMORY_DMABUF;
	b.index = 0;
	b.m.planes = &plane;
	b.length = 1;
	plane.m.fd = eb.fd;

	ret = ioctl(st->fimc0_fd, VIDIOC_QBUF, &b);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_QBUF: %s\n", ERRSTR))
		return -errno;

	/* start processing */
	int type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	ret = ioctl(st->fimc0_fd, VIDIOC_STREAMON, &type);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_STREAMON: %s\n", ERRSTR))
		return -errno;

	type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	ret = ioctl(st->fimc0_fd, VIDIOC_STREAMON, &type);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_STREAMON: %s\n", ERRSTR))
		return -errno;

	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	b.memory = V4L2_MEMORY_DMABUF;
	b.m.planes = &plane;
	b.length = 1;

	/* grab processed buffers */
	ret = ioctl(st->fimc0_fd, VIDIOC_DQBUF, &b);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_DQBUF: %s\n", ERRSTR))
		return -errno;

	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	b.memory = V4L2_MEMORY_MMAP;
	b.m.planes = &plane;
	b.length = 1;

	ret = ioctl(st->fimc0_fd, VIDIOC_DQBUF, &b);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_DQBUF: %s\n", ERRSTR))
		return -errno;

	/* stop processing */
	type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	ret = ioctl(st->fimc0_fd, VIDIOC_STREAMOFF, &type);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_STREAMOFF: %s\n", ERRSTR))
		return -errno;

	type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	ret = ioctl(st->fimc0_fd, VIDIOC_STREAMOFF, &type);
	if (ERR_ON(ret < 0, "fimc0: VIDIOC_STREAMOFF: %s\n", ERRSTR))
		return -errno;

	LOG("FIMC0 worked correctly\n");

	/* mmap FIMC1 OUTPUT DMABUF and dump result */
	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	b.memory = V4L2_MEMORY_MMAP;
	b.m.planes = &plane;
	b.length = 1;

	ret = ioctl(st->fimc1_fd, VIDIOC_QUERYBUF, &b);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_QUERYBUF: %s\n", ERRSTR))
		return -errno;

	/* mapping DMABUF */
	void *ptr = mmap(NULL, plane.length, PROT_READ, MAP_SHARED, eb.fd, 0);
	if (ERR_ON(ptr == MAP_FAILED, "mmap: %s\n", ERRSTR))
		return -errno;

	LOG("DMABUF from FIMC1 OUTPUT mmapped correctly\n");

	/* get format and dump result */
	struct v4l2_format fmt;
	CLEAR(fmt);

	fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;

	ret = ioctl(st->fimc1_fd, VIDIOC_G_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_G_FMT: %s\n", ERRSTR))
		return -errno;

	/* dump image, ignore result */
	dump_image("dmabuf-fimc1-output.ppm", fmt.fmt.pix_mp.pixelformat,
		fmt.fmt.pix_mp.width, fmt.fmt.pix_mp.height, ptr);

	/* cleanup DMABUF stuff */
	munmap(ptr, plane.length);
	close(eb.fd);

	/* mmap FIMC1 output and dump it */

	ptr = mmap(NULL, plane.length,
		PROT_READ | PROT_WRITE, MAP_SHARED, st->fimc1_fd,
		plane.m.mem_offset);
	if (ERR_ON(ptr == MAP_FAILED, "mmap: %s\n", ERRSTR))
		return -errno;

	LOG("FIMC1 output mmapped correctly\n");

	/* dump image, ignore result */
	dump_image("mmap-fimc1-output.ppm", fmt.fmt.pix_mp.pixelformat,
		fmt.fmt.pix_mp.width, fmt.fmt.pix_mp.height, ptr);

	munmap(ptr, plane.length);

	return 0;
}

int process_fimc1(struct state *st)
{
	int ret;
	/* enqueue buffer 0 as FIMC1's output */
	struct v4l2_buffer b;
	struct v4l2_plane plane;
	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	b.memory = V4L2_MEMORY_MMAP;
	b.index = 0;
	b.m.planes = &plane;
	b.length = 1;

	ret = ioctl(st->fimc1_fd, VIDIOC_QBUF, &b);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_QBUF: %s\n", ERRSTR))
		return -errno;

	/* enqueue userptr as FIMC1's capture */
	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	b.memory = V4L2_MEMORY_USERPTR;
	b.index = 0;
	b.m.planes = &plane;
	b.length = 1;
	plane.m.userptr = (unsigned long)st->dst_ptr;
	plane.length = st->dst_size;

	ret = ioctl(st->fimc1_fd, VIDIOC_QBUF, &b);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_QBUF: %s\n", ERRSTR))
		return -errno;

	/* start processing */
	int type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	ret = ioctl(st->fimc1_fd, VIDIOC_STREAMON, &type);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_STREAMON: %s\n", ERRSTR))
		return -errno;

	type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	ret = ioctl(st->fimc1_fd, VIDIOC_STREAMON, &type);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_STREAMON: %s\n", ERRSTR))
		return -errno;

	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	b.memory = V4L2_MEMORY_USERPTR;
	b.m.planes = &plane;
	b.length = 1;

	/* grab processed buffers */
	ret = ioctl(st->fimc1_fd, VIDIOC_DQBUF, &b);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_DQBUF: %s\n", ERRSTR))
		return -errno;

	CLEAR(plane);
	CLEAR(b);
	b.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	b.memory = V4L2_MEMORY_MMAP;
	b.m.planes = &plane;
	b.length = 1;

	ret = ioctl(st->fimc1_fd, VIDIOC_DQBUF, &b);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_DQBUF: %s\n", ERRSTR))
		return -errno;

	/* stop processing */
	type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	ret = ioctl(st->fimc1_fd, VIDIOC_STREAMOFF, &type);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_STREAMOFF: %s\n", ERRSTR))
		return -errno;

	type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	ret = ioctl(st->fimc1_fd, VIDIOC_STREAMOFF, &type);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_STREAMOFF: %s\n", ERRSTR))
		return -errno;

	LOG("FIMC1 worked correctly\n");

	/* dump image, ignore errors */
	struct v4l2_format fmt;
	CLEAR(fmt);
	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	ret = ioctl(st->fimc1_fd, VIDIOC_G_FMT, &fmt);
	if (ERR_ON(ret < 0, "fimc1: VIDIOC_G_FMT: %s\n", ERRSTR))
		return 0;

	msync(st->dst_ptr, st->dst_size, MS_SYNC);

	dump_image("fimc1-capture.ppm", fmt.fmt.pix_mp.pixelformat,
		fmt.fmt.pix_mp.width, fmt.fmt.pix_mp.height,
		st->dst_ptr);

	return 0;
}
int main(int argc, char *argv[])
{
	struct state st;
	CLEAR(st);

	int ret = config_create(&st.config, argc, argv);
	if (ret) {
		usage();
		CRIT("bad arguments\n");
	}

	if (st.config.help) {
		usage();
		return EXIT_SUCCESS;
	}

	st.vivi_fd = open(st.config.vivi_path, O_RDWR);
	CRIT_ON(st.vivi_fd < 0, "failed to open VIVI at %s: %s\n",
		st.config.vivi_path, ERRSTR);

	st.fimc0_fd = open(st.config.fimc0_path, O_RDWR);
	CRIT_ON(st.vivi_fd < 0, "failed to open FIMC0 at %s: %s\n",
		st.config.fimc0_path, ERRSTR);

	st.fimc1_fd = open(st.config.fimc1_path, O_RDWR);
	CRIT_ON(st.vivi_fd < 0, "failed to open FIMC1 at %s: %s\n",
		st.config.fimc1_path, ERRSTR);

	ret = setup_formats(&st);
	CRIT_ON(ret, "failed to setup formats\n");

	ret = allocate_buffers(&st);
	CRIT_ON(ret, "failed to allocate buffers\n");

	ret = process_vivi(&st);
	CRIT_ON(ret, "failed to do vivi processing\n");

	ret = process_fimc0(&st);
	CRIT_ON(ret, "failed to do fimc0 processing\n");

	ret = process_fimc1(&st);
	CRIT_ON(ret, "failed to do fimc1 processing\n");

	LOG("Test passed\n");

	return EXIT_SUCCESS;
}

--------------060906070401060709050107--

