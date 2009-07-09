Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:5964 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760476AbZGIQJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2009 12:09:06 -0400
Date: Thu, 9 Jul 2009 18:08:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, Janne Grunau <j@jannau.net>
Subject: Re: [RFC] Anticipating lirc breakage
Message-ID: <20090709180829.33cb6c07@hyperion.delvare>
In-Reply-To: <200907091144.48125.jarod@redhat.com>
References: <20090406174448.118f574e@hyperion.delvare>
	<20090407075029.21d14f4a@pedra.chehab.org>
	<20090407143617.2c2adbf7@hyperion.delvare>
	<200907091144.48125.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 9 Jul 2009 11:44:46 -0400, Jarod Wilson wrote:
> On Tuesday 07 April 2009 08:36:17 Jean Delvare wrote:
> > > So, let's just forget the workarounds and go straight to the point: focus on
> > > merging lirc-i2c drivers.
> > 
> > Will this happen next week? I fear not. Which is why I can't wait for
> > it. And anyway, in order to merge the lirc_i2c driver, it must be
> > turned into a new-style I2C driver first, so bridge drivers must be
> > prepared for this, which is exactly what my patches are doing.
> 
> For what its worth, I fixed up lirc_i2c a few days ago, and now have
> it working just fine with my pvr-250 under 2.6.31-rc2.

Excellent. Apparently you did not hit any problem, but if you ever do
need help for the i2c side of things, just ask and I'll be happy to
help.

> Real Soon Now (I swear), I'm hoping to get up another head of steam
> for submitting lirc upstream. Multiple drivers have received a bunch
> of love in the past few weeks, so I think we're in a pretty good state
> to have another go at it...
> 


-- 
Jean Delvare
