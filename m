Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10446 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965713Ab0GPOs1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 10:48:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Date: Fri, 16 Jul 2010 16:47:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: [PATCH 01/10 v2] ARM: Samsung: Add FIMC register and platform
 definitions
In-reply-to: <4C40603B.8000208@gmail.com>
To: 'Maurus Cuelenaere' <mcuelenaere@gmail.com>
Cc: 'Kukjin Kim' <kgene.kim@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Message-id: <000801cb24f5$c3377490$49a65db0$%nawrocki@samsung.com>
Content-language: en-us
References: <1279185041-6004-1-git-send-email-s.nawrocki@samsung.com>
 <1279185041-6004-2-git-send-email-s.nawrocki@samsung.com>
 <012101cb24cb$83187410$89495c30$%kim@samsung.com>
 <000301cb24eb$13434000$39c9c000$%nawrocki@samsung.com>
 <4C40603B.8000208@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Maurus Cuelenaere [mailto:mcuelenaere@gmail.com]
> Sent: Friday, July 16, 2010 3:36 PM
> To: Sylwester Nawrocki
> Cc: 'Kukjin Kim'; Pawel Osciak; Marek Szyprowski;
> kyungmin.park@samsung.com; linux-media@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 01/10 v2] ARM: Samsung: Add FIMC register and
> platform definitions
> 
>  Op 16-07-10 15:30, Sylwester Nawrocki schreef:
> > Hi,
> >
> > thank you for the review. Please se my comments below.
> >
> >> -----Original Message-----
> >> From: Kukjin Kim [mailto:kgene.kim@samsung.com]
> >> Sent: Friday, July 16, 2010 11:45 AM
> >> To: 'Sylwester Nawrocki'; linux-samsung-soc@vger.kernel.org; linux-
> arm-
> >> kernel@lists.infradead.org
> >> Cc: p.osciak@samsung.com; m.szyprowski@samsung.com;
> >> kyungmin.park@samsung.com; linux-media@vger.kernel.org
> >> Subject: RE: [PATCH 01/10 v2] ARM: Samsung: Add FIMC register and
> >> platform definitions
> >>

<snip>

> >>> +
> >>> +struct samsung_plat_fimc {
> >>> +	struct s3c_fifo_link	*fifo_targets[FIMC_MAX_FIFO_TARGETS];
> >>> +};
> >>> +
> >>> +#endif /* FIMC_H_ */
> >>> +
> >> No need last empty line...
> > C89 and C99 standard requires a new line character at the end of
> file.
> > The compiler should issue a warning when the new line character
> > at the end of file is missing, otherwise it is not compliant with
> > the above C standards.
> > So I would rather add a new line where it is missing rather than
> > removing it.
> > There is lots of header files already in arch/arm/plat-samsung where
> > there is even more than one empty line at the end of file.
> 
> AFAIK there *already is* an empty line, git just omits it in diffs.
> Try removing the last line with your editor and see what git diff
> gives, it'll
> show "\ No newline at end of file".

Indeed, I just had two new-line characters with single empty line..

> 
> --
> Maurus Cuelenaere

Thanks,
Sylwester


