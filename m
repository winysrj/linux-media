Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58778 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbbATQBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 11:01:00 -0500
Date: Tue, 20 Jan 2015 17:00:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 07/19] mfd: max77693: Adjust FLASH_EN_SHIFT and
 TORCH_EN_SHIFT macros
Message-ID: <20150120160056.GA32144@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-8-git-send-email-j.anaszewski@samsung.com>
 <20150120111719.GF13701@x1>
 <54BE51B2.8040209@samsung.com>
 <54BE6228.5070304@samsung.com>
 <20150120154029.GC13701@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120154029.GC13701@x1>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 2015-01-20 15:40:29, Lee Jones wrote:
> On Tue, 20 Jan 2015, Jacek Anaszewski wrote:
> 
> > On 01/20/2015 02:01 PM, Jacek Anaszewski wrote:
> > >On 01/20/2015 12:17 PM, Lee Jones wrote:
> > >>On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
> > >>
> > >>>Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
> > >>>when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
> > >>>from leds-max77693 driver.
> > >>
> > >>Off-by-one ay?  Wasn't the original code tested?
> > >
> > >The driver using these macros is a part of LED / flash API integration
> > >patch series, which still undergoes modifications and it hasn't
> > >reached its final state yet, as there are many things to discuss.
> > 
> > To be more precise: the original code had been tested and was working
> > properly with the header that is in the mainline. Nonetheless, because
> > of the modifications in the driver that was requested during code
> > review, it turned out that it would be more convenient to redefine the
> > macros.
> > 
> > I'd opt for just agreeing about the mfd related patches and merge
> > them no sooner than the leds-max77693 driver is merged.
> 
> The only way we can guarantee this is to have them go in during
> different merge-windows, unless of course they go in via the same tree.

Umm. Maintainers should be able to coordinate that. Delaying patch for
one major release seems rather cruel. Perhaps one maintainer should
ack the patch and the second one should merge it...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
