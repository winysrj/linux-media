Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:60662 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932202Ab2LNTlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 14:41:22 -0500
Date: Fri, 14 Dec 2012 11:41:16 -0800
From: Tony Lindgren <tony@atomide.com>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: balbi@ti.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] ir-rx51: Handle signals properly
Message-ID: <20121214194115.GL4989@atomide.com>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1353251589-26143-2-git-send-email-timo.t.kokkonen@iki.fi>
 <20121120195755.GM18567@atomide.com>
 <20121214172809.GT4989@atomide.com>
 <20121214172616.GC9620@arwen.pp.htv.fi>
 <50CB7E88.9050207@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CB7E88.9050207@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Timo Kokkonen <timo.t.kokkonen@iki.fi> [121214 11:33]:
> On 12/14/12 19:26, Felipe Balbi wrote:
> > 
> > if it's really for PWM, shouldn't we be using drivers/pwm/ ??
> > 
> 
> Now that Neil Brown posted the PWM driver for omap, I've been thinking
> about whether converting the ir-rx51 into the PWM API would work. Maybe
> controlling the PWM itself would be sufficient, but the ir-rx51 uses
> also another dmtimer for creating accurate (enough) timing source for
> the IR pulse edges.

OK.
 
> I haven't tried whether the default 32kHz clock source is enough for
> that. Now that I think about it, I don't see why it wouldn't be good
> enough. I think it would even be possible to just use the PWM api alone

Cool.

Regards,

Tony
