Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web23203.mail.ird.yahoo.com ([217.146.189.58])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1KnxHX-0002t2-0N
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 17:18:28 +0200
Date: Thu, 9 Oct 2008 15:17:47 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <455973.84516.qm@web23203.mail.ird.yahoo.com>
Subject: Re: [linux-dvb] [vdr] stb0899 and tt s2-3200
Reply-To: newspaperman_germany@yahoo.com
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

I have Alex Betis' + Ales Jurik's patch running with liplianindvb, but still the same problem with those DVB-S2 8PSK transponders.


--- Alex Betis <alex.betis@gmail.com> schrieb am Do, 9.10.2008:

> Von: Alex Betis <alex.betis@gmail.com>
> Betreff: Re: [linux-dvb] [vdr] stb0899 and tt s2-3200
> An: ajurik@quick.cz
> CC: linux-dvb@linuxtv.org
> Datum: Donnerstag, 9. Oktober 2008, 15:58
> I will try that patch together with mine soon. Will update
> with results.
>
> On Thu, Oct 9, 2008 at 3:47 PM, Ales Jurik
> <ajurik@quick.cz> wrote:
>
> > On Thursday 09 of October 2008, Goga777 wrote:
> > > > > > > it's not working with SR
> 30000 FEC 3/4 dvb-s2 8PSK, still the
> > same
> > > > > > > problem.
> > > > > > >
> > > > > > > kind regards
> > > > > > >
> > > > > > > Newsy
> > > > > >
> > > > > > It seems that patch from
> > > > > >
> http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.htmlis
> > > > > > not applied. The internal PLL must
> be disabled when setting new
> > > > > > frequency as is written in stb6100
> documentation.
> > > > >
> > > > > has your July-patch any relation with
> stb0899 patches from Alex Betis
> > ?
> > > > >
> > > > >
> http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029455.html
> > > > >
> >
> http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html
> > > > >
> > > > > Goga
> > > >
> > > > I don't think so as Alex's patches
> are for demodulator (stb0899) but my
> > > > was for tuner (stb6100).
> > > >
> > > > Regarding stb6100 doc the tuning procedure
> should be:
> > > > 1. Disable PLL (LPEN_LPEN)
> > > > 2. Set-up the tuner
> > > > 3. Start PLL
> > > > 4. Start VCO search
> > > > 5. Wait for 5 ms
> > > > 6. Disable VCO search, turn off VCO search
> clock and disable LPF BW
> > clock
> > > >
> > > > The steps 1-5 should be done in 5 steps (not
> less) and as I remeber
> > I've
> > > > got better result when inserting small delay
> between steps 1 and 2 and
> > > > the delay from step 5 was set to 10ms. In
> stb6100.c are steps 1 and 2
> > > > done together within 1 write to stb6100
> registers and this seems to be
> > > > not optimal for some modulations.
> > >
> > > that's why TT3200 owners have to try both
> patches together - from you and
> > > from Alex Betis ? is it correct ?
> > >
> > > Goga
> >
> > Yes, I think so, but now I'm not able to test it
> as I don't have the TT
> > S2-3200 more in my PC. If nobody will be able to test
> it I'll try to do it
> > this weekend.
> >
> > Regards,
> >
> > Ales
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> >
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
