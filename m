Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:47861 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbeH0Mco (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 08:32:44 -0400
Date: Mon, 27 Aug 2018 10:44:18 +0200
From: Helmut Grohne <helmut.grohne@intenta.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: aptina-pll: allow approximating the requested
 pix_clock
Message-ID: <20180827084418.io2ea3z3h3ziv5mf@laureti-dev>
References: <20180814084026.be4fpbhrppdnx2a3@laureti-dev>
 <20180823075208.mqjctv4ax4dakfws@laureti-dev>
 <11902774.1rSuDQUnix@avalon>
 <20180824120517.7fn6omq3q7fhhb52@laureti-dev>
 <20180825113247.64hlewztioog44ao@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20180825113247.64hlewztioog44ao@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 25, 2018 at 01:32:47PM +0200, Sakari Ailus wrote:
> On Fri, Aug 24, 2018 at 02:05:17PM +0200, Helmut Grohne wrote:
> > Take for instance MT9M024. The data sheet
> > (http://www.mouser.com/ds/2/308/MT9M024-D-606228.pdf) allows deducing
> > the following limits:
> > 
> > 	const struct aptina_pll_limits mt9m024_limits = {
> > 		.ext_clock_min = 6000000,
> > 		.ext_clock_max = 50000000,
> > 		.int_clock_min = 2000000,
> > 		.int_clock_max = 24000000,
> > 		.out_clock_min = 384000000,
> > 		.out_clock_max = 768000000,
> > 		.pix_clock_max = 74250000,
> > 		.n_min = 1,
> > 		.n_max = 63,
> > 		.m_min = 32,
> > 		.m_max = 255,
> > 		.p1_min = 4,
> > 		.p1_max = 16,
> > 	};
> > 
> > Now if you choose ext_clock and pix_clock maximal within the given
> > limits, the existing aptina_pll_calculate gives up. Lowering the
> > pix_clock does not help either. Even down to 73 MHz, it is unable to
> > find any pll configuration.
> > 
> > The new algorithm finds a solution (n=11, m=98, p1=6) with 7.5 KHz
> > error. Incidentally, that solution is close to the one given by the
> > vendor tool (n=22, m=196, p1=6).
> 
> These values don't seem valid for 6 MHz --- the frequency after the PLL is
> less than 384 MHz. Did you use a different external clock frequency?

I wrote that I used the maximal external clock frequency, which is 50
MHz. For that value, the output clock is within the requested bounds.
Are you implying that the chosen pll parameters should be valid for all
possible external clocks simultaneously?

Helmut
