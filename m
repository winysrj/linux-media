Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail142.messagelabs.com ([216.82.249.99]:15891 "EHLO
	mail142.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0CWE2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 00:28:04 -0400
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 23 Mar 2010 09:58:01 +0530
Subject: RE: omap2 camera
Message-ID: <70376CA23424B34D86F1C7DE6B997343017F5D5BD8@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <70376CA23424B34D86F1C7DE6B997343017F5D5BD5@VSHINMSMBX01.vshodc.lntinfotech.com>
 <A24693684029E5489D1D202277BE89445428BE8E@dlee02.ent.ti.com>,<4BA7A72B.9000300@maxwell.research.nokia.com>
In-Reply-To: <4BA7A72B.9000300@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
________________________________________
From: Sakari Ailus [sakari.ailus@maxwell.research.nokia.com]
Sent: Monday, March 22, 2010 10:51 PM
To: Aguirre, Sergio
Cc: Viral Mehta; linux-media@vger.kernel.org
Subject: Re: omap2 camera

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

> Thanks, Sergio!

Thanks for your response. Thanks Sergio.

> I've only aware of the tcm825x sensor driver that works with the OMAP
> 2420 camera controller (omap24xxcam) driver.

Does this also mean that omap24xxcam.ko will *only* work with OMAP2420?
Or the same driver can be used for OMAP2430 board as well ?  As name suggests, omap24xxcam....

> So likely you'd need the driver for the sensor you have on that board.
Okie, I am trying to get that done. I took linux-2.6.14-V5 kernel from linux.omap.com and
that supports camera on OMAP2430 and it has functional driver for ex3691 sensor.
I am trying to know if I can forward port that.

> The omap24xxcam and tcm825x drivers should be moved to use v4l2_subdev
> but I'm not quite sure what will be the schedule of that. Then we could
> get rid of the v4l2-int-device interface that those drives still use.

They are still using v4l2-int-device as of 2.6.33.

Regards,

--
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

______________________________________________________________________

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
