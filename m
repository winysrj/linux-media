Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1Knvvc-0005P8-8u
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 15:51:47 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org,
 Goga777 <goga777@bk.ru>
Date: Thu, 9 Oct 2008 15:47:31 +0200
References: <200810091507.50544.ajurik@quick.cz>
	<E1Knvg5-000LDW-00.goga777-bk-ru@f141.mail.ru>
In-Reply-To: <E1Knvg5-000LDW-00.goga777-bk-ru@f141.mail.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810091547.31992.ajurik@quick.cz>
Subject: Re: [linux-dvb] =?iso-8859-1?q?=5Bvdr=5D_stb0899_and_tt_s2-3200?=
Reply-To: ajurik@quick.cz
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

On Thursday 09 of October 2008, Goga777 wrote:
> > > > > it's not working with SR 30000 FEC 3/4 dvb-s2 8PSK, still the same
> > > > > problem.
> > > > >
> > > > > kind regards
> > > > >
> > > > > Newsy
> > > >
> > > > It seems that patch from
> > > > http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.html is
> > > > not applied. The internal PLL must be disabled when setting new
> > > > frequency as is written in stb6100 documentation.
> > >
> > > has your July-patch any relation with stb0899 patches from Alex Betis ?
> > >
> > > http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029455.html
> > > http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html
> > >
> > > Goga
> >
> > I don't think so as Alex's patches are for demodulator (stb0899) but my
> > was for tuner (stb6100).
> >
> > Regarding stb6100 doc the tuning procedure should be:
> > 1. Disable PLL (LPEN_LPEN)
> > 2. Set-up the tuner
> > 3. Start PLL
> > 4. Start VCO search
> > 5. Wait for 5 ms
> > 6. Disable VCO search, turn off VCO search clock and disable LPF BW clock
> >
> > The steps 1-5 should be done in 5 steps (not less) and as I remeber I've
> > got better result when inserting small delay between steps 1 and 2 and
> > the delay from step 5 was set to 10ms. In stb6100.c are steps 1 and 2
> > done together within 1 write to stb6100 registers and this seems to be
> > not optimal for some modulations.
>
> that's why TT3200 owners have to try both patches together - from you and
> from Alex Betis ? is it correct ?
>
> Goga

Yes, I think so, but now I'm not able to test it as I don't have the TT 
S2-3200 more in my PC. If nobody will be able to test it I'll try to do it 
this weekend.

Regards,

Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
