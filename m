Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RLxkj4001925
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 17:59:46 -0400
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RLxYUI014730
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 17:59:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Tue, 27 May 2008 23:57:48 +0200
References: <200805272313.18651.hverkuil@xs4all.nl>
	<20080527184104.07e242a0@gaivota>
In-Reply-To: <20080527184104.07e242a0@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805272357.48974.hverkuil@xs4all.nl>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Handling of VIDIOC_G_STD and ENUMSTD in __video_do_ioctl
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

On Tuesday 27 May 2008 23:41:04 Mauro Carvalho Chehab wrote:
> On Tue, 27 May 2008 23:13:18 +0200
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Mauro,
> >
> > While converting ivtv I noticed that VIDIOC_G_STD is now handled
> > inside __video_do_ioctl and is implemented by returning a field
> > from the video_device struct (which is set in turn when S_STD is
> > called).
> >
> > This is not correct: this assumes that each device has its own
> > independent tvnorm setting, but devices like /dev/video0 and
> > /dev/vbi0 are linked: setting the standard to NTSC for one should
> > set it to NTSC for the other as well. And this is even more
> > important for ivtv with its additional raw video and audio devices.
> >
> > The way it is done now means that this happens:
> >
> > v4l2-ctl -s ntsc -d /dev/vbi0
> > v4l2-ctl -s pal -d /dev/video0
> > v4l2-ctl -S -d /dev/video0
> > Video Standard = 0x000000ff
> >         PAL-B/B1/G/H/I/D/D1/K
> > v4l2-ctl -S -d /dev/vbi0
> > Video Standard = 0x0000b000
> >         NTSC-M/M-JP/M-KR
> >
> > That's not right. I suggest adding a proper vidioc_g_std callback
> > instead and let the driver handle it. The driver knows which
> > devices are linked.
>
> Yes. IMO, the proper fix is to keep the default behaviour, if
> vidioc_g_std is not defined, but letting you specify a different
> behaviour, if needed.
>
> Something like:
>
> 	if (!vidioc_g_std)
> 		*id = vfd->current_norm;
> 	else
> 		ret = vfd->vidioc_g_std(file, fh, arg);

I'm implementing this right now.

>
> > In addition, the VIDIOC_ENUMSTD is now also handled inside
> > __video_do_ioctl. I don't think that is correct. The purpose of
> > this ioctl is for applications to setup a list of standards that
> > the input supports and more importantly that the input will handle
> > differently. The way it is implemented now means that v4l2-ctl
> > --list-standards returns this:
> >
> >         index       : 0
> >         ID          : 0x00000000000000FF
> >         Name        : PAL
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 1
> >         ID          : 0x0000000000000100
> >         Name        : PAL-M
> >         Frame period: 1001/30000
> >         Frame lines : 525
> >
> >         index       : 2
> >         ID          : 0x0000000000000200
> >         Name        : PAL-N
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 3
> >         ID          : 0x0000000000000400
> >         Name        : PAL-Nc
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 4
> >         ID          : 0x0000000000000800
> >         Name        : PAL-60
> >         Frame period: 1001/30000
> >         Frame lines : 525
> >
> >         index       : 5
> >         ID          : 0x000000000000B000
> >         Name        : NTSC
> >         Frame period: 1001/30000
> >         Frame lines : 525
> >
> >         index       : 6
> >         ID          : 0x0000000000004000
> >         Name        : NTSC-443
> >         Frame period: 1001/30000
> >         Frame lines : 525
> >
> >         index       : 7
> >         ID          : 0x0000000000FF0000
> >         Name        : SECAM
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> > Compare that to what ivtv used to return:
> >
> >         index       : 0
> >         ID          : 0x000000000000000F
> >         Name        : PAL-BGH
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 1
> >         ID          : 0x00000000000000E0
> >         Name        : PAL-DK
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 2
> >         ID          : 0x0000000000000010
> >         Name        : PAL-I
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 3
> >         ID          : 0x0000000000000100
> >         Name        : PAL-M
> >         Frame period: 1001/30000
> >         Frame lines : 525
> >
> >         index       : 4
> >         ID          : 0x0000000000000200
> >         Name        : PAL-N
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 5
> >         ID          : 0x0000000000000400
> >         Name        : PAL-Nc
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 6
> >         ID          : 0x00000000000D0000
> >         Name        : SECAM-BGH
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 7
> >         ID          : 0x0000000000320000
> >         Name        : SECAM-DK
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 8
> >         ID          : 0x0000000000400000
> >         Name        : SECAM-L
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 9
> >         ID          : 0x0000000000800000
> >         Name        : SECAM-L'
> >         Frame period: 1/25
> >         Frame lines : 625
> >
> >         index       : 10
> >         ID          : 0x0000000000001000
> >         Name        : NTSC-M
> >         Frame period: 1001/30000
> >         Frame lines : 525
> >
> >         index       : 11
> >         ID          : 0x0000000000002000
> >         Name        : NTSC-J
> >         Frame period: 1001/30000
> >         Frame lines : 525
> >
> >         index       : 12
> >         ID          : 0x0000000000008000
> >         Name        : NTSC-K
> >         Frame period: 1001/30000
> >         Frame lines : 525
> >
> > All these standards might be explicitly selected by the user. Which
> > substandards can be combined into one ENUMSTD entry is really
> > dependent on the hardware and the input. E.g. standards like PAL-60
> > and NTSC-443 are never used in broadcasts, but can be used when
> > capturing from composite/S-Video inputs.
> >
> > Again, I think that it might be better to leave this to the driver,
> > although perhaps the driver might supply a table instead and let
> > __video_do_ioctl do the actual job.
>
> There are some discussions about this at V4L ML. A recent report
> rised the point that this behaviour broke a few programs that
> considers the enumbered standards as if they aren't in fact a bitmask
> (other userspace programs, like tvtime, considers standards as
> bitmask, so they work well).
>
> IMO, the proper solution would be to enumerate the grouped bitmasks,
> as the code already does, plus all individual standards.
>
> So, it would return STD_SECAM and also STD_SECAM_L, STD_SECAM_Lc,
> etc.

