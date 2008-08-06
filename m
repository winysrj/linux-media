Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KQquM-0000YB-Pw
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 23:51:03 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	6C5AF1801800
	for <linux-dvb@linuxtv.org>; Wed,  6 Aug 2008 21:49:40 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: rvf16 <rvf16@yahoo.gr>
Date: Thu, 7 Aug 2008 07:49:40 +1000
Message-Id: <20080806214940.4024447808F@ws1-5.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] CX23885 based AVerMedia AVerTV Hybrid Express Slim
 tv card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1791297125=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1791297125==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121805938038700"

This is a multi-part message in MIME format.

--_----------=_121805938038700
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

I just had a quick look in the .inf file that is installed=20


by the drivers from Avermedia.

It appears that your card uses a TDA18271 tuner.  I'm not=20
sure what demod it is using though, just thought this might=20
help you a bit.

Maybe you could try using one of the cards already in the=20
cx23885 driver, some of these are using this tuner...

As Steve said the best way to find out what is in the tuner=20
is to physically open the case and identify all chips and=20
related devices.

Maybe perform an i2cdetect on the three i2c interfaces of=20
the cx23885 and include this on the wiki page (if there=20
isn't a wiki page create it and include your regspy logs,=20
photos and key components, link to product page, etc)

Good luck.

Stephen

rvf16 wrote:
> Thanks for the reply but how am i going to do all these?
>
> Are there any howtos for identifying tuner and demodulator?
> Where do i find the patches to add support for my device?
> Submit my patches? what do you mean? After reading several mails in=20
> this mailing list i did the regspy task but now i am completely=20
> blind .
> Thank you.
>
>> Start by identifying the tuner and demodulator, then patch the=20
>> cx23885 tree - adding support for these devices - and submit your=20
>> patches here for review.

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_121805938038700
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

<span id=3D"obmessage"><pre>I just had a quick look in the .inf file that i=
s installed <br>by the drivers from Avermedia.<br><br>It appears that your =
card uses a TDA18271 tuner.  I'm not <br>sure what demod it is using though=
, just thought this might <br>help you a bit.<br><br>Maybe you could try us=
ing one of the cards already in the <br>cx23885 driver, some of these are u=
sing this tuner...<br><br>As Steve said the best way to find out what is in=
 the tuner <br>is to physically open the case and identify all chips and <b=
r>related devices.<br><br>Maybe perform an i2cdetect on the three i2c inter=
faces of <br>the cx23885 and include this on the wiki page (if there <br>is=
n't a wiki page create it and include your regspy logs, <br>photos and key =
components, link to product page, etc)<br><br>Good luck.<br><br>Stephen<br>=
<br>rvf16 wrote:<br>&gt; Thanks for the reply but how am i going to do all =
these?<br>&gt;<br>&gt; Are there any howtos for identifying tuner and demod=
ulator?<br>&gt; Where do i find the patches to add support for my device?<b=
r>&gt; Submit my patches? what do you mean? After reading several mails in =
<br>&gt; this mailing list i did the regspy task but now i am completely <b=
r>&gt; blind .<br>&gt; Thank you.<br>&gt;<br>&gt;&gt; Start by identifying =
the tuner and demodulator, then patch the <br>&gt;&gt; cx23885 tree - addin=
g support for these devices - and submit your <br>&gt;&gt; patches here for=
 review.<br><br></pre></span>
<div>

</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_121805938038700--



--===============1791297125==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1791297125==--
