Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:15883 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1CUGIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 02:08:48 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIE00F5X9290R60@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Mar 2011 15:08:33 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIE00FUK9295K@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Mar 2011 15:08:33 +0900 (KST)
Date: Mon, 21 Mar 2011 15:08:33 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [PATCH] Add support for M-5MOLS 8 Mega Pixel camera
In-reply-to: <4D8503EC.6040103@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Kim HeungJun <riverful@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Reply-to: riverful.kim@samsung.com
Message-id: <4D86EB61.1010706@samsung.com>
Content-transfer-encoding: 8BIT
References: <1300282723-31536-1-git-send-email-riverful.kim@samsung.com>
 <4D84B183.7020709@gmail.com> <3985908C-2E67-4274-AA8F-E5F70745DED7@gmail.com>
 <4D8503EC.6040103@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

2011-03-20 오전 4:28, Sylwester Nawrocki 쓴 글:
> On 03/19/2011 04:11 PM, Kim HeungJun wrote:
>> Hi Sylwester,
>>
>> Thanks for the reviews. :)
>>
>> 2011. 3. 19., 오후 10:37, Sylwester Nawrocki 작성:
>>
>>> Hi HeungJun,
>>>
>>> On 03/16/2011 02:38 PM, Kim, Heungjun wrote:
>>>> Add I2C/V4L2 subdev driver for M-5MOLS camera sensor with integrated
>>>> image signal processor.
>>>>
[snip]
>>>>
>>>> 3. Speed-up whole I2C operation
>>>> 	: I've tested several times for decreasing the stabilization time
>>>> 	while I2C communication, and I have find proper time. Of course,
>>>> 	it's more faster than previous version.
>>>
>>> That sounds good. Do you think the delays before I2C read/write could
>>> be avoided in some (if not all) cases by using some status registers
>>> polling?
>> I don't understand literally. Could you explain more detailed with some examples?
>> My understanding is that it might be an issues or problem when getting some
>> status registers with polling it. is it right?
> 
> My concern is that we might not need an extra delay between consecutive 
> read or write operations in every case. Possibly it would be enough
> to read the status of some operations instead. But that just what I suspect.
Ah, I understand. The consecutive delay needs to read/write operations.
Because, in non-delay cases, I found the values is not changed to be read
when the driver is reading continuously at the different address. I means,
if there is not regular amount of delay in r/w operations, the value is kept
the previous value to be read by I2C operation. It's the same way in writing
case. It's wierd.

It might be different the kind of M-5MOLS sensor's FW and packaging type. But,
I expect that the internal ARM core of M-5MOLS takes time to proceed something
and to load values through I2C bus for the host process. 

Regards,
Heungjun Kim
