Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:45719 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875Ab0BKA6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 19:58:07 -0500
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135
 variants
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
In-Reply-To: <20100210203601.31ef3220@hyperion.delvare>
References: <20100127120211.2d022375@hyperion.delvare>
	 <4B630179.3080006@redhat.com> <1264812461.16350.90.camel@localhost>
	 <20100130115632.03da7e1b@hyperion.delvare>
	 <1264986995.21486.20.camel@pc07.localdom.local>
	 <20100201105628.77057856@hyperion.delvare>
	 <1265075273.2588.51.camel@localhost>
	 <20100202085415.38a1e362@hyperion.delvare> <4B681173.1030404@redhat.com>
	 <20100210190907.5c695e4e@hyperion.delvare> <4B72FD83.1050500@redhat.com>
	 <20100210203601.31ef3220@hyperion.delvare>
Content-Type: text/plain
Date: Thu, 11 Feb 2010 01:58:02 +0100
Message-Id: <1265849882.4422.17.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 10.02.2010, 20:36 +0100 schrieb Jean Delvare:
> On Wed, 10 Feb 2010 16:40:03 -0200, Mauro Carvalho Chehab wrote:
> > Jean Delvare wrote:
> > > Under the assumption that saa7134_hwinit1() only touches GPIOs
> > > connected to IR receivers (and it certainly looks like this to me) I
> > > fail to see how these pins not being initialized could have any effect
> > > on non-IR code.
> > 
> > Now, i suspect that you're messing things again: are you referring to saa7134_hwinit1() or
> > to saa7134_input_init1()?
> > 
> > I suspect that you're talking about moving saa7134_input_init1(), since saa7134_hwinit1()
> > has the muted and spinlock inits. It also has the setups for video, vbi and mpeg. 
> > So, moving it require more care.
> 
> Err, you're right, I meant saa7134_input_init1() and not
> saa7134_hwinit1(), copy-and-paste error. Sorry for adding more
> confusion where it really wasn't needed...
> 

both attempts of Jean will work.

If we are only talking about moving input_init, only that Jean did
suggest initially, it should work, since only some GPIOs for enabling
remote chips are affected.

I can give the crappy tester, but don't have such a remote, but should
not be a problem to trigger the GPIOs later.

Cheers,
Hermann


