Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab2L2OYA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 09:24:00 -0500
Date: Sat, 29 Dec 2012 12:23:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ABI breakage due to "Unsupported formats in TRY_FMT/S_FMT"
 recommendation
Message-ID: <20121229122334.00ea0b8a@redhat.com>
In-Reply-To: <201212291253.45189.hverkuil@xs4all.nl>
References: <CAGoCfiwzFFZ+hLOKT-5cHTJOiY8ZsRVXmDx+W7x+7uMXMKWk5g@mail.gmail.com>
	<20121228222744.6b567a9b@redhat.com>
	<201212291253.45189.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 29 Dec 2012 12:53:45 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Sat December 29 2012 01:27:44 Mauro Carvalho Chehab wrote:
> > Em Fri, 28 Dec 2012 14:52:24 -0500
> > Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
> > 
> > > Hi there,
> > > 
> > > So I noticed that one of the "V4L2 ambiguities" discussed at the Media
> > > Workshop relates to expected behavior with TRY_FMT/S_FMT.
...
> > Well, if applications will break with this change, then we need to revisit
> > the question, and decide otherwise, as it shouldn't break userspace.
> > 
> > It should be noticed, however, that currently, some drivers won't
> > return errors when S_FMT/TRY_FMT requests invalid parameters.
> > 
> > So, IMHO, what should be done is:
> > 	1) to not break userspace;
> > 	2) userspace apps should be improved to handle those drivers
> > that have a potential of breaking them;
> > 	3) clearly state at the API, and enforce via compliance tool,
> > that all drivers will behave the same.
> 
> In my opinion these are application bugs, and not ABI breakages. As Mauro
> mentioned, some drivers don't return an error and so would always have failed
> with these apps (examples: cx18/ivtv, gspca).

It is both an application bug and a potential ABI breakage.

Hmm... as MythTv and tvtime are meant to be used to watch TV, maybe we can
look on it using a different angle.

tvtime tries first V4L2_PIX_FMT_YUYV. If it fails, it tries V4L2_PIX_FMT_UYVY.

The drivers that support YUYV directly are:

$ git grep -l V4L2_PIX_FMT_YUYV drivers/media/usb drivers/media/pci
drivers/media/pci/bt8xx/bttv-driver.c
drivers/media/pci/cx23885/cx23885-video.c
drivers/media/pci/cx25821/cx25821-video.c
drivers/media/pci/cx88/cx88-video.c
drivers/media/pci/meye/meye.c
drivers/media/pci/saa7134/saa7134-video.c
drivers/media/pci/zoran/zoran_driver.c
drivers/media/usb/cx231xx/cx231xx-video.c
drivers/media/usb/em28xx/em28xx-video.c
drivers/media/usb/gspca/ov534.c
drivers/media/usb/gspca/vc032x.c
drivers/media/usb/s2255/s2255drv.c
drivers/media/usb/stkwebcam/stk-sensor.c
drivers/media/usb/stkwebcam/stk-webcam.c
drivers/media/usb/tlg2300/pd-video.c
drivers/media/usb/tm6000/tm6000-video.c
drivers/media/usb/usbvision/usbvision-core.c
drivers/media/usb/usbvision/usbvision-video.c
drivers/media/usb/uvc/uvc_driver.c

$ git grep -l V4L2_PIX_FMT_UYVY drivers/media/usb drivers/media/pci
drivers/media/pci/bt8xx/bttv-driver.c
drivers/media/pci/cx18/cx18-ioctl.c
drivers/media/pci/cx18/cx18-streams.c
drivers/media/pci/cx23885/cx23885-video.c
drivers/media/pci/cx25821/cx25821-video.c
drivers/media/pci/cx88/cx88-video.c
drivers/media/pci/saa7134/saa7134-video.c
drivers/media/pci/sta2x11/sta2x11_vip.c
drivers/media/pci/zoran/zoran_driver.c
drivers/media/usb/au0828/au0828-video.c
drivers/media/usb/gspca/kinect.c
drivers/media/usb/gspca/w996Xcf.c
drivers/media/usb/s2255/s2255drv.c
drivers/media/usb/stk1160/stk1160-v4l.c
drivers/media/usb/stkwebcam/stk-sensor.c
drivers/media/usb/stkwebcam/stk-webcam.c
drivers/media/usb/tm6000/tm6000-core.c
drivers/media/usb/tm6000/tm6000-video.c
drivers/media/usb/uvc/uvc_driver.c

