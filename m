Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56132 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab3BAAPg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 19:15:36 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHI00CPALY0AT00@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 09:15:35 +0900 (KST)
Received: from visitor4lab ([105.128.18.157])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHI008FWM1VNU90@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 09:15:34 +0900 (KST)
From: Kukjin Kim <kgene.kim@samsung.com>
To: 'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>,
	'Inki Dae' <inki.dae@samsung.com>
Cc: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, patches@linaro.org,
	s.nawrocki@samsung.com
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
 <1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
 <CAAQKjZNc0xFaoaqtKsLC=Evn60XA5UChtoMLAcgsWqyLNa7ejQ@mail.gmail.com>
 <510987B5.6090509@gmail.com> <050101cdff52$86df3a70$949daf50$%dae@samsung.com>
 <510B02AB.4080908@gmail.com>
In-reply-to: <510B02AB.4080908@gmail.com>
Subject: RE: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
Date: Thu, 31 Jan 2013 16:15:26 -0800
Message-id: <0b7501ce0011$3df65180$b9e2f480$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sylwester Nawrocki wrote:
> 
> Hi Inki,
> 
Hi Sylwester and Inki,

> On 01/31/2013 02:30 AM, Inki Dae wrote:
> >> -----Original Message-----
> >> From: Sylwester Nawrocki [mailto:sylvester.nawrocki@gmail.com]
> >> Sent: Thursday, January 31, 2013 5:51 AM
> >> To: Inki Dae
> >> Cc: Sachin Kamat; linux-media@vger.kernel.org; dri-
> >> devel@lists.freedesktop.org; devicetree-discuss@lists.ozlabs.org;
> >> patches@linaro.org; s.nawrocki@samsung.com
> >> Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery
> >> support for G2D
> >>
> >> On 01/30/2013 09:50 AM, Inki Dae wrote:
> >>>> +static const struct of_device_id exynos_g2d_match[] = {
> >>>> +       { .compatible = "samsung,g2d-v41" },
> >>>
> >>> not only Exynos5 and also Exyno4 has the g2d gpu and drm-based g2d
> >>> driver shoud support for all Exynos SoCs. How about using
> >>> "samsung,exynos5-g2d" instead and adding a new property 'version' to
> >>> identify ip version more surely? With this, we could know which SoC
> >>> and its g2d ip version. The version property could have '0x14' or
> >>> others. And please add descriptions to dt document.
> >>
> >> Err no. Are you suggesting using "samsung,exynos5-g2d" compatible
> string
> >> for Exynos4 specific IPs ? This would not be correct, and you still can
> >
> > I assumed the version 'v41' is the ip for Exynos5 SoC. So if this
version
> > means Exynos4 SoC then it should be "samsung,exynos4-g2d".
> 
> Yes, v3.0 is implemented in the S5PC110 (Exynos3110) SoCs and Exynos4210,
> V4.1 can be found in Exynos4212 and Exynos4412, if I'm not mistaken.
> 
> So we could have:
> 
> compatible = "samsung,exynos-g2d-3.0" /* for Exynos3110, Exynos4210 */
> compatible = "samsung,exynos-g2d-4.1" /* for Exynos4212, Exynos4412 */
> 
In my opinion, this is better than later. Because as I said, when we can use
IP version to identify, it is more clear and can be used 

One more, how about following?

compatible = "samsung,g2d-3.0"
compatible = "samsung,g2d-4.1"

I think, just g2d is enough. For example, we are using it for mfc like
following: compatible = "samsung.mfc-v6"

> or alternatively
> 
> compatible = "samsung,exynos3110-g2d" /* for Exynos3110, Exynos4210 */
> compatible = "samsung,exynos4212-g2d" /* for Exynos4212, Exynos4412 */
> 
Thanks.

- Kukjin

