Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fpasia.hk ([202.130.89.98]:44992 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab3J2HlX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 03:41:23 -0400
Message-ID: <526F66E2.4080108@gtsys.com.hk>
Date: Tue, 29 Oct 2013 15:42:26 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media@vger.kernel.org
Subject: Re: iram pool not available for MX27
References: <52490EEB.1090806@gtsys.com.hk> <1380529823.3959.1.camel@pizza.hi.pengutronix.de> <52493F77.2020602@gtsys.com.hk> <524940E3.2070206@gtsys.com.hk>
In-Reply-To: <524940E3.2070206@gtsys.com.hk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, September 30, 2013 05:14 PM, Chris Ruehl wrote:
> On Monday, September 30, 2013 05:08 PM, Chris Ruehl wrote:
>> Hi Philipp,
>>
>> On Monday, September 30, 2013 04:30 PM, Philipp Zabel wrote:
>>> Hi Chris,
>>>
>>> Am Montag, den 30.09.2013, 13:40 +0800 schrieb Chris Ruehl:
>>>> Hi Phillipp,
>>>>
>>>> hope things doing OK.
>>>>
>>>> I recently update to the 3.12-rc kernel and hit this problem below.
>>>>
>>>> [ 3.377790] coda coda-imx27.0: iram pool not available
>>>> [ 3.383363] coda: probe of coda-imx27.0 failed with error -12
>>>>
>>>> I read your comments of the patch-set using platform data rather then
>>>> hard coded addresses to get
>>>> the ocram from a SoC.
>>>>
>>>> I checked the imx27.dtsi for the iram (coda: coda@..) definition and
>>>> compare with the former hard coded address and size it matches.
>>>>
>>>> My .config also has the CONFIG_OF set.
>>>>
>>>> Any Idea what's go wrong?
>>> do you have the mmio-sram driver enabled (CONFIG_SRAM=y)?
>>>
>>> regards
>>> Philipp
>>>
>>
>> No, I didn't,  and I found out that my device is not yet ported to 
>> use "Device Tree Support"
>>
>> for the moment I will quick add the CONFIG_SRAM  and see what happen,
>> but on the long term I move my code (clone of mach-mx27ads.c)
>> to DTS which makes absolute sense when I see how nice that code works.
>>
>> Thanks for the reply!
>> Chris
>>
> CONFIG_SRAM not solve my problem, I must port the code to Device Tree 
> Support and call the of_ functions to make the iram config available.
>
> thank you.
> Chris
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

almost done but the coda works now with my board :-) and more questions 
coming up
but 1st:
[    4.626900] udevd[717]: starting version 175
[    7.190348] coda 10023000.coda: Initialized CodaDx6.
[    7.195486] coda 10023000.coda: Firmware version: 2.2.5
[    7.313178] coda 10023000.coda: codec registered as /dev/video0
[   13.999803] EXT4-fs (mmcblk0p1): re-mounted. Opts: (null)

:-) )))

Chris



