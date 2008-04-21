Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3LL3Kgv003805
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 17:03:20 -0400
Received: from mailrelay007.isp.belgacom.be (mailrelay007.isp.belgacom.be
	[195.238.6.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3LL39Xh011013
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 17:03:10 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Kees Cook <kees@outflux.net>
Date: Mon, 21 Apr 2008 23:10:46 +0200
References: <20080417012354.GH18929@outflux.net>
	<200804182133.21863.laurent.pinchart@skynet.be>
	<20080418194822.GN18865@outflux.net>
In-Reply-To: <20080418194822.GN18865@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804212310.47130.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] V4L: add "function" sysfs attribute to v4l devices
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

On Friday 18 April 2008, Kees Cook wrote:
> Hi Laurent,
>
> On Fri, Apr 18, 2008 at 09:33:21PM +0200, Laurent Pinchart wrote:
> > On Thursday 17 April 2008, Kees Cook wrote:
> > > +static const char *v4l2_function_type_names[] = {
> > > +	[V4L2_FN_VIDEO_CAP]		= "vid-cap",
> > > +	[V4L2_FN_VIDEO_OUT]		= "vid-out",
> > > +	[V4L2_FN_MPEG_CAP]		= "mpeg-cap",
> > > +	[V4L2_FN_MPEG_OUT]		= "mpeg-out",
> > > +	[V4L2_FN_YUV_CAP]		= "yuv-cap",
> > > +	[V4L2_FN_YUV_OUT]		= "yuv-out",
> >
> > I don't like those. Video capture devices can encode pixels in a variety
> > of formats. MPEG and YUV are only two special cases. You will find
> > devices encoding in RGB, Bayer, MJPEG, ... as well as some proprietary
> > formats.
>
> If these devices have a variable encoding method, perhaps just use
> "vid-cap" as the general rule.  (In the case that the output formats are
> selectable from a given device node at runtime.)

That would indeed be better. The function name should be derived from the v4l 
type if possible.

> > If I understand your problem correctly, you want to differentiate between
> > multiple v4l devices created by a single driver for a single hardware
> > device. Using the above functions might work for ivtv but rules out
> > devices that output multiple streams in the same format.
> >
> > Wouldn't it be better to fix the ivtv driver to use a single device node
> > for both compressed and uncompressed streams ?
>
> I'm not very familiar with the v4l code base, so I don't have a good
> answer about if it's right or not.  The core problem does tend to boil
> down to dealing with drivers that create multiple device nodes for the
> same physical hardware (ivtv is not alone in this regard).
>
> I don't know what the semantics are for device mode vs device node in
> v4l, but it seems that since there are multiple nodes being created for
> a given piece of hardware, something needs to be exported to sysfs to
> distinguish them.

Good point. 

v4l drivers create several device nodes for good or not-so-good reasons. I 
think we can classify the hardware/drivers in several categories:

1. The device supports multiple concurrent data streams for different kind of 
data. The is most often found for audio/video or video/vbi. Audio is handled 
through alsa, and video and vbi are handled through v4l. The driver then 
creates a device node for each video/vbi data stream. The devices can easily 
be distinguished by their v4l type.

2. The device supports a single data stream with a selectable data format. The 
driver will create a single device node, format selection is handled through 
the v4l API.

3. The device supports multiple concurrent data streams for a single kind of 
data. ivtv falls under this case. The most common use case is a device with 
several video pipes (usually 2) that can be used simultaneously to stream the 
same data (in different or identical formats, either fixed or configurable).

Case 3 is the only one to cause device node naming issues. I'm not sure if the 
driver does the right thing when it creates several device nodes. Should the 
peripheral be seen as a single device that allows access by two users 
simultaneously, or should it be seen as two fixed-format devices ? Each 
solution will probably come with its own set of issues.

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
