Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61250 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab0HHWe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Aug 2010 18:34:29 -0400
Received: by pzk26 with SMTP id 26so3425754pzk.19
        for <linux-media@vger.kernel.org>; Sun, 08 Aug 2010 15:34:28 -0700 (PDT)
Message-ID: <4C5F30F0.1060802@brooks.nu>
Date: Sun, 08 Aug 2010 16:34:24 -0600
From: Lane Brooks <lane@brooks.nu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: OMAP3 Bridge Problems
References: <4C583538.8060504@gmail.com> <201008042257.13290.laurent.pinchart@ideasonboard.com> <4C5AE19B.50609@brooks.nu> <201008090013.58188.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008090013.58188.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  On 08/08/2010 04:13 PM, Laurent Pinchart wrote:
> Hi Lane,
>
> On Thursday 05 August 2010 18:06:51 Lane Brooks wrote:
>>    On 08/04/2010 02:57 PM, Laurent Pinchart wrote:
>>> On Tuesday 03 August 2010 17:26:48 Lane Brooks wrote:
>> [snip]
>>
>>>> My question:
>>>>
>>>> - Are there other things I need to when I enable the parallel bridge?
>>>> For example, do I need to change a clock rate somewhere? From the TRM,
>>>> it seems like it should just work without any changes, but maybe I am
>>>> missing something.
>>> Good question. ISP bridge and YUV modes support are not implemented in
>>> the driver, but you're probably already aware of that.
>>>
>>> I unfortunately have no straightforward answer. Try tracing the ISP
>>> interrupts and monitoring the CCDC SBL busy bits to see if the CCDC
>>> writes images to memory correctly.
>> I found at least some of the problem. In my platform data I was enabling
>> the bridge using the #defines in ispreg.h as in
>>
>>
>> static struct isp_platform_data bmi_isp_platform_data = {
>>       .parallel = {
>>           .data_lane_shift    = 3,
>>           .clk_pol            = 0,
>>           .bridge             = ISPCTRL_PAR_BRIDGE_LENDIAN,
>>       },
>>       .subdevs = bmi_camera_subdevs,
>> };
>>
>> The bridge related #defines in ispreg.h, however, have a shift of 2
>> applied to them. The problem is that the shift is applied again in isp.c
>> when the options are actually applied. In other words, the bridge
>> parameters are being shifted up twice, which is causing corruption to
>> the control register and causing my hanging problems when I try to
>> enable the bridge. It seems there are several other such cases in the
>> ispreg.h where double shifting might occur if the user tries to use them
>> in the platform data.
>>
>> My question:
>> Is this an oversight or is it this way on purpose? Am I not supposed to
>> be using these defines in my platform definitions? It seems that *some*
>> of the parameters in ispreg.h should not be shifted up (like the bridge
>> options).
> It's a bug, thanks for pointing it out. The value shouldn't be shifted again
> in isp_select_bridge_input(). Do you want to submit a patch ?
>
The isp_parallel_platform_data struct specifies the bridge definition as 
2 bits, so if the shift is removed from isp_select_bridge instead of 
from the ispreg.h file, then the platform_data definition needs modified 
as well. Is that what you want?
