Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZICLRp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:17:45 -0400
Message-ID: <4A9FA681.5070100@hhs.nl>
Date: Thu, 03 Sep 2009 13:20:33 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
References: <4A9E9E08.7090104@onelan.com> <4A9EAF07.3040303@hhs.nl> <4A9F89AD.7030106@onelan.com> <4A9F9006.6020203@hhs.nl> <4A9F98BA.3010001@onelan.com> <4A9F9C5F.9000007@onelan.com>
In-Reply-To: <4A9F9C5F.9000007@onelan.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil,

I think we have found a bug in the read() implementation of the cx18
driver, see below.


Hi all,

On 09/03/2009 12:37 PM, Simon Farnsworth wrote:
> Simon Farnsworth wrote:
>> Hans de Goede wrote:
>>> Ok,
>>>
>>> That was even easier then I thought it would be. Attached is a
>>> patch (against libv4l-0.6.1), which implements 1) and 3) from
>>> above.
>>>
>> I applied it to a clone of your HG repository, and had to make a
>> minor change to get it to compile. I've attached the updated patch.
>>
>> It looks like the read() from the card isn't reading entire frames
>> ata a time - I'm using a piece of test gear that I have to return in
>> a couple of hours to send colourbars to it, and I'm seeing bad
>> colour, and the picture moving across the screen. I'll try and chase
>> this, see whether there's something obviously wrong.
>>
> There is indeed something obviously wrong; at line 315 of libv4l2.c, we
> expand the buffer we read into, then ask for that many bytes.
>

Ah, actually this is a driver bug, not a libv4l2 bug, but I'll fix things
in libv4l to work around it for now.

read() should always return an entire frame (or as much of it as will fit
and throw away the rest). Think for example of jpeg streams, where the
exact size of the image isn't known by the client (as it differs from frame
to frame). dest_fmt.fmt.pix.sizeimage purely is an upper limit, and so
is the value passed in to read(), the driver itself should clamp it so
that it returns exactly one frame (for formats which are frame based).

The page alignment (2 pages on i386 / one on x86_64) is done because some
drivers internally use page aligned buffer sizes and thus for example with
jpeg streams, can have frames queued for read() slightly bigger then
dest_fmt.fmt.pix.sizeimage, but when this happens that is really a driver bug,
because as said dest_fmt.fmt.pix.sizeimage should report an upper limit
of the the frame sizes to be expected. I'll remove the align workaround, as
that bug is much less likely to be hit (and probably easier to fix at the
driver level) then the issue we're now seeing with read().

Regards,

Hans
