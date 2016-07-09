Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35338 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbcGIS4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 14:56:22 -0400
Received: by mail-pa0-f66.google.com with SMTP id dx3so10106560pab.2
        for <linux-media@vger.kernel.org>; Sat, 09 Jul 2016 11:56:21 -0700 (PDT)
Subject: Re: [PATCH 02/11] Revert "[media] adv7180: fix broken standards
 handling"
To: Lars-Peter Clausen <lars@metafoo.de>, linux-media@vger.kernel.org
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-3-git-send-email-steve_longerbeam@mentor.com>
 <577E7924.9070301@metafoo.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <578148D3.3080504@gmail.com>
Date: Sat, 9 Jul 2016 11:56:19 -0700
MIME-Version: 1.0
In-Reply-To: <577E7924.9070301@metafoo.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/07/2016 08:45 AM, Lars-Peter Clausen wrote:
> On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
>> Autodetect was likely broken only because access to the
>> interrupt registers were broken, so there were no standard
>> change interrupts. After fixing that, and reverting this,
>> autodetect seems to work just fine on an i.mx6q SabreAuto.
>>
>> This reverts commit 937feeed3f0ae8a0389d5732f6db63dd912acd99.
> The brokenness the commit refers to is conceptual not functional. The driver
> simply implemented the API incorrect. A subdev driver is not allowed to
> automatically switch the output format/resolution randomly. In the best case
> this will confuse the receiver which is not prepared to receive the changed
> resolution, in the worst case it will cause buffer overruns with hardware
> that has no boundary checks. This is why this was removed from the driver.
>
> The correct sequence is for the driver to generate a change notification and
> then have userspace react to that notification by stopping the current
> stream, query the new format/resolution, reconfigure the video pipeline for
> the new format/resolution and re-start the stream.

Hi Lars, ok thanks for the clarification. Yes I agree that makes sense.
I will undo the revert in the next version and retest.

Steve

