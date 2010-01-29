Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54225 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab0A2C1t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 21:27:49 -0500
Subject: Re: cx18 fix patches
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4B624309.9040700@infradead.org>
References: <4B60F901.20301@redhat.com>
	 <1264681562.3081.3.camel@palomino.walls.org>
	 <4B624309.9040700@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 21:27:01 -0500
Message-Id: <1264732021.3095.18.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-01-29 at 00:08 -0200, Mauro Carvalho Chehab wrote:
> Andy Walls wrote:
> > Now I'll just review and test tonight (some time between 6:00 - 10:30
> > p.m. EST)
> 
> One more error (on x86_64):
> 
> drivers/media/video/cx18/cx18-alsa-pcm.c: In function ‘cx18_alsa_announce_pcm_data’:
> drivers/media/video/cx18/cx18-alsa-pcm.c:82: warning: format ‘%d’ expects type ‘int’, but argument 5 has type ‘size_t’
> 
> You should use %zu for size_t.

Yes, I saw it.

I'll handle it this weekend with some other cx18 fixes.  I'll have to
give you changes via -hg or as patches posted to the list, as I don't
have a -git clone yet.

Regards,
Andy

> Cheers,
> Mauro
> 

