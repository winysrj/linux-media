Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47261 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbbBTJhX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 04:37:23 -0500
Date: Fri, 20 Feb 2015 07:37:16 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Antti Palosaari <crope@iki.fi>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] [kbuild] Add and use IS_REACHABLE macro
Message-ID: <20150220073716.64560682@recife.lan>
In-Reply-To: <5822078.VORY4BTfEj@wuerfel>
References: <6116702.rrbrOqQ26P@wuerfel>
	<14254005.QkaJhTuY5H@wuerfel>
	<54E5FBEA.1000005@suse.cz>
	<5822078.VORY4BTfEj@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 20 Feb 2015 10:29:42 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Thursday 19 February 2015 16:06:18 Michal Marek wrote:
> > > We have similar problems in other areas
> > > of the kernel. In theory, we could enforce the VIDEO_TUNER driver to
> > > be modular here by adding lots of dependencies to it:
> > > 
> > > config VIDEO_TUNER
> > >       tristate
> > >       depends on MEDIA_TUNER_TEA5761 || !MEDIA_TUNER_TEA5761
> > >       depends on MEDIA_TUNER_TEA5767 || !MEDIA_TUNER_TEA5767
> > >       depends on MEDIA_TUNER_MSI001  || !MEDIA_TUNER_MSI001
> > 
> > Nah, that's even uglier. I suggest to merge your IS_REACHABLE patch.
> > 
> 
> Ok, can I take this as an ack from your side to merge the
> include/linux/kconfig.h part of the patch through the linux-media
> tree?
> 
> I thought about splitting up the patch into two, but that would
> just make merging it harder because we'd still have the dependency.

It is likely better if I merge at the linux-media tree. This way,
we can avoid conflicts with those headers, if this is ok for
Marek.

Regards,
Mauro

> 
> 	Arnd
