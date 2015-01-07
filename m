Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12607 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbbAGMLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 07:11:52 -0500
Message-id: <54AD2284.4060607@samsung.com>
Date: Wed, 07 Jan 2015 13:11:48 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Tony K Nadackal <tony.kn@samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	mchehab@osg.samsung.com, kgene@kernel.org, k.debski@samsung.com,
	s.nawrocki@samsung.com, robh+dt@kernel.org, mark.rutland@arm.com,
	bhushan.r@samsung.com
Subject: Re: [PATCH v2 2/2] [media] s5p-jpeg: Adding Exynos7 JPEG variant
References: <1418974680-5837-1-git-send-email-tony.kn@samsung.com>
 <1418974680-5837-3-git-send-email-tony.kn@samsung.com>
 <54AD068F.8030001@samsung.com> <000801d02a6c$59fdbc60$0df93520$@samsung.com>
In-reply-to: <000801d02a6c$59fdbc60$0df93520$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On 01/07/2015 12:22 PM, Tony K Nadackal wrote:
> Hi Jacek,
>
> On  Wednesday, January 07, 2015 3:43 PM : Jacek Anaszewski wrote,
>
>> Hi Tony,
>>
>> On 12/19/2014 08:38 AM, Tony K Nadackal wrote:
>>> Fimp_jpeg used in Exynos7 is a revised version. Some register
>>> configurations are slightly different from JPEG in Exynos4.
>>> Added one more variant SJPEG_EXYNOS7 to handle these differences.
>>>
>>> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
>>> ---
>>>    .../bindings/media/exynos-jpeg-codec.txt           |  2 +-
>>>    drivers/media/platform/s5p-jpeg/jpeg-core.c        | 61
> ++++++++++++++++++-
>> ---
>>>    drivers/media/platform/s5p-jpeg/jpeg-core.h        | 10 ++--
>>>    drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  | 32 ++++++------
>>>    drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h  |  8 +--
>>>    drivers/media/platform/s5p-jpeg/jpeg-regs.h        | 17 ++++--
>>>    6 files changed, 93 insertions(+), 37 deletions(-)
>>>
>>> diff --git
>>> a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
>>> b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
>>> index bf52ed4..cd19417 100644
>>> --- a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
>>> +++ b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
>>> @@ -4,7 +4,7 @@ Required properties:
>>>
>>>    - compatible	: should be one of:
>>>    		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg",
>>> -		  "samsung,exynos3250-jpeg";
>>> +		  "samsung,exynos3250-jpeg", "samsung,exynos7-jpeg";
>>>    - reg		: address and length of the JPEG codec IP register set;
>>>    - interrupts	: specifies the JPEG codec IP interrupt;
>>>    - clock-names   : should contain:
>>
>> This should be put in a separate patch.
>
> Checkpatch gives warning if this change is not there.
> If that is ok with you, I will make this change a separate patch.

If the patch updating the DT documentation will go first, then
checkpatch shouldn't raise a warning.

-- 
Best Regards,
Jacek Anaszewski
