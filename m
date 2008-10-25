Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+58e04052c4dd4717db75+1889+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KtaWv-00060w-8m
	for linux-dvb@linuxtv.org; Sat, 25 Oct 2008 06:13:37 +0200
Date: Sat, 25 Oct 2008 02:13:31 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Erik Boritsch <borych@gmx.de>
Message-ID: <20081025021331.35651bac@pedra.chehab.org>
In-Reply-To: <200810241441.40928.borych@gmx.de>
References: <200810241441.40928.borych@gmx.de>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] tm6000/tm6010 progress?
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

On Fri, 24 Oct 2008 14:41:40 +0200
Erik Boritsch <borych@gmx.de> wrote:

> Hello,
> 
> I am willing to help the devel opment of tm6000/tm6010 drivers as I am a 
> "happy" owner of Freecom Hybrid USB stick (14aa:0620 AVerMedia (again) 
> or C&E). Last entry in tm6010mercurial is 5 month ago and I cannot 
> compile the tm6010 tree.

I passed to a period of time were I couldn't dedicate to it. Let's see if I
would have more time those days.

> I am computer science student so I might be able to help with driver 
> development although I have close to no experience in this area. I will 
> sure be able to help testing drivers on my hardware.

Any help is welcome.

> The question is, what is the progress  and status of tm6010 
> development? I am particulary interested in analog an remote control 
> status. 

Analog:

There's a serious bug at URB decoding routines, causing kernel Panic, caused by
one of my trials to avoid loosing parts of the URB's. I didn't have time yet to
track where the problem is.

IR: There's no IR code yet. This chip doesn't support the standard way to probe
devices at I2C bus. The better would be to convert it to the new i2c way, where
the driver knows what devices are at what addresses. With this change, it
shouldn't be hard to implement IR support.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
