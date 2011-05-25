Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:46389 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab1EYGvA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 02:51:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LLQ008VIOCPF170@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 May 2011 15:50:59 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLQ00IHKOCZKB@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 May 2011 15:50:59 +0900 (KST)
Date: Wed, 25 May 2011 15:50:58 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: I just wondering how to set shutter or aperture value in uvc
 driver.
In-reply-to: <4DDCA67B.2060705@samsung.com>
To: riverful.kim@samsung.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4DDCA6D2.1050307@samsung.com>
References: <4DDCA67B.2060705@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

missing. sorry :)

2011-05-25 오후 3:49, Kim, HeungJun 쓴 글:
> Hi Laurent,
> 
> I try to add the more exposure methods of the M-5MOLS driver. Currently,
> the only 2 exposure type are available in the M-5MOLS driver -
> V4L2_EXPOSURE_AUTO, V4L2_EXPOSURE_MANUAL. But, the HW is capable to 

the HW is capable to shutter, aperture exposure value, of course auto exposure. 
 
> 
> So, I found the only UVC driver looks like using extra enumerations
> V4L2_EXPOSURE_SHUTTER_PRIORITY, V4L2_EXPOSURE_APERTURE_PRIORITY.
> But, I don't know how to set the each value in the each mode.
> 
> The way pointed the specific value is only one - V4L2_CID_EXPOSURE_ABSOLUTE.
> So, how can I set the specific value at the each mode?
> 
> 
> Regards,
> Heungjun Kim

