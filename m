Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61448 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab0KSOJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 09:09:06 -0500
Received: by fxm13 with SMTP id 13so684630fxm.19
        for <linux-media@vger.kernel.org>; Fri, 19 Nov 2010 06:09:04 -0800 (PST)
Message-ID: <4CE684E6.6010403@brooks.nu>
Date: Fri, 19 Nov 2010 07:08:38 -0700
From: Lane Brooks <lane@brooks.nu>
MIME-Version: 1.0
To: David Cohen <david.cohen@nokia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Translation faults with OMAP ISP
References: <4CE16AA2.3000208@brooks.nu> <201011160001.10737.laurent.pinchart@ideasonboard.com> <4CE317D3.2020504@brooks.nu> <201011180009.31053.laurent.pinchart@ideasonboard.com> <4CE46281.2010308@brooks.nu> <20101119132927.GD13490@esdhcp04381.research.nokia.com>
In-Reply-To: <20101119132927.GD13490@esdhcp04381.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 11/19/2010 06:29 AM, David Cohen wrote:
> On Thu, Nov 18, 2010 at 12:17:21AM +0100, ext Lane Brooks wrote:
>> On Wednesday 17 November 2010 00:46:27 Lane Brooks wrote:
>>>> Laurent,
>>>>
>>>> I am getting iommu translation errors when I try to use the CCDC output
>>>> after using the Resizer output.
>>>>
>>>> If I use the CCDC output to stream some video, then close it down,
>>>> switch to the Resizer output and open it up and try to stream, I get the
>>>> following errors spewing out:
>>>>
>>>> omap-iommu omap-iommu.0: omap2_iommu_fault_isr: da:00d0ef00 translation
>>>> fault
>>>> omap-iommu omap-iommu.0: iommu_fault_handler: da:00d0ef00 pgd:ce664034
>>>> *pgd:00000000
>>>>
>>>> and the select times out.
>>>>
>>>>    From a fresh boot, I can stream just fine from the Resizer and then
>>>> switch to the CCDC output just fine. It is only when I go from the CCDC
>>>> to the Resizer that I get this problem. Furthermore, when it gets into
>>>> this state, then anything dev node I try to use has the translation
>>>> errors and the only way to recover is to reboot.
>>>>
>>>> Any ideas on the problem?
> I'm not sure if it's your case, but OMAP3 ISP driver does not support
> pipeline with multiples outputs yet. We have to return error from the
> driver in this case. If you configured CCDC to write to memory and then
> to write to preview/resizer afterwards without deactivating the link to
> write to memory, you may face a similar problem you described.
>
> Can you please try a patch I've sent to you (CC'ing linux-media) with subject:
> "[omap3isp][PATCH] omap3isp: does not allow pipeline with multiple video
> outputs yet"?
>
> Regards,
>
> David
David,

I am not trying to use multiple outputs simultaneously. I get the 
translation error with the following sequence:

- Open resizer output and setup media links.
- Stream some images.
- Close resizer.
- Reset all media links.
- Open CCDC and setup media links.
- Try to stream some images but get translation faults.

Is your patch going to help with this problem?

Lane
