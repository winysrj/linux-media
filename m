Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41480 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaLVOXb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 09:23:31 -0500
Date: Mon, 22 Dec 2014 12:23:19 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCHv2 1/2] regmap: add configurable lock class key for
 lockdep
Message-ID: <20141222122319.4eefacb3@concha.lan.sisa.samsung.com>
In-Reply-To: <20141222133142.GM17800@sirena.org.uk>
References: <1419114892-4550-1-git-send-email-crope@iki.fi>
	<20141222124411.GK17800@sirena.org.uk>
	<549814BB.3040808@iki.fi>
	<20141222133142.GM17800@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Dec 2014 13:31:42 +0000
Mark Brown <broonie@kernel.org> escreveu:

> On Mon, Dec 22, 2014 at 02:55:23PM +0200, Antti Palosaari wrote:
> > On 12/22/2014 02:44 PM, Mark Brown wrote:
> > >On Sun, Dec 21, 2014 at 12:34:51AM +0200, Antti Palosaari wrote:
> 
> > >>I2C client and I2C adapter are using regmap. As a solution, add
> > >>configuration option to pass custom lock class key for lockdep
> > >>validator.
> 
> > >Why is this configurable, how would a device know if the system it is in
> > >needs a custom locking class and can safely use one?
> 
> > If RegMap instance is bus master, eg. I2C adapter, then you should define
> > own custom key. If you don't define own key and there will be slave on that
> > bus which uses RegMap too, there will be recursive locking from a lockdep
> > point of view.
> 
> That doesn't really explain to me why this is configurable, why should
> drivers have to worry about this?
>
> Please also write technical terms like regmap normally.

Hi Mark,

Basically, when there's no nested calls to regmap mutexes, the driver
should not care at all to set it. This likely covers most of the usecases
of the regmap API. However, on too complex drivers like the media ones, 
sometimes, we may have scenarios where:

	Driver A calls I2C driver B
	Driver B can call I2C driver C
	Driver A can call I2C driver C

So, there are three possible scenarios, with regards to mutex:
	driver A -> driver B (locking regmap driver B mutex)
	driver A -> driver C (locking regmap driver C mutex)
	driver A -> driver B (locking regmap driver B mutex) -> driver C (locking regmap driver C mutex)

Depending on the way those calls happen, there are no dead locks, but
disabling lockdep checks as a hole would prevent the code to detect the
bad lock scenarios.

However, on last case (A -> B -> C), the lockdep will complain about a
nested mutex, as it would consider that both B and C are locking the
very same mutex.

What this patch does is to offer a way for drivers B and C to define
different mutex groups (e. g. different mutex "IDs") that will teach
the lockdep code to threat regmap mutex on drivers B and C as different
mutexes.

I hope the above explanation helps.

Regards
-- 

Cheers,
Mauro
