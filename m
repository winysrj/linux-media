Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45478 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbZFATNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 15:13:17 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Paulraj, Sandeep" <s-paulraj@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Grosen, Mark" <mgrosen@ti.com>
Date: Mon, 1 Jun 2009 14:13:13 -0500
Subject: RE: New Driver for DaVinci DM355/DM365/DM6446
Message-ID: <A24693684029E5489D1D202277BE8944405CFFE7@dlee02.ent.ti.com>
References: <C9D59C82B94F474B872F2092A87F261481797D4B@dlee07.ent.ti.com>
 <A24693684029E5489D1D202277BE8944405CFFE6@dlee02.ent.ti.com>,<A69FA2915331DC488A831521EAE36FE401354ED000@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401354ED000@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Karicheri, Muralidharan
> Sent: Monday, June 01, 2009 9:58 PM
> To: Aguirre Rodriguez, Sergio Alberto; Paulraj, Sandeep; linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Grosen, Mark
> Subject: RE: New Driver for DaVinci DM355/DM365/DM6446
> 
> Sergio,
> 
> Is it part of the patches Vaibhav & others from TI are submitting to open source ?

Yes, currently I have been sharing this codebase with Vaibhav, which he is taking for the 3530 EVM, which uses the camera ISP to receive images from a video decoder using a parallel BT656 output.


> I know that there is an
> ongoing effort at TI India to submit the resizer driver to open source for OMAP3?

I guess this is still on hold, as the current internal approach is not acceptable in the V4L2 standards.

> As per the email
> exchanges I had with Vaibhav (TI India) on this, it is part of the ISP module.

That's correct.

> We plan to submit the
> patches to open source for H3A and was trying to see which is the right way to do it.

The ISP driver core that we are sharing, it already has the H3A driver on it, which is accessed through Private IOCTLs declared inside the driver.

> We will
> investigate the tree you mentioned below and let you know if we have additional questions.

Vaibhav should be already familiar with this codebase, so maybe it could be easier for you to talk with him about this.

> The plan is to align with OMAP3 for the implementation.

Although the current code maintenance is on hold because i've been busy with some other custormer requirements, i havent been able to continue working on the pending TODOs so far. But as this strategy on a better collaboration with the community is attempted, i'm trying ot find my way to get back wit hthe maintenance of this driver to meet at least the required changes for acceptance of the driver.

It'll be definitively good to align on this, so we can avoid rewriting the same thing over again.

Regards,
Sergio
> 
> regards,
> 
> Murali Karicheri
> email: m-karicheri2@ti.com
> 
>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Aguirre Rodriguez, Sergio Alberto
>Sent: Monday, June 01, 2009 2:39 PM
>To: Paulraj, Sandeep; linux-media@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org; Grosen, Mark
>Subject: RE: New Driver for DaVinci DM355/DM365/DM6446
>
>> From: linux-media-owner@vger.kernel.org [linux-media-
>owner@vger.kernel.org] On Behalf Of Paulraj, Sandeep
>> Sent: Monday, June 01, 2009 5:56 PM
>> To: linux-media@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org; Grosen, Mark
>> Subject: New Driver for DaVinci DM355/DM365/DM6446
>>
>> Hello,
>>
>> WE have a module(H3A) on Davinci DM6446,DM355 and DM365.
>>
>> Customers require a way to collect the data required to perform the Auto
>Exposure (AE), Auto Focus(AF), and Auto White balance (AWB) in hardware as
>opposed to software. > This is primarily for performance reasons as there
>is not enough software processing MIPS (to do 3A statistics) available in
>> an imaging/video system.
>>
>> Including this block in hardware reduces the load on the processor and
>bandwidth to the memory as the data is collected on the fly from the imager.
>>
>> This modules collects statistics and we currently implement it as a
>character driver.
>
>This also exists in OMAP3 chips, and is part of the ISP module.
>
>I maintain, along with Sakari Ailus, a V4L2 camera driver, which is
>currently just shared through a gitorious repository:
>
>http://gitorious.org/omap3camera
>
>The way we offer an interface for the user to be able to request this
>statistics is with the usage of private IOCTLs declared inside the same
>V4L2 capturing device driver.
>
>So, that way we have a V4L2 driver which has a private call, instead of
>having it separately from the capture driver.
>
>Regards,
>Sergio
>>
>> Which mailing list would be the most appropriate mailing list to submit
>patches for review?
>>
>> Thanks,
>> Sandeep
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

