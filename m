Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <alexander.saers@gmail.com>) id 1Mfpy2-0006MR-U5
	for linux-dvb@linuxtv.org; Tue, 25 Aug 2009 08:57:19 +0200
Received: by bwz9 with SMTP id 9so1819999bwz.17
	for <linux-dvb@linuxtv.org>; Mon, 24 Aug 2009 23:56:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A92AB38.7040207@ludd.ltu.se>
References: <7606f7c10908210621r77acf304g1c921396a566399a@mail.gmail.com>
	<4A92AB38.7040207@ludd.ltu.se>
Date: Tue, 25 Aug 2009 08:56:44 +0200
Message-ID: <7606f7c10908242356g74043de3yab0913900a3a758f@mail.gmail.com>
From: Alexander Saers <alex@saers.com>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Anysee E30 Combo Plus startup mode
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1198644393=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1198644393==
Content-Type: multipart/alternative; boundary=0015175d67ae674a520471f1d6fc

--0015175d67ae674a520471f1d6fc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Benjamin

Thanx for the reply. Good to know that I'm not alone with the issue :-).

The idee to simply remove the dvb-t part from the code was something i have
thought of. However if you do that you need to build a custom kernel every
time a security update is released. This can be a real pain :)

However I came up with the following simple solution to the problem. I just
prevent the modules from being loaded. Just edit
/etc/modprobe.d/blacklist.conf and add the following at the end of it.

If you want dvb-c add this
blacklist zl10353

if you want dvb-t add this
blacklist tda10023

And then reboot the computer. Almost to simple :)

Br
Alexander

2009/8/24 Benjamin Larsson <banan@ludd.ltu.se>

> Alexander Saers wrote:
>
>> Hello
>>
>> I have a Anysee E30 Combo Plus USB device. It's capable of both DVB-C and
>> DVB-T. I currently use the device with ubuntu 9.04 64bit with mythtv. I have
>> problem with selction of mode for the device
>>
>>  [...]
>
>>
>> Anyone experienced this problem? It would be nice to run DVB-C without
>> having to disconnect and connect hardware.
>>
>> Br
>> Alexander
>>
>
> I experience the same thing. Hacking the drivers does help.
>
>
> diff -r 46560e0b658e linux/drivers/media/dvb/dvb-usb/anysee.c
> --- a/linux/drivers/media/dvb/dvb-usb/anysee.c  Fri Apr 24 20:27:44 2009
> +0300
> +++ b/linux/drivers/media/dvb/dvb-usb/anysee.c  Sat Jul 11 12:08:29 2009
> +0200
> @@ -293,13 +293,6 @@ static int anysee_frontend_attach(struct
>                return 0;
>        }
>
> -       /* Zarlink ZL10353 DVB-T demod inside of Samsung DNOS404ZH103A NIM
> */
> -       adap->fe = dvb_attach(zl10353_attach, &anysee_zl10353_config,
> -                             &adap->dev->i2c_adap);
> -       if (adap->fe != NULL) {
> -               state->tuner = DVB_PLL_THOMSON_DTT7579;
> -               return 0;
> -       }
>
>        /* for E30 Combo Plus DVB-T demodulator */
>        if (dvb_usb_anysee_delsys) {
> @@ -321,13 +314,6 @@ static int anysee_frontend_attach(struct
>        if (ret)
>                return ret;
>
> -       /* Zarlink ZL10353 DVB-T demod inside of Samsung DNOS404ZH103A NIM
> */
> -       adap->fe = dvb_attach(zl10353_attach, &anysee_zl10353_config,
> -                             &adap->dev->i2c_adap);
> -       if (adap->fe != NULL) {
> -               state->tuner = DVB_PLL_THOMSON_DTT7579;
> -               return 0;
> -       }
>
>        /* IO port E - E30C rev 0.4 board requires this */
>        ret = anysee_write_reg(adap->dev, 0xb1, 0xa7);
>
>
> The issue is reported to the maintainer.
>
>
> MvH
> Benjamin Larsson
>
>
>

--0015175d67ae674a520471f1d6fc
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Benjamin<br><br>Thanx for the reply. Good to know that I&#39;m not al=
one with the issue :-).<br><br>The idee to simply remove the dvb-t part fro=
m the code was something i have thought of. However if you do that you need=
 to build a custom kernel every time a security update is released. This ca=
n be a real pain :)<br>
<br>However I came up with the following simple solution to the problem. I =
just prevent the modules from being loaded. Just edit /etc/modprobe.d/black=
list.conf and add the following at the end of it.<br><br>If you want dvb-c =
add this<br>
blacklist zl10353<br><br>if you want dvb-t add this<br>blacklist tda10023<b=
r><br>And then reboot the computer. Almost to simple :)<br><br>Br<br>Alexan=
der<br><br><div class=3D"gmail_quote">2009/8/24 Benjamin Larsson <span dir=
=3D"ltr">&lt;<a href=3D"mailto:banan@ludd.ltu.se">banan@ludd.ltu.se</a>&gt;=
</span><br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"im"=
>Alexander Saers wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hello<br>
<br>
I have a Anysee E30 Combo Plus USB device. It&#39;s capable of both DVB-C a=
nd DVB-T. I currently use the device with ubuntu 9.04 64bit with mythtv. I =
have problem with selction of mode for the device<br>
<br>
</blockquote></div>
[...]<div class=3D"im"><br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
Anyone experienced this problem? It would be nice to run DVB-C without havi=
ng to disconnect and connect hardware.<br>
<br>
Br<br>
Alexander<br>
</blockquote>
<br></div>
I experience the same thing. Hacking the drivers does help.<br>
<br>
<br>
diff -r 46560e0b658e linux/drivers/media/dvb/dvb-usb/anysee.c<br>
--- a/linux/drivers/media/dvb/dvb-usb/anysee.c =A0Fri Apr 24 20:27:44 2009 =
+0300<br>
+++ b/linux/drivers/media/dvb/dvb-usb/anysee.c =A0Sat Jul 11 12:08:29 2009 =
+0200<br>
@@ -293,13 +293,6 @@ static int anysee_frontend_attach(struct<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;<br>
 =A0 =A0 =A0 =A0}<br>
