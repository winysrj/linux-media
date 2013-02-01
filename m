Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18914 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422848Ab3BAKyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 05:54:03 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHJ00E09FKR0240@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 10:54:01 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MHJ00B82FM0K620@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 10:54:01 +0000 (GMT)
Message-id: <510B9EC8.6020102@samsung.com>
Date: Fri, 01 Feb 2013 11:54:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Inki Dae <inki.dae@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, patches@linaro.org
Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
 <1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
 <CAAQKjZNc0xFaoaqtKsLC=Evn60XA5UChtoMLAcgsWqyLNa7ejQ@mail.gmail.com>
 <510987B5.6090509@gmail.com> <050101cdff52$86df3a70$949daf50$%dae@samsung.com>
 <510B02AB.4080908@gmail.com> <0b7501ce0011$3df65180$b9e2f480$@samsung.com>
 <00fd01ce001b$5215a3f0$f640ebd0$%dae@samsung.com>
 <CAK9yfHxqqumg-oqH_Ku8Zkf8biWVknF91Su0VkWJJXjvWQ3Jhw@mail.gmail.com>
In-reply-to: <CAK9yfHxqqumg-oqH_Ku8Zkf8biWVknF91Su0VkWJJXjvWQ3Jhw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2013 09:33 AM, Sachin Kamat wrote:
> On 1 February 2013 06:57, Inki Dae <inki.dae@samsung.com> wrote:
>>
>> For example,
>> If compatible = "samsung,g2d-3.0" is added to exynos4210.dtsi, it'd be
>> reasonable. But what if that compatible string is added to exynos4.dtsi?.
>> This case isn't considered for exynos4412 SoC with v4.1.
> 
> In case of Exynos4 series the base address of G2D ip is different
> across series. Hence we cannot define it in exynos4.dtsi and need to
> define the nodes in exynos4xxx.dtsi or specific board files. Thus we
> can use the version appended compatible string.
> 
> However even the second option suggested by Sylwester is OK with me or
> to be even more specific we could go for both SoC as well as version
> option something like this.
> 
> compatible = "samsung,exynos3110-g2d-3.0" /* for Exynos3110, Exynos4210 */
> compatible = "samsung,exynos4212-g2d-4.1" /* for Exynos4212, Exynos4412 */
> 
> In any case please let me know the final preferred one so that I can
> update the code send the revised patches.

The version with SoC name embedded in it seems most reliable and correct
to me. 

compatible = "samsung,exynos3110-fimg-2d" /* for Exynos3110 (S5PC110, S5PV210), 
                                             Exynos4210 */
compatible = "samsung,exynos4212-fimg-2d" /* for Exynos4212, Exynos4412 */

FIMG stands for Fully Interactive Mobile Graphics, and other multimedia 
IPs follow this naming convention, e.g. FIMG-3D, FIMD (Display Controller), 
FIMC (Camera), etc.

This is just my opinion though, and it seems this is a most common scheme
from greping the device tree bindings documentation.

As Stephen pointed out, and I also did in some other mail thread in the 
past, not only an IP revision might be required, but also its integration 
details, specific to an SoC type are important. This actually happens 
to be the case with FIMC, where same version of one instance of the IP 
has more data interfaces routed to other SoC subsystems on one SoC type 
than on other one.

I think it won't be possible to use a scheme like "samsung-exynos-g2d-3.0"
for all IPs. And I would much more like to see a uniform naming convention
used, rather than living with a chaotic set of compatible properties, that
has a potential to become even more chaotic in the future.

--

Thanks,
Sylwester
