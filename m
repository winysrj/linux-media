Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50423 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbZAXDic (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 22:38:32 -0500
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
From: Andy Walls <awalls@radix.net>
To: "A. F. Cano" <afc@shibaya.lonestar.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090124030715.GA26123@shibaya.lonestar.org>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
	 <1232733940.3907.37.camel@palomino.walls.org>
	 <412bdbff0901231136l6967b5bbj8a3cfd4832ab102e@mail.gmail.com>
	 <1232760678.3907.77.camel@palomino.walls.org>
	 <20090124030715.GA26123@shibaya.lonestar.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jan 2009 22:39:18 -0500
Message-Id: <1232768358.3907.145.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-01-23 at 22:07 -0500, A. F. Cano wrote:
> On Fri, Jan 23, 2009 at 08:31:18PM -0500, Andy Walls wrote:
> > ...
> > Since I was to lazy to get Kaffeine to work properly, I wrote my own
> > test app.  It is inline below so you can see how I measured the time.
> 
> As I pointed out in another message recently I've been having problems
> tuning my own pvrusb2 device (the OnAir Creator).  I did encounter
> problems in kaffeine, so I tried to compile your test app.  A quick
> perusal shows that it uses the /dvb/apapter0/* devices so it should
> work here, but I can't compile it.  I'm missing some *.h file:
> 
> tuner.c: In function ‘main’:
> tuner.c:51: error: array type has incomplete element type
> tuner.c:52: error: storage size of ‘tasks’ isn’t known
> tuner.c:68: error: ‘DTV_DELIVERY_SYSTEM’ undeclared (first use in this function)
> tuner.c:68: error: (Each undeclared identifier is reported only once
> tuner.c:68: error: for each function it appears in.)
> tuner.c:69: error: ‘SYS_ATSC’ undeclared (first use in this function)
> tuner.c:71: error: ‘DTV_MODULATION’ undeclared (first use in this function)
> tuner.c:76: error: ‘FE_SET_PROPERTY’ undeclared (first use in this function)
> tuner.c:96: error: ‘DTV_FREQUENCY’ undeclared (first use in this function)
> tuner.c:97: error: ‘DTV_TUNE’ undeclared (first use in this function)
> 
> I'm running Debian Lenny.  I did install the libdvb-dev package but that
> wasn't it.  There are libdvbpsi[345]-dev packages, but before I go
> installing useless packages I thought I'd ask.

The latest dvb/frontend.h header file that includes the DVB API v5
ioctl()s aren't include in most distributions yet.


Here's how I compiled it, pointing to an include directory inside my
development repository:

$ gcc -Wall tune.c -o tune -I/home/andy/cx18dev/v4l-dvb/linux/include

Be aware that my little app sets up ATSC 8-VSB modulation which is the
driver default for my card anyway.  Even if I left some settings out, I
knew things would "just work".

Also note that I have a hard coded frequency/channel table in the
program useful for the terrestrial broadcasters near me, not necessarily
near you.

Regards,
Andy


