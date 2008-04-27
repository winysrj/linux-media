Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.228])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JqA97-0002B7-Fg
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 18:54:38 +0200
Received: by rv-out-0506.google.com with SMTP id b25so3012863rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 27 Apr 2008 09:54:32 -0700 (PDT)
Message-ID: <617be8890804270954nc3d060ev6836849841f65d06@mail.gmail.com>
Date: Sun, 27 Apr 2008 18:54:32 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Matthias Schwarzott" <zzam@gentoo.org>
In-Reply-To: <200804271659.41562.zzam@gentoo.org>
MIME-Version: 1.0
References: <617be8890804140209p3b79df8cm3f94de8f82b1faa5@mail.gmail.com>
	<200804270540.29590.zzam@gentoo.org>
	<617be8890804270442t5318e322g8904e6e698c70a15@mail.gmail.com>
	<200804271659.41562.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] a700 support (was: [patch 5/5] mt312: add
	attach-time setting to invert lnb-voltage (Matthias Schwarzott))
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0732858915=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0732858915==
Content-Type: multipart/alternative;
	boundary="----=_Part_2500_10693215.1209315272741"

------=_Part_2500_10693215.1209315272741
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks! I'll try it later and let you know the results.

Regards,
  Eduard



2008/4/27 Matthias Schwarzott <zzam@gentoo.org>:

> On Sonntag, 27. April 2008, Eduard Huguet wrote:
> > Thank you very much, Matthias. I was going to try the patch right now,
> > however I'm finding that it doesn't apply clean to the current HG tree.
> > This is what I'm getting:
> >
> > patching file linux/drivers/media/dvb/frontends/Kconfig
> > Hunk #1 FAILED at 368.
> > 1 out of 1 hunk FAILED -- saving rejects to file
> > linux/drivers/media/dvb/frontends/Kconfig.rej
> > patching file linux/drivers/media/dvb/frontends/Makefile
> > Hunk #1 succeeded at 23 (offset -2 lines).
> > patching file linux/drivers/media/dvb/frontends/zl10036.c
> > patching file linux/drivers/media/dvb/frontends/zl10036.h
> > patching file linux/drivers/media/video/saa7134/Kconfig
> > patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> > Hunk #3 succeeded at 5716 (offset 42 lines).
> > patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
> >
> > I've tried to manually patch Kconfig by adding the rejected lines, but I
> > suppose there must something I'm doing wrong: apparently it compiles
> fine,
> > but saa7134-dvb is not loaded and the frontend is not being created for
> the
> > card (although the card is detected and the video0 device for analog is
> > there).
> >
> This reject is caused by the massive movement of the hybrid tuner drivers
> to
> another directory.
> I solved the reject, and re-uploaded the patch.
> Here it does still work.
>
> Regards
> Matthias
>

------=_Part_2500_10693215.1209315272741
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks! I&#39;ll try it later and let you know the results.<br><br>Regards, <br>&nbsp; Eduard<br><br><br><br><div class="gmail_quote">2008/4/27 Matthias Schwarzott &lt;<a href="mailto:zzam@gentoo.org">zzam@gentoo.org</a>&gt;:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class="Ih2E3d">On Sonntag, 27. April 2008, Eduard Huguet wrote:<br>
&gt; Thank you very much, Matthias. I was going to try the patch right now,<br>
&gt; however I&#39;m finding that it doesn&#39;t apply clean to the current HG tree.<br>
&gt; This is what I&#39;m getting:<br>
&gt;<br>
&gt; patching file linux/drivers/media/dvb/frontends/Kconfig<br>
&gt; Hunk #1 FAILED at 368.<br>
&gt; 1 out of 1 hunk FAILED -- saving rejects to file<br>
&gt; linux/drivers/media/dvb/frontends/Kconfig.rej<br>
&gt; patching file linux/drivers/media/dvb/frontends/Makefile<br>
&gt; Hunk #1 succeeded at 23 (offset -2 lines).<br>
&gt; patching file linux/drivers/media/dvb/frontends/zl10036.c<br>
&gt; patching file linux/drivers/media/dvb/frontends/zl10036.h<br>
&gt; patching file linux/drivers/media/video/saa7134/Kconfig<br>
&gt; patching file linux/drivers/media/video/saa7134/saa7134-cards.c<br>
&gt; Hunk #3 succeeded at 5716 (offset 42 lines).<br>
&gt; patching file linux/drivers/media/video/saa7134/saa7134-dvb.c<br>
&gt;<br>
&gt; I&#39;ve tried to manually patch Kconfig by adding the rejected lines, but I<br>
&gt; suppose there must something I&#39;m doing wrong: apparently it compiles fine,<br>
&gt; but saa7134-dvb is not loaded and the frontend is not being created for the<br>
&gt; card (although the card is detected and the video0 device for analog is<br>
&gt; there).<br>
&gt;<br>
</div>This reject is caused by the massive movement of the hybrid tuner drivers to<br>
another directory.<br>
I solved the reject, and re-uploaded the patch.<br>
Here it does still work.<br>
<br>
Regards<br>
<font color="#888888">Matthias<br>
</font></blockquote></div><br>

------=_Part_2500_10693215.1209315272741--


--===============0732858915==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0732858915==--
