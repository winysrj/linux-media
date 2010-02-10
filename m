Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:62367 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab0BJTgG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 14:36:06 -0500
Date: Wed, 10 Feb 2010 20:36:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135
 variants
Message-ID: <20100210203601.31ef3220@hyperion.delvare>
In-Reply-To: <4B72FD83.1050500@redhat.com>
References: <20100127120211.2d022375@hyperion.delvare>
	<4B630179.3080006@redhat.com>
	<1264812461.16350.90.camel@localhost>
	<20100130115632.03da7e1b@hyperion.delvare>
	<1264986995.21486.20.camel@pc07.localdom.local>
	<20100201105628.77057856@hyperion.delvare>
	<1265075273.2588.51.camel@localhost>
	<20100202085415.38a1e362@hyperion.delvare>
	<4B681173.1030404@redhat.com>
	<20100210190907.5c695e4e@hyperion.delvare>
	<4B72FD83.1050500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Feb 2010 16:40:03 -0200, Mauro Carvalho Chehab wrote:
> Jean Delvare wrote:
> > Under the assumption that saa7134_hwinit1() only touches GPIOs
> > connected to IR receivers (and it certainly looks like this to me) I
> > fail to see how these pins not being initialized could have any effect
> > on non-IR code.
> 
> Now, i suspect that you're messing things again: are you referring to saa7134_hwinit1() or
> to saa7134_input_init1()?
> 
> I suspect that you're talking about moving saa7134_input_init1(), since saa7134_hwinit1()
> has the muted and spinlock inits. It also has the setups for video, vbi and mpeg. 
> So, moving it require more care.

Err, you're right, I meant saa7134_input_init1() and not
saa7134_hwinit1(), copy-and-paste error. Sorry for adding more
confusion where it really wasn't needed...

-- 
Jean Delvare
