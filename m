Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50007 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1HTVKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 17:10:31 -0400
Received: by ewy4 with SMTP id 4so1480262ewy.19
        for <linux-media@vger.kernel.org>; Sat, 20 Aug 2011 14:10:30 -0700 (PDT)
Message-ID: <4E5022C2.2000705@gmail.com>
Date: Sat, 20 Aug 2011 23:10:26 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFC: Negotiating frame buffer size between sensor subdevs and
 bridge devices
References: <4E31968B.9080603@samsung.com> <20110816222512.GF7436@valkosipuli.localdomain> <Pine.LNX.4.64.1108171942480.2773@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108171942480.2773@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/17/2011 07:43 PM, Guennadi Liakhovetski wrote:
> On Wed, 17 Aug 2011, Sakari Ailus wrote:
>> On Thu, Jul 28, 2011 at 07:04:11PM +0200, Sylwester Nawrocki wrote:
...
>>> In order to let the host drivers query or configure subdevs with required
>>> frame buffer size one of the following changes could be done at V4L2 API:
>>>
>>> 1. Add a 'sizeimage' field in struct v4l2_mbus_framefmt and make subdev
>>>   drivers optionally set/adjust it when setting or getting the format with
>>>   set_fmt/get_fmt pad level ops (and s/g_mbus_fmt ?)
>>>   There could be two situations:
>>>   - effective required frame buffer size is specified by the sensor and the
>>>     host driver relies on that value when allocating a buffer;
>>>   - the host driver forces some arbitrary buffer size and the sensor performs
>>>     any required action to limit transmitted amount of data to that amount
>>>     of data;
>>> Both cases could be covered similarly as it's done with VIDIOC_S_FMT.
>>>
>>> Introducing 'sizeimage' field is making the media bus format struct looking
>>> more similar to struct v4l2_pix_format and not quite in line with media bus
>>> format meaning, i.e. describing data on a physical bus, not in the memory.
>>> The other option I can think of is to create separate subdev video ops.
>>> 2. Add new s/g_sizeimage subdev video operations
...
>> I prefer this second approach over the first once since the maxiumu size of
>> the image in bytes really isn't a property of the bus.
> 
> Call that field framesamples and already it fits quite well with the
> notion of data on the bus and not in memory. Wouldn't this work?

Hmm...that might be exactly what we need.
That was also an initial Hans' proposal when we recently discussed it.

At least such an information should be sufficient for handling JPEG, where 
the effective buffer size might be calculated from a media bus pixel code
and a number of samples per frame.

--
Regards,
Sylwester
