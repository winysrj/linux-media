Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22317 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab1LGKcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 05:32:41 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVT00CV0XAF4R@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2011 10:32:39 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVT001T8XAEZN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2011 10:32:39 +0000 (GMT)
Date: Wed, 07 Dec 2011 11:32:38 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH 0/5] v4l: New camera controls
In-reply-to: <201112061334.45936.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, riverful.kim@samsung.com
Message-id: <4EDF40C6.3010900@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
 <201112061334.45936.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/06/2011 01:34 PM, Laurent Pinchart wrote:
> On Sunday 04 December 2011 16:16:11 Sylwester Nawrocki wrote:
>> Hi All,
>>
>> I put some effort in preparing a documentation for a couple of new controls
>> in the camera control class. It's a preeliminary work, it's mainly just
>> documentation. There is yet no patches for any driver using these controls.
>> I just wanted to get some possible feedback on them, if this sort of stuff
>> is welcome and what might need to be done differently.
> 
> Thanks for the patches.
> 
> Regarding patches 3/5, 4/5 and 5/5, we should perhaps try to brainstorm this a 
> bit. There's more to exposure setting than just those controls, maybe it's 
> time to think about a proper exposure API. We could start by gathering 
> requirements on the list, and maybe have an IRC meeting if needed.

Certainly the existing support for exposure setting in V4L2 is not sufficient
even for mobile camera control. I'll try to prepare a list of requirements.
It would be great to have a brainstorming session with more people experienced
in this field.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
