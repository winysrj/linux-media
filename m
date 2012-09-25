Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47834 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753767Ab2IYUDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 16:03:34 -0400
Message-ID: <50620E6C.8050308@iki.fi>
Date: Tue, 25 Sep 2012 23:05:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, remi@remlab.net, daniel-gl@gmx.net,
	sylwester.nawrocki@gmail.com
Subject: Re: [RFC] Timestamps and V4L2
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <201209211133.24174.hverkuil@xs4all.nl> <3710877.YmOTmlHk1B@avalon> <201209250847.45104.hverkuil@xs4all.nl>
In-Reply-To: <201209250847.45104.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Laurent,

Hans Verkuil wrote:
...
>>> Using v4l2_buffer flags to report the clock
>>> -------------------------------------------
>>>
>>> By defining flags like this:
>>>
>>> V4L2_BUF_FLAG_CLOCK_MASK	0x7000
>>> /* Possible Clocks */
>>> V4L2_BUF_FLAG_CLOCK_UNKNOWN	0x0000  /* system or monotonic, we don't know 
>> */
>>> V4L2_BUF_FLAG_CLOCK_MONOTONIC   0x1000
>>>
>>> you could tell the application which clock is used.
>>>
>>> This does allow for more clocks to be added in the future and clock
>>> selection would then be done by a control or possibly an ioctl.
>>
>> Clock selection could also be done by setting the buffer flag at QBUF time.
> 
> True. Not a bad idea, actually. You would have to specify that setting the
> clock to 0 (UNKNOWN) or any other unsupported clock, then that will be mapped
> to MONOTONIC for newer kernels, but that's no problem.
> 
> It has the advantage of not requiring any controls, ioctls, etc. The only
> disadvantage is that you can't check if a particular clock is actually
> supported. Although I guess you could do a QBUF followed by QUERYBUF to check
> the clock bits. But you can't change to a different clock for that buffer
> afterwards (at least, not until it is dequeued).

Buffer flags are not and will not be available on subdevs. If the
timestamp clock source is made selectable it should be selectable on
subdevs, too. I'm afraid otherwise it may end up being a useless
feature: the timestamps that the application gets from the devices must
be from the same clock, otherwise they cannot be compared in a
meaningful way. Or at least alternative mechanism should be provided to
subdevs, but I don't see then why that wouldn't be done on V4L2, too...

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
