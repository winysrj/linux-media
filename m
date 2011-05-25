Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:48848 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1EYLa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 07:30:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LLR0086E1ACF1I0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 May 2011 20:30:27 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLR00A7W1ARXE@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 May 2011 20:30:27 +0900 (KST)
Date: Wed, 25 May 2011 20:30:26 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: I just wondering how to set shutter or aperture value in uvc
 driver.
In-reply-to: <201105251317.39393.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Reply-to: riverful.kim@samsung.com
Message-id: <4DDCE852.9030509@samsung.com>
References: <4DDCA67B.2060705@samsung.com>
 <201105251317.39393.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

2011-05-25 오후 8:17, Laurent Pinchart 쓴 글:
> Hi Heungjun,
> 
> On Wednesday 25 May 2011 08:49:31 Kim, HeungJun wrote:
>> Hi Laurent,
>>
>> I try to add the more exposure methods of the M-5MOLS driver. Currently,
>> the only 2 exposure type are available in the M-5MOLS driver -
>> V4L2_EXPOSURE_AUTO, V4L2_EXPOSURE_MANUAL. But, the HW is capable to shutter,
>> aperture exposure value, of course auto exposure.
>> So, I found the only UVC driver looks like using extra enumerations
>> V4L2_EXPOSURE_SHUTTER_PRIORITY, V4L2_EXPOSURE_APERTURE_PRIORITY.
>> But, I don't know how to set the each value in the each mode.
>>
>> The way pointed the specific value is only one -
>> V4L2_CID_EXPOSURE_ABSOLUTE. So, how can I set the specific value at the
>> each mode?
> 
> You can control the aperture using the V4L2_CID_IRIS_ABSOLUTE control. See 
> http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html#camera-
> controls for more information regarding the exposure and iris controls.
> 
Thanks for response, and I could understand this!
Sorry for pre-checking documents. :)

Regards,
Heungjun Kim
