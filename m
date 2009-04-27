Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:3956 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZD0JfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 05:35:25 -0400
Date: Mon, 27 Apr 2009 11:35:14 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Vasily <vasaka@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [REVIEW] v4l2 loopback
Message-Id: <20090427113514.2d1013f9.ospite@studenti.unina.it>
In-Reply-To: <200904270422.59186.vasily@scopicsoftware.com>
References: <200903262049.10425.vasily@scopicsoftware.com>
	<200904270422.59186.vasily@scopicsoftware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Apr_2009_11_35_14_+0200_=g+fDADKNEULrW5n"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Mon__27_Apr_2009_11_35_14_+0200_=g+fDADKNEULrW5n
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vasily,

Your patch seems to be reversed, not a big deal for review purposes, of
course.
I think you know that if you are working on a hg clone you can simply
issue "hg diff" to get the right patch, or you could even use 'quilt' to
ease your work.

Just very few comments about syntax and style, since I am not a v4l
dev :)

On Mon, 27 Apr 2009 04:22:58 +0300
Vasily <vasaka@gmail.com> wrote:

> Hello Hans,
>=20
> Here is version with most issues fixed except usage of struct v4l2_device
> Can you please tell me more what should I use it for? I do not use any=20
> subdevice feature. It does not remove usage of video_device struct
> as I see from vivi driver it just used to be registered and unregistered
> and for messages, may be I missed something?
> So  can you tell please what I should use it for in loopback driver?
> Just add it to v4l2_loopback_device structure and registe it?
> ---
> This patch introduces v4l2 loopback module
>
> From: Vasily Levin <vasaka@gmail.com>
>=20
> This is v4l2 loopback driver which can be used to make available any user=
space
> video as v4l2 device. Initialy it was written to make videoeffects availa=
ble
> to Skype, but in fact it have many more uses.
>=20
> Priority: normal
>=20
> Signed-off-by: Vasily Levin <vasaka@gmail.com>
>=20
> diff -uprN v4l-dvb.my.p/linux/drivers/media/video/Kconfig v4l-dvb.orig/li=
nux/drivers/media/video/Kconfig
> --- v4l-dvb.my.p/linux/drivers/media/video/Kconfig	2009-04-26 21:30:37.00=
0000000 +0300
> +++ v4l-dvb.orig/linux/drivers/media/video/Kconfig	2009-04-25 04:41:20.00=
0000000 +0300
> @@ -479,13 +479,6 @@ config VIDEO_VIVI
>  	  Say Y here if you want to test video apps or debug V4L devices.
>  	  In doubt, say N.
> =20
> -config VIDEO_V4L2_LOOPBACK
> -	tristate "v4l2 loopback driver"
> -	depends on VIDEO_V4L2 && VIDEO_DEV
> -	help
> -	  Say Y if you want to use v4l2 loopback driver.
> -	  This driver can be compiled as a module, called v4l2loopback.
> -

The description here could be improved, don't you think so?

>  source "drivers/media/video/bt8xx/Kconfig"
> =20
>  config VIDEO_PMS
> diff -uprN v4l-dvb.my.p/linux/drivers/media/video/Makefile v4l-dvb.orig/l=
inux/drivers/media/video/Makefile
> --- v4l-dvb.my.p/linux/drivers/media/video/Makefile	2009-04-26 21:30:37.0=
00000000 +0300
> +++ v4l-dvb.orig/linux/drivers/media/video/Makefile	2009-04-25 04:41:20.0=
00000000 +0300
> @@ -132,7 +132,6 @@ obj-$(CONFIG_VIDEO_IVTV) +=3D ivtv/
>  obj-$(CONFIG_VIDEO_CX18) +=3D cx18/
> =20
>  obj-$(CONFIG_VIDEO_VIVI) +=3D vivi.o
> -obj-$(CONFIG_VIDEO_V4L2_LOOPBACK) +=3D v4l2loopback.o
>  obj-$(CONFIG_VIDEO_CX23885) +=3D cx23885/
> =20
>  obj-$(CONFIG_VIDEO_MX1)			+=3D mx1_camera.o
> diff -uprN v4l-dvb.my.p/linux/drivers/media/video/v4l2loopback.c v4l-dvb.=
orig/linux/drivers/media/video/v4l2loopback.c
> --- v4l-dvb.my.p/linux/drivers/media/video/v4l2loopback.c	2009-04-27 03:0=
7:08.000000000 +0300
> +++ v4l-dvb.orig/linux/drivers/media/video/v4l2loopback.c	1970-01-01 03:0=
0:00.000000000 +0300
> @@ -1,732 +0,0 @@
> -/*
> - *      v4l2loopback.c  --  video 4 linux loopback driver
> - *
> - *      Copyright (C) 2005-2009
> - *          Vasily Levin (vasaka@gmail.com)
> - *
> - *      This program is free software; you can redistribute it and/or mo=
dify
> - *      it under the terms of the GNU General Public License as publishe=
d by
> - *      the Free Software Foundation; either version 2 of the License, or
> - *      (at your option) any later version.
> - *
> - */

