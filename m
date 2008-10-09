Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1Knw2G-0006YN-Ar
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 15:58:36 +0200
Received: by qw-out-2122.google.com with SMTP id 9so9790qwb.17
	for <linux-dvb@linuxtv.org>; Thu, 09 Oct 2008 06:58:32 -0700 (PDT)
Message-ID: <c74595dc0810090658q4282f4b2w2e399d2a0c17c0a9@mail.gmail.com>
Date: Thu, 9 Oct 2008 15:58:32 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: ajurik@quick.cz
In-Reply-To: <200810091547.31992.ajurik@quick.cz>
MIME-Version: 1.0
References: <200810091507.50544.ajurik@quick.cz>
	<E1Knvg5-000LDW-00.goga777-bk-ru@f141.mail.ru>
	<200810091547.31992.ajurik@quick.cz>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [vdr] stb0899 and tt s2-3200
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0334279940=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0334279940==
Content-Type: multipart/alternative;
	boundary="----=_Part_52670_25749759.1223560712261"

------=_Part_52670_25749759.1223560712261
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I will try that patch together with mine soon. Will update with results.

On Thu, Oct 9, 2008 at 3:47 PM, Ales Jurik <ajurik@quick.cz> wrote:

> On Thursday 09 of October 2008, Goga777 wrote:
> > > > > > it's not working with SR 30000 FEC 3/4 dvb-s2 8PSK, still the
> same
> > > > > > problem.
> > > > > >
> > > > > > kind regards
> > > > > >
> > > > > > Newsy
> > > > >
> > > > > It seems that patch from
> > > > > http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.htmlis
> > > > > not applied. The internal PLL must be disabled when setting new
> > > > > frequency as is written in stb6100 documentation.
> > > >
> > > > has your July-patch any relation with stb0899 patches from Alex Betis
> ?
> > > >
> > > > http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029455.html
> > > >
> http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html
> > > >
> > > > Goga
> > >
> > > I don't think so as Alex's patches are for demodulator (stb0899) but my
> > > was for tuner (stb6100).
> > >
> > > Regarding stb6100 doc the tuning procedure should be:
> > > 1. Disable PLL (LPEN_LPEN)
> > > 2. Set-up the tuner
> > > 3. Start PLL
> > > 4. Start VCO search
> > > 5. Wait for 5 ms
> > > 6. Disable VCO search, turn off VCO search clock and disable LPF BW
> clock
> > >
> > > The steps 1-5 should be done in 5 steps (not less) and as I remeber
> I've
> > > got better result when inserting small delay between steps 1 and 2 and
> > > the delay from step 5 was set to 10ms. In stb6100.c are steps 1 and 2
> > > done together within 1 write to stb6100 registers and this seems to be
> > > not optimal for some modulations.
> >
> > that's why TT3200 owners have to try both patches together - from you and
> > from Alex Betis ? is it correct ?
> >
> > Goga
>
> Yes, I think so, but now I'm not able to test it as I don't have the TT
> S2-3200 more in my PC. If nobody will be able to test it I'll try to do it
> this weekend.
>
> Regards,
>
> Ales
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_52670_25749759.1223560712261
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">I will try that patch together with mine soon. Will update with results.<br><br><div class="gmail_quote">On Thu, Oct 9, 2008 at 3:47 PM, Ales Jurik <span dir="ltr">&lt;<a href="mailto:ajurik@quick.cz">ajurik@quick.cz</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class="Ih2E3d">On Thursday 09 of October 2008, Goga777 wrote:<br>
</div><div><div></div><div class="Wj3C7c">&gt; &gt; &gt; &gt; &gt; it&#39;s not working with SR 30000 FEC 3/4 dvb-s2 8PSK, still the same<br>
&gt; &gt; &gt; &gt; &gt; problem.<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; kind regards<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Newsy<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; It seems that patch from<br>
&gt; &gt; &gt; &gt; <a href="http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.html" target="_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.html</a> is<br>
&gt; &gt; &gt; &gt; not applied. The internal PLL must be disabled when setting new<br>
&gt; &gt; &gt; &gt; frequency as is written in stb6100 documentation.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; has your July-patch any relation with stb0899 patches from Alex Betis ?<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; <a href="http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029455.html" target="_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029455.html</a><br>
&gt; &gt; &gt; <a href="http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html" target="_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html</a><br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Goga<br>
&gt; &gt;<br>
&gt; &gt; I don&#39;t think so as Alex&#39;s patches are for demodulator (stb0899) but my<br>
&gt; &gt; was for tuner (stb6100).<br>
&gt; &gt;<br>
&gt; &gt; Regarding stb6100 doc the tuning procedure should be:<br>
&gt; &gt; 1. Disable PLL (LPEN_LPEN)<br>
&gt; &gt; 2. Set-up the tuner<br>
&gt; &gt; 3. Start PLL<br>
&gt; &gt; 4. Start VCO search<br>
&gt; &gt; 5. Wait for 5 ms<br>
&gt; &gt; 6. Disable VCO search, turn off VCO search clock and disable LPF BW clock<br>
&gt; &gt;<br>
&gt; &gt; The steps 1-5 should be done in 5 steps (not less) and as I remeber I&#39;ve<br>
&gt; &gt; got better result when inserting small delay between steps 1 and 2 and<br>
&gt; &gt; the delay from step 5 was set to 10ms. In stb6100.c are steps 1 and 2<br>
&gt; &gt; done together within 1 write to stb6100 registers and this seems to be<br>
&gt; &gt; not optimal for some modulations.<br>
&gt;<br>
&gt; that&#39;s why TT3200 owners have to try both patches together - from you and<br>
&gt; from Alex Betis ? is it correct ?<br>
&gt;<br>
&gt; Goga<br>
<br>
</div></div>Yes, I think so, but now I&#39;m not able to test it as I don&#39;t have the TT<br>
S2-3200 more in my PC. If nobody will be able to test it I&#39;ll try to do it<br>
this weekend.<br>
<br>
Regards,<br>
<font color="#888888"><br>
Ales<br>
</font><div><div></div><div class="Wj3C7c"><br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_52670_25749759.1223560712261--


--===============0334279940==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0334279940==--
