Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG9cZnN029810
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:38:35 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBG9augu005562
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:36:56 -0500
Date: Tue, 16 Dec 2008 10:37:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200812151145.54346.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0812161033090.5450@axis700.grange>
References: <200812151145.54346.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: Integrating v4l2_device/v4l2_subdev into the soc_camera
	framework
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

On Mon, 15 Dec 2008, Hans Verkuil wrote:

> Hi Guennadi,
> 
> Now that the v4l2_device and v4l2_subdev structs are merged into the 
> master v4l-dvb repository it is time to look at what needs to be done 
> to integrate it into the soc-camera framework.
> 
> The goal is to make the i2c sub-device drivers independent from how they 
> are used. That is, whether a sensor is used in an embedded device or in 
> a USB webcam or something else should not matter for the sensor driver.
> 
> I would really appreciate it if you can take a good look at what would 
> be needed to achieve this. We can then discuss that and make a plan on 
> how to proceed.
> 
> I'll be happy to answer any questions you have or help you in whatever 
> way you want.

Wow, that's a generous offer, perhaps, the most generous I've got in my 
entire life!:-)

Yes, I'll have a look at it (again) and will think how we can best 
integrate the two APIs. Although, I will not have too much time for this 
work, so, I'll be looking for the easiest / cheapest acceptible 
solution:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
