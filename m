Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9HGLcX8003159
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 12:21:38 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9HGLMd3006863
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 12:21:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dean Anderson <dean@sensoray.com>
Date: Fri, 17 Oct 2008 18:21:17 +0200
References: <1224256911.6327.11.camel@pete-desktop>
	<200810171736.53826.hverkuil@xs4all.nl>
	<48F8B84D.7000204@sensoray.com>
In-Reply-To: <48F8B84D.7000204@sensoray.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810171821.17275.hverkuil@xs4all.nl>
Cc: Greg KH <greg@kroah.com>, video4linux-list@redhat.com
Subject: Re: go7007 development
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

On Friday 17 October 2008 18:07:41 Dean Anderson wrote:
> Hans Verkuil wrote:
> > Hi Pete,
> >
> > On Friday 17 October 2008 17:21:51 Pete wrote:
> >> Hello,
> >>
> >> I am working on adding the Sensoray 2250 to the go7007 staging
> >> tree, starting from GregKH's staging patch here:
> >> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> >> gregkh-05-staging-2.6.27.patch
> >>
> >> In particular, we are stuck how to change the MPEG format with
> >> standard IOCTL calls.  In particular, this comment in the driver
> >> go7007.h below needs explanation:
> >>
> >> /* DEPRECATED -- use V4L2_PIX_FMT_MPEG and then call
> >> GO7007IOC_S_MPEG_PARAMS * to select between MPEG1, MPEG2, and
> >> MPEG4 */
> >> #define V4L2_PIX_FMT_MPEG4     v4l2_fourcc('M','P','G','4') /*
> >> MPEG4 */
> >>
> >> The existing driver, for backward-compatibility , allowed
> >> V4L2_PIX_FMT_MPEG4 to be used for v4l2_format.pixelformat with
> >> VIDIOC_S_FMT.
> >>
> >> GO7007IOC_S_MPEG_PARAMS is a custom ioctl call and we would rather
> >> have this done through v4l2 calls. We also can't seem to find
> >> where MPEG1, MPEG2, and MPEG4 elementary streams are defined in
> >> the V4L2 API.  We checked other drivers, but could not find
> >> anything.  The closest thing we found was the
> >> V4L2_CID_MPEG_STREAM_TYPE control, but the enums do not define
> >> elementary streams nor MPEG4.
> >>
> >> Your advice is appreciated.
> >>
> >> Thanks.
> >
> > It would be really nice to have this driver in the kernel.
> >
> > All MPEG streams use V4L2_PIX_FMT_MPEG and set the exact stream
> > type through V4L2_CID_MPEG_STREAM_TYPE. You probably need to add a
> > few new stream types to this control for the elementary streams. I
> > think something like TYPE_MPEG_ELEM might do the trick, and then
> > you can use the audio and video encoding controls to select the
> > precise audio/video encoding.
> >
> > I don't know enough about the capabilities, so perhaps
> > TYPE_MPEG1/2/4_ELEM is required instead of a more generic
> > TYPE_MPEG_ELEM.
>
> The generic approach seems better.  There will be boards with H264
> encapsulated in MPEG2 transport stream.  I'd recommend keeping the
> encapsulation/mux format in V4L2_CID_MPEG_STREAM_TYPE, but not
> necessarily the encoding.
>
> Otherwise you'll have V4L2_MPEG_STREAM_TYPE_MPEG2_TS_MPEG4_ENCODING,
> etc..  Maybe V4L2_CID_MPEG_STREAM_TYPE needs a comment that it is the
> encapsulation(or mux format), and the encoding should be defined in
> V4L2_CID_MPEG_VIDEO_ENCODING?

I think the v4l2 spec is clear enough on this topic.

> So for this Go7007, we suggest adding V4L2_MPEG_STREAM_TYPE_ELEM to
> V4L2_CID_MPEG_STREAM_TYPE.
> We also suggest adding V4L2_MPEG_VIDEO_ENCODING_MPEG_4 to
> V4L2_CID_MPEG_VIDEO_ENCODING.  Of course, there is the question of
> what version of MPEG4, but we'll leave that for another day.
>
> What do you think?

Agreed. Note that V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC already exists in 
the master v4l-dvb tree http://linuxtv.org/hg/v4l-dvb, also some newer 
audio encodings. These are merged in the latest 2.6.28 git tree as 
well.

When the go7007 driver has stabilized a bit and switched to the generic 
ioctls rather than using custom ioctls then you probably want to have 
you code merged in v4l-dvb. I expect a lot of internal API additions 
and improvements in the coming months so it's probably good to pay 
attention to the master tree to see what is happening there.

>
> > Since I designed the MPEG API for V4L2 I guess I'm the right person
> > to help you. I also have a Plextor TV402U since I always wanted to
> > get the go7007 driver into the kernel, but I never had the time so
> > I'm glad you've picked it up.
> >
> > Regards,
> >
> > 	Hans
>
> Good to hear, and thanks for the quick response.

No problem.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
