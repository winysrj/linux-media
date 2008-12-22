Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBMC7dU4014273
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 07:07:39 -0500
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBMC7OTH008374
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 07:07:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Date: Mon, 22 Dec 2008 13:07:15 +0100
References: <5d5443650811280216r450c6f02v3fb0db2e1580594a@mail.gmail.com>
	<200812071139.47936.hverkuil@xs4all.nl>
	<5d5443650812212349s793de6abk4eb83dee1bf4db30@mail.gmail.com>
In-Reply-To: <5d5443650812212349s793de6abk4eb83dee1bf4db30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812221307.15351.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: Re: [PATCH] Add Omnivision OV9640 sensor support.
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

On Monday 22 December 2008 08:49:34 Trilok Soni wrote:
> Hi Hans,
>
> Sorry for the delay in reply.
>
> >> Attached the updated ov9640 sensor patch.
> >
> > Thanks. Here is my review:
> >
> > 1) Don't use this: static struct ov9640_sensor ov9640;
> >
> > This allows only one sensor instance. This should be dynamic. Remember
> > that it should be possible (once the new v4l2_device/v4l2_subdev
> > framework is merged) to reuse this driver in other products as well. So
> > it should be possible to use two webcams with this sensor at the same
> > time. It's only a small amount of work to make this struct dynamic.
> > Ditto for the 'current_value' field of the static struct vcontrol: this
> > too is per-instance.
>
> Hopefully kzallocing in the probe ?

Yes. Typically all state information is pulled into one struct which is 
kzalloc'ed in the probe and freed at the end.

>
> > 2) Looking at all the YUV and RGB register settings I notice that they
> > seem to fall into two parts: all MTX regs and some COM regs are
> > identical for either RGB or YUV. It's a good idea to have only two
> > arrays for these registers rather than duplicating them for each
> > format. You might want to consider setting the remaining COM regs
> > directly in a switch (fmt) statement. Try it and see what is more
> > readable.
>
> I will try this.
>
> > 3) There already exists a standard autoexposure control:
> > V4L2_CID_EXPOSURE_AUTO.
>
> Ok.
>
> > 4) What does V4L2_CID_FREEZE_AGCAEC do?
>
> I need to pull out some docs on this, but not looked at them from long
> time.

I recommend that you read my posting "Re: Extended driver private controls?" 
on the linux-omap list as well (for some reason it was refused on the v4l 
list, weird).

> > 5) We have standardized the camera control names. A patch for this is
> > still pending, but I recommend that in the meantime you use these
> > names:
> >
> > AUTOGAIN: "Gain, Automatic"
> > AUTO_WHITE_BALANCE: "White Balance, Automatic"
> > HFLIP: "Horizontal Flip"
> > VFLIP: "Vertical Flip"
> >
> > AUTO_EXPOSURE will probably change to "Exposure, Automatic", but this
> > is still under discussion.
>
> Ok.

It's been decided that it will be called "Auto Exposure" instead.

>
> > 6) include/media/ov9640.h: what part of this header needs to be visible
> > to other parts of the kernel? A lot seems to be internal to the driver
> > and so should be moved to the driver source (or a ov9640_regs.h headers
> > next to the driver source).
>
> I will bring regs inside the source file and remove ov9640.h from
> include/media if there is no need of platform data dependency from
> board-xxx.c files.

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
