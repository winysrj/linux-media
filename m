Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49387 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752400AbdJITSR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 15:18:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v15 01/32] v4l: async: Remove re-probing support
Date: Mon, 09 Oct 2017 22:18:25 +0300
Message-ID: <4658069.8nBMSYzTmy@avalon>
In-Reply-To: <d24f3e73-0eb5-f523-45a2-6d8b037b3a4d@samsung.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com> <CGME20171009164457epcas1p3c5e134e4bb5d85498fe8d4f00332f2fc@epcas1p3.samsung.com> <d24f3e73-0eb5-f523-45a2-6d8b037b3a4d@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Monday, 9 October 2017 19:44:52 EEST Sylwester Nawrocki wrote:
> On 10/09/2017 04:18 PM, Sakari Ailus wrote:
> > Sure, how about this at the end of the current commit message:
> > 
> > If there is a need to support removing the clock provider in the future,
> > this should be implemented in the clock framework instead, not in V4L2.
> 
> I find it a little bit misleading, there is already support for removing
> the clock provider, only any clock references for consumers became then
> stale.  Perhaps:
> 
> "If there is a need to support the clock provider unregister/register
> cycle while keeping the clock references in the consumers in the future,
> this should be implemented in the clock framework instead, not in V4L2."
> 
> ? That said, I doubt this issue is going to be entirely solved solely
> in the clock framework, as it is a more general problem of resource
> dependencies.  It could be related to other resources, like regulator
> or GPIO.  It has been discussed for a long time now and it will likely
> take time until a general solution is available.

I discussed this issue with Mike Turquette during LPC, and he believed we 
could fix it in the clock framework by adding support for "un-orphaning" a 
clock. This remains to be proven by a real implementation, but could work for 
our use case.

I agree with you that similar problems exist for other resources such as 
regulators and GPIOs, but to my knowledge we have no system that requires V4L2 
reprobing due to regulator or GPIO dependencies.

-- 
Regards,

Laurent Pinchart
