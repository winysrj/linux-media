Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f165.google.com ([209.85.220.165])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <armel.frey@gmail.com>) id 1M6kQj-00044X-4K
	for linux-dvb@linuxtv.org; Wed, 20 May 2009 13:57:53 +0200
Received: by fxm9 with SMTP id 9so374824fxm.17
	for <linux-dvb@linuxtv.org>; Wed, 20 May 2009 04:57:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8566f5bc0905200456l2a88831w626d770852312bc6@mail.gmail.com>
References: <8566f5bc0905140646x6aaeb3ecq14e3c2c72b176e7@mail.gmail.com>
	<20090515231609.0ba14254@bk.ru>
	<8566f5bc0905200456l2a88831w626d770852312bc6@mail.gmail.com>
Date: Wed, 20 May 2009 13:57:17 +0200
Message-ID: <8566f5bc0905200457y31c5835bn64495654674c03e2@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0480568211=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0480568211==
Content-Type: multipart/alternative; boundary=001636c5bb71a42092046a56ba86

--001636c5bb71a42092046a56ba86
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>
> Ok, I now use http://mercurial.intuxication.org/hg/s2-liplianin
> I installed it on /usr/local/src/ with make & make install
>
> but szap-s2 lock dvb-s signal but not dvb-s2...
> someone have an idea???
> 2009/5/15 Goga777 <goga777@bk.ru>
>
>  > I have a problem with my HVR-4000 card.
>> >
>> > I installed the firmware cx24116 find on
>> > http://tevii.com/Tevii_linuxdriver_0815.rar
>> > sudo cp tevii_linuxdriver_0815/fw/dvb-fe-cx24116.fw
>> > /lib/firmware/dvb-fe-cx24116-1.23.86.1.fw
>> > sudo ln -s /lib/firmware/dvb-fe-cx24116-1.23.86.1.fw
>> > /lib/firmware/dvb-fe-cx24116.fw
>> >
>> > I installed S2API find on http://linuxtv.org/hg/~stoth/s2/
>>
>> please use http://mercurial.intuxication.org/hg/s2-liplianin
>>
>> > and I installed szap-s2 find on
>> http://mercurial.intuxication.org/hg/szap-s2
>> >
>> > Every seems to be ok...
>> > I can tune an DVB-S signal, but not DVB-S2...
>> > I try to tune a DVB-S2 signal with a symbols rate of 75335000
>> (>45000000)
>> > and I have this error message with dmesg :
>> >
>> > [ 450.409150] DVB: frontend 0 symbol rate 75335000 out of range
>> > (1000000..45000000)
>> >
>> > So I try dvbsnoop to see the frontend information :
>> >
>> > # dvbsnoop -s feinfo
>> > dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
>>
>> dvbsnoop doesn't work with s2api
>>
>>
>> Goga
>>
>>
>>
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>

--001636c5bb71a42092046a56ba86
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div>Ok, I now=A0use <a href=3D"http://mercurial.intuxication.org/hg/s2-lip=
lianin" target=3D"_blank">http://mercurial.intuxication.org/hg/s2-liplianin=
</a><br>I installed it on /usr/local/src/ with make &amp; make install</div=
>

<div>=A0</div>
<div>but szap-s2 lock dvb-s signal but not dvb-s2...</div>
<div>someone have an idea???<br></div>
<div class=3D"gmail_quote">2009/5/15 Goga777 <span dir=3D"ltr">&lt;<a href=
=3D"mailto:goga777@bk.ru" target=3D"_blank">goga777@bk.ru</a>&gt;</span>=20
<div>
<div></div>
<div class=3D"h5"><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div>&gt; I have a problem with my HVR-4000 card.<br>&gt;<br>&gt; I install=
ed the firmware cx24116 find on<br>&gt; <a href=3D"http://tevii.com/Tevii_l=
inuxdriver_0815.rar" target=3D"_blank">http://tevii.com/Tevii_linuxdriver_0=
815.rar</a><br>
&gt; sudo cp tevii_linuxdriver_0815/fw/dvb-fe-cx24116.fw<br>&gt; /lib/firmw=
are/dvb-fe-cx24116-1.23.86.1.fw<br>&gt; sudo ln -s /lib/firmware/dvb-fe-cx2=
4116-1.23.86.1.fw<br>&gt; /lib/firmware/dvb-fe-cx24116.fw<br>&gt;<br>&gt; I=
 installed S2API find on <a href=3D"http://linuxtv.org/hg/~stoth/s2/" targe=
t=3D"_blank">http://linuxtv.org/hg/~stoth/s2/</a><br>
<br></div>please use <a href=3D"http://mercurial.intuxication.org/hg/s2-lip=
lianin" target=3D"_blank">http://mercurial.intuxication.org/hg/s2-liplianin=
</a><br>
<div><br>&gt; and I installed szap-s2 find on <a href=3D"http://mercurial.i=
ntuxication.org/hg/szap-s2" target=3D"_blank">http://mercurial.intuxication=
.org/hg/szap-s2</a><br>&gt;<br>&gt; Every seems to be ok...<br>&gt; I can t=
une an DVB-S signal, but not DVB-S2...<br>
&gt; I try to tune a DVB-S2 signal with a symbols rate of 75335000 (&gt;450=
00000)<br>&gt; and I have this error message with dmesg :<br>&gt;<br>&gt; [=
 450.409150] DVB: frontend 0 symbol rate 75335000 out of range<br>&gt; (100=
0000..45000000)<br>
&gt;<br>&gt; So I try dvbsnoop to see the frontend information :<br>&gt;<br=
>&gt; # dvbsnoop -s feinfo<br>&gt; dvbsnoop V1.4.50 -- <a href=3D"http://dv=
bsnoop.sourceforge.net/" target=3D"_blank">http://dvbsnoop.sourceforge.net/=
</a><br>
<br></div>dvbsnoop doesn&#39;t work with s2api<br><br><br>Goga<br><br><br><=
br><br>_______________________________________________<br>linux-dvb users m=
ailing list<br>For V4L/DVB development, please use instead <a href=3D"mailt=
o:linux-media@vger.kernel.org" target=3D"_blank">linux-media@vger.kernel.or=
g</a><br>
<a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank">linux-dvb@linuxt=
v.org</a><br><a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/lin=
ux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/l=
inux-dvb</a><br>
</blockquote></div></div></div><br></blockquote></div><br>

--001636c5bb71a42092046a56ba86--


--===============0480568211==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0480568211==--
