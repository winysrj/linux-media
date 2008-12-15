Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFAkB9D018713
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 05:46:11 -0500
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBFAjtO3012457
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 05:45:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Mon, 15 Dec 2008 11:45:54 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812151145.54346.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>
Subject: Integrating v4l2_device/v4l2_subdev into the soc_camera framework
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

Hi Guennadi,

Now that the v4l2_device and v4l2_subdev structs are merged into the 
master v4l-dvb repository it is time to look at what needs to be done 
to integrate it into the soc-camera framework.

The goal is to make the i2c sub-device drivers independent from how they 
are used. That is, whether a sensor is used in an embedded device or in 
a USB webcam or something else should not matter for the sensor driver.

I would really appreciate it if you can take a good look at what would 
be needed to achieve this. We can then discuss that and make a plan on 
how to proceed.

I'll be happy to answer any questions you have or help you in whatever 
way you want.

Thank you,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
