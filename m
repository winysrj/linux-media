Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51122 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab3AGMMP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 07:12:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, tomi.valkeinen@ti.com,
	LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Status of the patches under review at LMML (35 patches)
Date: Mon, 07 Jan 2013 13:13:48 +0100
Message-ID: <1875055.ndRnj5NEuO@avalon>
In-Reply-To: <CA+V-a8tD5AEV4EseDky=sdWXKqsCyASk96wwxF=-ZmNQOUcJaA@mail.gmail.com>
References: <20130106113455.329ad868@redhat.com> <CA+V-a8tD5AEV4EseDky=sdWXKqsCyASk96wwxF=-ZmNQOUcJaA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Monday 07 January 2013 11:26:01 Prabhakar Lad wrote:
> On Sun, Jan 6, 2013 at 7:04 PM, Mauro Carvalho Chehab wrote:
> > This is the summary of the patches that are currently under review at
> > Linux Media Mailing List <linux-media@vger.kernel.org>.
> > Each patch is represented by its submission date, the subject (up to 70
> > chars) and the patchwork link (if submitted via email).
> 
> <Snip>
> 
> >                 == Prabhakar Lad <prabhakar.lad@ti.com> ==
> > 
> > Aug,24 2012: Corrected Oops on omap_vout when no manager is connected     
> >          http://patchwork.linuxtv.org/patch/14033  Federico Fuga
> > <fuga@studiofuga.com>
> Tomi can you take care of this patch ?

Tomi is on parental leave until beginning of February. Beside, he doesn't have 
much experience with the omap_vout driver. We need an Acked-by on this patch 
before he can take it in his tree.

-- 
Regards,

Laurent Pinchart

