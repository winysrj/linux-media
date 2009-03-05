Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1980 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZCEVXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 16:23:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
Date: Thu, 5 Mar 2009 22:24:02 +0100
Cc: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE89442E296E09@dlee02.ent.ti.com> <200903042344.32820.hverkuil@xs4all.nl> <49B031D6.1070203@maxwell.research.nokia.com>
In-Reply-To: <49B031D6.1070203@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903052224.03015.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 March 2009 21:11:02 Sakari Ailus wrote:
> Hans Verkuil wrote:
> >> Situation 1
> >>  - Instance1: Select sensor 1, and Do queue/dequeue of buffers.
> >>  - Instance2: If sensor 1 is currently selected, Begin loop requesting
> >> internally collected OMAP3ISP statistics (with V4L2 private based
> >> IOCTLs) for performing user-side Auto-exposure, Auto White Balance,
> >> Auto Focus algorithms. And Adjust gains (with S_CTRL) accordingly on
> >> sensor as a result.
> >
> > Question: if you have multiple sensors, and sensor 1 is selected, can
> > you still get statistics from sensor 2? Or is all this still limited to
> > the selected sensor? Just want to make sure I understand it all.
>
> The ISP does have submodules and there are some ways of configuring the
> data path inside the ISP, but in general just one sensor can be used at
> a time in meaningful way.
>
> Sergio, please correct me if I'm wrong: the only case I know that you
> can do is to use the ISP normally (data flowing through pretty much all
> the ISP modules) with one sensor and write the output of another sensor
> directly to memory in one of the parallel/CCP2/CSI2 receivers.
>
> I guess there's no use case for this, however. So just one user at a
> time for the OMAP 3 ISP.
>
>
>
> Another thing comes to my mind, though.
>
> Sergio has posted earlier a patchset containing a driver for using the
> ISP to process images from memory to memory. The ISP driver is used
> roughly the same way as with the omap34xxcam and real sensors. The
> interface towards the userspace offered by the driver, however, is
> different, you probably saw it (preview and resizer wrappers).
>
> My opinion has been that the memory-to-memory operation of the ISP
> should also offer V4L2 interface. V4L2, however, doesn't support such
> devices at the moment. The only differences that I can see is that
>
> 1. the input is a video buffer instead of sensor and
>
> 2. the source format needs to be specified somehow since the ISP can
> also do format conversion. So it's output and input at the same time.
>
> But if we had one video device per ISP, then memory-to-memory operation
> would be just one... input or output or what? :)
>
> Earlier we were thinking of creating one device node for it.

This sounds like a codec interface as 'described' here:

http://www.xs4all.nl/~hverkuil/spec/v4l2.html#CODEC

It would be a first for V4L2 to have a driver that can do this, but I agree 
that that would be a single device that has both 'output' and 'capture'.

> > That is probably what the driver should do, yes. The V4L2 spec leaves
> > it up to the driver whether you can switch inputs while a capture is in
> > progress. In this case I think it is perfectly reasonably for the
> > driver to return -EBUSY.
>
> Ok.
>
> >> I'm not clear if this single-node idea is really helping the user to
> >> have a simpler usage in Situation 1, which I feel will become pretty
> >> common on this driver...
> >
> > The spec is pretty clear about this, and existing v4l2 applications
> > also expect this behavior. Also, suppose you have two video nodes, what
> > happens when you want to use the inactive node? How can you tell it is
> > inactive?
>
> open() succeeds.
>
> Currently you can have just one device node using the ISP open.
> omap34xxcam_open() calls isp_get() which fails if the ISP use count was
> non-zero (means one).
>
> Or did I misunderstood something?

Oh dear. Please don't use 'use counts'. It is perfectly acceptable and 
desirable to have multiple opens on the same video node. Only one file 
handle can do reading/writing/streaming, but others should be able to 
querying controls, set brightness, or whatever at the same time.

Use counts are really bad and totally unnecessary. Only if another file 
handle is in streaming mode (and when using VIDIOC_S_PRIORITY) does it make 
sense to return -EBUSY for certain ioctls or read/write operations. 
Otherwise you shouldn't limit the user from opening the same device node as 
many times as he wants and use that to query the video device.

There are unfortunately a whole bunch of existing v4l2 drivers that have 
this same limitation. These drivers are wrong. It is sadly not very easy to 
fix them, but I can try to prevent the same bug from appearing in new 
drivers.

BTW, I looked at omap24xxcam_open(): data like fh->pix does *not* belong to 
the filehandle struct, it should be part of the top-level data structure. 
You want to be able to do simple things like querying a video node for the 
currently selected format. You can't do that if the format is stored in the 
filehandle! E.g.: you are streaming and you want to run 
v4l2-ctl --get-fmt-video to check what video format is being used. Things 
like this must be supported by a well-written v4l2 driver. Again, sadly 
quite a few v4l2 drivers do this wrong as well :-(

I also see that cam->users is not decreased by one if 
omap24xxcam_sensor_enable() fails.

Note that I'm looking at the code in the v4l-dvb repository, the linux-omap 
git tree might have fixed that already.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
