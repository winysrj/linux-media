Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:18153 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab1BXLLE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 06:11:04 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH40092PBQIZG90@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Feb 2011 19:56:42 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH40023YBQICC@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Feb 2011 19:56:42 +0900 (KST)
Date: Thu, 24 Feb 2011 19:56:42 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH 0/2] v4l2-ctrls: add new focus mode
In-reply-to: <201102241149.48831.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D66396A.509@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D6636B9.4020105@samsung.com>
 <201102241149.48831.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

First, Thanks to reply.

I commented below.

2011-02-24 오후 7:49, Laurent Pinchart 쓴 글:
> Hi,
> 
> On Thursday 24 February 2011 11:45:13 Kim, HeungJun wrote:
>> Hello,
>>
>> I faced to the absence of the mode of v4l2 focus for a couple of years.
>> While dealing with some few morebile camera sensors, the focus modes
>> are needed more than the current v4l2 focus mode, like a Macro &
>> Continuous mode. The M-5MOLS camera sensor I dealt with, also support
>> these 2 modes. So, I'm going to suggest supports of more detailed
>> v4l2 focus mode.
>>
>> This RFC series of patch adds new auto focus modes, and documents it.
>>
>> The first changes the boolean type of V4L2_CID_FOCUS_AUTO to menu type,
>> and insert menus 4 enumerations:
>>
>> V4L2_FOCUS_AUTO,
>> V4L2_FOCUS_MACRO,
>> V4L2_FOCUS_MANUAL,
>> V4L2_FOCUS_CONTINUOUS
>>
>> The recent mobile camera sensors with ISP supports Macro & Continuous Auto
>> Focus aka CAF mode, of course normal AUTO mode, even Continuous mode.
> 
> I'm curious, what sensor are you referring to ?
Yes. The Fujitsu M-5MO LS sensor supports these modes. And, actually NEC
CE147 sensor also support Macro Focus mode, not includeing CAF mode.

The current Samsung Galaxy S phone use same sensor(M-5MO) too. 
and these mobile phone's camera suport Macro Focus mode.


Regards,
Heungjun Kim
