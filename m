Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34865 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0KQXR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 18:17:27 -0500
Received: by eye27 with SMTP id 27so1659691eye.19
        for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 15:17:26 -0800 (PST)
Message-ID: <4CE46281.2010308@brooks.nu>
Date: Wed, 17 Nov 2010 16:17:21 -0700
From: Lane Brooks <lane@brooks.nu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: Translation faults with OMAP ISP
References: <4CE16AA2.3000208@brooks.nu> <201011160001.10737.laurent.pinchart@ideasonboard.com> <4CE317D3.2020504@brooks.nu> <201011180009.31053.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011180009.31053.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 11/17/2010 04:09 PM, Laurent Pinchart wrote:
> Hi Lane,
>
> On Wednesday 17 November 2010 00:46:27 Lane Brooks wrote:
>> Laurent,
>>
>> I am getting iommu translation errors when I try to use the CCDC output
>> after using the Resizer output.
>>
>> If I use the CCDC output to stream some video, then close it down,
>> switch to the Resizer output and open it up and try to stream, I get the
>> following errors spewing out:
>>
>> omap-iommu omap-iommu.0: omap2_iommu_fault_isr: da:00d0ef00 translation
>> fault
>> omap-iommu omap-iommu.0: iommu_fault_handler: da:00d0ef00 pgd:ce664034
>> *pgd:00000000
>>
>> and the select times out.
>>
>>   From a fresh boot, I can stream just fine from the Resizer and then
>> switch to the CCDC output just fine. It is only when I go from the CCDC
>> to the Resizer that I get this problem. Furthermore, when it gets into
>> this state, then anything dev node I try to use has the translation
>> errors and the only way to recover is to reboot.
>>
>> Any ideas on the problem?
> Ouch. First of all, could you please make sure you run the latest code ? Many
> bugs have been fixed in the last few months

I had a pretty good idea that this would be your response, but I was 
hoping otherwise as merging has become more and more difficult to keep 
up with. Anyway, until I have a chance to merge in everything, I just 
found a work around for our usage needs, and that is to always use the 
resizer output and just change the resizer format between full 
resolution and preview resolution. This has turned out to be much more 
stable than switching between the CCDC and RESIZER dev nodes.

Thanks again for your feedback.

Lane
