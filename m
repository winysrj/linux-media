Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab2HNIPB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 04:15:01 -0400
Message-ID: <502A093F.9040608@redhat.com>
Date: Tue, 14 Aug 2012 10:15:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: workshop-2011@linuxtv.org, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
References: <201208131427.56961.hverkuil@xs4all.nl> <5028FD7E.1010402@redhat.com> <5403829.BeBAZV71c8@avalon>
In-Reply-To: <5403829.BeBAZV71c8@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/14/2012 02:00 AM, Laurent Pinchart wrote:
> Hi Hans,
>
> On Monday 13 August 2012 15:13:34 Hans de Goede wrote:
>
> [snip]
>
>>> 4) What should a driver return in TRY_FMT/S_FMT if the requested format is
>>>      not supported (possible behaviours include returning the currently
>>>      selected format or a default format).
>>>
>>>      The spec says this: "Drivers should not return an error code unless
>>>      the input is ambiguous", but it does not explain what constitutes an
>>>      ambiguous input. Frankly, I can't think of any and in my opinion
>>>      TRY/S_FMT should never return an error other than EINVAL (if the
>>>      buffer type is unsupported) or EBUSY (for S_FMT if streaming is in
>>>      progress).
>>>
>>>      Returning an error for any other reason doesn't help the application
>>>      since the app will have no way of knowing what to do next.
>>
>> Ack on not returning an error for requesting an unavailable format. As for
>> what the driver should do (default versus current format) I've no
>> preference, I vote for letting this be decided by the driver
>> implementation.
>
> That's exactly the point that I wanted to clarify :-) I don't see a good
> reason to let the driver decide on this, and would prefer returning a default
> format

I see.

> as TRY_FMT would then always return the same result for a given input
> format regardless of the currently selected format.

That argument makes sense, so ack from me on always returning a default format.

Regards,

Hans
