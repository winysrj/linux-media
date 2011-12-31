Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62016 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1LaMDa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:03:30 -0500
Received: by eekc4 with SMTP id c4so14252766eek.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 04:03:29 -0800 (PST)
Message-ID: <4EFEFA08.805@gmail.com>
Date: Sat, 31 Dec 2011 13:03:20 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: v4l: how to get blanking clock count?
References: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com> <20111230213301.GA3677@valkosipuli.localdomain> <CAHG8p1ACi7CGFEBVaSr5G1cUMqtH8wX2mRY6n1yKF8TqgJ0oYw@mail.gmail.com> <20111231113529.GC3677@valkosipuli.localdomain>
In-Reply-To: <20111231113529.GC3677@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 12/31/2011 12:35 PM, Sakari Ailus wrote:
> On Sat, Dec 31, 2011 at 02:57:31PM +0800, Scott Jiang wrote:
>> 2011/12/31 Sakari Ailus <sakari.ailus@iki.fi>:
>>> On Fri, Dec 30, 2011 at 03:20:43PM +0800, Scott Jiang wrote:
>>>> Our bridge driver needs to know line clock count including active
>>>> lines and blanking area.
>>>> I can compute active clock count according to pixel format, but how
>>>> can I get this in blanking area in current framework?
>>>
>>> Such information is not available currently over the V4L2 subdev interface.
>>> Please see this patchset:
>>>
>>> <URL:http://www.spinics.net/lists/linux-media/msg41765.html>
>>>
>>> Patches 7 and 8 are probably the most interesting for you. This is an RFC
>>> patchset so the final implementation could well still change.
>>>
>> Hi Sakari,
>>
>> Thanks for your reply. Your patch added VBLANK and HBLANK control, but
>> my case isn't a user control.
>> That is to say, you can't specify a blanking control value for sensor.
> 
> I the case of your bridge, that may not be possible, but that's the only one
> I've heard of so I think it's definitely a special case. In that case the
> sensor driver can't be allowed to change the blanking periods while
> streaming is ongoing.

I agree, it's just a matter of adding proper logic at the sensor driver.
However it might be a bit tricky, the bridge would have to validate blanking
values before actually enabling streaming.

> framesamples proposed by Sylwester for v4l2_mbus_framefmt could, and
> probably should, be exposed as a control with similar property.

Yeah, I'm going to try to add it to your proposed image source control
class.

>> And you added pixel clock rate in mbus format, I think if I add two
>> more parametres such as VBLANK lines and HBLANK clocks I can solve
>> this problem. In fact, active lines and blanking lines are essential
>> params to define an image.
> 
> Only the active lines and rows are, blanking period is just an idle period
> where no image data is transferred. It does not affect the resulting image
> in any way.

--
Regards,
Sylwester
