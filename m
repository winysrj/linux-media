Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L52xv-0004sP-UX
	for linux-dvb@linuxtv.org; Tue, 25 Nov 2008 19:48:52 +0100
Received: by qw-out-2122.google.com with SMTP id 9so45975qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 25 Nov 2008 10:48:48 -0800 (PST)
Message-ID: <c74595dc0811251048u7ae97e70r46a1fe2d6520bb1f@mail.gmail.com>
Date: Tue, 25 Nov 2008 20:48:47 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
In-Reply-To: <3cc3561f0811251034v7ac1a77dt7a2233a62b6a8f1c@mail.gmail.com>
MIME-Version: 1.0
References: <8622.130.36.62.139.1227602799.squirrel@webmail.xs4all.nl>
	<492BBFD9.50909@cadsoft.de>
	<a3ef07920811250832g35f4670ft4e14c942c3eef990@mail.gmail.com>
	<3cc3561f0811251034v7ac1a77dt7a2233a62b6a8f1c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1406898214=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1406898214==
Content-Type: multipart/alternative;
	boundary="----=_Part_12757_24530318.1227638927937"

------=_Part_12757_24530318.1227638927937
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, Nov 25, 2008 at 8:34 PM, Morgan T=F8rvolt <morgan.torvolt@gmail.com=
>wrote:

> Regarding the actual problem, I have never been happy with the
> "FE_QPSK" and "FE_OFDM" enum fe_types. This imho does not make much
> sense. I would like to know what a card is supposed to receive. One
> modulation type is not locked to a transmission medium, nor frequency
> range, and QPSK can easily be used in a cable network if one wished to
> do so. I second the proposed solution of Artem, but I would do it with
> a twist.
>
> If possible, I would keep the old system for backwards compatibility,
> and create a different command where this confusing QPSK/OFDM/QAM gets
> removed altogether. I would have a enum frontend type that would
> indicate what standard is being followed, if any. An additional
> indication of all the different modulation types that is supported is
> a must. In addition to what Artem proposed, I would like to be able to
> read a supported frequency range ( i.e 950-2150 for satellite tuners
> ), and supported symbol rates. The last part there about symbol rate
> could be different for different modulation types. Most people would
> not need this, but some do. I don't think I have a good solution for
> how one would solve that, but one way would be if you could do as with
> the ca_types supported that is returned from different CAMs. One could
> return a list of stucts with modulation types and their respective
> limits and parameters. I don't know if this is really useful, but I
> remember that on some of the satellite modems we used, the symbol rate
> was limited by the center frequency of the carrier. If you got to
> close to the max and min, the carrier bandwidth would have to be
> reduced. There might be some equipment out there that has such
> limitations, and it could be worth adding support for that I guess.

If we're talking(writing) about enhanced capabilities, I'll throw my 2 cent=
s
as well...
The driver has to return what settings it will accept in tune command (or
maybe other commands as well).
For example, there is a chipset (don't remember the name) that doesn't
support AUTO settings for modulation, FEC and rolloff.
If that info will be available to the application (such as scan I'm dealing
with), it will be very useful.

------=_Part_12757_24530318.1227638927937
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><br><br><div class=3D"gmail_quote">On Tue, Nov 25, 2008 at=
 8:34 PM, Morgan T=F8rvolt <span dir=3D"ltr">&lt;<a href=3D"mailto:morgan.t=
orvolt@gmail.com">morgan.torvolt@gmail.com</a>&gt;</span> wrote:<br><blockq=
uote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 20=
4); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Regarding the actual problem, I have never been happy with the<br>
&quot;FE_QPSK&quot; and &quot;FE_OFDM&quot; enum fe_types. This imho does n=
ot make much<br>
sense. I would like to know what a card is supposed to receive. One<br>
modulation type is not locked to a transmission medium, nor frequency<br>
range, and QPSK can easily be used in a cable network if one wished to<br>
do so. I second the proposed solution of Artem, but I would do it with<br>
a twist.<br>
<br>
If possible, I would keep the old system for backwards compatibility,<br>
and create a different command where this confusing QPSK/OFDM/QAM gets<br>
removed altogether. I would have a enum frontend type that would<br>
indicate what standard is being followed, if any. An additional<br>
indication of all the different modulation types that is supported is<br>
a must. In addition to what Artem proposed, I would like to be able to<br>
read a supported frequency range ( i.e 950-2150 for satellite tuners<br>
), and supported symbol rates. The last part there about symbol rate<br>
could be different for different modulation types. Most people would<br>
not need this, but some do. I don&#39;t think I have a good solution for<br=
>
how one would solve that, but one way would be if you could do as with<br>
the ca_types supported that is returned from different CAMs. One could<br>
return a list of stucts with modulation types and their respective<br>
limits and parameters. I don&#39;t know if this is really useful, but I<br>
remember that on some of the satellite modems we used, the symbol rate<br>
was limited by the center frequency of the carrier. If you got to<br>
close to the max and min, the carrier bandwidth would have to be<br>
reduced. There might be some equipment out there that has such<br>
limitations, and it could be worth adding support for that I guess.</blockq=
uote><div>If we&#39;re talking(writing) about enhanced capabilities, I&#39;=
ll throw my 2 cents as well...<br>The driver has to return what settings it=
 will accept in tune command (or maybe other commands as well).<br>
For example, there is a chipset (don&#39;t remember the name) that doesn&#3=
9;t support AUTO settings for modulation, FEC and rolloff.<br>If that info =
will be available to the application (such as scan I&#39;m dealing with), i=
t will be very useful.<br>
</div></div><br></div>

------=_Part_12757_24530318.1227638927937--


--===============1406898214==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1406898214==--
