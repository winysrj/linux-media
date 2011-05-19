Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab1ESK4f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 06:56:35 -0400
Message-ID: <4DD4F75A.3010308@redhat.com>
Date: Thu, 19 May 2011 07:56:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, Jesse Barker <jesse.barker@linaro.org>
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded
 Linux memory management interest group list
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com> <201105141302.55100.hverkuil@xs4all.nl> <4DCE6B7B.1080907@redhat.com> <201105152310.31678.hverkuil@xs4all.nl> <4DD42218.7000302@maxwell.research.nokia.com>
In-Reply-To: <4DD42218.7000302@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-05-2011 16:46, Sakari Ailus escreveu:
> Hans Verkuil wrote:
>> Note that many video receivers cannot stall. You can't tell them to wait until
>> the last buffer finished processing. This is different from some/most? sensors.
> 
> Not even image sensors. They just output the frame data; if the receiver
> runs out of buffers the data is just lost. And if any part of the frame
> is lost, there's no use for other parts of it either. But that's
> something the receiver must handle, i.e. discard the data and increment
> frame number (field_count in v4l2_buffer).
> 
> The interfaces used by image sensors, be they parallel or serial, do not
> provide means to inform the sensor that the receiver has run out of
> buffer space. These interfaces are just unidirectional.

Well, it depends on how the hardware works, really. On most (all?) designs, the
IP block responsible to receive data from a sensor (or to transmit data, on an
output device) is capable of generating an IRQ to notify the OS that a 
framebuffer was filled. So, the V4L driver can mark that buffer as finished 
and remove it from the list of the queued buffers. Although the current API's
don't allow to create a new buffer if the list is empty, it may actually make
sense to allow kernel to dynamically create a new buffer, warranting that the
sensor (or receiver) will never run out of buffers under normal usage.

Of course, the maximum number of buffers should be specified, to avoid having
an unacceptable delay. On such case, the frame will end by being discarded.
It makes sense to provide a way to report userspace if this happens.

Mauro.
