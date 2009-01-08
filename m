Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6fe81ee853252f17f9b7+1964+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LKjqT-00089M-GL
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 02:38:01 +0100
Date: Wed, 7 Jan 2009 23:37:27 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Message-ID: <20090107233727.431157f9@pedra.chehab.org>
In-Reply-To: <1231288416.3117.29.camel@palomino.walls.org>
References: <20090104113738.GD3551@gmail.com>
	<1231097304.3125.64.camel@palomino.walls.org>
	<20090105130720.GB3621@gmail.com>
	<1231202800.3110.13.camel@palomino.walls.org>
	<20090106144917.736584e7@pedra.chehab.org>
	<20090106170002.GC3403@gmail.com>
	<20090106170926.52575365@pedra.chehab.org>
	<7C301ED0-CA57-406B-BA34-43A6EB21D96C@WhiteCitadel.com>
	<35565.62.178.208.71.1231285755.squirrel@webmail.dark-green.com>
	<1231288416.3117.29.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org,
	Paul <Paul@WhiteCitadel.com>
Subject: Re: [linux-dvb] s2-lipliandvb oops (cx88) -> cx88 maintainer ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Tue, 06 Jan 2009 19:33:36 -0500
Andy Walls <awalls@radix.net> wrote:

> Thanks for the report.  That's actually exactly what I would expect. 
> 
> The race I think happens should only happen after the first device is
> added to the cx8802_devlist and while the cx88-dvb module is probing
> devices a second device is being added to the cx8802_devlist with a
> pointer not properly set yet.
> (Of course, I'm not sure why Mauro's recent change didn't work for
> Gregoire.)

Probably because I moved also some code from cx88-mpeg into cx88-dvb. We should
rewrite the locks on the drivers to work better after the KBL unlock patches
that went on 2.6.27 and 2.6.28.


Cheers,
Mauro

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
