Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2HMO53 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 10:57:29 -0400
Message-ID: <50291613.1090101@redhat.com>
Date: Mon, 13 Aug 2012 16:58:27 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
References: <201208131427.56961.hverkuil@xs4all.nl> <5028FD7E.1010402@redhat.com> <201208131652.11182.hverkuil@xs4all.nl>
In-Reply-To: <201208131652.11182.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/13/2012 04:52 PM, Hans Verkuil wrote:
> On Mon August 13 2012 15:13:34 Hans de Goede wrote:
>> Hi,
>>
>> <snip>
>>
>>> 5) How to handle tuner ownership if both a video and radio node share the same
>>>      tuner?
>>>
>>>      Obvious rules:
>>>
>>>      - Calling S_FREQ, S_TUNER, S_MODULATOR or S_HW_FREQ_SEEK will change owner
>>>        or return EBUSY if streaming is in progress.
>>
>> That won't work, as there is no such thing as streaming from a radio node,
>
> There is, actually: read() for RDS data and alsa streaming (although that might
> be hard to detect in the case of USB audio).
>
>> I suggest we go with the simple approach we discussed at our last meeting in
>> your Dutch House: Calling S_FREQ, S_TUNER, S_MODULATOR or S_HW_FREQ_SEEK will
>> make an app the tuner-owner, and *closing* the device handle makes an app
>> release its tuner ownership. If an other app already is the tuner owner
>> -EBUSY is returned.
>
> So the ownership is associated with a filehandle?

Yes, that is how it works for videobuf streams too, right? The only difference
being that with videobuf streams there is an expilict way to release the ownership,
where as for tuner ownership there is none, so the ownership is released on device
close.

>
>>
>>>      - Ditto for STREAMON, read/write and polling for read/write.
>>
>> No, streaming and tuning are 2 different things, if an app does both, it
>> will likely tune before streaming, but in some cases a user may use a streaming
>> only app together with say v4l2-ctl to do the actual tuning. I think keeping
>> things simple here is key. Lets just treat the "tuner" and "stream" as 2 separate
>> entities with a separate ownership.
>
> That would work provided the ownership is associated with a filehandle.

Right.

>
>>
>>>      - Ditto for ioctls that expect a valid tuner configuration like QUERYSTD.
>>
>> QUERY is a read only ioctl, so it should not be influenced by any ownership, nor
>> imply ownership.
>
> It is definitely influenced by ownership, since if the tuner is in radio mode,
> then it can't detect a standard. Neither is this necessarily a passive call as
> some (mostly older) drivers need to switch the receiver to different modes in
> order to try and detect the current standard.

Hmm, then I guess that this call should fail with EBUSY if:
The tuner is owned by another app *and*
1) The tuner is in radio mode; or
2) The tuner is in tv mode *and* doing QUERYSTD requires "prodding" the device

<snip>

Regards,

Hans
