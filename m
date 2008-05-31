Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1K2Qbb-0003R2-MN
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 14:54:44 +0200
Received: by fk-out-0910.google.com with SMTP id f40so2308054fka.1
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 05:54:43 -0700 (PDT)
Message-ID: <ea4209750805310554n159f180eyf86e769ee8debcf0@mail.gmail.com>
Date: Sat, 31 May 2008 14:54:43 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
Cc: linux-dvb@linuxtv.org
In-Reply-To: <1bor0hfgk1uo2$.9i9tmhrqox9d.dlg@40tude.net>
MIME-Version: 1.0
References: <timjkg4t68k0.u9vss0x6vh17$.dlg@40tude.net>
	<19apj9y5ari7e$.iq8vatom4e8q.dlg@40tude.net>
	<a7d0idxnqmsq.1kxbekc9wr0n1.dlg@40tude.net>
	<ea4209750803260338k48f25e8mf95c5734481d2da7@mail.gmail.com>
	<loom.20080326T105420-829@post.gmane.org>
	<ea4209750803260417w38fd4ac2l82f50f8a9c0a29f2@mail.gmail.com>
	<5pvhprg5pgaz.1max8nss01igr.dlg@40tude.net>
	<1bor0hfgk1uo2$.9i9tmhrqox9d.dlg@40tude.net>
Subject: Re: [linux-dvb] STK7700-PH ( dib7700 + ConexantCX25842 + Xceive
	XC3028 )
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1301440098=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1301440098==
Content-Type: multipart/alternative;
	boundary="----=_Part_26_12460184.1212238483168"

------=_Part_26_12460184.1212238483168
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry, I forgot... I just tested this; first plug the card (it's detected as
usual and works fine with kaffeine). Then reboot the system without removing
the card. The led of the card stays on during all the process. Once system
is restarted, reopen kaffeine and it works just fine.

Albert

2008/5/29 elupus <elupus@ecce.se>:

> On Sun, 30 Mar 2008 18:53:04 +0200, elupus wrote:
>
> > On Wed, 26 Mar 2008 12:17:10 +0100, Albert Comerma wrote:
> >
> >> My card, pinnacle 320cx is also pciexpress, but sincerely I never tested
> >> with the card plugged and rebooting the system... so I may check it when
> I
> >> have my card available...
> >> For the repositories stuff, patrick is the one in charge of the dibcom
> >> changes, and I guess his version will go to the main branch soon, but
> think
> >> that the patch was introduced just a few days ago, so it's good to have
> a
> >> little time for testing.
> >> It would be nice if you could test with the usual dibcom1.1 firmware,
> just
> >> to be sure that it's not a firmware problem.
> >>
> >> Albert
> >>
> >> 2008/3/26, elupus <elupus@ecce.se>:
> >
> > I just did, and it actually seem to work just fine. So the patch supplied
> > in this thread should be just fine.
> >
> > Regards
> > Joakim
>
> Bump
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_26_12460184.1212238483168
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry, I forgot... I just tested this; first plug the card (it&#39;s
detected as usual and works fine with kaffeine). Then reboot the system
without removing the card. The led of the card stays on during all the
process. Once system is restarted, reopen kaffeine and it works just
fine.<br>
<br>Albert<br><br><div class="gmail_quote">2008/5/29 elupus &lt;<a href="mailto:elupus@ecce.se">elupus@ecce.se</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">On Sun, 30 Mar 2008 18:53:04 +0200, elupus wrote:<br>
<br>
&gt; On Wed, 26 Mar 2008 12:17:10 +0100, Albert Comerma wrote:<br>
&gt;<br>
&gt;&gt; My card, pinnacle 320cx is also pciexpress, but sincerely I never tested<br>
&gt;&gt; with the card plugged and rebooting the system... so I may check it when I<br>
&gt;&gt; have my card available...<br>
&gt;&gt; For the repositories stuff, patrick is the one in charge of the dibcom<br>
&gt;&gt; changes, and I guess his version will go to the main branch soon, but think<br>
&gt;&gt; that the patch was introduced just a few days ago, so it&#39;s good to have a<br>
&gt;&gt; little time for testing.<br>
&gt;&gt; It would be nice if you could test with the usual dibcom1.1 firmware, just<br>
&gt;&gt; to be sure that it&#39;s not a firmware problem.<br>
&gt;&gt;<br>
&gt;&gt; Albert<br>
&gt;&gt;<br>
&gt;&gt; 2008/3/26, elupus &lt;<a href="mailto:elupus@ecce.se">elupus@ecce.se</a>&gt;:<br>
&gt;<br>
&gt; I just did, and it actually seem to work just fine. So the patch supplied<br>
&gt; in this thread should be just fine.<br>
&gt;<br>
&gt; Regards<br>
&gt; Joakim<br>
<br>
</div>Bump<br>
<div><div></div><div class="Wj3C7c"><br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br>

------=_Part_26_12460184.1212238483168--


--===============1301440098==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1301440098==--
