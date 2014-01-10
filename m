Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaAJJHO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 04:07:14 -0500
Message-ID: <52CFB88C.4030109@linux.intel.com>
Date: Fri, 10 Jan 2014 11:08:28 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC v1.1 2/2] media: v4l: Only get module if it's different
 than the driver for v4l2_dev
References: <1386936216-32296-2-git-send-email-sakari.ailus@linux.intel.com> <1387288164-15250-1-git-send-email-sakari.ailus@linux.intel.com> <1814672.r475G5dY7x@avalon>
In-Reply-To: <1814672.r475G5dY7x@avalon>
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
> On Tuesday 17 December 2013 15:49:24 Sakari Ailus wrote:
>> When the sub-device is registered, increment the use count of the sub-device
>> owner only if it's different from the owner of the driver for the media
>> device. This avoids increasing the use count by the module itself and thus
>> making it possible to unload it when it's not in use.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> This looks good to me, but I wonder whether a more generic solution won't be
> needed, to solve the multiple circular reference issues we (will) have with
> subdevices and clocks. My gut feeling is that such a generic solution will
> also cater for the needs of the problem you're trying to solve here.

I can't immediately think of solving this in a generic fashion. There 
are dependencies to API behaviour for instance. For clocks this could be 
resolved by changing how clk_get() is used by sensor drivers, or 
changing the clock framework to allow unregistering clocks even if they 
have been obtained by the users but not enabled. Considering the current 
implementation of clk_unregister(), the need for (some) changes is 
apparent. (I could miss some changes elsewhere as I just checked 
linux-media.)

The above would still resolve this for clocks alone.

> This being said, there's no reason to delay this patch until a more generic
> solution is available, so
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
