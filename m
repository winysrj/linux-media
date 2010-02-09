Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:37431 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923Ab0BIAxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 19:53:34 -0500
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux
 filter (Was: Videotext application crashes the kernel due to DVB-demux
 patch)
From: hermann pitton <hermann-pitton@arcor.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chicken Shack <chicken.shack@gmx.de>,
	Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>, HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Francesco Lavra <francescolavra@interfree.it>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org, rms@gnu.org
In-Reply-To: <alpine.LFD.2.00.1002080746180.3829@localhost.localdomain>
References: <1265546998.9356.4.camel@localhost>
	 <4B6F72E5.3040905@redhat.com>  <4B700287.5080900@linuxtv.org>
	 <1265636585.5399.47.camel@brian.bconsult.de>
	 <alpine.LFD.2.00.1002080746180.3829@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 09 Feb 2010 01:53:19 +0100
Message-Id: <1265676799.5234.30.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 08.02.2010, 08:14 -0800 schrieb Linus Torvalds:
> 
> On Mon, 8 Feb 2010, Chicken Shack wrote:
> > 
> > This is a SCANDAL, not fun! This is SCANDALOUS!
> 
> I agree that this whole thread has been totally inappropriate from 
> beginning to end. 

The initial problem was, how to find such software producing that oops
at all.

Uwe/Chicken only later friendly distributed it to us.

Is there some alevt 1.7.0 (dvb-t/dvb-s :) anywhere else already?

Since only then, we have been able to discover, that it is valid bug
that needs investigation.

Else I do agree with all your findings, you had him blacklisted on LKML
already too, but v4l and dvb people are also somehow forced to work
together, because of the hybrid devices everywhere now.

Some don't like it and he is always on top of it again.

We make progress in so far.

Hermann



 

