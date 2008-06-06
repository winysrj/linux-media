Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bsmtp.bon.at ([213.33.87.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.schoeller@schoeller-soft.net>)
	id 1K4UEM-0003W9-O0
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 07:11:16 +0200
Received: from [10.1.2.1] (unknown [80.123.101.150])
	by bsmtp.bon.at (Postfix) with ESMTP id 957742C4010
	for <linux-dvb@linuxtv.org>; Fri,  6 Jun 2008 07:10:39 +0200 (CEST)
Message-ID: <4848C6D2.6040805@schoeller-soft.net>
Date: Fri, 06 Jun 2008 07:10:42 +0200
From: =?ISO-8859-15?Q?Michael_Sch=F6ller?=
	<michael.schoeller@schoeller-soft.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <484709F3.7020003@schoeller-soft.net>	<854d46170806041505w69a0bebakfa997223cade4381@mail.gmail.com>	<484794C8.5090506@okg-computer.de>
	<200806052227.52847.dkuhlen@gmx.net>
In-Reply-To: <200806052227.52847.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] How to get a PCTV Sat HDTC Pro USB (452e) running?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0842977609=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0842977609==
Content-Type: multipart/alternative;
 boundary="------------010605080905050500010201"

This is a multi-part message in MIME format.
--------------010605080905050500010201
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Well fine thanks,

I already have applied the patches and tried to compile multiproto...
Well it now gives me an compile error
--------------
In file included from /usr/src/multiproto/v4l/cx25840-core.c:42:
/usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h: In=20
function 'v4l2_i2c_drv_init':
/usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:197:=
=20
warning: assignment from incompatible pointer type
/usr/src/multiproto/v4l/cx25840-core.c: At top level:
/usr/src/multiproto/v4l/cx25840-core.c:71: error: conflicting type=20
qualifiers for 'addr_data'
/usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:41:=20
error: previous declaration of 'addr_data' was here
make[3]: *** [/usr/src/multiproto/v4l/cx25840-core.o] Error 1
make[2]: *** [_module_/usr/src/multiproto/v4l] Error 2
make[2]: Leaving directory `/usr/src/ps3-linux'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/usr/src/multiproto/v4l'
make: *** [all] Fehler 2
--------------
That does not look like an simple changed function/code error.

Michael


Dominik Kuhlen schrieb:
> Hi,
> On Thursday 05 June 2008, Jens Krehbiel-Gr=E4ther wrote:
>  =20
>> Hi Michael!
>>
>> Because of the several patches needed to add support for the=20
>> pctv_452e/tt_s2_3600/tt_s2_3650_ci I made a new diff on todays hg tree=
=20
>> with all the patches applied (I think all the patches were posted by=20
>> Dominik Kuhlen??).
>> I will try to update the wiki in the next days.
>>
>> Couldn't these patches be inserted into hg-tree (Manu??). The device=20
>> works with them (i am using it a few months now).
>>
>> I applied ONE patch wich includes all the patches listed here:
>> patch_multiproto_pctv452e_tts23600.diff
>> patch_multiproto_dvbs2_frequency.diff
>> patch_fix_tts2_keymap.diff
>> patch_add_tt_s2_3650_ci.diff
>> patch_add_tt_s2_3600_rc_keymap.diff
>>
>>    =20
> -----snip----
> I had just a brief look at the patch and it seems that pctv452e.c and l=
nb22.* are missing
> afaik hg diff  does not include added files if not specified explicitly=
.
>
>
> Dominik
> =20
>
>
>  =20
> -----------------------------------------------------------------------=
-
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


--------------010605080905050500010201
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content=3D"text/html;charset=3DISO-8859-15"
 http-equiv=3D"Content-Type">
  <title></title>
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
Well fine thanks,<br>
<br>
I already have applied the patches and tried to compile multiproto...<br>
Well it now gives me an compile error<br>
--------------<br>
In file included from /usr/src/multiproto/v4l/cx25840-core.c:42:<br>
/usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:
In function 'v4l2_i2c_drv_init':<br>
/usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:197:
warning: assignment from incompatible pointer type<br>
/usr/src/multiproto/v4l/cx25840-core.c: At top level:<br>
/usr/src/multiproto/v4l/cx25840-core.c:71: error: conflicting type
qualifiers for 'addr_data'<br>
/usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:41:
error: previous declaration of 'addr_data' was here<br>
make[3]: *** [/usr/src/multiproto/v4l/cx25840-core.o] Error 1<br>
make[2]: *** [_module_/usr/src/multiproto/v4l] Error 2<br>
make[2]: Leaving directory `/usr/src/ps3-linux'<br>
make[1]: *** [default] Fehler 2<br>
make[1]: Leaving directory `/usr/src/multiproto/v4l'<br>
make: *** [all] Fehler 2<br>
--------------<br>
That does not look like an simple changed function/code error.<br>
<br>
Michael<br>
<br>
<br>
Dominik Kuhlen schrieb:
<blockquote cite=3D"mid:200806052227.52847.dkuhlen@gmx.net" type=3D"cite"=
>
  <pre wrap=3D"">Hi,
On Thursday 05 June 2008, Jens Krehbiel-Gr=E4ther wrote:
  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">Hi Michael!

Because of the several patches needed to add support for the=20
pctv_452e/tt_s2_3600/tt_s2_3650_ci I made a new diff on todays hg tree=20
with all the patches applied (I think all the patches were posted by=20
Dominik Kuhlen??).
I will try to update the wiki in the next days.

Couldn't these patches be inserted into hg-tree (Manu??). The device=20
works with them (i am using it a few months now).

I applied ONE patch wich includes all the patches listed here:
patch_multiproto_pctv452e_tts23600.diff
patch_multiproto_dvbs2_frequency.diff
patch_fix_tts2_keymap.diff
patch_add_tt_s2_3650_ci.diff
patch_add_tt_s2_3600_rc_keymap.diff

    </pre>
  </blockquote>
  <pre wrap=3D""><!---->-----snip----
I had just a brief look at the patch and it seems that pctv452e.c and lnb=
22.* are missing
afaik hg diff  does not include added files if not specified explicitly.


Dominik
=20


  </pre>
  <pre wrap=3D"">
<hr size=3D"4" width=3D"90%">
_______________________________________________
linux-dvb mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:linux-dvb@linuxtv.or=
g">linux-dvb@linuxtv.org</a>
<a class=3D"moz-txt-link-freetext" href=3D"http://www.linuxtv.org/cgi-bin=
/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listi=
nfo/linux-dvb</a></pre>
</blockquote>
<br>
</body>
</html>

--------------010605080905050500010201--


--===============0842977609==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0842977609==--
