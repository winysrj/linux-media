Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:44632 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1EaGiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 02:38:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LM100DQVRQ374L0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 May 2011 15:38:23 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LM100LHSRRZ5L@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 May 2011 15:38:23 +0900 (KST)
Date: Tue, 31 May 2011 15:38:26 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: v4l2 device property framework in userspace
In-reply-to: <4DE38872.9090501@section5.ch>
To: Martin Strubel <hackfin@section5.ch>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Reply-to: riverful.kim@samsung.com
Message-id: <4DE48CE2.4010401@samsung.com>
References: <4DE244F4.90203@section5.ch>
 <201105300932.59570.hverkuil@xs4all.nl> <4DE365A8.9050508@section5.ch>
 <322765c00a668d7915214de27d3debe7.squirrel@webmail.xs4all.nl>
 <4DE38872.9090501@section5.ch>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

I'm not an expert of V4L2 and this camera sensor, too.
But, if you don't mind, I want to leave some comments about the registers,
and I hope that it helps you.

2011-05-30 오후 9:07, Martin Strubel 쓴 글:
> Hi Hans,
> 
>>
>> Can you give examples of the sort of things that are in those registers?
>> Is that XML file available somewhere? Are there public datasheets?
>>
> 
> If you mean the sensor datasheets, many of them are buried behind NDAs,
> but people are writing opensourced headers too...let's leave this to the
> lawyers.
> 
> Here's an example: http://section5.ch/downloads/mt9d111.xml
> The XSLT sheets to generate code from it are found in the netpp
> distribution, see http://www.section5.ch/netpp. You might have to read
> some of the documentation to get to the actual clues.
As you said, obviously this camera has a lot of registers.
But, IMHO, even it can be expressed by one subdev driver like any other ones.
Almost registers can be absorbed and adapted at the start(or booting) time.
And the most others also can be defined at the current V4L2 APIs.
(like controls, croppings, buffers, powers, etc)

The matter is to find which factor can vary, when the camera setting is varied
by the board as you said. And in just my short thinking, this is not much to
catch. If there are such things, not expressed using current V4L2 APIs, but
needed for your works or your board, you can submit this APIs to ML.

The best thing is, you collect such things(it can be express current V4L2 APIs),
and submit new V4L2 APIs, because there are many other people handling camera
driver like you, and they can think similary like you.
For sure, they can welcome to birth new APIs.


Cheers,
Heungjun Kim
