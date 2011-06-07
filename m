Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1FGMSL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 08:18:11 -0400
Message-ID: <4DEE16EE.9030200@redhat.com>
Date: Tue, 07 Jun 2011 09:17:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Subject: Re: [RFC v4] V4L2 API for flash devices
References: <4DC2F131.6090407@maxwell.research.nokia.com> <201105071446.56843.hverkuil@xs4all.nl> <4DC5849A.9050806@gmail.com> <4DC7151E.8070601@maxwell.research.nokia.com> <4DC9A2D0.2060709@gmail.com> <4DD2DBDC.6060303@maxwell.research.nokia.com> <4DD4464C.30702@gmail.com> <4DD4D0D2.7030609@maxwell.research.nokia.com>
In-Reply-To: <4DD4D0D2.7030609@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-05-2011 05:12, Sakari Ailus escreveu:
> Sylwester Nawrocki wrote:

>>>> These were mostly fixed point arithmetic numbers in [32-bit numerator/
>>>> 32-bit denominator] form carrying exposure time, shutter speed, aperture,
>>>> brightness, flash, etc. information. The tags could be read from ISP after
>>>> it buffered a frame in its memory and processed it.
>>>> In case of a JPEG image format the tags can be embedded into the main
>>>> image file. But the image processors not always supported that so we used
>>>> to have an ioctl for the purpose of retrieving the metadata in user space.
>>>> In some cases it is desired to read data directly from the driver rather
>>>> than parsing a relatively large buffer.
>>>> It would be good to have a uniform interface for passing such data to
>>>> applications. I think in that particular use case a control id/value pair
>>>> sequences would do.
 
> - Which formats are your rational numbers in? A kernel interface can't
> really have floating point numbers, so there would need to be a sane way
> to pass these to user space.

The V4L2 API has support for rational numbers. The frame rate is specified as a
rational number. There's a struct for that:

struct v4l2_fract {
	__u32   numerator;
	__u32   denominator;
};

Cheers,
Mauro
