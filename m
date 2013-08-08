Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47546 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966781Ab3HHWmT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 18:42:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] smiapp: re-use clamp_t instead of min(..., max(...))
Date: Fri, 09 Aug 2013 00:43:23 +0200
Message-ID: <3251824.sEh0l6OtR8@avalon>
In-Reply-To: <20130724155538.GF12281@valkosipuli.retiisi.org.uk>
References: <1374679278-9856-1-git-send-email-andriy.shevchenko@linux.intel.com> <CAHp75Vdp43x=SMYwpxWLoS0f7ku+qmZoAhW8Pao1p7DDGXcCPg@mail.gmail.com> <20130724155538.GF12281@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 24 July 2013 18:55:38 Sakari Ailus wrote:
> On Wed, Jul 24, 2013 at 06:49:24PM +0300, Andy Shevchenko wrote:
> > On Wed, Jul 24, 2013 at 6:45 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > 
> > []
> > 
> > >> +     max_m = clamp_t(u32, max_m,
> > >> sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN], +                    
> > >> sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
> > > 
> > > Do you need clamp_t()? Wouldn't plain clamp() do?
> > 
> > The *_t variants are preferred due to they are faster (no type checking).
> > 
> > > I can change it if you're ok with that.
> > 
> > I don't know why you may choose clamp instead of clamp_t here. Are you
> > going to change variable types?
> 
> Probably not. But clamp() would serve as a sanity check vs. clamp_t() which
> just does the thing. I'd prefer clamp() --- the compiler will not spend much
> time on it anyway.

Should I take this patch in my tree ? If so, could you please repost it with 
clamp() instead of clamp_t(), and your SoB or Acked-by ?

-- 
Regards,

Laurent Pinchart

