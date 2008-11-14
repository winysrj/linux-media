Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L0u4g-00084T-9z
	for linux-dvb@linuxtv.org; Fri, 14 Nov 2008 09:30:43 +0100
Received: by qw-out-2122.google.com with SMTP id 9so948501qwb.17
	for <linux-dvb@linuxtv.org>; Fri, 14 Nov 2008 00:30:37 -0800 (PST)
Message-ID: <c74595dc0811140030m2ac96ce6ge59e428a09a0288b@mail.gmail.com>
Date: Fri, 14 Nov 2008 10:30:37 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20081113230447.273580@gmx.net>
MIME-Version: 1.0
References: <20081112023112.94740@gmx.net>
	<c74595dc0811121256h505d71e1q3468e061dfefc3df@mail.gmail.com>
	<20081113230447.273580@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0468717786=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0468717786==
Content-Type: multipart/alternative;
	boundary="----=_Part_19850_4167156.1226651437335"

------=_Part_19850_4167156.1226651437335
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, Nov 14, 2008 at 1:04 AM, Hans Werner <HWerner4@gmx.de> wrote:

> > Hans,
> > I'm looking on your QPSK diff and I disagree with the changes.
> > I think the concept of having all missing parameters as AUTO values
> should
> > have modulation, rolloff and FEC set to AUTO enumeration.
> > If your card can't handle the AUTO setting, so you have to specify it i=
n
> > the
> > frequency file.
>
> I want the computer to do the work, see below ;).

Ok, I can't disagree with that :)

>
>
> > Applying your changes will break scaning S2 channels for a freq file wi=
th
> > the following line:
> > S 11258000 H 27500000
> > or even
> > S2 11258000 H 27500000
> >
> > Since it will order the driver to use QPSK modulation, while there shou=
ld
> > be
> > 8PSK or AUTO.
> > I don't really know how rolloff=3D35 will affect since its the default =
in
> > some
> > drivers, but again, AUTO setting was intended for that purpose,
> > to let the card/driver decide what parameters should be used.
>
> Ok, I have looked at this again and written a new patch. I also looked at
> what
> you checked in yesterday for S1/S2 and -D options.
>
> In order to keep the AUTO behaviour you want and also allow for cards whi=
ch
> cannot handle autos I have added a new option -X which sets a noauto flag=
.
> When this option is chosen, instead of putting an initial transponder wit=
h
> an AUTO
> in the transponder list, several transponders are created for each allowe=
d
> value of
> each free parameter (which may be delivery system, modulation, fec or
> rolloff).
>
> so with -X
> S 12551500 V 22000000 5/6
> results in
> initial transponder DVB-S  12551500 V 22000000 5/6 35 QPSK
> initial transponder DVB-S2 12551500 V 22000000 5/6 35 QPSK
> initial transponder DVB-S2 12551500 V 22000000 5/6 35 8PSK
> initial transponder DVB-S2 12551500 V 22000000 5/6 25 QPSK
> initial transponder DVB-S2 12551500 V 22000000 5/6 25 8PSK
> initial transponder DVB-S2 12551500 V 22000000 5/6 20 QPSK
> initial transponder DVB-S2 12551500 V 22000000 5/6 20 8PSK
>
> (fec was fixed in the transponder file in this example, but delivery
> system, rolloff and modulation were not)
>
> The new S1/S2 and -D options are respected. So with -D S1, the S2
> lines would not be added for example.
>
> Using -X -D and S2/S1/S thus gives lots of flexibility for scanning.

I hope we won't run out of free letters for next command line flags we'll
add :)
Sounds good to me. My recent changes to delete duplicate frequencies when
lock was successful on one of them will be especially helpful in that case
to speed up the scan process.

>
>
> The patch also makes improvements in
> parse_satellite_delivery_system_descriptor, adding rolloff and the
> new S2 FECs and changes to delivery system and modulation parsing.

Thanks. You did part of the work I've intended to do :)

>
>
> Hans
>
> --
> Release early, release often.
>
> Sensationsangebot nur bis 30.11: GMX FreeDSL - Telefonanschluss + DSL
> f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T456=
9a
>

