Return-path: <linux-media-owner@vger.kernel.org>
Received: from uucp.cirr.com ([192.67.63.5]:63749 "EHLO killer.cirr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZAXDIP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 22:08:15 -0500
Received: from afc by tashi.lonestar.org with local (Exim 4.69)
	(envelope-from <afc@shibaya.lonestar.org>)
	id 1LQYrc-0000Fc-6x
	for linux-media@vger.kernel.org; Fri, 23 Jan 2009 22:07:16 -0500
Date: Fri, 23 Jan 2009 22:07:16 -0500
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-media@vger.kernel.org
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
Message-ID: <20090124030715.GA26123@shibaya.lonestar.org>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com> <1232733940.3907.37.camel@palomino.walls.org> <412bdbff0901231136l6967b5bbj8a3cfd4832ab102e@mail.gmail.com> <1232760678.3907.77.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1232760678.3907.77.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 23, 2009 at 08:31:18PM -0500, Andy Walls wrote:
> ...
> Since I was to lazy to get Kaffeine to work properly, I wrote my own
> test app.  It is inline below so you can see how I measured the time.

As I pointed out in another message recently I've been having problems
tuning my own pvrusb2 device (the OnAir Creator).  I did encounter
problems in kaffeine, so I tried to compile your test app.  A quick
perusal shows that it uses the /dvb/apapter0/* devices so it should
work here, but I can't compile it.  I'm missing some *.h file:

tuner.c: In function ‘main’:
tuner.c:51: error: array type has incomplete element type
tuner.c:52: error: storage size of ‘tasks’ isn’t known
tuner.c:68: error: ‘DTV_DELIVERY_SYSTEM’ undeclared (first use in this function)
tuner.c:68: error: (Each undeclared identifier is reported only once
tuner.c:68: error: for each function it appears in.)
tuner.c:69: error: ‘SYS_ATSC’ undeclared (first use in this function)
tuner.c:71: error: ‘DTV_MODULATION’ undeclared (first use in this function)
tuner.c:76: error: ‘FE_SET_PROPERTY’ undeclared (first use in this function)
tuner.c:96: error: ‘DTV_FREQUENCY’ undeclared (first use in this function)
tuner.c:97: error: ‘DTV_TUNE’ undeclared (first use in this function)

I'm running Debian Lenny.  I did install the libdvb-dev package but that
wasn't it.  There are libdvbpsi[345]-dev packages, but before I go
installing useless packages I thought I'd ask.

A.

