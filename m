Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:56754 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3BFLry (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 06:47:54 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHS00AUURFT6NF0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 20:47:53 +0900 (KST)
Received: from NOINKIDAE02 ([10.90.8.52])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHS00GC4RFS6B80@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 20:47:52 +0900 (KST)
From: Inki Dae <inki.dae@samsung.com>
To: 'Sylwester Nawrocki' <s.nawrocki@samsung.com>
Cc: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, k.debski@samsung.com,
	kgene.kim@samsung.com, patches@linaro.org,
	'Ajay Kumar' <ajaykumar.rs@samsung.com>,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	jy0922.shim@samsung.com, 'Rahul Sharma' <rahul.sharma@samsung.com>
References: <1360128584-23167-1-git-send-email-sachin.kamat@linaro.org>
 <1360128584-23167-2-git-send-email-sachin.kamat@linaro.org>
 <02a301ce043c$1b12d150$513873f0$%dae@samsung.com>
 <CAK9yfHyZrwdJV-Ct8Fby0uX1htHpAmJvCnX3VRYJSsey=L5HFA@mail.gmail.com>
 <02af01ce0447$37c26940$a7473bc0$%dae@samsung.com>
 <51123D34.5020404@samsung.com>
In-reply-to: <51123D34.5020404@samsung.com>
Subject: RE: [PATCH v2 2/2] drm/exynos: Add device tree based discovery support
 for G2D
Date: Wed, 06 Feb 2013 20:47:52 +0900
Message-id: <02f801ce045f$cbb9f8d0$632dea70$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sylwester Nawrocki
> Sent: Wednesday, February 06, 2013 8:24 PM
> To: Inki Dae
> Cc: 'Sachin Kamat'; linux-media@vger.kernel.org; dri-
> devel@lists.freedesktop.org; devicetree-discuss@lists.ozlabs.org;
> k.debski@samsung.com; kgene.kim@samsung.com; patches@linaro.org; 'Ajay
> Kumar'; kyungmin.park@samsung.com; sw0312.kim@samsung.com;
> jy0922.shim@samsung.com
> Subject: Re: [PATCH v2 2/2] drm/exynos: Add device tree based discovery
> support for G2D
> 
> On 02/06/2013 09:51 AM, Inki Dae wrote:
> [...]
> > I think that it's better to go to gpu than media and we can divide
> Exynos
> > IPs into the bellow categories,
> >
> > Media : mfc
> > GPU : g2d, g3d, fimc, gsc
> 
> Heh, nice try! :) GPU and FIMC ? FIMC is a camera subsystem (hence 'C'
> in the acronym), so what it has really to do with GPU ? All right, this IP
> has really two functions: camera capture and video post-processing
> (colorspace conversion, scaling), but the main feature is camera capture
> (fimc-lite is a camera capture interface IP only).
> 
> Also, Exynos5 GScaler is used as a DMA engine for camera capture data
> pipelines, so it will be used by a camera capture driver as well. It
> really belongs to "Media" and "GPU", as this is a multifunctional
> device (similarly to FIMC).
> 
> So I propose following classification, which seems less inaccurate:
> 
> GPU:   g2d, g3d
> Media: mfc, fimc, fimc-lite, fimc-is, mipi-csis, gsc
> Video: fimd, hdmi, eDP, mipi-dsim
> 

Ok, it seems that your propose is better. :)

To Sachin,
Please add g2d document to .../bindings/gpu

To Rahul,
Could you please move .../drm/exynos/* to .../bindings/video? Probably you
need to rename the files there to exynos*.txt

If there are no other opinions, let's start  :)

Thanks,
Inki Dae

> I have already a DT bindings description prepared for fimc [1].
> (probably it needs to be rephrased a bit not to refer to the linux
> device model). I put it in Documentation/devicetree/bindings/media/soc,
> but likely there is no need for the 'soc' subdirectory...
> 
> > Video : fimd, hdmi, eDP, MIPI-DSI
> >
> > And I think that the device-tree describes hardware so possibly, all
> > documents in .../bindings/drm/exynos/* should be moved to proper place
> also.
> > Please give  me any opinions.
> 
> Yes, I agree. If possible, it would be nice to have some Linux API
> agnostic locations.
> 
> [1] goo.gl/eTGOl
> 
> --
> 
> Thanks,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

