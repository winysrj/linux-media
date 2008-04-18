Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3IJn0ov030369
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 15:49:00 -0400
Received: from mylar.outflux.net (mylar.outflux.net [69.93.193.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3IJmX47017686
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 15:48:34 -0400
Date: Fri, 18 Apr 2008 12:48:22 -0700
From: Kees Cook <kees@outflux.net>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080418194822.GN18865@outflux.net>
References: <20080417012354.GH18929@outflux.net>
	<200804182133.21863.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804182133.21863.laurent.pinchart@skynet.be>
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

Hi Laurent,

On Fri, Apr 18, 2008 at 09:33:21PM +0200, Laurent Pinchart wrote:
> On Thursday 17 April 2008, Kees Cook wrote:
> > +static const char *v4l2_function_type_names[] = {
> > +	[V4L2_FN_VIDEO_CAP]		= "vid-cap",
> > +	[V4L2_FN_VIDEO_OUT]		= "vid-out",
> > +	[V4L2_FN_MPEG_CAP]		= "mpeg-cap",
> > +	[V4L2_FN_MPEG_OUT]		= "mpeg-out",
> > +	[V4L2_FN_YUV_CAP]		= "yuv-cap",
> > +	[V4L2_FN_YUV_OUT]		= "yuv-out",
> 
> I don't like those. Video capture devices can encode pixels in a variety of 
> formats. MPEG and YUV are only two special cases. You will find devices 
> encoding in RGB, Bayer, MJPEG, ... as well as some proprietary formats.

If these devices have a variable encoding method, perhaps just use
"vid-cap" as the general rule.  (In the case that the output formats are
selectable from a given device node at runtime.)

> If I understand your problem correctly, you want to differentiate between 
> multiple v4l devices created by a single driver for a single hardware device. 
> Using the above functions might work for ivtv but rules out devices that 
> output multiple streams in the same format.
> 
> Wouldn't it be better to fix the ivtv driver to use a single device node for 
> both compressed and uncompressed streams ?

I'm not very familiar with the v4l code base, so I don't have a good
answer about if it's right or not.  The core problem does tend to boil
down to dealing with drivers that create multiple device nodes for the
same physical hardware (ivtv is not alone in this regard).

I don't know what the semantics are for device mode vs device node in
v4l, but it seems that since there are multiple nodes being created for
a given piece of hardware, something needs to be exported to sysfs to
distinguish them.

-Kees

-- 
Kees Cook                                            @outflux.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
