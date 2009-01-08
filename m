Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LKkW6-0003W1-Dx
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 03:21:03 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Gregoire Favre <gregoire.favre@gmail.com>
In-Reply-To: <20090104182403.GB3521@gmail.com>
References: <c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com> <20090104111429.1f828fc8@bk.ru>
	<1231057784.2615.9.camel@pc10.localdom.local>
	<20090104103744.GB3551@gmail.com>
	<1231085219.2723.1.camel@pc10.localdom.local>
	<20090104163744.GA3521@gmail.com>
	<1231089346.2723.9.camel@pc10.localdom.local>
	<20090104182403.GB3521@gmail.com>
Date: Thu, 08 Jan 2009 03:20:44 +0100
Message-Id: <1231381244.2647.19.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
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

Hi,

Am Sonntag, den 04.01.2009, 19:24 +0100 schrieb Gregoire Favre:
> On Sun, Jan 04, 2009 at 06:15:46PM +0100, hermann pitton wrote:
> 
[...]
> 
> Isn't those numbers of channels quiete small ?

sorry, did not read it to the end and only noticed the oops is gone.

Yes, looks poor, but I don't have any such hardware and can't compare
what a recent windows driver would deliver. Also at least on 13.0E the
scan file needs lots of updates (lyngsat.com), 19.2 I did not test, but
on 28.2 kaffeine finds much more, but I'm only in borderline reception
conditions and not a reference.

To my surprise, current tda826x silicon tuners for example have no
difference, but previous latest can tuners can have 30% less on the same
signal. I got it told the other way round.

> I think my debug info are wrong, I put :
> options cx88_alsa index=-2

The default -1 should auto enumerate and else you force the dsps/mixers
considering that the sound card(s) are usually first.

> options cx88xx i2c_debug=1
> in  /etc/modprobe.conf isn't that right ?

Thought that should always work.
("depmod -a" ?)

Cheers,
Hermann







_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
