Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48792 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726418AbeHYPLb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Aug 2018 11:11:31 -0400
Date: Sat, 25 Aug 2018 14:32:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Helmut Grohne <helmut.grohne@intenta.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: aptina-pll: allow approximating the requested
 pix_clock
Message-ID: <20180825113247.64hlewztioog44ao@valkosipuli.retiisi.org.uk>
References: <20180814084026.be4fpbhrppdnx2a3@laureti-dev>
 <20180823075208.mqjctv4ax4dakfws@laureti-dev>
 <11902774.1rSuDQUnix@avalon>
 <20180824120517.7fn6omq3q7fhhb52@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180824120517.7fn6omq3q7fhhb52@laureti-dev>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 24, 2018 at 02:05:17PM +0200, Helmut Grohne wrote:
> Hi Laurent,
> 
> Thank you for taking the time to reply to my patch and to my earlier
> questions.
> 
> On Thu, Aug 23, 2018 at 01:12:15PM +0200, Laurent Pinchart wrote:
> > Could you please share numbers, ideally when run in kernel space ?
> 
> Can you explain the benefits of profiling this inside the kernel rather
> than outside? Doing it outside is much simpler, so I'd like to
> understand your reasons. The next question is what kind of system to
> profile on. I guess doing it on an X86 will not help. Typical users will
> use some arm CPU and integer division on arm is slower than on x86. Is a
> Cortex A9 ok?
> 
> If you can provide more relevant inputs, that'd also help. I was able to
> derive an example input from the dt bindings for mt9p031 (ext=6MHz,
> pix=96MHz) and also used random inputs for testing. Getting more
> real-world inputs would help in producing a useful benchmark.
> 
> > This patch is very hard to review as you rewrite the whole, removing all the 
> > documentation for the existing algorithm, without documenting the new one. 
> 
> That's not entirely fair. Unlike the original algorithm, I've split it
> to multiple functions and unlike the original algorithm, I've documented
> pre- and post-conditions. In a sense, that's actually more
> documentation. At least, you now see what the functions are supposed to
> be doing.
> 
> Inside the alogrithm, I've often writting which precondition
> (in)equation I used in which particular step.
> 
> The variable naming choice makes it very clear that the first step is
> reducing the value ranges for n, m, and p1 as much as possible before
> proceeding to an actual parameter computation.
> 
> There was little choice in removing much of the old algorithm as the
> approach of using gcd is numerically unstable. I actually kept
> everything until the first gcd computation.
> 
> > There's also no example of a failing case with the existing code that works 
> > with yours.
> 
> That is an unfortunate omission. I should have thought of this and
> should have given it upfront. I'm sorry.
> 
> Take for instance MT9M024. The data sheet
> (http://www.mouser.com/ds/2/308/MT9M024-D-606228.pdf) allows deducing
> the following limits:
> 
> 	const struct aptina_pll_limits mt9m024_limits = {
> 		.ext_clock_min = 6000000,
> 		.ext_clock_max = 50000000,
> 		.int_clock_min = 2000000,
> 		.int_clock_max = 24000000,
> 		.out_clock_min = 384000000,
> 		.out_clock_max = 768000000,
> 		.pix_clock_max = 74250000,
> 		.n_min = 1,
> 		.n_max = 63,
> 		.m_min = 32,
> 		.m_max = 255,
> 		.p1_min = 4,
> 		.p1_max = 16,
> 	};
> 
> Now if you choose ext_clock and pix_clock maximal within the given
> limits, the existing aptina_pll_calculate gives up. Lowering the
> pix_clock does not help either. Even down to 73 MHz, it is unable to
> find any pll configuration.
> 
> The new algorithm finds a solution (n=11, m=98, p1=6) with 7.5 KHz
> error. Incidentally, that solution is close to the one given by the
> vendor tool (n=22, m=196, p1=6).

These values don't seem valid for 6 MHz --- the frequency after the PLL is
less than 384 MHz. Did you use a different external clock frequency?

> 
> > Could you please document the algorithm in details (especially explaining the 
> > background ideas), and share at least one use case, with with numbers for all 
> > the input and output parameters ?
> 
> I'll try to improve the documentation in the next version. Summarizing
> the idea is something I can do, but beyond that I don't see much to add
> beyond prose.
> 
> Ahead of posting a V2, let me suggest this:
> 
> /* The first part of the algorithm reduces the given aptina_pll_limits
>  * for n, m and p1 using the (in)equalities and the concrete values for
>  * ext_clock and pix_clock in order to reduce the search space.
>  *
>  * The main loop iterates over all remaining possible p1 values and
>  * computes the necessary out_clock frequency. The ext_clock / out_clock
>  * ratio is then approximated with n / m within their respective bounds.
>  * For each parameter choice, the preconditions must be rechecked,
>  * because integer rounding errors may result in violating some of the
>  * preconditions. The parameter set with the least frequency error is
>  * returned.
>  */
> 
> Is this what you are looking for?
> 
> Helmut

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
