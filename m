Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.189])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <armel.frey@gmail.com>) id 1M6kPD-0003d7-Cn
	for linux-dvb@linuxtv.org; Wed, 20 May 2009 13:56:19 +0200
Received: by fk-out-0910.google.com with SMTP id 22so164763fkq.1
	for <linux-dvb@linuxtv.org>; Wed, 20 May 2009 04:56:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090515231609.0ba14254@bk.ru>
References: <8566f5bc0905140646x6aaeb3ecq14e3c2c72b176e7@mail.gmail.com>
	<20090515231609.0ba14254@bk.ru>
Date: Wed, 20 May 2009 13:56:14 +0200
Message-ID: <8566f5bc0905200456l2a88831w626d770852312bc6@mail.gmail.com>
From: armel frey <armel.frey@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S2 frontend doesn't work!
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1823749879=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1823749879==
Content-Type: multipart/alternative; boundary=001636c5abcce4c5a5046a56b6b8

--001636c5abcce4c5a5046a56b6b8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ok, I now use http://mercurial.intuxication.org/hg/s2-liplianin
I installed it on /usr/local/src/ with make & make install

but szap-s2 lock dvb-s signal but not dvb-s2...
someone have an idea???
2009/5/15 Goga777 <goga777@bk.ru>

> > I have a problem with my HVR-4000 card.
> >
> > I installed the firmware cx24116 find on
> > http://tevii.com/Tevii_linuxdriver_0815.rar
> > sudo cp tevii_linuxdriver_0815/fw/dvb-fe-cx24116.fw
> > /lib/firmware/dvb-fe-cx24116-1.23.86.1.fw
> > sudo ln -s /lib/firmware/dvb-fe-cx24116-1.23.86.1.fw
> > /lib/firmware/dvb-fe-cx24116.fw
> >
> > I installed S2API find on http://linuxtv.org/hg/~stoth/s2/
>
> please use http://mercurial.intuxication.org/hg/s2-liplianin
>
> > and I installed szap-s2 find on
> http://mercurial.intuxication.org/hg/szap-s2
> >
> > Every seems to be ok...
> > I can tune an DVB-S signal, but not DVB-S2...
> > I try to tune a DVB-S2 signal with a symbols rate of 75335000 (>45000000)
> > and I have this error message with dmesg :
> >
> > [ 450.409150] DVB: frontend 0 symbol rate 75335000 out of range
> > (1000000..45000000)
> >
> > So I try dvbsnoop to see the frontend information :
> >
> > # dvbsnoop -s feinfo
> > dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
>
> dvbsnoop doesn't work with s2api
>
>
> Goga
>
>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--001636c5abcce4c5a5046a56b6b8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Ok, I now=A0use <a href=3D"http://mercurial.intuxication.org/hg/s2-lip=
lianin" target=3D"_blank">http://mercurial.intuxication.org/hg/s2-liplianin=
</a><br>I installed it on /usr/local/src/ with make &amp; make install</div=
>
<div>=A0</div>
<div>but szap-s2 lock dvb-s signal but not dvb-s2...</div>
<div>someone have an idea???<br></div>
<div class=3D"gmail_quote">2009/5/15 Goga777 <span dir=3D"ltr">&lt;<a href=
=3D"mailto:goga777@bk.ru">goga777@bk.ru</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class=3D"im">&gt; I have a problem with my HVR-4000 card.<br>&gt;<br>&=
gt; I installed the firmware cx24116 find on<br>&gt; <a href=3D"http://tevi=
i.com/Tevii_linuxdriver_0815.rar" target=3D"_blank">http://tevii.com/Tevii_=
linuxdriver_0815.rar</a><br>
&gt; sudo cp tevii_linuxdriver_0815/fw/dvb-fe-cx24116.fw<br>&gt; /lib/firmw=
are/dvb-fe-cx24116-1.23.86.1.fw<br>&gt; sudo ln -s /lib/firmware/dvb-fe-cx2=
4116-1.23.86.1.fw<br>&gt; /lib/firmware/dvb-fe-cx24116.fw<br>&gt;<br>&gt; I=
 installed S2API find on <a href=3D"http://linuxtv.org/hg/~stoth/s2/" targe=
t=3D"_blank">http://linuxtv.org/hg/~stoth/s2/</a><br>
<br></div>please use <a href=3D"http://mercurial.intuxication.org/hg/s2-lip=
lianin" target=3D"_blank">http://mercurial.intuxication.org/hg/s2-liplianin=
</a><br>
<div class=3D"im"><br>&gt; and I installed szap-s2 find on <a href=3D"http:=
//mercurial.intuxication.org/hg/szap-s2" target=3D"_blank">http://mercurial=
.intuxication.org/hg/szap-s2</a><br>&gt;<br>&gt; Every seems to be ok...<br=
>
&gt; I can tune an DVB-S signal, but not DVB-S2...<br>&gt; I try to tune a =
DVB-S2 signal with a symbols rate of 75335000 (&gt;45000000)<br>&gt; and I =
have this error message with dmesg :<br>&gt;<br>&gt; [ 450.409150] DVB: fro=
ntend 0 symbol rate 75335000 out of range<br>
&gt; (1000000..45000000)<br>&gt;<br>&gt; So I try dvbsnoop to see the front=
end information :<br>&gt;<br>&gt; # dvbsnoop -s feinfo<br>&gt; dvbsnoop V1.=
4.50 -- <a href=3D"http://dvbsnoop.sourceforge.net/" target=3D"_blank">http=
://dvbsnoop.sourceforge.net/</a><br>
<br></div>dvbsnoop doesn&#39;t work with s2api<br><br><br>Goga<br><br><br><=
br><br>_______________________________________________<br>linux-dvb users m=
ailing list<br>For V4L/DVB development, please use instead <a href=3D"mailt=
o:linux-media@vger.kernel.org">linux-media@vger.kernel.org</a><br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a hr=
ef=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target=3D"=
_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></=
blockquote>
</div><br>

--001636c5abcce4c5a5046a56b6b8--


--===============1823749879==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1823749879==--
