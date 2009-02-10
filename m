Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbZBJTDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:18 -0500
Date: Tue, 10 Feb 2009 17:02:03 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jonathan Isom <jeisom@gmail.com>
Cc: hermann pitton <hermann-pitton@arcor.de>, CityK <cityk@rogers.com>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	David Engel <david@istwok.net>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090210170203.61fe7709@pedra.chehab.org>
In-Reply-To: <1767e6740902100448q4f710a87q511b61433e992898@mail.gmail.com>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<1234226235.2790.27.camel@pc10.localdom.local>
	<1234227277.3932.4.camel@pc10.localdom.local>
	<1234229460.3932.27.camel@pc10.localdom.local>
	<20090210003520.14426415@pedra.chehab.org>
	<1234235643.2682.16.camel@pc10.localdom.local>
	<1234237395.2682.22.camel@pc10.localdom.local>
	<20090210041512.6d684be3@pedra.chehab.org>
	<1767e6740902100407t6737d9f4j5d9edefef8801e27@mail.gmail.com>
	<20090210102732.5421a296@pedra.chehab.org>
	<1767e6740902100448q4f710a87q511b61433e992898@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Feb 2009 06:48:12 -0600
Jonathan Isom <jeisom@gmail.com> wrote:

> > You tried the latest tree at http://linuxtv.org/hg/v4l-dvb or my saa7134 tree
> > (http://linuxtv.org/hg/~mchehab/saa7134)?
> >
> > In the first case, could you please confirm that it works fine also with the saa7134 tree?  
> 
> Hi
>   I can confirm they work with both trees.
> 
> Later


Thanks, Jonathan. I'll merge the saa7134 patches then. The method I used
previously is better fitted when we know how to enable and disable the i2c
gate, but, for ATSC 115, we only know how to open the gate.

Cheers,
Mauro
