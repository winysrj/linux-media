Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:52020 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863Ab0ISVCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 17:02:45 -0400
Subject: Re: RFC: BKL, locking and ioctls
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <4C967082.3040405@redhat.com>
References: <201009191229.35800.hverkuil@xs4all.nl>
	 <201009191658.11346.hverkuil@xs4all.nl> <4C9656A6.80303@redhat.com>
	 <201009192106.47601.hverkuil@xs4all.nl>  <4C967082.3040405@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 17:02:31 -0400
Message-ID: <1284930151.2079.156.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2010-09-19 at 17:20 -0300, Mauro Carvalho Chehab wrote:
> Em 19-09-2010 16:06, Hans Verkuil escreveu:
> > On Sunday, September 19, 2010 20:29:58 Mauro Carvalho Chehab wrote:
> >> Em 19-09-2010 11:58, Hans Verkuil escreveu:
> >>> On Sunday, September 19, 2010 13:43:43 Mauro Carvalho Chehab wrote:
> >>
> >>>> A per-dev lock may not be good on devices where you have lots of interfaces, and that allows
> >>>> more than one stream per interface.
> >>>
> >>> My proposal is actually a lock per device node, not per device (although that's
> >>> what many simple drivers probably will use).
> >>
> >> Yes, that's what I meant. However, V4L2 API allows multiple opens and multiple streams per
> >> device node (and this is actually in use by several drivers).
> > 
> > Just to be clear: multiple opens is a V4L2 requirement. Some older drivers had exclusive
> > access, but those are gradually fixed.
> > 
> > Multiple stream per device node: if you are talking about allowing e.g. both VBI streaming
> > and video streaming from one device node, then that is indeed allowed by the current spec.
> > Few drivers support this though, and it is a really bad idea. During the Helsinki meeting we
> > agreed to remove this from the spec (point 10a in the mini summit report).
> 
> I'm talking about read(), overlay and mmap(). The spec says, at "Multiple Opens" [1]:
> 	"When a device supports multiple functions like capturing and overlay simultaneously,
> 	 multiple opens allow concurrent use of the device by forked processes or specialized applications."
> 
> [1] http://linuxtv.org/downloads/v4l-dvb-apis/ch01.html#id2717880
> 
> So, it is allowed by the spec. What is forbidden is to have some copy logic in kernel to duplicate data.
> 
> > 
> >>>> So, I did a different implementation, implementing the mutex pointer per file handler.
> >>>> On devices that a simple lock is possible, all you need to do is to use the same locking
> >>>> for all file handles, but if drivers want a finer control, they can use a per-file handler
> >>>> lock.
> >>>
> >>> I am rather unhappy about this. First of all, per-filehandle locks are pretty pointless. If
> >>> you need to serialize for a single filehandle (which would only be needed for multithreaded
> >>> applications where the threads use the same filehandle), then you definitely need to serialize
> >>> between multiple file handles that are open on the same device node.
> >>
> >> On multithread apps, they'll share the same file handle, so, there's no issue. Some applications
> >> like xawtv and xdtv allows recording a video by starting another proccess that will use the read() 
> >> interface for one stream, while the other stream is using mmap() (or overlay) will have two different
> >> file handlers, one for each app. That's said, a driver using per-fh locks will likely need to
> >> have an additional lock for global resources. I didn't start porting cx88 driver, but I suspect
> >> that it will need to use it.
> > 
> > That read/mmap construct was discussed as well in Helsinki (also point 10a). I quote from the report:
> > 
> > "Mixed read() and mmap() streaming. Allow or disallow? bttv allows it, which is against the spec since
> > it only has one buffer queue so a read() will steal a frame. No conclusion was reached. Everyone thought
> > it was very ugly but some apps apparently use this. Even though few drivers actually support this functionality."
> > 
> > Applications must be able to work without this 'feature' since so few drivers allow this. And it
> > is against the spec as well. Perhaps we should try to remove this 'feature' and see if the apps
> > still work. If they do, then kill it. It's truly horrible. And it is definitely not a reason to
> > choose a overly complex locking scheme just so that some old apps can do a read and dqbuf at the
> > same time.
> 
> xawtv will stop working in record mode. It is one of the applications we added on our list that
> we should use as reference.
> 
> I'm not against patching it to implement a different logic for record. Patches are welcome.
> 
> Considering that, currently, very few applications allow recording (I think only xawtv/xdtv, both using
> ffmpeg or mencoder for record) and mythtv are the only ones, I don't think we should remove it, without
> having it implemented on more places.

For non-MPEG v4l2 devices
mythtv-0.21/libs/libmythtv/NuppelVideoRecorder.cpp::DoV4L2() looks like
it only uses VIDIOC_QBUF and VIDIOC_DQBUF for video frames - no read()s.
It appears to use read() for VBI data on a different file descriptor.
(em28xx VBI appears to be implemented via videobuf in the em28xx
driver.)

For the MPEG class of devices (ivtv/cx18),
mythtv-0.21/libs/libmythtv/mpegrecoder.cpp only uses read().



> Besides that, not all device drivers will work with all applications or provide the complete set of
> functionalities. For example, there are only three drivers (ivtv, cx18 and pvrusb2), as far as I remember, 
> that only implements read() method. By using your logic that "only a few drivers allow feature X", maybe
> we should deprecate read() as well ;)

Hans,

On an somewhat related note, but off-topic: what is the proper way to
implement VIDIOC_QUERYCAP for a driver that implements read()
on /dev/video0 (MPEG) and mmap() streaming on /dev/video32 (YUV)?

I'm assuming the right way is for VIDIOC_QUERYCAP to return different
caps based on which device node was queried.

Regards,
Andy



