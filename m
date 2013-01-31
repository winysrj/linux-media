Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:13342 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3AaBaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 20:30:20 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHG008A2UU4GWA0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 10:30:18 +0900 (KST)
Received: from NOINKIDAE02 ([10.90.8.52])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHG000R7UUH2WM1@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 10:30:17 +0900 (KST)
From: Inki Dae <inki.dae@samsung.com>
To: 'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>
Cc: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, patches@linaro.org,
	s.nawrocki@samsung.com
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
 <1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
 <CAAQKjZNc0xFaoaqtKsLC=Evn60XA5UChtoMLAcgsWqyLNa7ejQ@mail.gmail.com>
 <510987B5.6090509@gmail.com>
In-reply-to: <510987B5.6090509@gmail.com>
Subject: RE: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
Date: Thu, 31 Jan 2013 10:30:14 +0900
Message-id: <050101cdff52$86df3a70$949daf50$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Sylwester Nawrocki [mailto:sylvester.nawrocki@gmail.com]
> Sent: Thursday, January 31, 2013 5:51 AM
> To: Inki Dae
> Cc: Sachin Kamat; linux-media@vger.kernel.org; dri-
> devel@lists.freedesktop.org; devicetree-discuss@lists.ozlabs.org;
> patches@linaro.org; s.nawrocki@samsung.com
> Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery
> support for G2D
> 
> On 01/30/2013 09:50 AM, Inki Dae wrote:
> >> +static const struct of_device_id exynos_g2d_match[] = {
> >> +       { .compatible = "samsung,g2d-v41" },
> >
> > not only Exynos5 and also Exyno4 has the g2d gpu and drm-based g2d
> > driver shoud support for all Exynos SoCs. How about using
> > "samsung,exynos5-g2d" instead and adding a new property 'version' to
> > identify ip version more surely? With this, we could know which SoC
> > and its g2d ip version. The version property could have '0x14' or
> > others. And please add descriptions to dt document.
> 
> Err no. Are you suggesting using "samsung,exynos5-g2d" compatible string
> for Exynos4 specific IPs ? This would not be correct, and you still can

I assumed the version 'v41' is the ip for Exynos5 SoC. So if this version
means Exynos4 SoC then it should be "samsung,exynos4-g2d".

> match the driver with multiple different revisions of the IP and associate
> any required driver's private data with each corresponding compatible
> property.
> 

Right, and for why I prefer to use version property instead of embedded
version string, you can refer to the my comment I replied already to the
"drm/exynos: Get HDMI version from device tree" email thread.

> Perhaps it would make more sense to include the SoCs name in the
> compatible
> string, e.g. "samsung,exynos-g2d-v41", but appending revision of the IP
> seems acceptable to me. The revisions appear to be well documented and
> it's
> more or less clear which one corresponds to which SoC.
> 
> --
> 
> Thanks,
> Sylwester

