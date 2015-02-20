Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:63477 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbbBTJam (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 04:30:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org,
	Antti Palosaari <crope@iki.fi>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] [kbuild] Add and use IS_REACHABLE macro
Date: Fri, 20 Feb 2015 10:29:42 +0100
Message-ID: <5822078.VORY4BTfEj@wuerfel>
In-Reply-To: <54E5FBEA.1000005@suse.cz>
References: <6116702.rrbrOqQ26P@wuerfel> <14254005.QkaJhTuY5H@wuerfel> <54E5FBEA.1000005@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 19 February 2015 16:06:18 Michal Marek wrote:
> > We have similar problems in other areas
> > of the kernel. In theory, we could enforce the VIDEO_TUNER driver to
> > be modular here by adding lots of dependencies to it:
> > 
> > config VIDEO_TUNER
> >       tristate
> >       depends on MEDIA_TUNER_TEA5761 || !MEDIA_TUNER_TEA5761
> >       depends on MEDIA_TUNER_TEA5767 || !MEDIA_TUNER_TEA5767
> >       depends on MEDIA_TUNER_MSI001  || !MEDIA_TUNER_MSI001
> 
> Nah, that's even uglier. I suggest to merge your IS_REACHABLE patch.
> 

Ok, can I take this as an ack from your side to merge the
include/linux/kconfig.h part of the patch through the linux-media
tree?

I thought about splitting up the patch into two, but that would
just make merging it harder because we'd still have the dependency.

	Arnd
