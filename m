Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:52076 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZEWSZZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 14:25:25 -0400
Date: Sat, 23 May 2009 11:25:27 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"xlzhang76@gmail.com" <xlzhang76@gmail.com>
Subject: Re: [PATCH 1/5 - part 2] V4L2 patches for Intel Moorestown Camera
 Imaging Drivers
In-Reply-To: <20090523060342.46eb89aa@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0905231059460.32713@shell2.speakeasy.net>
References: <0A882F4D99BBF6449D58E61AAFD7EDD613810F55@pdsmsx502.ccr.corp.intel.com>
 <20090523060342.46eb89aa@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 23 May 2009, Mauro Carvalho Chehab wrote:
> > + + if (intel->open) { + ++intel->open; + DBG_DD(("device has opened
> > already - %d\n", intel->open)); + return 0; + } + + file->private_data
> > = dev; + /* increment our usage count for the driver */ +
> > ++intel->open; + DBG_DD(("intel_open is %d\n", intel->open)); +
>
> Open is not the proper place to clean the configuration, since a V4L2
> device should support more than one open.  You can use a different
> userspace app to control your device, while other application is
> streaming it.

It looks like only the first open will set the configuration, subsequent
ones don't do anything.  So maybe this driver is ok for multiple opens?
Doesn't the kernel make open and close atomic, so some kind of barrier or
atomic variable isn't necessary?

> > +static int intel_g_fmt_cap(struct file *file, void *priv,
> > +                               struct v4l2_format *f)
> > +{
> > +       struct video_device *dev = video_devdata(file);
> > +       struct intel_isp_device *intel = video_get_drvdata(dev);
> > +       int ret;
> > +
> > +       DBG_DD(("intel_g_fmt_cap\n"));
> > +       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {

Once switched to video-ioctl2, it don't be necessary to check the type of
buffer.  vidioc_g_fmt_cap will only be called with video capture buffers.
It's the same with all the other vidioc_*_cap methods.

> > +static int intel_s_input(struct file *file, void *priv, unsigned int i)
> > +{
> > +       return 0;
> > +}

Wouldn't it be better to return an error if the input is something other
than zero?

> > +       snrcfg = intel->sys_conf.isi_config;
> > +       index = f->index;
> > +
> > +       if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +               ret = -EINVAL;
> > +       else {
> > +               if (snrcfg->type == SENSOR_TYPE_SOC)
> > +                       if (index >= 8)
> > +                               return -EINVAL;
> > +               if (index >= sizeof(fmts) / sizeof(*fmts))
> > +                       return -EINVAL;
> > +               memset(f, 0, sizeof(*f));
> > +               f->index = index;

Saving index, clearing f, and restoring index isn't necessary.
video-ioctl2 will take care of clearing everything that needs to be
cleared.

> > +               f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

Not necessary either, you already know type is set correctly.

> > +       if (buf->memory != V4L2_MEMORY_MMAP ||
> > +           buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> > +           buf->index >= intel->num_frames || buf->index < 0)
> > +               return  -EINVAL;

You don't need to check buf->type, it will be a type your driver supports.
buf->index is unsigned, obviously it can't be less than zero.  The same
applies to all the other buffer functions.  Looks like you copied from old
code.  Some drivers had these unnecessary checks but they should have all
been cleaned up by now.

> > +       pci_read_config_word(dev, PCI_VENDOR_ID, &intel->vendorID);
> > +       pci_read_config_word(dev, PCI_DEVICE_ID, &intel->deviceID);

Do you ever use these after saving them?