------=_Part_19850_4167156.1226651437335
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><br><div class=3D"gmail_quote">On Fri, Nov 14, 2008 at 1:0=
4 AM, Hans Werner <span dir=3D"ltr">&lt;<a href=3D"mailto:HWerner4@gmx.de">=
HWerner4@gmx.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8=
ex; padding-left: 1ex;">
<div><div></div><div class=3D"Wj3C7c">&gt; Hans,<br>
&gt; I&#39;m looking on your QPSK diff and I disagree with the changes.<br>
&gt; I think the concept of having all missing parameters as AUTO values sh=
ould<br>
&gt; have modulation, rolloff and FEC set to AUTO enumeration.<br>
&gt; If your card can&#39;t handle the AUTO setting, so you have to specify=
 it in<br>
&gt; the<br>
&gt; frequency file.<br>
<br>
</div></div>I want the computer to do the work, see below ;).</blockquote><=
div>Ok, I can&#39;t disagree with that :) <br></div><blockquote class=3D"gm=
ail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt =
0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<div class=3D"Ih2E3d"><br>
&gt; Applying your changes will break scaning S2 channels for a freq file w=
ith<br>
&gt; the following line:<br>
&gt; S 11258000 H 27500000<br>
&gt; or even<br>
&gt; S2 11258000 H 27500000<br>
&gt;<br>
&gt; Since it will order the driver to use QPSK modulation, while there sho=
uld<br>
&gt; be<br>
&gt; 8PSK or AUTO.<br>
&gt; I don&#39;t really know how rolloff=3D35 will affect since its the def=
ault in<br>
&gt; some<br>
&gt; drivers, but again, AUTO setting was intended for that purpose,<br>
&gt; to let the card/driver decide what parameters should be used.<br>
<br>
</div>Ok, I have looked at this again and written a new patch. I also looke=
d at what<br>
you checked in yesterday for S1/S2 and -D options.<br>
<br>
In order to keep the AUTO behaviour you want and also allow for cards which=
<br>
cannot handle autos I have added a new option -X which sets a noauto flag.<=
br>
When this option is chosen, instead of putting an initial transponder with =
an AUTO<br>
in the transponder list, several transponders are created for each allowed =
value of<br>
each free parameter (which may be delivery system, modulation, fec or rollo=
ff).<br>
<br>
so with -X<br>
<div class=3D"Ih2E3d">S 12551500 V 22000000 5/6<br>
</div>results in<br>
initial transponder DVB-S &nbsp;12551500 V 22000000 5/6 35 QPSK<br>
initial transponder DVB-S2 12551500 V 22000000 5/6 35 QPSK<br>
initial transponder DVB-S2 12551500 V 22000000 5/6 35 8PSK<br>
initial transponder DVB-S2 12551500 V 22000000 5/6 25 QPSK<br>
initial transponder DVB-S2 12551500 V 22000000 5/6 25 8PSK<br>
initial transponder DVB-S2 12551500 V 22000000 5/6 20 QPSK<br>
initial transponder DVB-S2 12551500 V 22000000 5/6 20 8PSK<br>
<br>
(fec was fixed in the transponder file in this example, but delivery<br>
system, rolloff and modulation were not)<br>
<br>
The new S1/S2 and -D options are respected. So with -D S1, the S2<br>
lines would not be added for example.<br>
<br>
Using -X -D and S2/S1/S thus gives lots of flexibility for scanning.</block=
quote><div>I hope we won&#39;t run out of free letters for next command lin=
e flags we&#39;ll add :)<br>Sounds good to me. My recent changes to delete =
duplicate frequencies when lock was successful on one of them will be espec=
ially helpful in that case to speed up the scan process.<br>
</div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb=
(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
The patch also makes improvements in<br>
parse_satellite_delivery_system_descriptor, adding rolloff and the<br>
new S2 FECs and changes to delivery system and modulation parsing.</blockqu=
ote><div>Thanks. You did part of the work I&#39;ve intended to do :) <br></=
div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(2=
04, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<div class=3D"Ih2E3d"><br>
Hans<br>
<br>
--<br>
Release early, release often.<br>
<br>
</div><div><div></div><div class=3D"Wj3C7c">Sensationsangebot nur bis 30.11=
: GMX FreeDSL - Telefonanschluss + DSL<br>
f=FCr nur 16,37 Euro/mtl.!* <a href=3D"http://dsl.gmx.de/?ac=3DOM.AD.PD003K=
11308T4569a" target=3D"_blank">http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a</a><br>
</div></div></blockquote></div><br></div>

------=_Part_19850_4167156.1226651437335--


--===============0468717786==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0468717786==--
