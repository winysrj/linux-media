Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37822 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab1LNNeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 08:34:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW7008664D35I60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 13:34:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW7007J74D3JD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 13:34:15 +0000 (GMT)
Date: Wed, 14 Dec 2011 14:34:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 1/2] v4l: Add new alpha component control
In-reply-to: <201112131318.54709.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	m.szyprowski@samsung.com, jonghun.han@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4EE8A5D6.4030408@samsung.com>
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com>
 <201111291958.48671.laurent.pinchart@ideasonboard.com>
 <4EE083D2.3010102@samsung.com> <201112131318.54709.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 12/13/2011 01:18 PM, Hans Verkuil wrote:
>> are you going to carry on with the control range update patches ?
>> I'd like to push the alpha colour control for v3.3 but it depends
>> on the controls framework updates now.
> 
> Good question. I am not sure whether this is something we actually want. It 
> would make applications much harder to write if the range of a control can 
> suddenly change.
> 
> On the other hand, it might be a good solution for a harder problem which is 
> as yet unsolved: if you have multiple inputs, and each input has a different 
> set of controls (e.g. one input is a SDTV receiver, the other is a HDTV 
> receiver), then you can have the situation where e.g. the contrast control is 
> present for both inputs, but with a different range. Switching inputs would 
> then generate a control event telling the app that the range changed.
> 
> But this may still be overkill...

Hmm, it doesn't look like an overkill to me. I'm certain there will be use
cases where control range update is needed. Maybe we could specify in
the API in what circumstances the control range update is allowed for drivers.
So not all applications need to handle the related events.

Nevertheless I won't be pushing on this, not to mess around in the whole
API because of some embedded systems requirements.
So I'm going to update the range for alpha control manually in the driver
for the time being.

> 
> In other words, I don't know. Not helpful, I agree.

That was helpful anyway :-) Thanks.

-- 

Regards,
Sylwester
