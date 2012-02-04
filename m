Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:59440 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab2BDLWo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Feb 2012 06:22:44 -0500
Message-ID: <4F2D14ED.8080105@iki.fi>
Date: Sat, 04 Feb 2012 13:22:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
References: <4F27CF29.5090905@samsung.com> <20120201100007.GA841@valkosipuli.localdomain> <4F2924F8.3040408@samsung.com>
In-Reply-To: <4F2924F8.3040408@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> On 02/01/2012 11:00 AM, Sakari Ailus wrote:
>> I'd guess that all the ISP would do to such formats is to write them to
>> memory since I don't see much use for either in ISPs --- both typically are
>> output of the ISP.
> 
> Yep, correct. In fact in those cases the sensor has complicated ISP built in,
> so everything a bridge have to do is to pass data over to user space.
> 
> Also non-image data might need to be passed to user space as well.

How does one know in the user space which part of the video buffer
contains jpeg data and which part is yuv? Does the data contain some
kind of header, or how is this done currently?

I'd be much in favour or using a separate channel ID as Guennadi asked;
that way you could quite probably save one memory copy as well. But if
the hardware already exists and behaves badly there's usually not much
you can do about it.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
