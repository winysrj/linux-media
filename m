Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:42924 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1ERTnh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 15:43:37 -0400
Message-ID: <4DD42218.7000302@maxwell.research.nokia.com>
Date: Wed, 18 May 2011 22:46:32 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Jesse Barker <jesse.barker@linaro.org>
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded
 Linux memory management interest group list
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com> <201105141302.55100.hverkuil@xs4all.nl> <4DCE6B7B.1080907@redhat.com> <201105152310.31678.hverkuil@xs4all.nl>
In-Reply-To: <201105152310.31678.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Verkuil wrote:
> Note that many video receivers cannot stall. You can't tell them to wait until
> the last buffer finished processing. This is different from some/most? sensors.

Not even image sensors. They just output the frame data; if the receiver
runs out of buffers the data is just lost. And if any part of the frame
is lost, there's no use for other parts of it either. But that's
something the receiver must handle, i.e. discard the data and increment
frame number (field_count in v4l2_buffer).

The interfaces used by image sensors, be they parallel or serial, do not
provide means to inform the sensor that the receiver has run out of
buffer space. These interfaces are just unidirectional.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
