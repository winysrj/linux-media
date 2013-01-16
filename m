Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22952 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3APONb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 09:13:31 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGQ005XD245SK40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jan 2013 14:13:29 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MGQ00L2R25SBG10@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jan 2013 14:13:29 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, ajaykumar.rs@samsung.com,
	patches@linaro.org
References: <1357541069-7898-1-git-send-email-sachin.kamat@linaro.org>
 <50F67D4A.9010909@samsung.com>
 <CAK9yfHzaGgKrwbwbHjiciMWdD3dEqMctWj89pCSvUuotHBVG7Q@mail.gmail.com>
In-reply-to: <CAK9yfHzaGgKrwbwbHjiciMWdD3dEqMctWj89pCSvUuotHBVG7Q@mail.gmail.com>
Subject: RE: [PATCH] s5p-g2d: Add support for G2D H/W Rev.4.1
Date: Wed, 16 Jan 2013 15:13:03 +0100
Message-id: <000701cdf3f3$9a10b0c0$ce321240$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

I tested your patch on Exynos 4210 and it works. Ack on my side.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Wednesday, January 16, 2013 11:24 AM
> To: Sylwester Nawrocki
> Cc: linux-media@vger.kernel.org; ajaykumar.rs@samsung.com;
> patches@linaro.org; Kamil Debski
> Subject: Re: [PATCH] s5p-g2d: Add support for G2D H/W Rev.4.1
> 
> Hi Sylwester,
> 
> On 16 January 2013 15:43, Sylwester Nawrocki <s.nawrocki@samsung.com>
> wrote:
> > Hi Sachin,
> >
> > I have just one small comment...
> >
> > On 01/07/2013 07:44 AM, Sachin Kamat wrote:
> >> +static void *g2d_get_drv_data(struct platform_device *pdev) {
> >> +     struct g2d_variant *driver_data = NULL;
> >> +
> >> +     driver_data = (struct g2d_variant *)
> >> +             platform_get_device_id(pdev)->driver_data;
> >> +
> >> +     return driver_data;
> >> +}
> >
> > How about adding this to g2d.h as:
> >
> > static inline struct g2d_variant *g2d_get_drv_data(struct
> > platform_device *pdev) {
> >         return (struct g2d_variant
> > *)platform_get_device_id(pdev)->driver_data;
> > }
> >
> > ?
> 
> OK. I will move it to g2d.h and resend the patch.
> 
> >
> > Otherwise the patch looks OK to me.
> >
> > --
> >
> > Thanks,
> > Sylwester
> 
> 
> 
> --
> With warm regards,
> Sachin


