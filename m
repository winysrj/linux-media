Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bsmtp.bon.at ([213.33.87.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.schoeller@schoeller-soft.net>)
	id 1K4fiN-0003vm-DH
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 19:27:00 +0200
Received: from [10.1.2.1] (unknown [80.123.101.150])
	by bsmtp.bon.at (Postfix) with ESMTP id 5C35D2C4014
	for <linux-dvb@linuxtv.org>; Fri,  6 Jun 2008 19:26:24 +0200 (CEST)
Message-ID: <48497340.3050602@schoeller-soft.net>
Date: Fri, 06 Jun 2008 19:26:24 +0200
From: =?ISO-8859-1?Q?Michael_Sch=F6ller?=
	<michael.schoeller@schoeller-soft.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <484709F3.7020003@schoeller-soft.net>	
	<854d46170806041505w69a0bebakfa997223cade4381@mail.gmail.com>	
	<484794C8.5090506@okg-computer.de>	
	<200806052227.52847.dkuhlen@gmx.net>	
	<4848C6D2.6040805@schoeller-soft.net>
	<854d46170806060249h1aec73e4s645462a123371c29@mail.gmail.com>
In-Reply-To: <854d46170806060249h1aec73e4s645462a123371c29@mail.gmail.com>
Subject: Re: [linux-dvb] How to get a PCTV Sat HDTC Pro USB (452e) running?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0315929774=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0315929774==
Content-Type: multipart/alternative;
 boundary="------------010707060303060200060002"

This is a multi-part message in MIME format.
--------------010707060303060200060002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Well that worked! I was able to compile the drivers. :)

And the bad news. I wasn't able to compile dvb-apps. Or to be more=20
specific I followed the instructions for patching dvb-apps to work with=20
multiproto. (

http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025222.html)

As I understand the instructions I copied the source code of scan to the =
dvb-apps/util/scan directory and applied the patch on it. After a little =
extra change for the includes (changed them to point to the ones of multi=
proto). I was able to compile the hole stuff without errors. However scan=
 always gives me an DVBFE_SET_PARAMS ioctl fail with "Invalid argument".
After some time I give up on and tried to patch szap. Well szap seems to =
be a wrong version since even used structures in the source code has diff=
erent names than the ones in the patch file. I got dvb-apps with hg from =
linuxtv.org.

I'm really down now my hope to get this damn thing running before the fir=
st EM match is now not present. Good by HDTV quality games hello PAL...

*schniff*




