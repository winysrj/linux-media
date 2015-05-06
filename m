Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38687 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbbEFQIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 12:08:09 -0400
Message-ID: <554A3A09.9050208@xs4all.nl>
Date: Wed, 06 May 2015 17:58:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: y2038@lists.linaro.org, Kamil Debski <k.debski@samsung.com>,
	linux-samsung-soc@vger.kernel.org, mchehab@osg.samsung.com,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	kyungmin.park@samsung.com, thomas@tommie-lie.de,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com
Subject: Re: [Y2038] [PATCH v4 06/10] cec: add HDMI CEC framework: y2038 question
References: <1429794192-20541-1-git-send-email-k.debski@samsung.com> <553DE7EB.6090900@xs4all.nl> <554722EC.3060301@xs4all.nl> <4726638.QZKcRc97FC@wuerfel>
In-Reply-To: <4726638.QZKcRc97FC@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On 05/04/2015 12:14 PM, Arnd Bergmann wrote:
> On Monday 04 May 2015 09:42:36 Hans Verkuil wrote:
>> Ping! (Added Arnd to the CC list)
> 
> Hi Hans,
> 
> sorry I missed this the first time
> 
>> On 04/27/2015 09:40 AM, Hans Verkuil wrote:
>>> Added the y2038 mailinglist since I would like to get their input for
>>> this API.
>>>
>>> Y2038 experts, can you take a look at my comment in the code below?
>>>
>>> Thanks!
>>
>> Arnd, I just saw your patch series adding struct __kernel_timespec to
>> uapi/linux/time.h. I get the feeling that it might take a few kernel
>> cycles before we have a timespec64 available in userspace. Based on that
>> I think this CEC API should drop the timestamps for now and wait until
>> timespec64 becomes available before adding it.
>>
>> The timestamps are a nice-to-have, but not critical. So adding it later
>> shouldn't be a problem. What is your opinion?
> 
> It will take a little while for the patches to make it in, I would guess
> 4.3 at the earliest. Using your own struct works just as well and would
> be less ambiguous.
> 
> However, for timestamps, I would recommend not using timespec anyway.
> Instead, just use a single 64-bit nanosecond value from ktime_get_ns()
> (or ktime_get_boot_ns() if you need a time that keeps ticking across
> suspend). This is more efficient to get and simpler to use as long
> as you don't need to convert from nanosecond to timespec.

Possibly stupid follow-up question:

is ktime_get_ns() just a different representation as ktime_get_ts64()?

Or is there some offset between the two? They seem to be identical based
on a quick test, but I'd like to be certain that that's always the case.

Users need to be able to relate this timestamp to a struct timespec as
returned by V4L2 (and others).

Thanks!

	Hans
