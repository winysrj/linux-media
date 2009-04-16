Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:55464 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZDPAMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 20:12:24 -0400
Received: by rv-out-0506.google.com with SMTP id f9so142955rvb.1
        for <linux-media@vger.kernel.org>; Wed, 15 Apr 2009 17:12:23 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Apr 2009 09:12:23 +0900
Message-ID: <5e9665e10904151712o5fa3076dr85ad12fc7f04914d@mail.gmail.com>
Subject: [RFC] Making Samsung S3C64XX camera interface driver in SoC camera
	subsystem
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: kernel@pengutronix.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	dongsoo45.kim@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm planing to make a new camera interface driver for S3C64XX from Samsung.
Even if it already has a driver, it seems to be re-designed for some
reasons. If you are interested in, take a look at following repository
(http://git.kernel.org/?p=linux/kernel/git/eyryu_ap/samsung-ap-2.6.24.git;a=summary)
drivers/media/video/s3c_* files

Before beginning to implement a new driver for that, I need to clarify
some of features about how to implement in driver.

Please take a look at the diagram on page 610 of following user manual
of s3c6400.
http://www.ebv.com/fileadmin/products/Products/Samsung/S3C6400/S3C6400X_UserManual_rev1-0_2008-02_661558um.pdf

It seems to have a couple of path for camera data named codec and
preview, and they could be used at the same time.
It means that it has no problem making those two paths into
independent device nodes like /dev/video0 and /dev/video1

But there is a limit of size using both of paths at the same time. I
mean, If you are using preview path and camera sensor is running with
1280*720 resolution (which seems to be the max resolution could be
handled by preview path), codec path can't use resolution bigger than
1280*720 at the same time because camera sensor can't produce
different resolution at a time.

And also we should face a big problem when we are making dual camera
system with s3c64xx. Dual camera with single camera interface has some
restriction using clock and data path, because they have to be shared
between both of cameras.
I suppose to handle them with VIDIOC_S_INPUT and G_INPUT. And with
those, we can handle dual camera with single camera interface in a
decent way.

But the thing is that there should be a problem using dual camera with
preview and codec path of s3c64xx. Even if we have each preview, and
codec device node and can't open them concurrently when user is
attempting to open each camera sensor like "camera A with preview node
and camera B with codec node". Because both of those camera sensors
are sharing same data path and clock source, and s3c64xx camera
interface only can handle one camera at a time.

So, what I am concerned is how to make it a elegant driver which has
two device nodes handling multiple sensors as input devices.
Sounds complicated but I'm asking you to help me with any opinion
about designing this driver. Any opinion about these issues will be
greatly helpful to me.
Cheers,

Nate
