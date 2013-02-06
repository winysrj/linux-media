Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25398 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3BFLXg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 06:23:36 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHS003L8Q4KSC50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 11:23:34 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MHS009NBQB96Y40@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 11:23:34 +0000 (GMT)
Message-id: <51123D34.5020404@samsung.com>
Date: Wed, 06 Feb 2013 12:23:32 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Inki Dae <inki.dae@samsung.com>
Cc: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, k.debski@samsung.com,
	kgene.kim@samsung.com, patches@linaro.org,
	'Ajay Kumar' <ajaykumar.rs@samsung.com>,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	jy0922.shim@samsung.com
Subject: Re: [PATCH v2 2/2] drm/exynos: Add device tree based discovery support
 for G2D
References: <1360128584-23167-1-git-send-email-sachin.kamat@linaro.org>
 <1360128584-23167-2-git-send-email-sachin.kamat@linaro.org>
 <02a301ce043c$1b12d150$513873f0$%dae@samsung.com>
 <CAK9yfHyZrwdJV-Ct8Fby0uX1htHpAmJvCnX3VRYJSsey=L5HFA@mail.gmail.com>
 <02af01ce0447$37c26940$a7473bc0$%dae@samsung.com>
In-reply-to: <02af01ce0447$37c26940$a7473bc0$%dae@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2013 09:51 AM, Inki Dae wrote:
[...]
> I think that it's better to go to gpu than media and we can divide Exynos
> IPs into the bellow categories,
> 
> Media : mfc
> GPU : g2d, g3d, fimc, gsc

Heh, nice try! :) GPU and FIMC ? FIMC is a camera subsystem (hence 'C' 
in the acronym), so what it has really to do with GPU ? All right, this IP 
has really two functions: camera capture and video post-processing 
(colorspace conversion, scaling), but the main feature is camera capture 
(fimc-lite is a camera capture interface IP only).

Also, Exynos5 GScaler is used as a DMA engine for camera capture data
pipelines, so it will be used by a camera capture driver as well. It
really belongs to "Media" and "GPU", as this is a multifunctional 
device (similarly to FIMC).

So I propose following classification, which seems less inaccurate:

GPU:   g2d, g3d
Media: mfc, fimc, fimc-lite, fimc-is, mipi-csis, gsc
Video: fimd, hdmi, eDP, mipi-dsim

I have already a DT bindings description prepared for fimc [1].
(probably it needs to be rephrased a bit not to refer to the linux
device model). I put it in Documentation/devicetree/bindings/media/soc, 
but likely there is no need for the 'soc' subdirectory...

> Video : fimd, hdmi, eDP, MIPI-DSI
> 
> And I think that the device-tree describes hardware so possibly, all
> documents in .../bindings/drm/exynos/* should be moved to proper place also.
> Please give  me any opinions.

Yes, I agree. If possible, it would be nice to have some Linux API
agnostic locations.

[1] goo.gl/eTGOl

--

Thanks,
Sylwester