<br>
- =A0 =A0 =A0 /* Zarlink ZL10353 DVB-T demod inside of Samsung DNOS404ZH103=
A NIM */<br>
- =A0 =A0 =A0 adap-&gt;fe =3D dvb_attach(zl10353_attach, &amp;anysee_zl1035=
3_config,<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &amp;adap-&gt;dev=
-&gt;i2c_adap);<br>
- =A0 =A0 =A0 if (adap-&gt;fe !=3D NULL) {<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 state-&gt;tuner =3D DVB_PLL_THOMSON_DTT7579;<=
br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
- =A0 =A0 =A0 }<br>
<br>
 =A0 =A0 =A0 =A0/* for E30 Combo Plus DVB-T demodulator */<br>
 =A0 =A0 =A0 =A0if (dvb_usb_anysee_delsys) {<br>
@@ -321,13 +314,6 @@ static int anysee_frontend_attach(struct<br>
 =A0 =A0 =A0 =A0if (ret)<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;<br>
<br>
- =A0 =A0 =A0 /* Zarlink ZL10353 DVB-T demod inside of Samsung DNOS404ZH103=
A NIM */<br>
- =A0 =A0 =A0 adap-&gt;fe =3D dvb_attach(zl10353_attach, &amp;anysee_zl1035=
3_config,<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &amp;adap-&gt;dev=
-&gt;i2c_adap);<br>
- =A0 =A0 =A0 if (adap-&gt;fe !=3D NULL) {<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 state-&gt;tuner =3D DVB_PLL_THOMSON_DTT7579;<=
br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
- =A0 =A0 =A0 }<br>
<br>
 =A0 =A0 =A0 =A0/* IO port E - E30C rev 0.4 board requires this */<br>
 =A0 =A0 =A0 =A0ret =3D anysee_write_reg(adap-&gt;dev, 0xb1, 0xa7);<br>
<br>
<br>
The issue is reported to the maintainer.<br>
<br>
<br>
MvH<br><font color=3D"#888888">
Benjamin Larsson<br>
<br>
<br>
</font></blockquote></div><br>

--0015175d67ae674a520471f1d6fc--


--===============1198644393==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1198644393==--