Faruk A schrieb:
> Hi Michael!
>
> I was having the same problem too, this is what i did.
> All i need is pctv 452e drivers and don't care for the rest.
> you can do this in couples of ways.. first you can run "make menuconfig=
"
> and unselect whatever drivers thats troubling you.
> I did that but after cx25840-core there is another one after that anoth=
er
> drivers.... then i did  the ugly way works 100%
>
> cd to multiproto/linux/drivers/media/video
> and rename the Makefile to like Makefile_
> after this i won't compile any analog drivers and it will compile dvb
> and radio drivers.
> if you don't what radio too do the same thing to radio dir.
>
> Faruk
>
>
> 2008/6/6 Michael Sch=F6ller <michael.schoeller@schoeller-soft.net>:
>  =20
>> Well fine thanks,
>>
>> I already have applied the patches and tried to compile multiproto...
>> Well it now gives me an compile error
>> --------------
>> In file included from /usr/src/multiproto/v4l/cx25840-core.c:42:
>> /usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h: =
In
>> function 'v4l2_i2c_drv_init':
>> /usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:1=
97:
>> warning: assignment from incompatible pointer type
>> /usr/src/multiproto/v4l/cx25840-core.c: At top level:
>> /usr/src/multiproto/v4l/cx25840-core.c:71: error: conflicting type
>> qualifiers for 'addr_data'
>> /usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:4=
1:
>> error: previous declaration of 'addr_data' was here
>> make[3]: *** [/usr/src/multiproto/v4l/cx25840-core.o] Error 1
>> make[2]: *** [_module_/usr/src/multiproto/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/ps3-linux'
>> make[1]: *** [default] Fehler 2
>> make[1]: Leaving directory `/usr/src/multiproto/v4l'
>> make: *** [all] Fehler 2
>> --------------
>> That does not look like an simple changed function/code error.
>>
>> Michael
>>
>>
>> Dominik Kuhlen schrieb:
>>
>> Hi,
>> On Thursday 05 June 2008, Jens Krehbiel-Gr=E4ther wrote:
>>
>>
>> Hi Michael!
>>
>> Because of the several patches needed to add support for the
>> pctv_452e/tt_s2_3600/tt_s2_3650_ci I made a new diff on todays hg tree
>> with all the patches applied (I think all the patches were posted by
>> Dominik Kuhlen??).
>> I will try to update the wiki in the next days.
>>
>> Couldn't these patches be inserted into hg-tree (Manu??). The device
>> works with them (i am using it a few months now).
>>
>> I applied ONE patch wich includes all the patches listed here:
>> patch_multiproto_pctv452e_tts23600.diff
>> patch_multiproto_dvbs2_frequency.diff
>> patch_fix_tts2_keymap.diff
>> patch_add_tt_s2_3650_ci.diff
>> patch_add_tt_s2_3600_rc_keymap.diff
>>
>>
>>
>> -----snip----
>> I had just a brief look at the patch and it seems that pctv452e.c and
>> lnb22.* are missing
>> afaik hg diff  does not include added files if not specified explicitl=
y.
>>
>>
>> Dominik
>>
>>
>>
>>
>>
>> ________________________________
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>    =20
>
>  =20


--------------010707060303060200060002
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Well that worked! I was able to compile the drivers. :)<br>
<br>
And the bad news. I wasn't able to compile dvb-apps. Or to be more
specific I followed the instructions for patching dvb-apps to work with
multiproto. (<br>
<pre wrap=""><a class="moz-txt-link-freetext"
 href="http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025222.html">http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025222.html</a>)

As I understand the instructions I copied the source code of scan to the dvb-apps/util/scan directory and applied the patch on it. After a little extra change for the includes (changed them to point to the ones of multiproto). I was able to compile the hole stuff without errors. However scan always gives me an DVBFE_SET_PARAMS ioctl fail with "Invalid argument".
After some time I give up on and tried to patch szap. Well szap seems to be a wrong version since even used structures in the source code has different names than the ones in the patch file. I got dvb-apps with hg from linuxtv.org.

I'm really down now my hope to get this damn thing running before the first EM match is now not present. Good by HDTV quality games hello PAL...

*schniff*
</pre>
<br>
<br>
<br>
Faruk A schrieb:
<blockquote
 cite="mid:854d46170806060249h1aec73e4s645462a123371c29@mail.gmail.com"
 type="cite">
  <pre wrap="">Hi Michael!

I was having the same problem too, this is what i did.
All i need is pctv 452e drivers and don't care for the rest.
you can do this in couples of ways.. first you can run "make menuconfig"
and unselect whatever drivers thats troubling you.
I did that but after cx25840-core there is another one after that another
drivers.... then i did  the ugly way works 100%

cd to multiproto/linux/drivers/media/video
and rename the Makefile to like Makefile_
after this i won't compile any analog drivers and it will compile dvb
and radio drivers.
if you don't what radio too do the same thing to radio dir.

Faruk


2008/6/6 Michael Sch&ouml;ller <a class="moz-txt-link-rfc2396E" href="mailto:michael.schoeller@schoeller-soft.net">&lt;michael.schoeller@schoeller-soft.net&gt;</a>:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Well fine thanks,

I already have applied the patches and tried to compile multiproto...
Well it now gives me an compile error
--------------
In file included from /usr/src/multiproto/v4l/cx25840-core.c:42:
/usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h: In
function 'v4l2_i2c_drv_init':
/usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:197:
warning: assignment from incompatible pointer type
/usr/src/multiproto/v4l/cx25840-core.c: At top level:
/usr/src/multiproto/v4l/cx25840-core.c:71: error: conflicting type
qualifiers for 'addr_data'
/usr/src/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:41:
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

Hi,
On Thursday 05 June 2008, Jens Krehbiel-Gr&auml;ther wrote:


Hi Michael!

Because of the several patches needed to add support for the
pctv_452e/tt_s2_3600/tt_s2_3650_ci I made a new diff on todays hg tree
with all the patches applied (I think all the patches were posted by
Dominik Kuhlen??).
I will try to update the wiki in the next days.

Couldn't these patches be inserted into hg-tree (Manu??). The device
works with them (i am using it a few months now).

I applied ONE patch wich includes all the patches listed here:
patch_multiproto_pctv452e_tts23600.diff
patch_multiproto_dvbs2_frequency.diff
patch_fix_tts2_keymap.diff
patch_add_tt_s2_3650_ci.diff
patch_add_tt_s2_3600_rc_keymap.diff



-----snip----
I had just a brief look at the patch and it seems that pctv452e.c and
lnb22.* are missing
afaik hg diff  does not include added files if not specified explicitly.


Dominik





________________________________
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>

    </pre>
  </blockquote>
  <pre wrap=""><!---->
  </pre>
</blockquote>
<br>
</body>
</html>

--------------010707060303060200060002--


--===============0315929774==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0315929774==--
