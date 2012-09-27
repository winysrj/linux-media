Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47644 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2I0Kka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 06:40:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>, remi@remlab.net,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC] Timestamps and V4L2
Date: Thu, 27 Sep 2012 12:41:08 +0200
Message-ID: <21756413.MuViFDO8NB@avalon>
In-Reply-To: <50638219.7020105@gmail.com>
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <32114057.tIVjSTYujk@avalon> <50638219.7020105@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 27 September 2012 00:30:49 Sylwester Nawrocki wrote:
> On 09/25/2012 02:35 AM, Laurent Pinchart wrote:
> > Does the clock type need to be selectable for mem-to-mem devices ? Do
> > device- specific timestamps make sense there ?
> 
> I'd like to clarify one thing here, i.e. if we select device-specific
> timestamps how should the v4l2_buffer::timestamp field behave ?
> 
> Are these two things exclusive ? Or should v4l2_buffer::timestamp be
> valid even if device-specific timestamps are enabled ?

That's a very good question. The use cases I have in mind don't need both at 
the same time. The point of device-specific timestamps is to get a precise 
timestamp corresponding to the frame capture time, instead of the frame 
transfer time. They need to be correlated with system timestamps, but for that 
we need device-specific APIs to pass correlation information to userspace. 
Passing a "transfer time" system timestamp along with the device timestamp 
would be useless, as there would be no good correlation between the two.

> With regards to your question, I think device-specific timestamps make
> sense for mem-to-mem devices. Maybe not for the very simple ones, that
> process buffers 1-to-1, but codecs may need it. I was told the Exynos/
> S5P Multi Format Codec device has some register the timestamps could
> be read from, but it's currently not used by the s5p-mfc driver. Kamil
> might provide more details on that.

What kind of timestamps are they ?

> I guess if capture and output devices can have their timestamping clocks
> selectable it should be also possible for mem-to-mem devices.

-- 
Regards,

Laurent Pinchart

