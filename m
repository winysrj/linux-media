Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:56218 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab1BUOrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 09:47:31 -0500
Message-ID: <4D627B00.4090309@matrix-vision.de>
Date: Mon, 21 Feb 2011 15:47:28 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: link error w/ media-0006-sensors
References: <4D35BC6D.1050801@matrix-vision.de> <201101190030.30161.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101190030.30161.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

sorry to resurrect this from a month ago...

I've continued to export omap_pm_set_min_bus_tput() to enable building
the omap3-isp module, although Paul Wamsley's reply you referred to
clearly indicates that this is the wrong approach.

Aren't you also building omap3-isp as a module?  How are you guys
getting around this?

-Michael

On 01/19/2011 12:30 AM, Laurent Pinchart wrote:
> Hi Michael,
> 
> On Tuesday 18 January 2011 17:14:37 Michael Jones wrote:
>> Hi Laurent & Sakari,
>>
>> On Laurent's media-0006-sensors branch, when compiling with
>> CONFIG_VIDEO_OMAP3=m, I got the following linking error:
>>
>> ERROR: "omap_pm_set_min_bus_tput" [drivers/media/video/isp/omap3-isp.ko]
>> undefined!
>>
>> I can get rid of the error with the patch below. But as always, I
>> wonder: Why didn't anybody else come across this error? Are you all
>> compiling with VIDEO_OMAP3=y? Is there a config file somewhere I can see
>> where someone is using that?
>>
>> And would anything be wrong with the patch below?
> 
> Martin Hostettler sent the same patch to linux-omap today ("[PATCH] OMAP: PM: 
> Export omap_pm_set_min_bus_tput to modules"). See Please see Paul Wamsley's 
> answer on the list.
> 


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