I'll take a closer look at this.

> The big advantage of having this code inside videodev is that a lot
> of duplicated (and sometimes conflicting) code were removed (for
> example, NTSC/M had different names, depending on the driver: NTSC-M,
> NTSC, NTSC_M, NTSC/M). On some cases, the above names were including
> the japanese/korean standards, on others they are added as separate
> entries (even if they were using the same parameters inside the
> drivers).
>
> I really prefer to keep this handled inside video_ioctl2, since it
> avoids similar mistakes.
>
> > I found a few other bugs as well in __video_do_ioctl, but the two
> > that I found are easy to fix and I'll make a pull request for them.
> > But I will need to do a closer review of __video_do_ioctl, in case
> > there are more surprises.
>
> Ok.
>
> The most relevant behaviour changes are those above, and the split of
> streaming commands, like:
>
>         case VIDIOC_TRY_FMT:
>         {
>                 struct v4l2_format *f = (struct v4l2_format *)arg;
>
>                 /* FIXME: Should be one dump per type */
>                 dbgarg (cmd, "type=%s\n", prt_names(f->type,
>                                                 v4l2_type_names));
>                 switch (f->type) {
>                 case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>                         if (vfd->vidioc_try_fmt_cap)
>                                 ret=vfd->vidioc_try_fmt_cap(file, fh,
> f); if (!ret)
>                                 v4l_print_pix_fmt(vfd,&f->fmt.pix);
>                         break;
>                 case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>                         if (vfd->vidioc_try_fmt_overlay)
>                                 ret=vfd->vidioc_try_fmt_overlay(file,
> fh, f); break;
>
> 	...
>
> You should agree with me that those ioctls with different input
> parameters and similar but different functions into an union {} were
> something really weird at V4L2 API ;)

True.

> Except for G_STD and ENUM_STD, the other commands are (or should be)
> just a call to the callback (and a memset(0) for _G_ commands - but
> preserving the input argument).
>
> Since a few of those calls are used only at ivtv/cx18, it may have a
> few cut-and-paste mistakes ;)

One thing I'm unhappy about is the naming for some of the FMT callbacks: 
it's rather confusing that V4L2_BUF_TYPE_VBI_CAPTURE maps to 
vidioc_g_fmt_vbi and V4L2_BUF_TYPE_SLICED_VBI_CAPTURE maps to 
vidioc_g_fmt_vbi_capture. If you don't mind I'm going to change that.

I propose the following mapping:

V4L2_BUF_TYPE_VIDEO_CAPTURE -> vidioc_g_fmt_video_cap
V4L2_BUF_TYPE_VIDEO_OVERLAY -> vidioc_g_fmt_video_overlay
V4L2_BUF_TYPE_VBI_CAPTURE -> vidioc_g_fmt_vbi_cap
V4L2_BUF_TYPE_SLICED_VBI_OUTPUT -> vidioc_g_fmt_sliced_vbi_output
V4L2_BUF_TYPE_SLICED_VBI_CAPTURE -> vidioc_g_fmt_sliced_vbi_cap
V4L2_BUF_TYPE_VIDEO_OUTPUT -> vidioc_g_fmt_video_output
V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY -> vidioc_g_fmt_video_output_overlay
V4L2_BUF_TYPE_VBI_OUTPUT -> vidioc_g_fmt_vbi_output
V4L2_BUF_TYPE_PRIVATE -> vidioc_g_fmt_type_private

If you prefer something a bit shorter, then we can replace 'video' 
by 'vid' and 'output' by 'out'.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
