Return-path: <linux-media-owner@vger.kernel.org>
Received: from www84.your-server.de ([213.133.104.84]:50479 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbZLRWJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 17:09:26 -0500
Subject: Re: [Fwd: [patch] media video cx23888 driver: ported to new kfifo
 API]
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org
In-Reply-To: <20091218140026.15416033.akpm@linux-foundation.org>
References: <4B2B5622.80604@infradead.org>
	 <1261137648.3080.36.camel@palomino.walls.org>
	 <1261138265.8293.2.camel@wall-e>
	 <1261172359.3060.11.camel@palomino.walls.org>
	 <1261173442.13019.13.camel@wall-e>
	 <20091218140026.15416033.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 18 Dec 2009 23:09:26 +0100
Message-ID: <1261174166.13019.20.camel@wall-e>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 18.12.2009, 14:00 -0800 schrieb Andrew Morton:
> On Fri, 18 Dec 2009 22:57:22 +0100
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > But kfifo_len() did not
> > requiere a lock in my opinion. It is save to use without a look. 
> 
> What do you mean by this?  Safe in general, or safe in this particular driver?
> 

Safe until you don't call kfifo_reset(). kfifo_reset() is evil, because
it it the only function which breaks the single read/writer concept. 

This function modifies the in and the out fifo counters. Thats why i
introduced the kfifo_reset_out() function, which set the out to the
value of in, which means the fifo is empty. This function can be call
from the receiver of a fifo without locking.  

Stefani




