Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <meysam.hariri@gmail.com>) id 1KbHbU-0001cu-7O
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 18:22:42 +0200
Received: by ey-out-2122.google.com with SMTP id 25so8319eya.17
	for <linux-dvb@linuxtv.org>; Thu, 04 Sep 2008 09:22:36 -0700 (PDT)
Message-ID: <1a18e9e80809040922k1c2022c6u1695b48e12666ff2@mail.gmail.com>
Date: Thu, 4 Sep 2008 20:52:36 +0430
From: "Meysam Hariri" <meysam.hariri@gmail.com>
To: newspaperman_germany@yahoo.com, linux-dvb@linuxtv.org
In-Reply-To: <772209.85557.qm@web23204.mail.ird.yahoo.com>
MIME-Version: 1.0
References: <772209.85557.qm@web23204.mail.ird.yahoo.com>
Subject: Re: [linux-dvb] Drivers for TT S2-3200
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0837495287=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0837495287==
Content-Type: multipart/alternative;
	boundary="----=_Part_39951_18244741.1220545356687"

------=_Part_39951_18244741.1220545356687
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

May i add some bugs to your list:

4) For dvb-s channels whenever i start szap on a channel, it may lock or no=
t
lock by chance. i'll have to exit and run szap multiple times to get lock.
some ppl say setting a slightly lower symbrate or frequency for the channel
will fix the problem. but this should be fixed within the driver.

the problem with some dvbs2 channels seems to be also from the 8psk
modulation and not the symbolrate/fec combination itself. there are 8psk
channels on lower symbolrates with different fec it can't get lock.

Isn't that from the lack of support in the driver for 8psk? i roughly looke=
d
at the sources and there seems to be more on qpsk where there is no mention
of 8psk for instance on switch loops.

Regards,


On Thu, Sep 4, 2008 at 5:57 PM, Newsy Paper
<newspaperman_germany@yahoo.com>wrote:

> @Igor: I tried your new driver. My first impression is that it works stab=
le
> with me TT S2-3200 so thx for providing a driver that's uptodate.
>
> I found 3 bugs:
> 1) When I switch to Nilesat (this is the weakest satellite; I get a weak
> signal, but still no dropouts and pixelation). When I switch from one
> transponder to another on that satellite I get no more signal lock on the
> chosen transponder. I have to kill and restart vdr to get signal again. I=
t
> doesn't depend on the transponder frequency it occours with all transpond=
ers
> on nilesat (while for others it could be another satellite that is so wea=
k
> to cause such switching problems). The problem already occoured with
> multiproto + channel lock patch.
>
> 2) There's still this bug with DVB-S2 SR 30000 3/4 I don't know if you
> already expierenced this bug but it only occours with linux drivers. In
> Windows it's working.
>
> 3) no signal strengh on femon, but I think you already know this.
>
> kind regards
>
>
> Newsy
>
> __________________________________________________
> Do You Yahoo!?
> Sie sind Spam leid? Yahoo! Mail verf=FCgt =FCber einen herausragenden Sch=
utz
> gegen Massenmails.
> http://mail.yahoo.com
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_39951_18244741.1220545356687
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">May i add some bugs to your list:<br><br>4) For dvb-s chan=
nels whenever i start szap on a channel, it may lock or not lock by chance.=
 i&#39;ll have to exit and run szap multiple times to get lock. some ppl sa=
y setting a slightly lower symbrate or frequency for the channel will fix t=
he problem. but this should be fixed within the driver.<br>
<br>the problem with some dvbs2 channels seems to be  also from the 8psk mo=
dulation and not the symbolrate/fec combination itself. there are 8psk chan=
nels on lower symbolrates with different fec it can&#39;t get lock.<br>
<br>Isn&#39;t that from the lack of support in the driver for 8psk? i rough=
ly looked at the sources and there seems to be more on qpsk where there is =
no mention of 8psk for instance on switch loops.<br><br>Regards,<br><br>
<br><div class=3D"gmail_quote">On Thu, Sep 4, 2008 at 5:57 PM, Newsy Paper =
<span dir=3D"ltr">&lt;<a href=3D"mailto:newspaperman_germany@yahoo.com">new=
spaperman_germany@yahoo.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt=
 0pt 0pt 0.8ex; padding-left: 1ex;">
@Igor: I tried your new driver. My first impression is that it works stable=
 with me TT S2-3200 so thx for providing a driver that&#39;s uptodate.<br>
<br>
I found 3 bugs:<br>
1) When I switch to Nilesat (this is the weakest satellite; I get a weak si=
gnal, but still no dropouts and pixelation). When I switch from one transpo=
nder to another on that satellite I get no more signal lock on the chosen t=
ransponder. I have to kill and restart vdr to get signal again. It doesn&#3=
9;t depend on the transponder frequency it occours with all transponders on=
 nilesat (while for others it could be another satellite that is so weak to=
 cause such switching problems). The problem already occoured with multipro=
to + channel lock patch.<br>

<br>
2) There&#39;s still this bug with DVB-S2 SR 30000 3/4 I don&#39;t know if =
you already expierenced this bug but it only occours with linux drivers. In=
 Windows it&#39;s working.<br>
<br>
3) no signal strengh on femon, but I think you already know this.<br>
<br>
kind regards<br>
<br>
<br>
Newsy<br>
<br>
__________________________________________________<br>
Do You Yahoo!?<br>
Sie sind Spam leid? Yahoo! Mail verf=FCgt =FCber einen herausragenden Schut=
z gegen Massenmails.<br>
<a href=3D"http://mail.yahoo.com" target=3D"_blank">http://mail.yahoo.com</=
a><br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</blockquote></div><br></div>

------=_Part_39951_18244741.1220545356687--


--===============0837495287==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0837495287==--
