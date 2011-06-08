Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:19663 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1FHKR4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 06:17:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LMG00MD6V9TEPW0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 19:17:54 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LMG00APPV9UJ8@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 19:17:54 +0900 (KST)
Date: Wed, 08 Jun 2011 19:17:53 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFCv2 PATCH 08/11] v4l2-ctrls: simplify event subscription.
In-reply-to: <20110606100534.GI6073@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4DEF4C51.3090302@samsung.com>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
 <2993c04b0ba330b3f634e281a6b50ee8cd7e6f7c.1306329390.git.hans.verkuil@cisco.com>
 <201106032155.10808.laurent.pinchart@ideasonboard.com>
 <201106041228.04249.hverkuil@xs4all.nl>
 <20110606100534.GI6073@valkosipuli.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011-06-06 오후 7:05, Sakari Ailus 쓴 글:
> On Sat, Jun 04, 2011 at 12:28:04PM +0200, Hans Verkuil wrote:
>> On Friday, June 03, 2011 21:55:10 Laurent Pinchart wrote:
> [clip]
>>>> +{
>>>> +	int ret = 0;
>>>> +
>>>> +	if (!fh->events)
>>>> +		ret = v4l2_event_init(fh);
>>>> +	if (!ret)
>>>> +		ret = v4l2_event_alloc(fh, n);
>>>> +	if (!ret)
>>>> +		ret = v4l2_event_subscribe(fh, sub);
>>>
>>> I tend to return errors when they occur instead of continuing to the end of 
>>> the function. Handling errors on the spot makes code easier to read in my 
>>> opinion, as I expect the main code flow to be the error-free path.
>>
>> Hmmm, I rather like the way the code looks in this particular case. But it;s
>> no big deal and I can change it.
> 
> The M5MOLS driver uses this pattern extensively in I2C access error
> handling. I agree with Laurent in principle, but on the other hand I think
> using this pattern makes sense. The error handling takes much less code and
> the test for continuing always is "if (!ret)" it is relatively readable as
> well. 
> 
> I'm fine with either resolution.
Actually, this pattern was advice from Hans for the M-5MOLS reviews at past,
and it's very helpful and I satisfied mostly.

Also, I was testing or using both this usage and the other one for a while,
and as a result, I figured out which is good choice between continueing to the end
of the function and return imediately, depends on various situation.

Consequently, IMHO, both usgaes are fine, but if the checking factor like (!ret),
changes the other one like (!flag) not ret, then it looks better to return
immediately, or the other handling methods, not using continueing to check error
at the end.

Regards,
Heungjun Kim

