Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.icp-qv1-irony-out3.iinet.net.au ([203.59.1.149])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1Jm47V-0007dJ-LP
	for linux-dvb@linuxtv.org; Wed, 16 Apr 2008 11:40:08 +0200
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: sonofzev@iinet.net.au, timf <timf@iinet.net.au>
Date: Wed, 16 Apr 2008 17:39:53 +0800
Message-Id: <48450.1208338793@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvico Fusion HDTV DVB-T dual express - willing to
Reply-To: sonofzev@iinet.net.au
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1418997724=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1418997724==
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

<HTML>
Hi Tim<BR>
<BR>
Yes I have tried those sources. (as well as the official v4l sources). Both=
 had the same result. <BR>
<BR>
cheers<BR>
<BR>
Allan <BR>
<BR>
<BR>
 <BR>
<BR>
<span style=3D"font-weight: bold;">On Tue Apr 15 20:02 , timf <timf@iinet.n=
et.au> sent:<BR>
<BR>
</timf@iinet.net.au></span><blockquote style=3D"border-left: 2px solid rgb(=
245, 245, 245); margin-left: 5px; margin-right: 0px; padding-left: 5px; pad=
ding-right: 0px;"><a href=3D"javascript:top.opencompose('sonofzev@iinet.net=
.au','','','')">sonofzev@iinet.net.au</a> wrote:<BR>

&gt; Hi Folks<BR>

&gt;<BR>

&gt; I have mistakenly bought a Fusion HDTV DVB-T dual express (cx23885) as=
 <BR>

&gt; a result of misreading some other posts and sites. I was under the <BR>

&gt; impression that it would work either from the current kernel source or=
 <BR>

&gt; using Chris Pascoe's modules.  Unfortunately I didn't realise that the=
 <BR>

&gt; American and Euro/Australian version were different.<BR>

&gt;<BR>

&gt; The kernel modules and those from the mercurial tree seems to get <BR>

&gt; everything going, but when I try to tune it, it seems to only give <BR>

&gt; "ATSC" tuning options. (This seems ridiculous as it is the <BR>

&gt; "Europe/Australia" model). I believe it must be recognising the card <=
BR>

&gt; as the American model (confirmed on the PC Board that it is the <BR>

&gt; Aus/Euro model). There are no error messages e.t.c.. it just can't <BR>

&gt; find a signal and only gives ATSC tuning options.<BR>

&gt;<BR>

&gt; Chris had offered to take a look at what was going on in my system but=
 <BR>

&gt; hasn't responded to any mails for a few weeks now and I can't see any =
<BR>

&gt; evidence of him doing anything, so I am assuming he is too busy for <B=
R>

&gt; the moment to take a look.<BR>

&gt;<BR>

&gt; I bought this as a second and third tuner for my mythtv/gaming system =
<BR>

&gt; . The system already has a Fusion Lite card in it which is working <BR>

&gt; very well.  The importance of this was highlighted when I missed the <=
BR>

&gt; Henry Rollins interview on Rove so my gf could watch Grey's Anatomy <B=
R>

&gt; (puke!!!).<BR>

&gt;<BR>

&gt; If there are any local developers (Melbourne, Australia or even <BR>

&gt; elsewhere in Australia)  then I would be happy to trade it with a <BR>

&gt; confirmed working dual tuner card on a temporary basis to enable the <=
BR>

&gt; driver to be completed/ amended to cope with the Australian/European <=
BR>

&gt; version of the card.<BR>

&gt;<BR>

&gt; Otherwise for any developers not in Australia,I can setup a login for =
<BR>

&gt; you (ssh only, no remote X or anything). Just contact me via aklinbail=
 <BR>

&gt; at gmail.  The PC it sits on is our one and only TV tuner (our analog =
<BR>

&gt; signal is crap) so there are some limitations as to the times you can =
<BR>

&gt; login to the box and also with regards to keeping the current kernel <=
BR>

&gt; build in place so we can use it on our return home from work in the <B=
R>

&gt; evening.<BR>

&gt;<BR>

&gt; cheers<BR>

&gt;<BR>

&gt;<BR>

&gt; Allan<BR>

&gt;<BR>

&gt;<BR>

&gt; ----------------------------------------------------------------------=
--<BR>

&gt;<BR>

&gt; _______________________________________________<BR>

&gt; linux-dvb mailing list<BR>

&gt; <a href=3D"javascript:top.opencompose('linux-dvb@linuxtv.org','','',''=
)">linux-dvb@linuxtv.org</a><BR>

&gt; <a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Fwww.linuxtv.org%2Fcgi-bin%=
2Fmailman%2Flistinfo%2Flinux-dvb" target=3D"_blank"><span style=3D"color: r=
ed;">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</span></a><B=
R>

Hi Allan,<BR>

Have you tried Chris's test repo at:<BR>

<BR>

<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Flinuxtv.org%2Fhg%2F%7Epascoe%2F=
xc-test%2F" target=3D"_blank"><span style=3D"color: red;">http://linuxtv.or=
g/hg/~pascoe/xc-test/</span></a><BR>

<BR>

<BR>

Regards,<BR>

Tim<BR>

)<BR>

</blockquote></HTML>
<BR>=


--===============1418997724==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1418997724==--
