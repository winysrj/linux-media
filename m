Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:59192 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab1ESNvm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 09:51:42 -0400
Message-ID: <4DD51EB2.30408@matrix-vision.de>
Date: Thu, 19 May 2011 15:44:18 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Alex Gershgorin <alexg@meprolight.com>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	"'sakari.ailus@iki.fi'" <sakari.ailus@iki.fi>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
Subject: Re: FW: OMAP 3 ISP
References: <4875438356E7CA4A8F2145FCD3E61C0B15D3557D38@MEP-EXCH.meprolight.com> <201105191502.11130.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105191502.11130.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/19/2011 03:02 PM, Laurent Pinchart wrote:
> Hi Alex,
> 
> On Thursday 19 May 2011 14:51:16 Alex Gershgorin wrote:
>> Thanks Laurent,
>>
>> My video source is not the video camera and performs many other functions.
>> For this purpose I have RS232 port.
>> As for the video, it runs continuously and is not subject to control except
>> for the power supply.
> 
> As a quick hack, you can create an I2C driver for your video source that 
> doesn't access the device and just returns fixed format and frame size.
> 
> The correct fix is to implement support for platform subdevs in the V4L2 core.
> 

I recently implemented support for platform V4L2 subdevs.  Now that it
sounds like others would be interested in this, I will try to polish it
up and submit the patch for review in the next week or so.

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
