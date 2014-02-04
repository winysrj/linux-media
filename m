Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1096 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaBDKIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 05:08:11 -0500
Message-ID: <52F0BB3E.2060601@xs4all.nl>
Date: Tue, 04 Feb 2014 11:04:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Dean Anderson <linux-dev@sensoray.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] s2255drv: port to videobuf2
References: <1391189745-11398-1-git-send-email-linux-dev@sensoray.com> <52EF66A4.30401@xs4all.nl> <4019df5ff7ddbc7945122a7a571ed57b@sensoray.com>
In-Reply-To: <4019df5ff7ddbc7945122a7a571ed57b@sensoray.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dean,

On 02/03/14 18:06, Dean Anderson wrote:
> On 2014-02-03 03:51, Hans Verkuil wrote:
>> Hi Dean,
>>
>> Some specific comments below, but first two general comments:
>>
>> It is easier to review if at least the removal of the old s2255_fh struct
>> was done as a separate patch. It's always good to try and keep the changes
>> in patches as small as possible. The actual vb2 conversion is always a
>> 'big bang' patch, that's unavoidable, but it's easier if it isn't mixed in
>> with other changes that are not directly related to the vb2 conversion.
> 
> 
> I figured removal of s2255_fh was a natural part of the videobuf2 conversion process, but I can break it up.

It's more like the first phase of a vb2 conversion. It really is wrong
for videobuf as well, so it makes sense to do that first.

> I also did change some formatting and naming changes (s2255_channel to s2255_vc) that can be postponed.

Just put it in a separate patch either before or after the patch that does
the vb2 conversion.

> 
>>
>> And did you also run the v4l2-compliance utility for this driver? That's
>> useful to check that everything it still correct.
> 
> Thanks for the comments.  I'll do a v2 soon with v4l2-compliance fully tested too.

Rather than the standard v4l2-compliance from v4l-utils, can you use this
from my own tree:

http://git.linuxtv.org/hverkuil/v4l-utils.git/shortlog/refs/heads/streaming

I've started work to add tests for streaming to v4l2-compliance. While not
complete it should cover what the s2255 driver needs. I'm very interested
in what it finds (or, as the case might be, what it doesn't find).

In order to do the streaming tests you have to run it with option -s.

Regards,

	Hans

