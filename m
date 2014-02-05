Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4245 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaBEHRX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 02:17:23 -0500
Message-ID: <52F1E56B.50602@xs4all.nl>
Date: Wed, 05 Feb 2014 08:16:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Dean Anderson <linux-dev@sensoray.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] s2255drv: file handle cleanup
References: <1391553393-17672-1-git-send-email-linux-dev@sensoray.com> <13a909e44a406b9b9e54c6941d853e7f@sensoray.com>
In-Reply-To: <13a909e44a406b9b9e54c6941d853e7f@sensoray.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2014 12:10 AM, Dean Anderson wrote:
> Hi Hans,
> 
> Please ignore and reject this patch. videobuf_queue_vmalloc_init needs 
> to be in probe, not in open.
> 
> Let me know your thoughts on doing videobuf2 before s2255_fh removal so 
> we don't have to work around or fix videobuf version one's deficiencies.

What I have done in the past w.r.t. vb2 conversions is to move fields
out of the fh struct where it is possible without breaking videobuf, then
when I do the final vb2 conversion I drop the fh struct completely.

As you mentioned before, the resources field can't really be dropped
until the vb2 conversion, but it simplifies matters if the rest is moved
out first. The end result of a vb2 conversion is great, but the actual
patch is a pain to review :-)

Now that I am adding streaming tests in v4l2-compliance I am hoping that
it will be easier to verify correctness in the future, something that
really hasn't been possible.

Regards,

	Hans

> 
> Thanks,
> 
> 
> 
> 
> On 2014-02-04 16:36, Dean Anderson wrote:
>> Removes most parameters from s2255_fh.  These elements belong in 
>> s2255_ch.
>> In the future, s2255_fh will be removed when videobuf2 is used. 
>> videobuf2
>> has convenient and safe functions for locking streaming resources.
>>
>> The removal of s2255_fh (and s2255_fh->resources) was not done now to
>> avoid using videobuf_queue_is_busy.
>>
>> videobuf_queue_is busy may be unsafe as noted by the following comment
>> in videobuf-core.c:
>> "/* Locking: Only usage in bttv unsafe find way to remove */"
>>
>> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
>> ---

