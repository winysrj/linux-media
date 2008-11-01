Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-4.orange.nl ([193.252.22.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1KwIeq-0002uJ-3f
	for linux-dvb@linuxtv.org; Sat, 01 Nov 2008 16:45:02 +0100
Message-ID: <490C7958.8050902@verbraak.org>
Date: Sat, 01 Nov 2008 16:44:24 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: Goga777 <goga777@bk.ru>, linux-dvb@linuxtv.org
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>	<490C7194.8060603@verbraak.org>
	<20081101182051.3ac22972@bk.ru>
In-Reply-To: <20081101182051.3ac22972@bk.ru>
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0073475483=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0073475483==
Content-Type: multipart/alternative;
 boundary="------------030101060300080600050906"

This is a multi-part message in MIME format.
--------------030101060300080600050906
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: quoted-printable

Goga777 schreef:
> =F0=D2=C9=D7=C5=D4=D3=D4=D7=D5=C0, Michel
>
> but cx24116 based cards don't work with fec=3Dauto for dvb-s2=20
>
> I'm not sure - may be for cx24116 cards the parameters roll off & modul=
ation are obligatory (not optional)
>
>
>
>  =20
>> Tested your scan-s2 with a Technisat HD2 card.
>>
>> Scanning works. But some channels are reported twice with different=20
>> frequency. I found an error which is fixed by the patch file named=20
>> scan.c.diff1.
>>
>> I would also like to propose the following change (see file scan.c.dif=
f2=20
>> or scan.c.diff which includes both patches). This change makes it=20
>> possible to only scan for DVB-S channels or DVB-S2 channels or both.=20
>> This is done by specifying lines starting with S or S2 in the input fi=
le.
>>
>> example input file:
>> # Astra 19.2E SDT info service transponder
>> # freq pol sr fec
>> S 12522000 H 22000000 2/3       <only DVB-S channels are scanned>
>> S 11914000 H 27500000 AUTO
>> S 10743750 H 22000000 5/6
>> S 12187500 H 27500000 3/4
>> S 12343500 H 27500000 3/4
>> S 12515250 H 22000000 5/6
>> S 12574250 H 22000000 5/6
>> S2 12522000 H 22000000 AUTO    <only DVB-S2 channels are scanned>
>> S2 11914000 H 27500000 AUTO
>>
>> I hope this is usefull.
>>
>> Regards,
>>
>> Michel.
>>    =20
>
>
>  =20

Goga,

AUTO fec does work because the following is the result for the DVB-S2=20
channels I get with the above input:

PREMIERE HD:11914:h:0:27500:767:772:129:6
DISCOVERY HD:11914:h:0:27500:1023:1027:130:6
ASTRA HD+:11914:h:0:27500:1279:1283:131:6
ANIXE HD:11914:h:0:27500:1535:1539:132:6

Regards,

Michel.

--------------030101060300080600050906
Content-Type: text/html; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content=3D"text/html;charset=3DKOI8-R" http-equiv=3D"Content-Type=
">
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
Goga777 schreef:
<blockquote cite=3D"mid:20081101182051.3ac22972@bk.ru" type=3D"cite">
  <pre wrap=3D"">=F0=D2=C9=D7=C5=D4=D3=D4=D7=D5=C0, Michel

but cx24116 based cards don't work with fec=3Dauto for dvb-s2=20

I'm not sure - may be for cx24116 cards the parameters roll off &amp; mod=
ulation are obligatory (not optional)



  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">Tested your scan-s2 with a Technisat HD2 card.

Scanning works. But some channels are reported twice with different=20
frequency. I found an error which is fixed by the patch file named=20
scan.c.diff1.

I would also like to propose the following change (see file scan.c.diff2=20
or scan.c.diff which includes both patches). This change makes it=20
possible to only scan for DVB-S channels or DVB-S2 channels or both.=20
This is done by specifying lines starting with S or S2 in the input file.

example input file:
# Astra 19.2E SDT info service transponder
# freq pol sr fec
S 12522000 H 22000000 2/3       &lt;only DVB-S channels are scanned&gt;
S 11914000 H 27500000 AUTO
S 10743750 H 22000000 5/6
S 12187500 H 27500000 3/4
S 12343500 H 27500000 3/4
S 12515250 H 22000000 5/6
S 12574250 H 22000000 5/6
S2 12522000 H 22000000 AUTO    &lt;only DVB-S2 channels are scanned&gt;
S2 11914000 H 27500000 AUTO

I hope this is usefull.

Regards,

Michel.
    </pre>
  </blockquote>
  <pre wrap=3D""><!---->

  </pre>
</blockquote>
<br>
Goga,<br>
<br>
AUTO fec does work because the following is the result for the DVB-S2
channels I get with the above input:<br>
<br>
PREMIERE HD:11914:h:0:27500:767:772:129:6<br>
DISCOVERY HD:11914:h:0:27500:1023:1027:130:6<br>
ASTRA HD+:11914:h:0:27500:1279:1283:131:6<br>
ANIXE HD:11914:h:0:27500:1535:1539:132:6<br>
<br>
Regards,<br>
<br>
Michel.<br>
</body>
</html>

--------------030101060300080600050906--



--===============0073475483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0073475483==--
