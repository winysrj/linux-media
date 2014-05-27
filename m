Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33539 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaE0Ky1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 06:54:27 -0400
Message-ID: <53846EE0.2030203@linux.intel.com>
Date: Tue, 27 May 2014 13:54:24 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: I2C address is the last part of the subdev
 name
References: <1400140602-27282-1-git-send-email-sakari.ailus@linux.intel.com> <3402705.9k4s8R0HnX@avalon>
In-Reply-To: <3402705.9k4s8R0HnX@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
>
> Thank you for the patch.
>
> On Thursday 15 May 2014 10:56:42 Sakari Ailus wrote:
>> The I2C address of the sensor device was in the middle of the sub-device
>> name and not in the end as it should have been. The smiapp sub-device names
>> will change from e.g. "vs6555 1-0010 pixel array" to "vs6555 pixel array
>> 1-0010".
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>> This was already supposed to be fixed by "[media] smiapp: Use I2C adapter ID
>> and address in the sub-device name" but the I2C address indeed was in the
>> middle of the sub-device name and not in the end as it should have been.
>
> I don't mind much whether the I2C bus number is in the middle or at the end of
> the name. The current "vs6555 1-0010 pixel array" value looks good to me, as
> it means "the pixel array of the vs6555 1-0010 sensor" in English, but I'm
> fine with "vs6555 pixel array 1-0010" as well.
>
> However, as discussed privately, I think we need to make sure that
> applications don't rely on a specific format for the name. Names must be
> unique, but should not otherwise be parsed by applications to extract device
> location information (at least in my opinion). That information should be

I agree with that; my primary motivation with this patch is consistency: 
other drivers do the same, i.e. put the bus information at the end of 
the name. Still I don't think other drivers expose multiple sub-devices, 
so the question hasn't popped up before.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
