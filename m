Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48555 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbcEKOOf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 10:14:35 -0400
Date: Wed, 11 May 2016 09:14:29 -0500
From: Rob Herring <robh@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Benoit Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux PWM List <linux-pwm@vger.kernel.org>,
	linux-omap <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 4/7] [media] ir-rx51: add DT support to driver
Message-ID: <20160511141429.GA5894@rob-hp-laptop>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1462634508-24961-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160509200657.GA3379@rob-hp-laptop>
 <5730F8BA.5000402@gmail.com>
 <CAL_JsqJPZS1ne_xAuBFtCc5L1HKFJf0LDUJ7CRSFXhc3adkTfA@mail.gmail.com>
 <20160510021826.GE1129@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160510021826.GE1129@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 10, 2016 at 04:18:27AM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Mon, May 09, 2016 at 04:07:35PM -0500, Rob Herring wrote:
> > There's already a pwm-led binding that can be used. Though there
> > may be missing consumer IR to LED subsystem support in the kernel.
> > You could list both compatibles, use the rx51 IR driver now, and
> > then move to pwm-led driver in the future.
> 
> Well from a purely HW point of view it's a PWM connected led. The
> usage is completely different though. Usually PWM is used to control
> the LED's brightness via the duty cycle (basic concept: enabling led
> only 50% of time reduces brightness to 50%).
> 
> In the IR led's case the aim is generating a specific serial pattern
> instead. For this task it uses a dmtimer in PWM mode and a second
> one to reconfigure the pwm timer.

In that case, it will probably never be a generic driver.

> I don't know about a good name, but rx51 should be replaced with
> n900 in the compatible string. So maybe "nokia,n900-infrared-diode".

That's fine, but the shorter '-ir' was too.

Rob
