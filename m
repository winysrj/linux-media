Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:50476 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab0CVRWG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 13:22:06 -0400
Message-ID: <4BA7A72B.9000300@maxwell.research.nokia.com>
Date: Mon, 22 Mar 2010 19:21:47 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Viral Mehta <Viral.Mehta@lntinfotech.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap2 camera
References: <70376CA23424B34D86F1C7DE6B997343017F5D5BD5@VSHINMSMBX01.vshodc.lntinfotech.com> <A24693684029E5489D1D202277BE89445428BE8E@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89445428BE8E@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
> Hi Viral,
> 
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Viral Mehta
>> Sent: Monday, March 22, 2010 5:20 AM
>> To: linux-media@vger.kernel.org
>> Subject: omap2 camera
>>
>> Hi list,
>>
>> I am using OMAP2430 board and I wanted to test camera module on that
>> board.
>> I am using latest 2.6.33 kernel. However, it looks like camera module is
>> not supported with latest kernel.
>>
>> Anyone is having any idea? Also, do we require to have ex3691 sensor
>> driver in mainline kernel in order to get omap24xxcam working ?
>>
>> These are the steps I followed,
>> 1. make omap2430_sdp_defconfig
>> 2. Enable omap2 camera option which is under drivers/media/video
>> 3. make uImage
>>
>> And with this uImage, camera is not working. I would appreciate any help.
> 
> I'm adding Sakari Ailus to the CC list, which is the owner of the driver.

Thanks, Sergio!

I've only aware of the tcm825x sensor driver that works with the OMAP
2420 camera controller (omap24xxcam) driver.

So likely you'd need the driver for the sensor you have on that board.

The omap24xxcam and tcm825x drivers should be moved to use v4l2_subdev
but I'm not quite sure what will be the schedule of that. Then we could
get rid of the v4l2-int-device interface that those drives still use.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
