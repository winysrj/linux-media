Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway02.websitewelcome.com ([69.56.216.20]:34750 "EHLO
	gateway02.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584AbaBEVoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 16:44:23 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway02.websitewelcome.com (Postfix) with ESMTP id EB8B358CFF7F1
	for <linux-media@vger.kernel.org>; Wed,  5 Feb 2014 15:44:19 -0600 (CST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Feb 2014 15:44:19 -0600
From: Dean Anderson <linux-dev@sensoray.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [PATCH] s2255drv: port to videobuf2
In-Reply-To: <52F0BB3E.2060601@xs4all.nl>
References: <1391189745-11398-1-git-send-email-linux-dev@sensoray.com>
 <52EF66A4.30401@xs4all.nl> <4019df5ff7ddbc7945122a7a571ed57b@sensoray.com>
 <52F0BB3E.2060601@xs4all.nl>
Message-ID: <9f20eef936bc930aeba88ff784f4bae0@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-02-04 04:04, Hans Verkuil wrote:
> Hi Dean,
> 
> On 02/03/14 18:06, Dean Anderson wrote:
>> On 2014-02-03 03:51, Hans Verkuil wrote:
>>> Hi Dean,
>>> 
>>> Some specific comments below, but first two general comments:
>>> 
>>> It is easier to review if at least the removal of the old s2255_fh 
>>> struct
>>> was done as a separate patch. It's always good to try and keep the 
>>> changes
>>> in patches as small as possible. The actual vb2 conversion is always 
>>> a
>>> 'big bang' patch, that's unavoidable, but it's easier if it isn't 
>>> mixed in
>>> with other changes that are not directly related to the vb2 
>>> conversion.
>> 
>> 
>> I figured removal of s2255_fh was a natural part of the videobuf2 
>> conversion process, but I can break it up.
> 
> It's more like the first phase of a vb2 conversion. It really is wrong
> for videobuf as well, so it makes sense to do that first.
> 
>> I also did change some formatting and naming changes (s2255_channel 
>> to s2255_vc) that can be postponed.
> 
> Just put it in a separate patch either before or after the patch that 
> does
> the vb2 conversion.
> 
>> 
>>> 
>>> And did you also run the v4l2-compliance utility for this driver? 
>>> That's
>>> useful to check that everything it still correct.
>> 
>> Thanks for the comments.  I'll do a v2 soon with v4l2-compliance 
>> fully tested too.
> 
> Rather than the standard v4l2-compliance from v4l-utils, can you use 
> this
> from my own tree:
> 
> http://git.linuxtv.org/hverkuil/v4l-utils.git/shortlog/refs/heads/streaming
> 
> I've started work to add tests for streaming to v4l2-compliance. While 
> not
> complete it should cover what the s2255 driver needs. I'm very 
> interested
> in what it finds (or, as the case might be, what it doesn't find).
> 
> In order to do the streaming tests you have to run it with option -s.
> 

The current driver before the videobuf2 patch has 3 errors and 8 
warnings with option "-s".  The warnings are "msg5650" warnings that 
will break existing applications if fixed.

Here's what is causing at least two of the errors (the other is 
unsupported USERPTR, which will be fixed in VB2):

Vidioc_reqbufs calls videobuf_reqbufs, which returns a fail if 
req->count = 0.

IE:

if (req->count < 1) {
	dprintk(1, "reqbufs: count invalid (%d)\n", req->count);
	return -EINVAL;
}

Are drivers using videobuf required to check if 
v4l2_requestbuffers->count == 0 before calling videobuf_reqbufs? That 
seems unlikely and inefficient, so this could be an issue with 
videobuf-core.c..

Thanks,






> Regards,
> 
> 	Hans
