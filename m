Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56761 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbZHCNut (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Aug 2009 09:50:49 -0400
Message-ID: <4A76EC37.1030106@redhat.com>
Date: Mon, 03 Aug 2009 15:55:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	t.i.m@zen.co.uk
Subject: Re: RFC: distuingishing between hardware and emulated formats
References: <4A76A227.20503@redhat.com>    <200908031047.02633.laurent.pinchart@ideasonboard.com> <9e1cb4ce313ea28894136a17cba44628.squirrel@webmail.xs4all.nl>
In-Reply-To: <9e1cb4ce313ea28894136a17cba44628.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Laurent et all

On 08/03/2009 11:28 AM, Hans Verkuil wrote:
>> Hi Hans,
>>
>> On Monday 03 August 2009 10:39:03 Hans de Goede wrote:
>>> Hi All,
>>>
>>> The gstreamer folks have asked to add an API to libv4l2 so
>>> that they can distuingish between formats emulated by libv4l2
>>> and formats offered raw by the hardware.
>>>
>>> I think this is a usefull thing to do and I think this is best
>>> done by adding a new flag for the flags field of the
>>> v4l2_fmtdesc struct. So I would like to propose to add the
>>> following new flag to videodev2.h :
>>>
>>> #define V4L2_FMT_FLAG_EMULATED 0x0002
>>>
>>> And add the necessary documentation to the spec. The emulated term
>>> is what I've always been using in libv4l discussions for formats
>>> which are not offered native by the hardware but are offered by
>>> libv4l through conversion. If someone has a better name for the
>>> flag suggestions are welcome.
>
> Seems fine to me. I can't think of any objections.
>

Thanks for the feedback (thanks to Laurent too).

>> I'd go one step further and add a integer cost value instead of a flag.
>> The
>> purpose of distinguishes between native and emulated formats is to keep
>> the
>> end-to-end video cost (in terms of memory, CPU time, ...) as low as
>> possible.
>> If we later end up chaining several conversions in a row (JPEG ->  YUV ->
>> RGB
>> for instance, although that might be a bad example) a cost value will help
>> applications select the best format depending on their needs and
>> capabilities.
>>
>> For instance, imagine we "emulate" YUV with a quite low cost and RGB with
>> a
>> quite high cost. If the application can use both YUV and RGB (let's say
>> for
>> display purpose) with equal costs, it will still want to select YUV.
>>
>> Now, the million dollar question is, how do we evaluate the cost value
>> incurred by a software conversion algorithm ?
>
> I don't think we should attempt to do things like this. I don't believe
> there is a need for it, and even if there is, then we really have no idea
> on how to represent such a cost. Having an emulated flag makes a lot of
> sense, but attempting to go any further with this seems premature at the
> least.
>

Hmm, Laurent does have an interesting point. For example many uvc cams
have a native format which is packed yuv, but gstreamer prefers planar yuv,
now if we can explain the cost of using planar instead of the native packed,
hmm then again the emulated flag handles this case just fine. Thinking of it
this actually was the reason for the gstreamer folks request to have such a flag.

Now that still leaves the case were the app can take either yuv420 planar
or rgb, and we come from packedyuv, then clearly from a conversion cost pov
going to planaryuv is cheaper. But how much cheaper is cheaper ??

I've to side with Hans on this one, lets just do the flag, that is a big step
forward, doing more seems overkill, but more importantly will probably get
messy pretty quickly.

Regards,

Hans

p.s.

>>> If you read this and even if your only thoughts are: seems ok to me,
>>> please reply saying so. It is very frustrating to suggest API additions
>>> and not get any feedback.
>> Indeed. I'll remember that comment next time I send an RFC to linux-media
>> and
>> I'll of course expect you to answer ;-)
>>

hehe
