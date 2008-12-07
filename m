Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB7Ae7QX029853
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 05:40:07 -0500
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB7Adr1v015500
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 05:39:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Date: Sun, 7 Dec 2008 11:39:47 +0100
References: <5d5443650811280216r450c6f02v3fb0db2e1580594a@mail.gmail.com>
	<5d5443650812010451o321e76e6s2681b3486e7c3c24@mail.gmail.com>
	<5d5443650812070140w423d6fe9ua2f0ff9d2974bbd7@mail.gmail.com>
In-Reply-To: <5d5443650812070140w423d6fe9ua2f0ff9d2974bbd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071139.47936.hverkuil@xs4all.nl>
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

Hi Trilok,

On Sunday 07 December 2008 10:40:51 Trilok Soni wrote:
> Hi Hans,
>
> On Mon, Dec 1, 2008 at 6:21 PM, Trilok Soni <soni.trilok@gmail.com> 
wrote:
> > Hi Hans,
> >
> >> I reviewed this sensor driver and it's fine except for one thing:
> >> setting the default registers from outside the driver. This is a
> >> really bad idea. I2C drivers should be self-contained. I've made
> >> the same comment in the tvp514x driver review which I'm copying
> >> below (with some small edits):
> >
> > I knew that you are going to comment on that, and I agree on those
> > points. I will pull in that register initialization to the driver.
>
> Attached the updated ov9640 sensor patch.

Thanks. Here is my review:

1) Don't use this: static struct ov9640_sensor ov9640;

This allows only one sensor instance. This should be dynamic. Remember 
that it should be possible (once the new v4l2_device/v4l2_subdev 
framework is merged) to reuse this driver in other products as well. So 
it should be possible to use two webcams with this sensor at the same 
time. It's only a small amount of work to make this struct dynamic. 
Ditto for the 'current_value' field of the static struct vcontrol: this 
too is per-instance.

2) Looking at all the YUV and RGB register settings I notice that they 
seem to fall into two parts: all MTX regs and some COM regs are 
identical for either RGB or YUV. It's a good idea to have only two 
arrays for these registers rather than duplicating them for each 
format. You might want to consider setting the remaining COM regs 
directly in a switch (fmt) statement. Try it and see what is more 
readable.

3) There already exists a standard autoexposure control: 
V4L2_CID_EXPOSURE_AUTO.

4) What does V4L2_CID_FREEZE_AGCAEC do? 

5) We have standardized the camera control names. A patch for this is 
still pending, but I recommend that in the meantime you use these 
names:

AUTOGAIN: "Gain, Automatic"
AUTO_WHITE_BALANCE: "White Balance, Automatic"
HFLIP: "Horizontal Flip"
VFLIP: "Vertical Flip"

AUTO_EXPOSURE will probably change to "Exposure, Automatic", but this is 
still under discussion.

6) include/media/ov9640.h: what part of this header needs to be visible 
to other parts of the kernel? A lot seems to be internal to the driver 
and so should be moved to the driver source (or a ov9640_regs.h headers 
next to the driver source).

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
