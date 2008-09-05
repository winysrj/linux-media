Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: hermann pitton <hermann-pitton@arcor.de>
To: Johannes Stezenbach <js@linuxtv.org>
In-Reply-To: <20080904204709.GA32329@linuxtv.org>
References: <48C00822.4030509@gmail.com> <48C01698.4060503@gmail.com>
	<48C01A99.402@gmail.com>  <20080904204709.GA32329@linuxtv.org>
Date: Fri, 05 Sep 2008 03:01:10 +0200
Message-Id: <1220576470.2684.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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


Am Donnerstag, den 04.09.2008, 22:47 +0200 schrieb Johannes Stezenbach:
> On Thu, Sep 04, 2008, Manu Abraham wrote:
> > 
> > Does it support ISDB-T, ATSC-MH, CMMB, DBM-T/H?
> > Intentionally, no!  Experience with the old api development has proven
> > that making blind assumptions about delivery systems is a bad idea.
> > It's better to add in support for these when the hardware actually arrives
> > and can be properly tested.
> 
> Full ACK on this one. Once an API is merged into the mailine
> kernel we're stuck with it, no matter how ugly and broken it might be.
> -> NEVER merge untested APIs
> 
> > If you would like to use any of these drivers now, you may pull the
> > tree from http://jusst.de/hg/multiproto.  Drivers may be configured
> > with 'make menuconfig' the same as you've done with v4l.
> > 
> > Feedback, bug reports, etc. are welcomed and encouraged!
> 
> I only want to add a bit of historical perspective so people
> are aware of the reasons why Steve came up with his alternative
> API proposal, and why a number of developers seem to support it.
> 
> First let's look at the timestamps:
> http://jusst.de/hg/multiproto/log/2a911b8f9910/linux/include/linux/dvb/frontend.h
> http://jusst.de/hg/multiproto_api_merge/log/4c62efb08ea6/linux/include/linux/dvb/frontend.h
> 
> Then at some discussion from nearly one year ago:
> http://article.gmane.org/gmane.linux.drivers.dvb/36643
> 
> 
> Johannes

-- 
"Folks,
As vou can see for yourself.
The way this clock over here
is behaving,
TIME IS OF AFFLICTION!
Now this might be cause for alarm
Among a portion of you, as,
>From a certain experience,
I TEND TO PROCLAIM:
'THE EONS ARE CLOSING'!" -- Frank Zappa

OK, maybe more quoting does help a little.

"Im Falschen kann es nichts Richtiges geben."

Theodor W. Adorno

"Da steh ich nun ich armer Tor und bin so klug als je zuvor."

Johann Wolfgang von Goethe

"Wo viel Licht ist, ist auch viel Schatten."

As said previously, the "best" interpreter ever was Ronald Reagan on his
Berlin speech ...

Again the same author.

In general I prefer Zappa too, it's more like driving beans to Utah or
that one with the fried chickens :)

Cheers,
Hermann





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
