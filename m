Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1L7dPO-0001bc-PL
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 23:07:55 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2236770fga.25
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 14:07:51 -0800 (PST)
Message-ID: <4935B1B3.40709@googlemail.com>
Date: Tue, 02 Dec 2008 23:07:47 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <492168D8.4050900@googlemail.com>	
	<19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>	
	<c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>	
	<49358FE8.9020701@googlemail.com>
	<c74595dc0812021205x22936540w9ce74549f07339ff@mail.gmail.com>
In-Reply-To: <c74595dc0812021205x22936540w9ce74549f07339ff@mail.gmail.com>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Alex Betis schrieb:
> What driver and scan utility do you use?
I'm using the current linuxtv.org repository. I'm a DVB-C user. DVB-S2 isn'=
t important for me.

> If you use S2API driver, please try my scan-s2 from here:
> http://mercurial.intuxication.org/hg/scan-s2/
If I use 'scan-s2 -c -o vdr', the output is wrong. I get:

Bayerisches FS S=FCd;ARD:201:202=3Ddeu,203=3D2ch;206=3Ddeu:204:0:28107:4198=
5:1101:0

I should get:

Bayerisches FS S=FCd;ARD:346:M256:C:6900:201:202=3Ddeu,203=3D2ch;206=3Ddeu:=
204:0:28107:41985:0:0

Frequency, modulation, DVB type and symbol rate are still missing.

> I did several fixes in that area.
A fix for the lack ONID I did sent some time ago
(http://linuxtv.org/pipermail/linux-dvb/2007-April/017266.html). Nobody was=
 interested.
The including of the polarization into the comparison of the transponders w=
as also
discussed in the German vdr portal
(http://www.vdr-portal.de/board/thread.php?postid=3D746738#post746738).

I think there is a bug in the DVB-S/DVB-S2 code. If a NIT from a DVB-S tran=
sponder was
scanned and a new transponder was found, parse_nit() should create a transp=
onder for DVB-S
and DVB-S2. Currently one new transponder is created and it is first initia=
lized for DVB-S
and some lines later, it is reinitialized for DVB-S2.

-Hartmut


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
