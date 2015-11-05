Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57536 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030521AbbKEJFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2015 04:05:51 -0500
Subject: Re: [Y2038] Which type to use for timestamps: u64 or s64?
To: Arnd Bergmann <arnd@arndb.de>
References: <563B0817.2060508@xs4all.nl> <10717379.s8aWAKUxAs@wuerfel>
Cc: y2038@lists.linaro.org, Junghak Sung <jh1009.sung@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <563B1BE8.8090007@xs4all.nl>
Date: Thu, 5 Nov 2015 10:05:44 +0100
MIME-Version: 1.0
In-Reply-To: <10717379.s8aWAKUxAs@wuerfel>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/05/15 09:36, Arnd Bergmann wrote:
> On Thursday 05 November 2015 08:41:11 Hans Verkuil wrote:
>> Hi Arnd,
>>
>> We're redesigning the timestamp handling in the video4linux subsystem moving away
>> from struct timeval to a single timestamp in ns (what ktime_get_ns() gives us).
>> But I was wondering: ktime_get_ns() gives a s64, so should we use s64 as well as
>> the timestamp type we'll eventually be returning to the user, or should we use u64?
>>
>> The current patch series we made uses a u64, but I am now beginning to doubt that
>> decision.
> 
> I would lean towards u64, but I don't think it really matters either way,
> especially since all the drivers should be using monotonic timestamps now.

One thing that might be easier if it is a s64 is when adding/subtracting offsets
from the timestamp. And the other reason is that a u64 gives a false view of the
underlying type. With a s64 it is clear that a timestamp will wrap around after
292 years instead of double that. Admittedly, not our problem, but if we ever send
a space probe to Alpha Centauri, then it might be nice to know as application
developer that you need to take special measures if the mission takes longer than
292 years :-)

Regards,

	Hans
