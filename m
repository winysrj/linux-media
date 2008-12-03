Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L7m5p-0000pl-AC
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 08:24:19 +0100
Received: by qyk9 with SMTP id 9so3975884qyk.17
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 23:23:43 -0800 (PST)
Message-ID: <c74595dc0812022323w1df844cegc0c0ef269babed66@mail.gmail.com>
Date: Wed, 3 Dec 2008 09:23:42 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: e9hack <e9hack@googlemail.com>
In-Reply-To: <4935B1B3.40709@googlemail.com>
MIME-Version: 1.0
References: <492168D8.4050900@googlemail.com>
	<19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>
	<c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>
	<49358FE8.9020701@googlemail.com>
	<c74595dc0812021205x22936540w9ce74549f07339ff@mail.gmail.com>
	<4935B1B3.40709@googlemail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH]Fix a bug in scan,
	which outputs the wrong frequency if the current tuned transponder
	is scanned only
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0238266607=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0238266607==
Content-Type: multipart/alternative;
	boundary="----=_Part_116406_20506955.1228289022955"

------=_Part_116406_20506955.1228289022955
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, Dec 3, 2008 at 12:07 AM, e9hack <e9hack@googlemail.com> wrote:

> Alex Betis schrieb:
> > What driver and scan utility do you use?
> I'm using the current linuxtv.org repository. I'm a DVB-C user. DVB-S2
> isn't important for me.

I have only DVB-S/S2, so I can only guess. Your help will be appreciated in
order to fix DVB-C issues.


>
> > If you use S2API driver, please try my scan-s2 from here:
> > http://mercurial.intuxication.org/hg/scan-s2/
> If I use 'scan-s2 -c -o vdr', the output is wrong. I get:
>
> Bayerisches FS S=FCd;ARD:201:202=3Ddeu,203=3D2ch;206=3Ddeu:204:0:28107:41=
985:1101:0
>
> I should get:
>
> Bayerisches FS
> S=FCd;ARD:346:M256:C:6900:201:202=3Ddeu,203=3D2ch;206=3Ddeu:204:0:28107:4=
1985:0:0
>
> Frequency, modulation, DVB type and symbol rate are still missing.

That's interesting. That means the utility doesn't know what delivery syste=
m
is used. Probably because it didn't tune the driver.
I'll check that. It should happen with DVB-S as well.
Can you scan the same channel without "-c" and report if the dump is
correct?


>
>
> > I did several fixes in that area.
> A fix for the lack ONID I did sent some time ago
> (http://linuxtv.org/pipermail/linux-dvb/2007-April/017266.html). Nobody
> was interested.

That was already fixed few days ago. Take latest version.

>
> The including of the polarization into the comparison of the transponders
> was also
> discussed in the German vdr portal
> (http://www.vdr-portal.de/board/thread.php?postid=3D746738#post746738).

That was already fixed few weeks ago.


>
>
> I think there is a bug in the DVB-S/DVB-S2 code. If a NIT from a DVB-S
> transponder was
> scanned and a new transponder was found, parse_nit() should create a
> transponder for DVB-S
> and DVB-S2. Currently one new transponder is created and it is first
> initialized for DVB-S
> and some lines later, it is reinitialized for DVB-S2.

You're right, transponder allocation is missing there. Will fix it, thanks.

>
>
> -Hartmut
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_116406_20506955.1228289022955
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><div class=3D"gmail_quote">On Wed, Dec 3, 2008 at 12:07 AM=
, e9hack <span dir=3D"ltr">&lt;<a href=3D"mailto:e9hack@googlemail.com">e9h=
ack@googlemail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Alex Betis schrieb:<br>
<div class=3D"Ih2E3d">&gt; What driver and scan utility do you use?<br></di=
v>I&#39;m using the current <a href=3D"http://linuxtv.org/" target=3D"_blan=
k">linuxtv.org</a> repository. I&#39;m a DVB-C user. DVB-S2 isn&#39;t impor=
tant for me.</blockquote>

<div>I have only DVB-S/S2, so I can only guess. Your help will be appreciat=
ed in order to fix DVB-C issues.</div>
<div>&nbsp;</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class=3D"Ih2E3d"><br>&gt; If you use S2API driver, please try my scan-=
s2 from here:<br>&gt; <a href=3D"http://mercurial.intuxication.org/hg/scan-=
s2/" target=3D"_blank">http://mercurial.intuxication.org/hg/scan-s2/</a><br=
>
</div>If I use &#39;scan-s2 -c -o vdr&#39;, the output is wrong. I get:<br>=
<br>Bayerisches FS S=FCd;ARD:201:202=3Ddeu,203=3D2ch;206=3Ddeu:204:0:28107:=
41985:1101:0<br><br>I should get:<br><br>Bayerisches FS S=FCd;ARD:346:M256:=
C:6900:201:202=3Ddeu,203=3D2ch;206=3Ddeu:204:0:28107:41985:0:0<br>
<br>Frequency, modulation, DVB type and symbol rate are still missing.</blo=
ckquote>
<div>That&#39;s interesting. That means the utility doesn&#39;t know what d=
elivery system is used. Probably because it didn&#39;t tune the driver.</di=
v>
<div>I&#39;ll check that. It should happen with DVB-S as well.</div>
<div>Can you scan the same channel without &quot;-c&quot; and report if the=
 dump is correct?</div>
<div>&nbsp;</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=3D""></span><br>
<div class=3D"Ih2E3d"><br>&gt; I did several fixes in that area.<br></div>A=
 fix for the lack ONID I did sent some time ago<br>(<a href=3D"http://linux=
tv.org/pipermail/linux-dvb/2007-April/017266.html" target=3D"_blank">http:/=
/linuxtv.org/pipermail/linux-dvb/2007-April/017266.html</a>). Nobody was in=
terested.</blockquote>

<div>That was already fixed few days ago. Take latest version.</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=3D""></span><br>The inc=
luding of the polarization into the comparison of the transponders was also=
<br>
discussed in the German vdr portal<br>(<a href=3D"http://www.vdr-portal.de/=
board/thread.php?postid=3D746738#post746738" target=3D"_blank">http://www.v=
dr-portal.de/board/thread.php?postid=3D746738#post746738</a>).</blockquote>
<div>That was already fixed few weeks ago.</div>
<div>&nbsp;</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=3D""></span><br><br>I t=
hink there is a bug in the DVB-S/DVB-S2 code. If a NIT from a DVB-S transpo=
nder was<br>
scanned and a new transponder was found, parse_nit() should create a transp=
onder for DVB-S<br>and DVB-S2. Currently one new transponder is created and=
 it is first initialized for DVB-S<br>and some lines later, it is reinitial=
ized for DVB-S2.</blockquote>

<div>You&#39;re right, transponder allocation is missing there. Will fix it=
, thanks.</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=3D""></span><br>
<div>
<div></div>
<div class=3D"Wj3C7c"><br>-Hartmut<br><br><br>_____________________________=
__________________<br>linux-dvb mailing list<br><a href=3D"mailto:linux-dvb=
@linuxtv.org">linux-dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv.or=
g/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.=
org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_116406_20506955.1228289022955--


--===============0238266607==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0238266607==--
