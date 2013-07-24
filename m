Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33310 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754002Ab3GXP4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 11:56:13 -0400
Date: Wed, 24 Jul 2013 18:55:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] smiapp: re-use clamp_t instead of min(..., max(...))
Message-ID: <20130724155538.GF12281@valkosipuli.retiisi.org.uk>
References: <1374679278-9856-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130724154536.GE12281@valkosipuli.retiisi.org.uk>
 <CAHp75Vdp43x=SMYwpxWLoS0f7ku+qmZoAhW8Pao1p7DDGXcCPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vdp43x=SMYwpxWLoS0f7ku+qmZoAhW8Pao1p7DDGXcCPg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 24, 2013 at 06:49:24PM +0300, Andy Shevchenko wrote:
> On Wed, Jul 24, 2013 at 6:45 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
> []
> 
> >> +     max_m = clamp_t(u32, max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
> >> +                     sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
> >
> > Do you need clamp_t()? Wouldn't plain clamp() do?
> 
> The *_t variants are preferred due to they are faster (no type checking).
> 
> > I can change it if you're ok with that.
> 
> I don't know why you may choose clamp instead of clamp_t here. Are you
> going to change variable types?

Probably not. But clamp() would serve as a sanity check vs. clamp_t() which
just does the thing. I'd prefer clamp() --- the compiler will not spend much
time on it anyway.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
