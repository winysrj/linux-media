Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAO84Y9g031594
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:04:34 -0500
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAO84LXN027769
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:04:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Date: Mon, 24 Nov 2008 09:04:12 +0100
References: <hvaibhav@ti.com> <200811232300.40530.hverkuil@xs4all.nl>
	<5d5443650811232216x6c9a77a4p2945f87e1ab65a67@mail.gmail.com>
In-Reply-To: <5d5443650811232216x6c9a77a4p2945f87e1ab65a67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811240904.12758.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-omap@vger.kernel.org,
	davinci-linux-open-source-bounces@linux.davincidsp.com
Subject: Re: [PATCH 2/2] TVP514x V4L int device driver support
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

On Monday 24 November 2008 07:16:12 Trilok Soni wrote:
> Hi Hans,
>
> On Mon, Nov 24, 2008 at 3:30 AM, Hans Verkuil <hverkuil@xs4all.nl> 
wrote:
> > Hi Vaibhav,
> >
> > Here is my review as promised (although a day late). It's a mix of
> > smaller and larger issues:
> >
> > 1) CONFIG_VIDEO_ADV_DEBUG is meant to enable the ability to set/get
> > registers through the VIDIOC_DBG_G/S_REGISTER ioctls. For general
> > debugging you should use a debug module option (see e.g.
> > saa7115.c).
>
> Local dprintk with log levels is fine, as far as it not misused.
>
> > 2) Please use the media/v4l2-i2c-drv.h or
> > media/v4l2-i2c-drv-legacy.h header to hide some of the i2c
> > complexity (again, see e.g. saa7115.c). The i2c API tends to change
> > a lot (and some changes are upcoming) so using this header will
> > mean that i2c driver changes will be minimal in the future. In
> > addition it will ensure that this driver can be compiled with older
> > kernels as well once it is part of the v4l-dvb repository.
>
> I don't agree with having support to compile with older kernels. Even
> though I2C APIs change as lot it is for good, and creating
> abstractions doesn't help as saa7xxx is family of chips where I don't
> see the case here. Once this driver is mainlined if someone does i2c
> subsystem change which breaks this driver from building then he/she
> has to make changes to all the code affecting it.
>
> I am not in favour of adding support to compile with older kernels.
>
> > 3) Remember that the use of v4l2-int-device.h must be temporary
> > only. It will make it impossible to use this driver with any other
> > platform but omap. I had hoped to release my generic v4l2 subdevice
> > support today which should replace v4l2-int-device.h in time, but I
> > hit a bug that needs to be resolved first. I hope to fix it during
> > the next week so that I can finally make it available for use asap.
>
> Better step would be to have single camera-sensor framework or merge
> with soc-camera framework. Two frameworks doesn't help anyone, but
> creates more confusion for new developers.

The v4l2-int-device.h stuff should never have been added. Ditto for 
parts of the soc-camera framework that duplicates v4l2-int-device.h. My 
new v4l2_subdev support will replace the three methods of using i2c 
devices (or similar) that are currently in use. It's exactly to reduce 
the confusion that I'm working on this.

It's been discussed before on the v4l mailinglist and the relevant 
developers are aware of this. It's almost finished, just need to track 
down a single remaining oops.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
