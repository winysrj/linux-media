Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBM7nsGT010576
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 02:49:54 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBM7nZAq016260
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 02:49:35 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1918834wfc.6
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 23:49:34 -0800 (PST)
Message-ID: <5d5443650812212349s793de6abk4eb83dee1bf4db30@mail.gmail.com>
Date: Mon, 22 Dec 2008 13:19:34 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200812071139.47936.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650811280216r450c6f02v3fb0db2e1580594a@mail.gmail.com>
	<5d5443650812010451o321e76e6s2681b3486e7c3c24@mail.gmail.com>
	<5d5443650812070140w423d6fe9ua2f0ff9d2974bbd7@mail.gmail.com>
	<200812071139.47936.hverkuil@xs4all.nl>
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

Hi Hans,

Sorry for the delay in reply.

>>
>> Attached the updated ov9640 sensor patch.
>
> Thanks. Here is my review:
>
> 1) Don't use this: static struct ov9640_sensor ov9640;
>
> This allows only one sensor instance. This should be dynamic. Remember
> that it should be possible (once the new v4l2_device/v4l2_subdev
> framework is merged) to reuse this driver in other products as well. So
> it should be possible to use two webcams with this sensor at the same
> time. It's only a small amount of work to make this struct dynamic.
> Ditto for the 'current_value' field of the static struct vcontrol: this
> too is per-instance.

Hopefully kzallocing in the probe ?

>
> 2) Looking at all the YUV and RGB register settings I notice that they
> seem to fall into two parts: all MTX regs and some COM regs are
> identical for either RGB or YUV. It's a good idea to have only two
> arrays for these registers rather than duplicating them for each
> format. You might want to consider setting the remaining COM regs
> directly in a switch (fmt) statement. Try it and see what is more
> readable.

I will try this.

>
> 3) There already exists a standard autoexposure control:
> V4L2_CID_EXPOSURE_AUTO.

Ok.

>
> 4) What does V4L2_CID_FREEZE_AGCAEC do?
>

I need to pull out some docs on this, but not looked at them from long time.

> 5) We have standardized the camera control names. A patch for this is
> still pending, but I recommend that in the meantime you use these
> names:
>
> AUTOGAIN: "Gain, Automatic"
> AUTO_WHITE_BALANCE: "White Balance, Automatic"
> HFLIP: "Horizontal Flip"
> VFLIP: "Vertical Flip"
>
> AUTO_EXPOSURE will probably change to "Exposure, Automatic", but this is
> still under discussion.

Ok.

>
> 6) include/media/ov9640.h: what part of this header needs to be visible
> to other parts of the kernel? A lot seems to be internal to the driver
> and so should be moved to the driver source (or a ov9640_regs.h headers
> next to the driver source).

I will bring regs inside the source file and remove ov9640.h from
include/media if there is no need of platform data dependency from
board-xxx.c files.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
