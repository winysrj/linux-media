Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56901 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbcE0Ult (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 16:41:49 -0400
Subject: Re: [PATCH v4 2/7] media: s5p-mfc: use generic reserved memory
 bindings
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Rob Herring <robh@kernel.org>
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-3-git-send-email-m.szyprowski@samsung.com>
 <a14c4f45-64c9-f72d-532b-ad1ff53fa9eb@osg.samsung.com>
 <20160525173614.GA8309@rob-hp-laptop>
 <709cf900-86dd-5020-d516-24caa971d74a@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <78803037-2aa8-0d62-c69a-f95caec393ab@osg.samsung.com>
Date: Fri, 27 May 2016 16:41:34 -0400
MIME-Version: 1.0
In-Reply-To: <709cf900-86dd-5020-d516-24caa971d74a@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 05/27/2016 02:37 AM, Marek Szyprowski wrote:
> Hello,
> 
> 
> On 2016-05-25 19:36, Rob Herring wrote:
>> On Wed, May 25, 2016 at 11:18:59AM -0400, Javier Martinez Canillas wrote:
>>> Hello Marek,
>>>
>>> On 05/24/2016 09:31 AM, Marek Szyprowski wrote:
>>>> Use generic reserved memory bindings and mark old, custom properties
>>>> as obsoleted.
>>>>
>>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>> ---
>>>>   .../devicetree/bindings/media/s5p-mfc.txt          | 39 +++++++++++++++++-----
>>>>   1 file changed, 31 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
>>>> index 2d5787e..92c94f5 100644
>>>> --- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
>>>> +++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
>>>> @@ -21,15 +21,18 @@ Required properties:
>>>>     - clock-names : from common clock binding: must contain "mfc",
>>>>             corresponding to entry in the clocks property.
>>>>   -  - samsung,mfc-r : Base address of the first memory bank used by MFC
>>>> -            for DMA contiguous memory allocation and its size.
>>>> -
>>>> -  - samsung,mfc-l : Base address of the second memory bank used by MFC
>>>> -            for DMA contiguous memory allocation and its size.
>>>> -
>>>>   Optional properties:
>>>>     - power-domains : power-domain property defined with a phandle
>>>>                  to respective power domain.
>>>> +  - memory-region : from reserved memory binding: phandles to two reserved
>>>> +    memory regions, first is for "left" mfc memory bus interfaces,
>>>> +    second if for the "right" mfc memory bus, used when no SYSMMU
>>>> +    support is available
>>>> +
>>>> +Obsolete properties:
>>>> +  - samsung,mfc-r, samsung,mfc-l : support removed, please use memory-region
>>>> +    property instead
>>>> +
>>>>
>>> I wonder if we should maintain backward compatibility for this driver
>>> since s5p-mfc memory allocation won't work with an old FDT if support
>>> for the old properties are removed.
>> Well, minimally the commit log should indicate that compatibility is
>> being broken.
> 
> Compatibility is only partially broken. I add this to the commit message. Old
> bindings will still work with the new driver when IOMMU is enabled - in such case reserved
> memory regions are ignored so this should not be a big issue. Using IOMMU also increases
> total memory space for the video buffers without wasting it as 'reserved'. Hope that
> once those patches are merged, the IOMMU can be finally enabled in the exynos_defconfig.
>

Yes, a problem is that some Exynos machines (for example the Snow and Peach
Chromebooks) fail to boot when IOMMU is enabled due the bootloader leaving
the FIMD enabled doing DMA operations automatically as you found before.

You proposed to add a "iommu-reserved-mapping" property [0] but that never
landed due not having an agreement on how should be fixed properly IIUC [1].

So that has to be fixed before enabling the Exynos IOMMU support by default.

[0]: http://www.spinics.net/lists/arm-kernel/msg415501.html
[1]: http://www.spinics.net/lists/arm-kernel/msg419747.html 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
