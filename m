Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-4.orange.nl ([193.252.22.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1KwItd-0004ls-Pe
	for linux-dvb@linuxtv.org; Sat, 01 Nov 2008 17:00:18 +0100
Message-ID: <490C7CEB.6030704@verbraak.org>
Date: Sat, 01 Nov 2008 16:59:39 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: Goga777 <goga777@bk.ru>, linux-dvb@linuxtv.org
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>	<490C7194.8060603@verbraak.org>	<20081101182051.3ac22972@bk.ru>	<490C7958.8050902@verbraak.org>
	<20081101185045.1616b5c6@bk.ru>
In-Reply-To: <20081101185045.1616b5c6@bk.ru>
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1655903032=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1655903032==
Content-Type: multipart/alternative;
 boundary="------------010902050106010806000605"

This is a multi-part message in MIME format.
--------------010902050106010806000605
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: quoted-printable

Goga777 schreef:
>>> =F0=D2=C9=D7=C5=D4=D3=D4=D7=D5=C0, Michel
>>>
>>> but cx24116 based cards don't work with fec=3Dauto for dvb-s2=20
>>>
>>> I'm not sure - may be for cx24116 cards the parameters roll off & mod=
ulation are obligatory (not optional)
>>>
>>>
>>>
>>>  =20
>>>      =20
>>>> Tested your scan-s2 with a Technisat HD2 card.
>>>>
>>>> Scanning works. But some channels are reported twice with different=20
>>>> frequency. I found an error which is fixed by the patch file named=20
>>>> scan.c.diff1.
>>>>
>>>> I would also like to propose the following change (see file scan.c.d=
iff2=20
>>>> or scan.c.diff which includes both patches). This change makes it=20
>>>> possible to only scan for DVB-S channels or DVB-S2 channels or both.=
=20
>>>> This is done by specifying lines starting with S or S2 in the input =
file.
>>>>
>>>> example input file:
>>>> # Astra 19.2E SDT info service transponder
>>>> # freq pol sr fec
>>>> S 12522000 H 22000000 2/3       <only DVB-S channels are scanned>
>>>> S 11914000 H 27500000 AUTO
>>>> S 10743750 H 22000000 5/6
>>>> S 12187500 H 27500000 3/4
>>>> S 12343500 H 27500000 3/4
>>>> S 12515250 H 22000000 5/6
>>>> S 12574250 H 22000000 5/6
>>>> S2 12522000 H 22000000 AUTO    <only DVB-S2 channels are scanned>
>>>> S2 11914000 H 27500000 AUTO
>>>>
>>>> I hope this is usefull.
>>>>
>>>> Regards,
>>>>
>>>> Michel.
>>>>    =20
>>>>        =20
>>>  =20
>>>      =20
>> Goga,
>>
>> AUTO fec does work because the following is the result for the DVB-S2=20
>> channels I get with the above input:
>>
>> PREMIERE HD:11914:h:0:27500:767:772:129:6
>> DISCOVERY HD:11914:h:0:27500:1023:1027:130:6
>> ASTRA HD+:11914:h:0:27500:1279:1283:131:6
>> ANIXE HD:11914:h:0:27500:1535:1539:132:6
>>    =20
>
> you have stb0899 based card, but I have mean cx24116 based card.
>
> Goga
>
>  =20
Goga,

Sorry I mis understood you. I used AUTO fec because the DVB-S2 channel=20
on Astra 19.2 and frequency 11914 use FEC 9/10 according to the webpage=20
kingofsat (http://nl.kingofsat.net/pos-19.2E.php). Because current=20
scan-s2 does not handle this I changed it to AUTO.

fec table according to scan.c
struct strtab fectab[] =3D {
        { "NONE", FEC_NONE },
        { "1/2",  FEC_1_2 },
        { "2/3",  FEC_2_3 },
        { "3/4",  FEC_3_4 },
        { "4/5",  FEC_4_5 },
        { "5/6",  FEC_5_6 },
        { "6/7",  FEC_6_7 },
        { "7/8",  FEC_7_8 },
        { "8/9",  FEC_8_9 },
        { "AUTO", FEC_AUTO },
        { NULL, 0 }
};

New DVB API can handle FEC 9/10 (include/linux/dvb/frontend.h)
typedef enum fe_code_rate {
        FEC_NONE =3D 0,
        FEC_1_2,
        FEC_2_3,
        FEC_3_4,
        FEC_4_5,
        FEC_5_6,
        FEC_6_7,
        FEC_7_8,
        FEC_8_9,
        FEC_AUTO,
        FEC_3_5,
        FEC_9_10,
} fe_code_rate_t;

Will create a patch for this as soon as possible.

Regards

Michel.

--------------010902050106010806000605
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
<blockquote cite=3D"mid:20081101185045.1616b5c6@bk.ru" type=3D"cite">
  <blockquote type=3D"cite">
    <blockquote type=3D"cite">
      <pre wrap=3D"">=F0=D2=C9=D7=C5=D4=D3=D4=D7=D5=C0, Michel

but cx24116 based cards don't work with fec=3Dauto for dvb-s2=20

I'm not sure - may be for cx24116 cards the parameters roll off &amp; mod=
ulation are obligatory (not optional)



 =20
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
   =20
        </pre>
      </blockquote>
      <pre wrap=3D"">
 =20
      </pre>
    </blockquote>
    <pre wrap=3D"">Goga,

AUTO fec does work because the following is the result for the DVB-S2=20
channels I get with the above input:

PREMIERE HD:11914:h:0:27500:767:772:129:6
DISCOVERY HD:11914:h:0:27500:1023:1027:130:6
ASTRA HD+:11914:h:0:27500:1279:1283:131:6
ANIXE HD:11914:h:0:27500:1535:1539:132:6
    </pre>
  </blockquote>
  <pre wrap=3D""><!---->
you have stb0899 based card, but I have mean cx24116 based card.

Goga

  </pre>
</blockquote>
Goga,<br>
<br>
Sorry I mis understood you. I used AUTO fec because the DVB-S2 channel
on Astra 19.2 and frequency 11914 use FEC 9/10 according to the webpage
kingofsat (<a class=3D"moz-txt-link-freetext" href=3D"http://nl.kingofsat=
.net/pos-19.2E.php">http://nl.kingofsat.net/pos-19.2E.php</a>). Because c=
urrent
scan-s2 does not handle this I changed it to AUTO.<br>
<br>
fec table according to scan.c<br>
struct strtab fectab[] =3D {<br>
=9A=9A=9A=9A=9A=9A=9A { "NONE", FEC_NONE },<br>
=9A=9A=9A=9A=9A=9A=9A { "1/2",=9A FEC_1_2 },<br>
=9A=9A=9A=9A=9A=9A=9A { "2/3",=9A FEC_2_3 },<br>
=9A=9A=9A=9A=9A=9A=9A { "3/4",=9A FEC_3_4 },<br>
=9A=9A=9A=9A=9A=9A=9A { "4/5",=9A FEC_4_5 },<br>
=9A=9A=9A=9A=9A=9A=9A { "5/6",=9A FEC_5_6 },<br>
=9A=9A=9A=9A=9A=9A=9A { "6/7",=9A FEC_6_7 },<br>
=9A=9A=9A=9A=9A=9A=9A { "7/8",=9A FEC_7_8 },<br>
=9A=9A=9A=9A=9A=9A=9A { "8/9",=9A FEC_8_9 },<br>
=9A=9A=9A=9A=9A=9A=9A { "AUTO", FEC_AUTO },<br>
=9A=9A=9A=9A=9A=9A=9A { NULL, 0 }<br>
};<br>
<br>
New DVB API can handle FEC 9/10 (include/linux/dvb/frontend.h)<br>
typedef enum fe_code_rate {<br>
=9A=9A=9A=9A=9A=9A=9A FEC_NONE =3D 0,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_1_2,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_2_3,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_3_4,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_4_5,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_5_6,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_6_7,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_7_8,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_8_9,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_AUTO,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_3_5,<br>
=9A=9A=9A=9A=9A=9A=9A FEC_9_10,<br>
} fe_code_rate_t;<br>
<br>
Will create a patch for this as soon as possible.<br>
<br>
Regards<br>
<br>
Michel.<br>
</body>
</html>

--------------010902050106010806000605--



--===============1655903032==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1655903032==--
