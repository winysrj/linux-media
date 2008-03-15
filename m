Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1Jag0v-0000cF-SS
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 00:42:11 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1662244tia.13
	for <linux-dvb@linuxtv.org>; Sat, 15 Mar 2008 16:42:04 -0700 (PDT)
Message-ID: <abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>
Date: Sun, 16 Mar 2008 10:42:04 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47DBDB9F.5060107@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>
	<47D9EED4.8090303@linuxtv.org>
	<abf3e5070803132022g3e2c638fxc218030c535372b@mail.gmail.com>
	<47DA0F01.8010707@iki.fi> <47DA7008.8010404@linuxtv.org>
	<47DAC42D.7010306@iki.fi> <47DAC4BE.5090805@iki.fi>
	<abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>
	<abf3e5070803150621k501c451lc7fc8a74efcf0977@mail.gmail.com>
	<47DBDB9F.5060107@iki.fi>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

On Sun, Mar 16, 2008 at 1:22 AM, Antti Palosaari <crope@iki.fi> wrote:

>
> Jarryd Beck wrote:
> >  >  Michael's patch didn't produce any interesting dmesg output. I included
> >  >  dmesg for plugging in and tuning with antti's patch.
>
> First errors came from same situation as earlier, no_reconnect. But it
> finally still worked.
>
>
> > Just realised I didn't have debug enabled for Michael's patch. When
> > tuning I got lots of this:
> >
> > tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
> > tda18271_init_regs: initializing registers for device @ 1-00c0
> > tda18271_tune: freq = 219500000, ifc = 3800000, bw = 7000000, std = 0x1d
> >
> > My keyboard was fine this time (that was the point it normally responded
> > really slowly), and the driver loaded instantly instead of taking nearly
> > half a minute.
> > It looks like it might be a step in the right direction, but it's still
> > not tuning.
> >
> > Jarryd.
>
> Frequency control values of the demodulator seems to be ok now. Also adc
> and coeff looks correct. It is hard to say where is problem...
> Can you test if demodulator can detect TPS parameter automatically? You
> can do that inserting AUTO to initial tuning file, for example set FEC
> AUTO. And then "scan tuning-file"
>
>
>
>
> regards
> Antti
> --
> http://palosaari.fi/
>

Sorry I'm completely lost at this point, are you talking about adding something
to /usr/share/dvb-apps/dvb-t/au-sydney_north_shore and then running
scandvb, or are you talking about something else?

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
