Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:22212 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3BALwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 06:52:35 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHJ00JPEIB7C311@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 20:52:33 +0900 (KST)
Received: from NOINKIDAE02 ([10.90.8.52])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHJ00DJUIBLSU20@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 20:52:33 +0900 (KST)
From: Inki Dae <inki.dae@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>
Cc: 'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, patches@linaro.org
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
 <1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
 <CAAQKjZNc0xFaoaqtKsLC=Evn60XA5UChtoMLAcgsWqyLNa7ejQ@mail.gmail.com>
 <510987B5.6090509@gmail.com> <050101cdff52$86df3a70$949daf50$%dae@samsung.com>
 <510B02AB.4080908@gmail.com> <0b7501ce0011$3df65180$b9e2f480$@samsung.com>
 <00fd01ce001b$5215a3f0$f640ebd0$%dae@samsung.com>
 <CAK9yfHxqqumg-oqH_Ku8Zkf8biWVknF91Su0VkWJJXjvWQ3Jhw@mail.gmail.com>
 <510B9EC8.6020102@samsung.com>
 <CAK9yfHw+aTgiLwGVJt=J9-ie4-2JAaF4Nh3n4tjcHp6w2JHamg@mail.gmail.com>
 <014401ce006f$c7dd1dd0$57975970$%dae@samsung.com>
 <CAK9yfHyEdd_nr5eqT9WZ4+J9LHczL4U5VAUEwzzjbH1H0xgjUQ@mail.gmail.com>
In-reply-to: <CAK9yfHyEdd_nr5eqT9WZ4+J9LHczL4U5VAUEwzzjbH1H0xgjUQ@mail.gmail.com>
Subject: RE: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
Date: Fri, 01 Feb 2013 20:52:32 +0900
Message-id: <014501ce0072$9eca1a80$dc5e4f80$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sachin Kamat
> Sent: Friday, February 01, 2013 8:40 PM
> To: Inki Dae
> Cc: Sylwester Nawrocki; Kukjin Kim; Sylwester Nawrocki; linux-
> media@vger.kernel.org; dri-devel@lists.freedesktop.org; devicetree-
> discuss@lists.ozlabs.org; patches@linaro.org
> Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery
> support for G2D
> 
> On 1 February 2013 17:02, Inki Dae <inki.dae@samsung.com> wrote:
> >
> > How about using like below?
> >         Compatible = ""samsung,exynos4x12-fimg-2d" /* for Exynos4212,
> > Exynos4412  */
> > It looks odd to use "samsung,exynos4212-fimg-2d" saying that this ip is
> for
> > exynos4212 and exynos4412.
> 
> AFAIK, compatible strings are not supposed to have any wildcard
characters.
> Compatible string should suggest the first SoC that contained this IP.
> Hence IMO 4212 is OK.
> 

Got it. Please post it again.

> 
> --
> With warm regards,
> Sachin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