Nitpicking here: just one space before the text?

> -#include <linux/version.h>
> -#include <linux/vmalloc.h>
> -#include <linux/mm.h>
> -#include <linux/time.h>
> -#include <linux/module.h>
> -#include <media/v4l2-ioctl.h>
> -#include "v4l2loopback.h"
> -
> -#define YAVLD_STREAMING
> -
> -MODULE_DESCRIPTION("V4L2 loopback video device");
> -MODULE_VERSION("0.1.1");
> -MODULE_AUTHOR("Vasily Levin");
> -MODULE_LICENSE("GPL");
> -

"GPL v2"? I am not sure if this is of any importance.

> -/* module parameters */
> -static int debug =3D 0;
> -module_param(debug, int, 0);
> -MODULE_PARM_DESC(debug,"if debug output is enabled, values are 0, 1 or 2=
");
> -

To do debug prints, these days, most kernel modules defines DEBUG at
the top of the file (just when needed) and then use pr_debug() or better
dev_dbg() into code.

> -static int max_buffers_number =3D 4;
> -module_param(max_buffers_number, int, 0);
> -MODULE_PARM_DESC(max_buffers_number,"how many buffers should be allocate=
d");
> -
> -static int max_openers =3D 10;
> -module_param(max_openers, int, 0);
> -MODULE_PARM_DESC(max_openers,"how many users can open loopback device");
> -
> -#define dprintk(fmt, args...)\
> -	if (debug) {\
> -		printk(KERN_INFO "v4l2-loopback: " fmt, ##args);\
> -	}
> -
> -
> -#define dprintkrw(fmt, args...)\
> -	if (debug > 1) {\
> -		printk(KERN_INFO "v4l2-loopback: " fmt, ##args);\
> -	}
> -

If you choose to use dev_dbg() these two macros could be dropped, you
will loose debug levels, but it is not a big loss IMHO.

> -/* global module data */
> -struct v4l2_loopback_device *dev;
> -/* forward declarations */
> -static void init_buffers(int buffer_size);
> -static int allocate_buffers(void);
> -static const struct v4l2_file_operations v4l2_loopback_fops;
> -static const struct v4l2_ioctl_ops v4l2_loopback_ioctl_ops;
> -/* Queue helpers */
> -/* next functions sets buffer flags and adjusts counters accordingly */
> -static void set_done(struct v4l2_buffer *buffer)
> -{
> -	buffer->flags |=3D V4L2_BUF_FLAG_DONE;
> -	buffer->flags &=3D ~V4L2_BUF_FLAG_QUEUED;
> -}
> -
> -static void set_queued(struct v4l2_buffer *buffer)
> -{
> -	buffer->flags |=3D V4L2_BUF_FLAG_QUEUED;
> -	buffer->flags &=3D ~V4L2_BUF_FLAG_DONE;
> -}
> -

Just nitpicking, you can well ignore this comment: I find more logical
to unset the old value first and then set the new flag in these two.

> -static void unset_all(struct v4l2_buffer *buffer)
> -{
> -	buffer->flags &=3D ~V4L2_BUF_FLAG_QUEUED;
> -	buffer->flags &=3D ~V4L2_BUF_FLAG_DONE;
> -}

also it won't hurt to qualify these three function above as 'inline'.

> -/* V4L2 ioctl caps and params calls */
> -/* returns device capabilities, called on VIDIOC_QUERYCAP ioctl*/
> -static int vidioc_querycap(struct file *file,
> -			   void *priv, struct v4l2_capability *cap)
> -{
> -	strlcpy(cap->driver, "v4l2 loopback", sizeof(cap->driver));
> -	strlcpy(cap->card, "Dummy video device", sizeof(cap->card));
> -	cap->version =3D 1;
> -	cap->capabilities =3D
> -	    V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
> -	    V4L2_CAP_READWRITE
> -#ifdef YAVLD_STREAMING
> -	    | V4L2_CAP_STREAMING
> -#endif
> -	    ;
> -	return 0;
> -}
> -
> -/* returns device formats, called on VIDIOC_ENUM_FMT ioctl*/
> -static int vidioc_enum_fmt_cap(struct file *file, void *fh,
> -			       struct v4l2_fmtdesc *f)
> -{
> -	if (dev->ready_for_capture =3D=3D 0)
> -		return -EINVAL;
> -	if (f->index)
> -		return -EINVAL;
> -	strlcpy(f->description, "current format", sizeof(f->description));
> -	f->pixelformat =3D dev->pix_format.pixelformat;
> -	return 0;
> -};
> -
> -/* returns current video format format fmt, called on VIDIOC_G_FMT ioctl=
 */
> -static int vidioc_g_fmt_cap(struct file *file,
> -			    void *priv, struct v4l2_format *fmt)
> -{
> -	if (dev->ready_for_capture =3D=3D 0)
> -		return -EINVAL;
> -	fmt->fmt.pix =3D dev->pix_format;
> -	return 0;
> -}
> -
> -/* checks if it is OK to change to format fmt, called on VIDIOC_TRY_FMT =
ioctl
> - * with v4l2_buf_type set to V4L2_BUF_TYPE_VIDEO_CAPTURE */
> -/* actual check is done by inner_try_fmt_cap */
> -/* just checking that pixelformat is OK and set other parameters, app sh=
ould
> - * obey this decidion */

typo here: 'decidion' -> 'decision', also you could put the end of
comment alone as a last line in multi-line comments, if you choose this
style use it also in all the other comments.

> -static int vidioc_try_fmt_cap(struct file *file,
> -			      void *priv, struct v4l2_format *fmt)
> -{
> -	struct v4l2_loopback_opener *opener =3D file->private_data;
> -
> -	opener->type =3D READER;
> -	if (dev->ready_for_capture =3D=3D 0)
> -		return -EINVAL;
> -	if (fmt->fmt.pix.pixelformat !=3D dev->pix_format.pixelformat)
> -		return -EINVAL;
> -	fmt->fmt.pix =3D dev->pix_format;
> -	return 0;
> -}
> -
> -/* checks if it is OK to change to format fmt, called on VIDIOC_TRY_FMT =
ioctl
> - * with v4l2_buf_type set to V4L2_BUF_TYPE_VIDEO_OUTPUT */
> -/* if format is negotiated do not change it */
> -static int vidioc_try_fmt_video_output(struct file *file,
> -				       void *priv, struct v4l2_format *fmt)
> -{
> -	struct v4l2_loopback_opener *opener =3D file->private_data;
> -
> -	opener->type =3D WRITER;
> -	/* TODO(vasaka) loopback does not care about formats writer want to set,
> -	 * maybe it is a good idea to restrict format somehow */
> -	if (dev->ready_for_capture) {
> -		fmt->fmt.pix =3D dev->pix_format;
> -	} else {
> -		if (fmt->fmt.pix.sizeimage =3D=3D 0)
> -			return -1;
> -		dev->pix_format =3D fmt->fmt.pix;
> -	}
> -	return 0;
> -};
> -
> -/* sets new output format, if possible, called on VIDIOC_S_FMT ioctl
> - * with v4l2_buf_type set to V4L2_BUF_TYPE_VIDEO_CAPTURE */
> -/* actually format is set  by input and we even do not check it, just re=
turn
> - * current one, but it is possible to set subregions of input TODO(vasak=
a) */
> -static int vidioc_s_fmt_cap(struct file *file,
> -			    void *priv, struct v4l2_format *fmt)
> -{
> -	return vidioc_try_fmt_cap(file, priv, fmt);
> -}
> -
> -/* sets new output format, if possible, called on VIDIOC_S_FMT ioctl
> - * with v4l2_buf_type set to V4L2_BUF_TYPE_VIDEO_OUTPUT */
> -/* allocate data here because we do not know if it will be streaming or
> - * read/write IO */
> -static int vidioc_s_fmt_video_output(struct file *file,
> -				     void *priv, struct v4l2_format *fmt)
> -{
> -	int ret =3D vidioc_try_fmt_video_output(file, priv, fmt);
> -
> -	if (ret < 0)
> -		return ret;
> -	if (dev->ready_for_capture =3D=3D 0) {
> -		dev->buffer_size =3D PAGE_ALIGN(dev->pix_format.sizeimage);
> -		fmt->fmt.pix.sizeimage =3D dev->buffer_size;
> -	}
> -	return ret;
> -}
> -
> -/*get some data flaw parameters, only capability, fps and readbuffers ha=
s effect
> - *on this driver, called on VIDIOC_G_PARM*/

put a space before text here.

> -static int vidioc_g_parm(struct file *file, void *priv,
> -			 struct v4l2_streamparm *parm)
> -{
> -	/* do not care about type of opener, hope this enums would always be
> -	 * compatible */
> -	parm->parm.capture =3D dev->capture_param;
> -	return 0;
> -}
> -
> -/*get some data flaw parameters, only capability, fps and readbuffers ha=
s effect
> - *on this driver, called on VIDIOC_S_PARM */
> -static int vidioc_s_parm(struct file *file, void *priv,
> -			 struct v4l2_streamparm *parm)
> -{
> -	dprintk("vidioc_s_parm called frate=3D%d/%d\n",
> -	       parm->parm.capture.timeperframe.numerator,
> -	       parm->parm.capture.timeperframe.denominator);
> -	switch (parm->type) {
> -	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		parm->parm.capture =3D dev->capture_param;
> -		return 0;
> -	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		/* TODO(vasaka) do nothing now, but should set fps if
> -		 * needed */
> -		parm->parm.capture =3D dev->capture_param;
> -		return 0;
> -	default:
> -		return -1;
> -	}
> -}
> -
> -/* sets a tv standard, actually we do not need to handle this any specia=
l way
> - * added to support effecttv, can not be inline as I need pointer to it =
*/
> -static int vidioc_s_std(struct file *file, void *private_data,
> -			v4l2_std_id *norm)
> -{
> -	return 0;
> -}
> -
> -/* returns set of device inputs, in our case there is only one, but late=
r I may
> - * add more, called on VIDIOC_ENUMINPUT */
> -static int vidioc_enum_input(struct file *file, void *fh,
> -			     struct v4l2_input *inp)
> -{
> -	if (dev->ready_for_capture =3D=3D 0)
> -		return -EINVAL;
> -	if (inp->index =3D=3D 0) {
> -		strlcpy(inp->name, "loopback", sizeof(inp->name));
> -		inp->type =3D V4L2_INPUT_TYPE_CAMERA;
> -		inp->audioset =3D 0;
> -		inp->tuner =3D 0;
> -		inp->std =3D V4L2_STD_ALL;
> -		inp->status =3D 0;
> -		return 0;
> -	}
> -	return -EINVAL;
> -}
> -
> -/* which input is currently active, called on VIDIOC_G_INPUT */
> -int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
> -{
> -	*i =3D 0;
> -	return 0;
> -}
> -
> -/* set input, can make sense if we have more than one video src,
> - * called on VIDIOC_S_INPUT */
> -int vidioc_s_input(struct file *file, void *fh, unsigned int i)
> -{
> -	if (i =3D=3D 0)
> -		return 0;
> -	return -EINVAL;
> -}
> -
> -/* V4L2 ioctl buffer related calls */
> -/* negotiate buffer type, called on VIDIOC_REQBUFS */
> -/* only mmap streaming supported */
> -static int vidioc_reqbufs(struct file *file, void *fh,
> -			  struct v4l2_requestbuffers *b)
> -{
> -	switch (b->memory) {
> -	case V4L2_MEMORY_MMAP:
> -		/* do nothing here, buffers are always allocated*/
> -		if (b->count =3D=3D 0)
> -			return 0;
> -		b->count =3D dev->buffers_number;
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -/* returns buffer asked for, called on VIDIOC_QUERYBUF */
> -/* give app as many buffers as it wants, if it less than 100 :-),
> - * but map them in our inner buffers */
> -static int vidioc_querybuf(struct file *file, void *fh,
> -			   struct v4l2_buffer *b)
> -{
> -	enum v4l2_buf_type type =3D b->type;
> -	int index =3D b->index;
> -
> -	if ((b->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> -	    (b->type !=3D V4L2_BUF_TYPE_VIDEO_OUTPUT)) {
> -		return -EINVAL;
> -	}
> -	if (b->index > 100)
> -		return -EINVAL;

define a MAX_BUFFER_INDEX macro instead of the 100 here?

> -	*b =3D dev->buffers[b->index % dev->buffers_number];
> -	b->type =3D type;
> -	b->index =3D index;
> -	return 0;
> -}
> -
> -/* put buffer to queue, called on VIDIOC_QBUF */
> -static int vidioc_qbuf(struct file *file, void *private_data,
> -		       struct v4l2_buffer *buf)
> -{
> -	int index =3D buf->index % dev->buffers_number;
> -
> -	if (buf->index > 100)

as above

> -		return -EINVAL;
> -	switch (buf->type) {
> -	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		set_queued(&dev->buffers[index]);
> -		return 0;
> -	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		do_gettimeofday(&dev->buffers[index].timestamp);
> -		set_done(&dev->buffers[index]);
> -		wake_up_all(&dev->read_event);
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -/* put buffer to dequeue, called on VIDIOC_DQBUF */
> -static int vidioc_dqbuf(struct file *file, void *private_data,
> -			struct v4l2_buffer *buf)
> -{
> -	int index;
> -	struct v4l2_loopback_opener *opener =3D file->private_data;
> -
> -	switch (buf->type) {
> -	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		if ((dev->write_position <=3D opener->position) &&
> -			(file->f_flags&O_NONBLOCK))
> -			return -EAGAIN;
> -		wait_event_interruptible(dev->read_event, (dev->write_position >
> -					 opener->position));
> -		if (dev->write_position > opener->position+2)
> -			opener->position =3D dev->write_position - 1;
> -		index =3D opener->position % dev->buffers_number;
> -		if (!(dev->buffers[index].flags&V4L2_BUF_FLAG_MAPPED)) {
> -			printk(KERN_INFO "v4l2-loopback: "
> -			       "trying to g\return not mapped buf\n");
> -			return -EINVAL;
> -		}
> -		++opener->position;
> -		unset_all(&dev->buffers[index]);
> -		*buf =3D dev->buffers[index];
> -		return 0;
> -	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		index =3D dev->write_position % dev->buffers_number;
> -		unset_all(&dev->buffers[index]);
> -		*buf =3D dev->buffers[index];
> -		++dev->write_position;
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -static int vidioc_streamon(struct file *file, void *private_data,
> -			   enum v4l2_buf_type type)
> -{
> -	int ret;
> -	switch (type) {
> -	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		if (dev->ready_for_capture =3D=3D 0) {
> -			ret =3D allocate_buffers();
> -			if (ret < 0)
> -				return ret;
> -			init_buffers(dev->buffer_size);
> -			dev->ready_for_capture =3D 1;
> -		}
> -		return 0;
> -	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		if (dev->ready_for_capture =3D=3D 0)
> -			return -EIO;
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -static int vidioc_streamoff(struct file *file, void *private_data,
> -			    enum v4l2_buf_type type)
> -{
> -	return 0;
> -}
> -
> -#ifdef CONFIG_VIDEO_V4L1_COMPAT
> -int vidiocgmbuf(struct file *file, void *fh, struct video_mbuf *p)
> -{
> -	p->frames =3D dev->buffers_number;
> -	p->offsets[0] =3D 0;
> -	p->offsets[1] =3D 0;
> -	p->size =3D dev->buffer_size;
> -	return 0;
> -}
> -#endif
> -/* file operations */
> -static void vm_open(struct vm_area_struct *vma)
> -{
> -	/* TODO(vasaka) do open counter here */
> -}
> -
> -static void vm_close(struct vm_area_struct *vma)
> -{
> -	/* TODO(vasaka) do open counter here */
> -}
> -
> -static struct vm_operations_struct vm_ops =3D {
> -	.open =3D vm_open,
> -	.close =3D vm_close,
> -};
> -
> -static int v4l2_loopback_mmap(struct file *file,
> -			      struct vm_area_struct *vma)
> -{
> -
> -	struct page *page =3D NULL;
> -	unsigned long addr;
> -	unsigned long start =3D (unsigned long) vma->vm_start;
> -	unsigned long size =3D (unsigned long) (vma->vm_end - vma->vm_start);
> -
> -	dprintk("entering v4l_mmap(), offset: %lu\n", vma->vm_pgoff);
> -	if (size > dev->buffer_size) {
> -		printk(KERN_INFO "v4l2-loopback: "
> -		       "userspace tries to mmap to much, fail\n");
> -		return -EINVAL;
> -	}
> -	if ((vma->vm_pgoff << PAGE_SHIFT) >
> -	    dev->buffer_size * (dev->buffers_number - 1)) {
> -		printk(KERN_INFO "v4l2-loopback: "
> -		       "userspace tries to mmap to far, fail\n");
> -		return -EINVAL;
> -	}
> -	addr =3D (unsigned long) dev->image + (vma->vm_pgoff << PAGE_SHIFT);
> -
> -	while (size > 0) {
> -		page =3D (void *) vmalloc_to_page((void *) addr);
> -
> -		if (vm_insert_page(vma, start, page) < 0)
> -			return -EAGAIN;
> -
> -		start +=3D PAGE_SIZE;
> -		addr +=3D PAGE_SIZE;
> -		size -=3D PAGE_SIZE;
> -	}
> -
> -	vma->vm_ops =3D &vm_ops;
> -	vma->vm_private_data =3D 0;
> -	dev->buffers[(vma->vm_pgoff<<PAGE_SHIFT)/dev->buffer_size].flags |=3D
> -		V4L2_BUF_FLAG_MAPPED;
> -
> -	vm_open(vma);
> -
> -	dprintk("leaving v4l_mmap()\n");
> -
> -	return 0;
> -}
> -
> -static unsigned int v4l2_loopback_poll(struct file *file,
> -				       struct poll_table_struct *pts)
> -{
> -	struct v4l2_loopback_opener *opener =3D file->private_data;
> -	int ret_mask =3D 0;
> -
> -	switch (opener->type) {
> -	case WRITER:
> -		ret_mask =3D POLLOUT | POLLWRNORM;
> -		break;
> -	case READER:
> -		poll_wait(file, &dev->read_event, pts);
> -		if (dev->write_position > opener->position)
> -			ret_mask =3D  POLLIN | POLLRDNORM;
> -		break;
> -	default:
> -		ret_mask =3D -POLLERR;
> -	}
> -	return ret_mask;
> -}
> -
> -/* do not want to limit device opens, it can be as many readers as user =
want,
> - * writers are limited by means of setting writer field */
> -static int v4l_loopback_open(struct file *file)
> -{
> -	struct v4l2_loopback_opener *opener;
> -
> -	dprintk("entering v4l_open()\n");
> -	if (dev->open_count.counter =3D=3D max_openers)
> -		return -EBUSY;
> -	/* kfree on close */
> -	opener =3D kzalloc(sizeof(*opener), GFP_KERNEL);
> -	if (opener =3D=3D NULL)
> -		return -ENOMEM;
> -	file->private_data =3D opener;
> -	atomic_inc(&dev->open_count);
> -	return 0;
> -}
> -
> -static int v4l_loopback_close(struct file *file)
> -{
> -	struct v4l2_loopback_opener *opener =3D file->private_data;
> -
> -	dprintk("entering v4l_close()\n");
> -	atomic_dec(&dev->open_count);
> -	/* TODO(vasaka) does the closed file means that mmaped buffers are
> -	 * no more valid and one can free data? */
> -	if (dev->open_count.counter =3D=3D 0) {
> -		vfree(dev->image);
> -		dev->image =3D NULL;
> -		dev->ready_for_capture =3D 0;
> -		dev->buffer_size =3D 0;
> -	}
> -	kfree(opener);
> -	return 0;
> -}
> -
> -static ssize_t v4l_loopback_read(struct file *file, char __user *buf,
> -				 size_t count, loff_t *ppos)
> -{
> -	int read_index;
> -	struct v4l2_loopback_opener *opener =3D file->private_data;
> -
> -	if ((dev->write_position <=3D opener->position) &&
> -		(file->f_flags&O_NONBLOCK)) {
> -		return -EAGAIN;
> -	}
> -	wait_event_interruptible(dev->read_event,
> -				 (dev->write_position > opener->position));
> -	if (count > dev->buffer_size)
> -		count =3D dev->buffer_size;
> -	if (dev->write_position > opener->position+2)
> -		opener->position =3D dev->write_position - 1;
> -	read_index =3D opener->position % dev->buffers_number;
> -	if (copy_to_user((void *) buf, (void *) (dev->image +
> -			 dev->buffers[read_index].m.offset), count)) {
> -		printk(KERN_INFO "v4l2-loopback: "
> -			"failed copy_from_user() in write buf\n");
> -		return -EFAULT;
> -	}
> -	++opener->position;
> -	dprintkrw("leave v4l2_loopback_read()\n");
> -	return count;
> -}
> -
> -static ssize_t v4l_loopback_write(struct file *file,
> -				  const char __user *buf, size_t count,
> -				  loff_t *ppos)
> -{
> -	int write_index =3D dev->write_position % dev->buffers_number;
> -	int ret;
> -
> -	if (dev->ready_for_capture =3D=3D 0) {
> -		ret =3D allocate_buffers();
> -		if (ret < 0)
> -			return ret;
> -		init_buffers(dev->buffer_size);
> -		dev->ready_for_capture =3D 1;
> -	}=09
> -	dprintkrw("v4l2_loopback_write() trying to write %d bytes\n", count);
> -	if (count > dev->buffer_size)
> -		count =3D dev->buffer_size;
> -	if (copy_from_user(
> -		   (void *) (dev->image + dev->buffers[write_index].m.offset),
> -		   (void *) buf, count)) {
> -		printk(KERN_INFO "v4l2-loopback: "
> -		   "failed copy_from_user() in write buf, could not write %d\n",
> -		   count);
> -		return -EFAULT;
> -	}
> -	do_gettimeofday(&dev->buffers[write_index].timestamp);
> -	dev->buffers[write_index].sequence =3D dev->write_position++;
> -	wake_up_all(&dev->read_event);
> -	dprintkrw("leave v4l2_loopback_write()\n");
> -	return count;
> -}
> -
> -/* init functions */
> -/* allocates buffers, if buffer_size is set */
> -static int allocate_buffers(void)
> -{
> -	/* vfree on close file operation in case no open handles left */
> -	if (dev->buffer_size =3D=3D 0)
> -		return -EINVAL;
> -	dev->image =3D vmalloc(dev->buffer_size * dev->buffers_number);
> -	if (dev->image =3D=3D NULL)
> -		return -ENOMEM;
> -	dprintk("vmallocated %ld bytes\n",
> -		dev->buffer_size * dev->buffers_number);
> -	return 0;
> -}
> -/* init inner buffers, they are capture mode and flags are set as
> - * for capture mod buffers */
> -static void init_buffers(int buffer_size)
> -{
> -	int i;
> -	for (i =3D 0; i < dev->buffers_number; ++i) {
> -		dev->buffers[i].bytesused =3D buffer_size;
> -		dev->buffers[i].length =3D buffer_size;
> -		dev->buffers[i].field =3D V4L2_FIELD_NONE;
> -		dev->buffers[i].flags =3D 0;
> -		dev->buffers[i].index =3D i;
> -		dev->buffers[i].input =3D 0;
> -		dev->buffers[i].m.offset =3D i * buffer_size;
> -		dev->buffers[i].memory =3D V4L2_MEMORY_MMAP;
> -		dev->buffers[i].sequence =3D 0;
> -		dev->buffers[i].timestamp.tv_sec =3D 0;
> -		dev->buffers[i].timestamp.tv_usec =3D 0;
> -		dev->buffers[i].type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	}
> -	dev->write_position =3D 0;
> -}
> -
> -/* fills and register video device */
> -static void init_vdev(struct video_device *vdev)
> -{
> -	strlcpy(vdev->name, "Loopback video device", sizeof(vdev->name));
> -	vdev->tvnorms =3D V4L2_STD_NTSC | V4L2_STD_SECAM | V4L2_STD_PAL;/* TODO=
 */
> -	vdev->current_norm =3D V4L2_STD_PAL_B, /* do not know what is best here=
 */
> -	vdev->vfl_type =3D VFL_TYPE_GRABBER;
> -	vdev->fops =3D &v4l2_loopback_fops;
> -	vdev->ioctl_ops =3D &v4l2_loopback_ioctl_ops;
> -	vdev->release =3D &video_device_release;
> -	vdev->minor =3D -1;
> -#ifdef DEBUG
> -	vdev->debug =3D V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
> -#endif
> -}
> -
> -/* init default capture paramete, only fps may be changed in future */

typo here: 'paramete' -> 'parameters'?

> -static void init_capture_param(struct v4l2_captureparm *capture_param)
> -{
> -	capture_param->capability =3D 0;
> -	capture_param->capturemode =3D 0;
> -	capture_param->extendedmode =3D 0;
> -	capture_param->readbuffers =3D max_buffers_number;
> -	capture_param->timeperframe.numerator =3D 1;
> -	capture_param->timeperframe.denominator =3D 30;
> -}
> -
> -/* init loopback main structure */
> -static int v4l2_loopback_init(struct v4l2_loopback_device *dev)
> -{
> -	dev->vdev =3D video_device_alloc();
> -	if (dev->vdev =3D=3D NULL)
> -		return -ENOMEM;
> -	init_vdev(dev->vdev);
> -	init_capture_param(&dev->capture_param);
> -	dev->buffers_number =3D max_buffers_number;
> -	atomic_set(&dev->open_count, 0);
> -	dev->ready_for_capture =3D 0;
> -	dev->buffer_size =3D 0;
> -	dev->image =3D NULL;
> -	/* kfree on module release */
> -	dev->buffers =3D
> -	    kzalloc(sizeof(*dev->buffers) * dev->buffers_number,
> -		    GFP_KERNEL);
> -	if (dev->buffers =3D=3D NULL)
> -		return -ENOMEM;
> -	init_waitqueue_head(&dev->read_event);
> -	return 0;
> -};
> -
> -/* LINUX KERNEL */
> -static const struct v4l2_file_operations v4l2_loopback_fops =3D {
> -      .owner =3D THIS_MODULE,
> -      .open =3D v4l_loopback_open,
> -      .release =3D v4l_loopback_close,
> -      .read =3D v4l_loopback_read,
> -      .write =3D v4l_loopback_write,
> -      .poll =3D v4l2_loopback_poll,
> -      .mmap =3D v4l2_loopback_mmap,
> -      .ioctl =3D video_ioctl2,
> -};
> -

align the equals signs using spaces here and below.

> -static const struct v4l2_ioctl_ops v4l2_loopback_ioctl_ops =3D {
> -	.vidioc_querycap =3D &vidioc_querycap,
> -	.vidioc_enum_fmt_vid_cap =3D &vidioc_enum_fmt_cap,
> -	.vidioc_enum_input =3D &vidioc_enum_input,
> -	.vidioc_g_input =3D &vidioc_g_input,
> -	.vidioc_s_input =3D &vidioc_s_input,
> -	.vidioc_g_fmt_vid_cap =3D &vidioc_g_fmt_cap,
> -	.vidioc_s_fmt_vid_cap =3D &vidioc_s_fmt_cap,
> -	.vidioc_s_fmt_vid_out =3D &vidioc_s_fmt_video_output,
> -	.vidioc_try_fmt_vid_cap =3D &vidioc_try_fmt_cap,
> -	.vidioc_try_fmt_vid_out =3D &vidioc_try_fmt_video_output,
> -	.vidioc_s_std =3D &vidioc_s_std,
> -	.vidioc_g_parm =3D &vidioc_g_parm,
> -	.vidioc_s_parm =3D &vidioc_s_parm,
> -	.vidioc_reqbufs =3D &vidioc_reqbufs,
> -	.vidioc_querybuf =3D &vidioc_querybuf,
> -	.vidioc_qbuf =3D &vidioc_qbuf,
> -	.vidioc_dqbuf =3D &vidioc_dqbuf,
> -	.vidioc_streamon =3D &vidioc_streamon,
> -	.vidioc_streamoff =3D &vidioc_streamoff,
> -#ifdef CONFIG_VIDEO_V4L1_COMPAT
> -	.vidiocgmbuf =3D &vidiocgmbuf,
> -#endif
> -};
> -
> -int __init init_module()
> -{
> -	int ret;
> -=09
> -	dprintk("entering init_module()\n");
> -	/* kfree on module release */
> -	dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
> -	if (dev =3D=3D NULL)
> -		return -ENOMEM;
> -	ret =3D v4l2_loopback_init(dev);
> -	if (ret < 0)
> -		return ret;
> -	/* register the device -> it creates /dev/video* */
> -	if (video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1) < 0) {
> -		video_device_release(dev->vdev);
> -		printk(KERN_INFO "failed video_register_device()\n");
> -		return -EFAULT;
> -	}
> -	printk(KERN_INFO "v4l2-loopback module installed\n");
> -	return 0;
> -}
> -
> -void __exit cleanup_module()
> -{
> -	dprintk("entering cleanup_module()\n");
> -	/* unregister the device -> it deletes /dev/video* */
> -	video_unregister_device(dev->vdev);
> -	kfree(dev->buffers);
> -	kfree(dev);
> -	printk(KERN_INFO "v4l2-loopback module removed\n");
> -}
> \ =D0=92 =D0=BA=D0=BE=D0=BD=D1=86=D0=B5 =D1=84=D0=B0=D0=B9=D0=BB=D0=B0 =
=D0=BD=D0=B5=D1=82 =D0=BD=D0=BE=D0=B2=D0=BE=D0=B9 =D1=81=D1=82=D1=80=D0=BE=
=D0=BA=D0=B8

Does this mean that there is a missing newline character at the of the
file? :)

> diff -uprN v4l-dvb.my.p/linux/drivers/media/video/v4l2loopback.h v4l-dvb.=
orig/linux/drivers/media/video/v4l2loopback.h
> --- v4l-dvb.my.p/linux/drivers/media/video/v4l2loopback.h	2009-04-27 02:1=
0:54.000000000 +0300
> +++ v4l-dvb.orig/linux/drivers/media/video/v4l2loopback.h	1970-01-01 03:0=
0:00.000000000 +0300
> @@ -1,56 +0,0 @@
> -/*
> - *      v4l2loopback.h  --  video 4 linux loopback driver
> - *
> - *      Copyright (C) 2005-2009
> - *          Vasily Levin (vasaka@gmail.com)
> - *
> - *      This program is free software; you can redistribute it and/or mo=
dify
> - *      it under the terms of the GNU General Public License as publishe=
d by
> - *      the Free Software Foundation; either version 2 of the License, or
> - *      (at your option) any later version.
> - *
> - */
> -

If there is no other user of v4l2oopback.h maybe you can merge this file
into v4l2loopback.c

> -#ifndef _V4L2LOOPBACK_H
> -#define	_V4L2LOOPBACK_H
> -
> -#include <linux/videodev2.h>
> -#include <media/v4l2-common.h>
> -
> -/* TODO(vasaka) use typenames which are common to kernel, but first find=
 out if
> - * it is needed */
> -/* struct keeping state and settings of loopback device */
> -struct v4l2_loopback_device {
> -	struct video_device *vdev;
> -	/* pixel and stream format */
> -	struct v4l2_pix_format pix_format;
> -	struct v4l2_captureparm capture_param;
> -	/* buffers stuff */
> -	u8 *image;         /* pointer to actual buffers data */
> -	int buffers_number;  /* should not be big, 4 is a good choice */
> -	struct v4l2_buffer *buffers;	/* inner driver buffers */
> -	int write_position; /* number of last written frame + 1 */
> -	long buffer_size;
> -	/* sync stuff */
> -	atomic_t open_count;
> -	int ready_for_capture;/* set to true when at least one writer opened
> -			      * device and negotiated format */
> -	wait_queue_head_t read_event;
> -};
> -
> -/* types of opener shows what opener wants to do with loopback */
> -enum opener_type {
> -	UNNEGOTIATED =3D 0,
> -	READER =3D 1,
> -	WRITER =3D 2,
> -};
> -
> -/* struct keeping state and type of opener */
> -struct v4l2_loopback_opener {
> -	enum opener_type type;
> -	int buffers_number;
> -	int position; /* number of last processed frame + 1 or
> -		       * write_position - 1 if reader went out of sync */
> -	struct v4l2_buffer *buffers;
> -};
> -#endif				/* _V4L2LOOPBACK_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Mon__27_Apr_2009_11_35_14_+0200_=g+fDADKNEULrW5n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn1fFIACgkQ5xr2akVTsAEQlwCdGyaVyaVppv8mNMwAt/b/9A/y
Ut4AnjMEYOO1tr+4TB28bYGaZU2KvPDh
=57Tp
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Apr_2009_11_35_14_+0200_=g+fDADKNEULrW5n--
