Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35111 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1EYLRZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 07:17:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: riverful.kim@samsung.com
Subject: Re: I just wondering how to set shutter or aperture value in uvc driver.
Date: Wed, 25 May 2011 13:17:38 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <4DDCA67B.2060705@samsung.com>
In-Reply-To: <4DDCA67B.2060705@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105251317.39393.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Heungjun,

On Wednesday 25 May 2011 08:49:31 Kim, HeungJun wrote:
> Hi Laurent,
> 
> I try to add the more exposure methods of the M-5MOLS driver. Currently,
> the only 2 exposure type are available in the M-5MOLS driver -
> V4L2_EXPOSURE_AUTO, V4L2_EXPOSURE_MANUAL. But, the HW is capable to shutter,
> aperture exposure value, of course auto exposure.
> So, I found the only UVC driver looks like using extra enumerations
> V4L2_EXPOSURE_SHUTTER_PRIORITY, V4L2_EXPOSURE_APERTURE_PRIORITY.
> But, I don't know how to set the each value in the each mode.
> 
> The way pointed the specific value is only one -
> V4L2_CID_EXPOSURE_ABSOLUTE. So, how can I set the specific value at the
> each mode?

You can control the aperture using the V4L2_CID_IRIS_ABSOLUTE control. See 
http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html#camera-
controls for more information regarding the exposure and iris controls.

-- 
Regards,

Laurent Pinchart
