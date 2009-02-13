Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZBMLa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 06:30:27 -0500
Date: Fri, 13 Feb 2009 09:28:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David Engel <david@istwok.net>, Jonathan Isom <jeisom@gmail.com>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090213092845.0ebfe97a@pedra.chehab.org>
In-Reply-To: <20090213090446.2d77435a@pedra.chehab.org>
References: <1234229460.3932.27.camel@pc10.localdom.local>
	<20090210003520.14426415@pedra.chehab.org>
	<1234235643.2682.16.camel@pc10.localdom.local>
	<1234237395.2682.22.camel@pc10.localdom.local>
	<20090210041512.6d684be3@pedra.chehab.org>
	<1767e6740902100407t6737d9f4j5d9edefef8801e27@mail.gmail.com>
	<20090210102732.5421a296@pedra.chehab.org>
	<20090211035016.GA3258@opus.istwok.net>
	<20090211054329.6c54d4ad@pedra.chehab.org>
	<20090211232149.GA28415@opus.istwok.net>
	<20090213030750.GA3721@opus.istwok.net>
	<20090213090446.2d77435a@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Feb 2009 09:04:46 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> It seems that some parts of saa7134 (or frontend) is overriding the i2c
> address,to write at the demod, causing a mess. Another alternative would be
> some bug at v4l subdev interface.
> 
> I'll seek at saa7134 code to see who is causing this error.

Ok, I found the bug. It is inside tuner-simple code. It is caused due to a hack for TUV1236.

I've just committed a fix for it:
	http://linuxtv.org/hg/v4l-dvb/rev/34ec729ed1a7

Please test.

Cheers,
Mauro
