Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JeTd3-0008EZ-8v
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 12:17:15 +0100
Received: by fg-out-1718.google.com with SMTP id 22so2982733fge.25
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 04:17:10 -0700 (PDT)
Message-ID: <ea4209750803260417w38fd4ac2l82f50f8a9c0a29f2@mail.gmail.com>
Date: Wed, 26 Mar 2008 12:17:10 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: elupus <elupus@ecce.se>
In-Reply-To: <loom.20080326T105420-829@post.gmane.org>
MIME-Version: 1.0
References: <timjkg4t68k0.u9vss0x6vh17$.dlg@40tude.net>
	<19apj9y5ari7e$.iq8vatom4e8q.dlg@40tude.net>
	<a7d0idxnqmsq.1kxbekc9wr0n1.dlg@40tude.net>
	<ea4209750803260338k48f25e8mf95c5734481d2da7@mail.gmail.com>
	<loom.20080326T105420-829@post.gmane.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] STK7700-PH ( dib7700 + ConexantCX25842 + Xceive
	XC3028 )
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0082476090=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0082476090==
Content-Type: multipart/alternative;
	boundary="----=_Part_16238_14223282.1206530230063"

------=_Part_16238_14223282.1206530230063
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

My card, pinnacle 320cx is also pciexpress, but sincerely I never tested
with the card plugged and rebooting the system... so I may check it when I
have my card available...
For the repositories stuff, patrick is the one in charge of the dibcom
changes, and I guess his version will go to the main branch soon, but think
that the patch was introduced just a few days ago, so it's good to have a
little time for testing.
It would be nice if you could test with the usual dibcom1.1 firmware, just
to be sure that it's not a firmware problem.

Albert

2008/3/26, elupus <elupus@ecce.se>:
>
> Albert Comerma <albert.comerma <at> gmail.com> writes:
>
> So, to sum up. Using the "standard" configuration of dibcom 7700+xc3028
> > you managed to get dvb-t working. Perhaps you have some problem with
> your
> > computer power management and it keeps power on usb while it's off.
> > Albert
> >
>
>
> Well I wouldn't consider that a problem with the computer. Rather a bug in
> the
> driver if it can't handle that situation.
>
> In my case it will always happen. The card isn't a standard usb card, it's
> a
> minipci(express) with a builtin usb-bridge to which the card is connected.
>
> My guess is that something isn't getting inited properly when card has
> never
> been in cold state on bootup. Do you have a hint on where to look for
> this?
>
> The patch for 7700+XC3028 haven't made it to trunk (to steal a svn term),
> so
> if you by "standard" means, the repo i mentioned in the first post and
> with
> the patch to detect this specific usb card then probably yes.
> I've not tested the 1.10 dibcom firmware with a full power off (I have to
> pull
> the powercord for it to coldboot).
> Since the error i'm getting now with the firmware from my windows drivers,
> are
> identical to what i kept getting with the firmware on linuxtv, i'd expect
> that
> it'd work if i just coldbooted the computer.
>
>
> (I wonder if I ever will get used to the multitude of repositores
> available).
>
>
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_16238_14223282.1206530230063
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

My card, pinnacle 320cx is also pciexpress, but sincerely I never tested with the card plugged and rebooting the system... so I may check it when I have my card available...<br>For the repositories stuff, patrick is the one in charge of the dibcom changes, and I guess his version will go to the main branch soon, but think that the patch was introduced just a few days ago, so it&#39;s good to have a little time for testing.<br>
It would be nice if you could test with the usual dibcom1.1 firmware, just to be sure that it&#39;s not a firmware problem.<br><br>Albert<br><br><div><span class="gmail_quote">2008/3/26, elupus &lt;<a href="mailto:elupus@ecce.se">elupus@ecce.se</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Albert Comerma &lt;albert.comerma &lt;at&gt; <a href="http://gmail.com">gmail.com</a>&gt; writes:<br> <br> So, to sum up. Using the &quot;standard&quot; configuration of dibcom 7700+xc3028<br> &gt; you managed to get dvb-t working. Perhaps you have some problem with your<br>
 &gt; computer power management and it keeps power on usb while it&#39;s off.<br> &gt; Albert<br> &gt;<br> <br> <br>Well I wouldn&#39;t consider that a problem with the computer. Rather a bug in the<br> driver if it can&#39;t handle that situation.<br>
 <br> In my case it will always happen. The card isn&#39;t a standard usb card, it&#39;s a<br> minipci(express) with a builtin usb-bridge to which the card is connected.<br> <br> My guess is that something isn&#39;t getting inited properly when card has never<br>
 been in cold state on bootup. Do you have a hint on where to look for this?<br> <br> The patch for 7700+XC3028 haven&#39;t made it to trunk (to steal a svn term), so<br> if you by &quot;standard&quot; means, the repo i mentioned in the first post and with<br>
 the patch to detect this specific usb card then probably yes.<br> I&#39;ve not tested the 1.10 dibcom firmware with a full power off (I have to pull<br> the powercord for it to coldboot).<br> Since the error i&#39;m getting now with the firmware from my windows drivers, are<br>
 identical to what i kept getting with the firmware on linuxtv, i&#39;d expect that<br> it&#39;d work if i just coldbooted the computer.<br> <br> <br> (I wonder if I ever will get used to the multitude of repositores available).<br>
 <br><br> <br> <br> <br> _______________________________________________<br> linux-dvb mailing list<br> <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br> <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
 </blockquote></div><br>

------=_Part_16238_14223282.1206530230063--


--===============0082476090==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0082476090==--
