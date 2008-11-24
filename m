Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAO6Hhjk032687
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 01:17:43 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAO6GDnl022535
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 01:16:33 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2017089wfc.6
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 22:16:12 -0800 (PST)
Message-ID: <5d5443650811232216x6c9a77a4p2945f87e1ab65a67@mail.gmail.com>
Date: Mon, 24 Nov 2008 11:46:12 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200811232300.40530.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <hvaibhav@ti.com>
	<1227280923-31654-1-git-send-email-hvaibhav@ti.com>
	<200811232300.40530.hverkuil@xs4all.nl>
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

Hi Hans,

On Mon, Nov 24, 2008 at 3:30 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Vaibhav,
>
> Here is my review as promised (although a day late). It's a mix of
> smaller and larger issues:
>
> 1) CONFIG_VIDEO_ADV_DEBUG is meant to enable the ability to set/get
> registers through the VIDIOC_DBG_G/S_REGISTER ioctls. For general
> debugging you should use a debug module option (see e.g. saa7115.c).

Local dprintk with log levels is fine, as far as it not misused.

>
> 2) Please use the media/v4l2-i2c-drv.h or media/v4l2-i2c-drv-legacy.h
> header to hide some of the i2c complexity (again, see e.g. saa7115.c).
> The i2c API tends to change a lot (and some changes are upcoming) so
> using this header will mean that i2c driver changes will be minimal in
> the future. In addition it will ensure that this driver can be compiled
> with older kernels as well once it is part of the v4l-dvb repository.

I don't agree with having support to compile with older kernels. Even
though I2C APIs change as lot it is for good, and creating
abstractions doesn't help as saa7xxx is family of chips where I don't
see the case here. Once this driver is mainlined if someone does i2c
subsystem change which breaks this driver from building then he/she
has to make changes to all the code affecting it.

I am not in favour of adding support to compile with older kernels.

>
> 3) Remember that the use of v4l2-int-device.h must be temporary only. It
> will make it impossible to use this driver with any other platform but
> omap. I had hoped to release my generic v4l2 subdevice support today
> which should replace v4l2-int-device.h in time, but I hit a bug that
> needs to be resolved first. I hope to fix it during the next week so
> that I can finally make it available for use asap.

Better step would be to have single camera-sensor framework or merge
with soc-camera framework. Two frameworks doesn't help anyone, but
creates more confusion for new developers.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
