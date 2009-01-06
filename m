Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+f3b844923945981420e4+1962+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LKF7s-00080h-5R
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 17:49:56 +0100
Date: Tue, 6 Jan 2009 14:49:17 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Message-ID: <20090106144917.736584e7@pedra.chehab.org>
In-Reply-To: <1231202800.3110.13.camel@palomino.walls.org>
References: <20090104113738.GD3551@gmail.com>
	<1231097304.3125.64.camel@palomino.walls.org>
	<20090105130720.GB3621@gmail.com>
	<1231202800.3110.13.camel@palomino.walls.org>
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

On Mon, 05 Jan 2009 19:46:40 -0500
Andy Walls <awalls@radix.net> wrote:

> I you run across the oops often, then the suspected race condition in
> the function I mentioned needs to be fixed.  That may be as simple as
> this lame patch:

Could you please provide you your SOB?

IMO, the proper fix would be to add some locking at cx88 init. I suspect that
this breakage (and other similar ones) are tue to the absense of KBL on newer kernels.

Gregoire,

What kernel version are you using?

>  
>   fail_free:
> +       /* FIXME - shouldn't we pull dev off the cx8802_devlist - oops */

Better to add here:
	core->dvbdev = NULL;




Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
