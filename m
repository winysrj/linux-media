Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934216AbZGQIUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 04:20:04 -0400
Date: Fri, 17 Jul 2009 05:19:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Laszlo Kustan <lkustan@gmail.com>, linux-media@vger.kernel.org
Subject: Re: AVerMedia AVerTV GO 007 FM, no radio sound (with routing
 enabled)
Message-ID: <20090717051956.1b6253c4@pedra.chehab.org>
In-Reply-To: <1247803058.26678.2.camel@AcerAspire4710>
References: <88b49f150907161417r7d487078h3e27b514cf8dd5cf@mail.gmail.com>
	<1247794346.3921.22.camel@AcerAspire4710>
	<1247797282.3187.47.camel@pc07.localdom.local>
	<1247803058.26678.2.camel@AcerAspire4710>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Jul 2009 10:57:38 +0700
Pham Thanh Nam <phamthanhnam.ptn@gmail.com> escreveu:

> Hi
> So, should we add an option for this card? For example:
> modprobe saa7134 card=57 radioontv

IMO, we should just apply a patch doing the right thing.

I couldn't find any explanation for the change. Let's just fix it with a good
explanation and hope that this will work with all AverTV GO 007 FM boards. If
not, someone will complain.



Cheers,
Mauro
