Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27052 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3GBKxh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jul 2013 06:53:37 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MPB004VP29BU840@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Jul 2013 11:53:35 +0100 (BST)
Message-id: <51D2B12D.7030304@samsung.com>
Date: Tue, 02 Jul 2013 12:53:33 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	a.hajda@samsung.com
Subject: Re: Question: interaction between selection API,
 ENUM_FRAMESIZES and S_FMT?
References: <201306241448.15187.hverkuil@xs4all.nl>
In-reply-to: <201306241448.15187.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Maybe it is a good time to separate configuration of a data source from
configuration of a data sink. Currently, everything is pretty mixed
for videodev API. The magic ioctl called S_FMT does to much.
As I understand it includes:
  a) setting pixelformat
  b) setting size of a buffer
  c) setting/adjusting crop rectangle previously defined using S_CROP
  d) if S_CROP is not used then S_FMT sets the framesize
     changing framesize ahs huge impact on a pipeline for capture device
  e) setting composing rectangle to the whole buffer

IMO, it would a good idea to split S_FMT into separate calls for a sink and
a source.

In case of a capture device, the source is TV grabber or sensor array.
They are controlled using S_STD for anlog TV, S_DV_TIMING for digital TV
or hypothetical S_FRAMESIZE for sensor arrays.
All mentioned medias are pretty different so they deserve dedicated ioctl.
I think it might be much better to introduce an ioctl dedicated
only for sensor arrays like {S/G}_SENSOR(_ARRAY). This ioctl would take width,
height as parameters (updating to defaults if only one resolution is supported).
All binning, skipping, etc. magic might have dedicated fields in S_SENSOR.
Introducing new selection target like SEL_TGT_FRAMESIZE or even
SEL_TGT_SOURCE is a nice abstraction but it is not need to provide HW
functionality to userspace.

In case of a capture device, the sink is a buffer. IMO, it would be nice
to have an ioctl dedicated only for configuration of buffers in memory.
Let's call it S_BUFFER. It will take width, height and pixelformat
as parameters. This ioctl would be very similar to S_FMT expect
much smaller influence on other parts of the pipeline. This call would
not change neither framesize nor cropping rectangle. There would be no
requirement that the buffer is fully filled without margins. This would
greatly simplify interactions with composing rectangle and scaling setup.

The interactions between composing rectangle and S_BUFFER are
an interesting topic. During the discussion about pipeline
configuration [1] it was mentioned that all dependencies
should be executed in to-memory order. It means that S_BUFFER
would adjust width and height to be assure that composing
rectangle fits. The same way adjusting composing rectangle will
change buffer size if necessary.

Finally S_FMT could be emulated in libv4l2 or v4l2-core as series of
of S_SELECTION and S_BUFFER calls, optionally S_STD, S_DV_TIMING or S_SENSOR
if possible. The same emulation would have to be performed for S_CROP.
The emulation would be used only to handle support for legacy applications.
All new and experimental applications must not use S_FMT or S_CROP.

I know that the changes are dramatic but fixing issues with pipeline
configuration is worth it.

What do you think about the proposed idea?

Regards,
Tomasz Stanislawski

[1] http://www.spinics.net/lists/linux-media/msg34541.html


