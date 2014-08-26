Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaHZUIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 16:08:42 -0400
Message-ID: <53FCE947.6000103@infradead.org>
Date: Tue, 26 Aug 2014 13:08:39 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Peter Foley <pefoley2@pefoley.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
	linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] [media] v4l2-pci-skeleton: Only build if PCI is available
References: <1409073919-27336-1-git-send-email-broonie@kernel.org> <53FCDE16.1000205@infradead.org> <20140826192624.GN17528@sirena.org.uk> <53FCE70A.6000907@infradead.org>
In-Reply-To: <53FCE70A.6000907@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/14 12:59, Randy Dunlap wrote:
> On 08/26/14 12:26, Mark Brown wrote:
>> On Tue, Aug 26, 2014 at 12:20:54PM -0700, Randy Dunlap wrote:
>>> On 08/26/14 10:25, Mark Brown wrote:
>>
>>>> index d58101e788fc..65a351d75c95 100644
>>>> --- a/Documentation/video4linux/Makefile
>>>> +++ b/Documentation/video4linux/Makefile
>>>> @@ -1 +1 @@
>>>> -obj-m := v4l2-pci-skeleton.o
>>>> +obj-$(CONFIG_VIDEO_PCI_SKELETON) := v4l2-pci-skeleton.o
>>>> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
>>
>>>> +config VIDEO_PCI_SKELETON
>>>> +	tristate "Skeleton PCI V4L2 driver"
>>>> +	depends on PCI && COMPILE_TEST
>>
>>> 	               && ??  No, don't require COMPILE_TEST.
>>
>> That's a very deliberate choice.  There's no reason I can see to build
>> this code other than to check that it builds, it's reference code rather
>> than something that someone is expected to actually use in their system.  
>> This seems like a perfect candidate for COMPILE_TEST.
>>
>>> 		However, PCI || COMPILE_TEST would allow it to build on arm64
>>> 		if COMPILE_TEST is enabled, guaranteeing build errors.
>>> 		Is that what should happen?  I suppose so...
>>
>> No, it's not - if it's going to depend on COMPILE_TEST at all it need to
>> be a hard dependency.
> 
> How about just drop COMPILE_TEST?  This code only builds if someone enabled
> BUILD_DOCSRC.  That should be enough (along with PCI and some VIDEO kconfig
> symbols) to qualify it.

I'll add BUILD_DOCSRC to the depends list in the Kconfig file...


-- 
~Randy
