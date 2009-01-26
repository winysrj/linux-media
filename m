Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRNse-0005eP-JJ
	for linux-dvb@linuxtv.org; Mon, 26 Jan 2009 10:35:45 +0100
Received: by qyk9 with SMTP id 9so6337518qyk.17
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 01:35:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org>
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de>
	<c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
	<Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org>
Date: Mon, 26 Jan 2009 11:35:10 +0200
Message-ID: <c74595dc0901260135x32f7c2bm59506de420dab978@mail.gmail.com>
From: Alex Betis <alex.betis@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use scan-s2?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0052664232=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0052664232==
Content-Type: multipart/alternative; boundary=0015175cb844730e4f04615f74aa

--0015175cb844730e4f04615f74aa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Mon, Jan 26, 2009 at 1:48 AM, Mika Laitio <lamikr@pilppa.org> wrote:

> > I also run it with "-5".
> > I personaly don't like to use network advertisements (-n switch) since I
> > don't trust them.
> > I use a full frequency filled INI file.
>
> Hi
>
> It might be that the signal is not the best possible for me as I can only
> scan about 500 channels with scan by using a command:
> ./scan -o vdr -a 1 Astra-19.2E
>
> In Astra-19.2E I have single line:
> #Astra 1KR (19.2E) - 10743.75 H - DVB-S (QPSK) - 22000 5/6 - NID:1 -
> TID:1051
> S 10743750 H 22000000 5/6
>
> However, once scanned the channels like eurosport, arte, skynews, cnn
> international shows up just fine with vdr-1.6.0.
>
> But if I try to use the same Astra-19.2E file with scan-s2, it can only
> find the channels from frequency 10743750 if I have stopped the "scan"
> after it had found those channels... If I let the scan to run in the end
> to other frequencies, then scan-s2 can not find anything...
>
> ./scan-s2 -a 1 -5 -n Astra-19.2E
>
> Propably Klaus Schmidinger reported something related with his TT-3200 in
> http://www.mail-archive.com/vdr@linuxtv.org/msg08493.html
> I have however hvr-4000.

As an owner of cx24116 device you should know that it doesn't allow any AUTO
settings, so you have to create an INI file with all parameters explicitly
specifed (FEC, modulation, rolloff).

I believe this is the main problem.

Also, please take the latest scan-s2, I've done some changes especily for
cx24116 cards.

--0015175cb844730e4f04615f74aa
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Mon, Jan 26, 2009 at 1:48 AM=
, Mika Laitio <span dir=3D"ltr">&lt;<a href=3D"mailto:lamikr@pilppa.org" ta=
rget=3D"_blank">lamikr@pilppa.org</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">&gt; I also run it with &quot;-5=
&quot;.<br>&gt; I personaly don&#39;t like to use network advertisements (-=
n switch) since I<br>
&gt; don&#39;t trust them.<br>&gt; I use a full frequency filled INI file.<=
br><br>Hi<br><br>It might be that the signal is not the best possible for m=
e as I can only<br>scan about 500 channels with scan by using a command:<br=
>
./scan -o vdr -a 1 Astra-19.2E<br><br>In Astra-19.2E I have single line:<br=
>#Astra 1KR (19.2E) - 10743.75 H - DVB-S (QPSK) - 22000 5/6 - NID:1 - TID:1=
051<br>S 10743750 H 22000000 5/6<br><br>However, once scanned the channels =
like eurosport, arte, skynews, cnn<br>
international shows up just fine with vdr-1.6.0.<br><br>But if I try to use=
 the same Astra-19.2E file with scan-s2, it can only<br>find the channels f=
rom frequency 10743750 if I have stopped the &quot;scan&quot;<br>after it h=
ad found those channels... If I let the scan to run in the end<br>
to other frequencies, then scan-s2 can not find anything...<br><br>./scan-s=
2 -a 1 -5 -n Astra-19.2E<br><br>Propably Klaus Schmidinger reported somethi=
ng related with his TT-3200 in<br><a href=3D"http://www.mail-archive.com/vd=
r@linuxtv.org/msg08493.html" target=3D"_blank">http://www.mail-archive.com/=
vdr@linuxtv.org/msg08493.html</a><br>
I have however hvr-4000.</blockquote>
<div>As an owner of cx24116 device you should know that it doesn&#39;t allo=
w any AUTO settings, so you have to create an INI file with all parameters =
explicitly specifed (FEC, modulation, rolloff).</div>
<div>&nbsp;</div>
<div>I believe this is the main problem.</div>
<div>&nbsp;</div>
<div>Also, please take the latest scan-s2, I&#39;ve done some changes espec=
ily for cx24116 cards.</div>
<div>&nbsp;</div></div></div>

--0015175cb844730e4f04615f74aa--


--===============0052664232==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0052664232==--
