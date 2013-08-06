Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:56789 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3HFWRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 18:17:42 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Grant Likely' <grant.likely@secretlab.ca>,
	Tomasz Figa <t.figa@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Sachin Kamat' <sachin.kamat@linaro.org>,
	'Rob Herring' <robherring2@gmail.com>,
	'Olof Johansson' <olof@lixom.net>,
	'Pawel Moll' <pawel.moll@arm.com>,
	'Mark Rutland' <mark.rutland@arm.com>,
	'Stephen Warren' <swarren@wwwdotorg.org>,
	'Ian Campbell' <ian.campbell@citrix.com>
Subject: Re: [PATCH 2/2] media: s5p-mfc: remove DT hacks and simplify initialization code
Date: Wed, 07 Aug 2013 00:17:36 +0200
Message-ID: <2081911.Lb2nBczokV@flatron>
In-Reply-To: <520174F5.6060508@samsung.com>
References: <1375705610-12724-1-git-send-email-m.szyprowski@samsung.com> <030d01ce928e$de27e190$9a77a4b0$%debski@samsung.com> <520174F5.6060508@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kukjin,

On Wednesday 07 of August 2013 07:13:09 Kukjin Kim wrote:
> On 08/06/13 19:22, Kamil Debski wrote:
> > Hi Kukjin,
> > 
> > This patch looks good.
> > 
> > Best wishes,
> > Kamil Debski
> > 
> >> From: Marek Szyprowski [mailto:m.szyprowski@samsung.com]
> >> Sent: Monday, August 05, 2013 2:27 PM
> >> 
> >> This patch removes custom initialization of reserved memory regions
> >> from s5p-mfc driver. Memory initialization can be now handled by
> >> generic code.
> >> 
> >> Signed-off-by: Marek Szyprowski<m.szyprowski@samsung.com>
> > 
> > Acked-by: Kamil Debski<k.debski@samsung.com>
> 
> Kamil, thanks for your ack.
> 
> Applied.

This is a nice cleanup, but I don't think it should be applied yet, 
because it depends on patch 1/2, which needs an Ack from DT maintainers.

Best regards,
Tomasz

