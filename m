Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JSjqd-00040C-A0
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 03:10:43 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <47BF5C5D.3090500@gmail.com>
References: <18b102300802210712o76dcccf9j2857d8092d1e9846@mail.gmail.com>
	<47BDB0FA.7080500@rogers.com>
	<18b102300802211051m3823e365v1fa025ac46edca0b@mail.gmail.com>
	<47BF15FB.4090105@rogers.com> <47BF3126.2020707@gmail.com>
	<47BF4F18.6040801@rogers.com>  <47BF5C5D.3090500@gmail.com>
Date: Sat, 23 Feb 2008 03:04:35 +0100
Message-Id: <1203732275.3246.14.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HD capture
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

Hi.

Am Samstag, den 23.02.2008, 03:35 +0400 schrieb Manu Abraham:
> CityK wrote:
> > Manu Abraham wrote:
> >> CityK wrote:
...
> >>
> >> For V4L to work with devices that way, it will need to copy more from 
> >> the other
> >> subsystems such as Video, DVB and ALSA since V4L alone is not any 
> >> specific
> >> "real" subsystem pertaining to something in real life. V4L just 
> >> originated as a
> >> means to tune Analog TV cards under Linux, which later went in a 
> >> different tangent.
> > 
> > While the move to multi-purpose, single IC devices is inevitable, the 
> > processing stages for the varying applications which the IC will perform 
> > (i.e. demodulation, encoding, ADC, etc)  remain the same ... I don't see 
> > how V4L would be cut out of the block ... unless, of course, that means 
> > DVB means to expand its capabilities and/or absorbing some of those 
> > currently handled by V4L
> 
> The in between stages will be masked out by larger stages which will wrap
> around them, thereby you don't see those small basic controls. As you see
> compared to the old days, you don't have that micro level controls anymore
> these days. Those are getting phased out at a reasonable pace, with more
> hardware doing those functionality of manual control. (features getting
> packed in to make look like something different)
> 
> For example, When there is so much integration at such a stage, you feel
> silly including something gigantic for something too silly. In such a 
> case for
> example of a TV output, you might not even need something that complex,
> for such a small feature. (to cite as a crude example, maybe a bad example,
> but i hope you get the idea)
> 

Maybe some facts in between, instead of pure advertising.

If you have that, sold per every single device painfully.
http://search.ebay.de/ws/search/SaleSearch?sofocus=bs&satitle=dvb+ci&sacat=-1%26catref%3DC5&fbd=1&catref=C6&fscl=1&sorefinesearch=1&flt=9&from=R14&nojspr=y&pfid=0&fswc=1&few=&saprclo=&saprchi=&fss=1&saslop=1&sasl=b.e.t.t.e.r.s.h.o.p.p.i.n.g&fls=4%26floc%3D1&sargn=-1%26saslc%3D0&salic=77&saatc=77&sadis=200&fpos=&fsct=&sacur=0&sacqyop=ge&sacqy=&sabfmts=0&fobfmt=1&saobfmts=insif&ga10244=10425&saslt=2&ftrt=1&ftrv=1&sabdlo=&sabdhi=&saaff=afdefault&afan=&afmp=&fsop=1%26fsoo%3D1&fcl=3&frpp=50

You still need something like this.
http://cgi.ebay.de/Neu-CAM-CI-MODUL-AlphaCrypt-Light-mit-Software-1-12_W0QQitemZ370000642816QQihZ024QQcategoryZ77740QQssPageNameZWDVWQQrdZ1QQcmdZViewItem

And still have exactly nothing.

If it stays like that, this will likely have some new owners soon,
but teach me better.

Cheers,
Hermann








_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
