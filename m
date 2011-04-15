Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:20254 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab1DOJL7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2011 05:11:59 -0400
Message-ID: <4DA80BCA.5020708@maxwell.research.nokia.com>
Date: Fri, 15 Apr 2011 12:11:38 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Subject: Re: [RFC v3] V4L2 API for flash devices
References: <4DA7F5AD.1050104@maxwell.research.nokia.com> <201104151047.19658.hselasky@c2i.net>
In-Reply-To: <201104151047.19658.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Petter Selasky wrote:
> On Friday 15 April 2011 09:37:17 Sakari Ailus wrote:
>> Hi,
>>
>> This is a third proposal for an interface for controlling flash devices
>> on the V4L2/v4l2_subdev APIs. My plan is to use the interface in the
>> ADP1653 driver, the flash controller used in the Nokia N900.
>>
>> Thanks to everyone who commented the previous version of this RFC! I
>> hope I managed to factor in everyone's comments. Please bug me if you
>> think I missed something. :-)
>>
>> Comments and questions are very, very welcome as always. There are still
>> many open questions which I would like to resolve. I've written my
>> proposal on the two last ones below the question itself.
>>
> 
> Hi,
> 
> I looked through your specification and did not find the answer to my 
> question. Do you support more than one flasher per webcam/camera?

Hi Hans,

You probably didn't find it since it's not there. :-)

When this interface is provided directly by the flash driver (a V4L2
subdev), it takes no stance to that. (The interface can also be provided
by the video node, but then it is up to the bridge driver to handle that
control. That could be the case e.g. for a web camera with flash in it.)
In case you have multiple flash chips they would be controlled
separately from each other through a different V4L2 subdev device node.

This would allow hardware which e.g. has two flash controllers connected
to a single sensor with strobe output, for example.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