The drivers that only support V4L2_PIX_FMT_UYVY seems to be
cx18, sta2x11_vip, au0828 and gspca (kinect, w996xcf). From those,
only cx18 and au0828 are TV drivers.

On a tvtime compiled without libv4l, the cx18 driver will fail with the
current logic, as it doesn't return an error when format doesn't
match. So, tvtime will fail anyway with 50% of the TV drivers that don't
support YUYV directly. It will also fail with most cameras, as they're
generally based on proprietary/bayer formats and/or may not have the
resolutions that tvtime requires.

That's said, libv4l does format conversion. So, if the logic on libv4l
is working properly, and as tvtime does upport libv4l upstream,
no real bug should be seen with tvtime, even if the device doesn't
support neither UYVY or YUYV.

The above also applies to MythTV, except that I'm not sure if MythTV uses
libv4l.

> Do these apps even handle the case where TRY isn't implemented at all by the
> driver? (hdpvr)

I think most apps don't try.

> There is nothing in the spec that says that you will get an error if the
> pixelformat isn't supported by the driver, in fact it says the opposite:
> 
> "Very simple, inflexible devices may even ignore all input and always return
> the default parameters."
> 
> We are not in the business to work around application bugs, IMHO. We can of
> course delay making these changes until those applications are fixed.

Delay such changes make sense for me.

> I suspect that the behavior of returning an error if a pixelformat is not
> supported is a leftover from the V4L1 API (VIDIOCSPICT). When drivers were
> converted to S/TRY_FMT this method of handling unsupported pixelformats was
> probably never changed. And quite a few newer drivers copy-and-pasted that
> method.

Yes, I suspect so. Yet, we should not break userspace.

> Drivers like cx18/ivtv that didn't copy-and-paste code looked at the
> API and followed what the API said.
> 
> At the moment most TV drivers seem to return an error, whereas for webcams
> it is hit and miss: uvc returned an error (until it was fixed recently),
> gspca didn't. So webcam applications probably do the right thing given the
> behavior of gspca.

Any serious application that wants to work with webcams need libv4l. Without
that, lots of webcams won't work anyway, due to the lack of format support
and/or conversion.

> 
> What does xawtv do, BTW?

v4l2_setformat(void *handle, struct ng_video_fmt *fmt)
{
...

    h->fmt_v4l2.fmt.pix.pixelformat  = xawtv_pixelformat[fmt->fmtid];
...
    if (-1 == xioctl(h->fd, VIDIOC_S_FMT, &h->fmt_v4l2, 1))
	return -1;
    if (h->fmt_v4l2.fmt.pix.pixelformat != xawtv_pixelformat[fmt->fmtid])
	return -1;
...

Basically, there's a loop at the code that starts capturing that will try
all supported formats there, calling setformat. If the returned format is
different, it tries the next one:

    for (i = 0;;) {
	conv = ng_conv_find_to(fmt->fmtid, &i);
	if (NULL == conv)
	    break;
	gfmt = *fmt;
	gfmt.fmtid = conv->fmtid_in;
	if (0 == ng_grabber_setformat(&gfmt,fix_ratio))
	    goto found;
    }

(ng_grabber_setformat calls internally v4l2_setformat)

So, xawtv3 won't be affected, even with libv4l disabled.

I didn't check xawtv4 code, but I would expect a similar behavior there.

-- 

Cheers,
Mauro
