Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6fe81ee853252f17f9b7+1964+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LKjo8-0007ZE-K2
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 02:35:36 +0100
Date: Wed, 7 Jan 2009 23:35:04 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Message-ID: <20090107233504.2aa932f2@pedra.chehab.org>
In-Reply-To: <1231285976.3117.8.camel@palomino.walls.org>
References: <20090104113738.GD3551@gmail.com>
	<1231097304.3125.64.camel@palomino.walls.org>
	<20090105130720.GB3621@gmail.com>
	<1231202800.3110.13.camel@palomino.walls.org>
	<20090106144917.736584e7@pedra.chehab.org>
	<1231285976.3117.8.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
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

On Tue, 06 Jan 2009 18:52:56 -0500
Andy Walls <awalls@radix.net> wrote:

> Mauro,
> 
> Please be aware that I am not happy with my own patch.  The function
> should really make sure everything is OK *before* putting the object on
> the cx8802_devlist.  The failure cases are "Oops"es waiting to happen:
> the pointer is on the list, but the objects are deallocated in the
> failure cases - not good. :P

Agreed. We should fix it by providing some lock to avoid having udev opening
the device before the end of the complete device initialization.

As I had to patch that file on the same point, instead of adding your
patch, I've added your logic on my patch, and added a comment pointing to your
patch at mail archives.


Cheers,
Mauro

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
