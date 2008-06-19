Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bsmtp.bon.at ([213.33.87.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.schoeller@schoeller-soft.net>)
	id 1K9QIF-0003w9-QK
	for linux-dvb@linuxtv.org; Thu, 19 Jun 2008 21:59:41 +0200
Message-ID: <485ABA8A.4030702@schoeller-soft.net>
Date: Thu, 19 Jun 2008 21:59:06 +0200
From: =?ISO-8859-15?Q?Michael_Sch=F6ller?=
	<michael.schoeller@schoeller-soft.net>
MIME-Version: 1.0
To: Dominik Kuhlen <dkuhlen@gmx.net>
References: <200806071627.30907.dkuhlen@gmx.net>	<484C056E.7010002@schoeller-soft.net>
	<200806092248.01786.dkuhlen@gmx.net>
In-Reply-To: <200806092248.01786.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] pctv452e and TT-S2-3600 step-by-step howto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2094312601=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============2094312601==
Content-Type: multipart/alternative;
 boundary="------------060300080206040801080807"

This is a multi-part message in MIME format.
--------------060300080206040801080807
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Maybe this is an hint that will enable you to find the problem. I just=20
looked at the dmesg messages right after I tried ./simpledvbtune -f=20
11954 and well this are the messages:

pctv452e_power_ctrl: 1
ioctl32(simpledvbtune:5591): Unknown cmd fd(3) cmd(80046f57){t:'o';sz:4}=20
arg(ff8c43e8) on /dev/dvb/adapter0/frontend0
lnbp22_set_voltage: 1 (18V=3D1 13V=3D0)
lnbp22_set_voltage: 0x72)
ioctl32(simpledvbtune:5591): Unknown cmd fd(3)=20
cmd(80ac6f53){t:'o';sz:172} arg(ff8c433c) on /dev/dvb/adapter0/frontend0
lnbp22_set_voltage: 2 (18V=3D1 13V=3D0)
lnbp22_set_voltage: 0x60)
pctv452e_power_ctrl: 0

Maybe that helps..
Oh I almost forgot. The leds on the Receiver. After loading the kernel=20
modules they go from orange to green. After trying simpledvbtune they go=20
from green to orange and never back.

Michael

Dominik Kuhlen schrieb:
> On Sunday 08 June 2008, Michael Sch=F6ller wrote:
>  =20
>> Dominik Kuhlen schrieb:
>>    =20
>>> Hi,
>>>
>>> I have attached a step-by-step howto for these devices
>>>
>>>
>>> Happy testing,
>>>  Dominik
>>>
>>>  =20
>>> ---------------------------------------------------------------------=
---
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>      =20
>> Well bad news...it's not working.
>> I try to notice any difference in my system to your description and we=
ll=20
>> it's not much...
>> My dmesg line:
>>
>> stb0899_get_dev_id: Device ID=3D[3], Release=3D[1]
>>
>> Your dmesg line:
>>
>> stb0899_get_dev_id: Device ID=3D[3], Release=3D[0]
>>
>> all other dmesg messages are identical.
>>
>>  next difference
>>
>> ls -l /dev/dvb/adapter0/
>> # total 0
>> # crw------- 1 schomi root 212, 4 Jun  7 15:37 demux0
>> # crw------- 1 schomi root 212, 5 Jun  7 15:37 dvr0
>> # crw------- 1 schomi root 212, 3 Jun  7 15:37 frontend0
>> # crw------- 1 schomi root 212, 7 Jun  7 15:37 net0
>>
>> well just do be sure I also tried chmod a+rw * but that didn't change =
anything. Well since schomi is my user I think that should be ok...
>>
>> So now to the real problem...
>> ./simpledvbtune -f 11954
>> using '/dev/dvb/adapter0/frontend0' as frontend
>> frontend fd=3D3: type=3D0
>> DVBFE_SET_DELSYS: Invalid argument
>> ioclt: FE_SET_VOLTAGE : 1
>> High band
>> tone: 1
>> dvbfe setparams :  delsys=3D1 1354MHz / Rate : 27500kBPS
>> DVBFE_SET_PARAMS: Invalid argument
>> tuning qpsk failed
>>    =20
> Hmm, this is strange. looks like you are using old drivers or old dvb-c=
ore module that doesn't support the new ioctls
> Did you load the modules with
> insmod ./dvb-core.ko
> insmod ./dvb-usb.ko
> insmod ./lnbp22.ko
> insmod ./stb0899.ko
> insmod ./stb6100.ko
> insmod ./dvb-usb-pctv452e.ko
> to be sure that no old/other modules were used?
>
>  =20
>> @Dominik
>> By any chance do you live in austria and can visit me ^^.
>>    =20
> No, sorry I don't.
>  =20
>> Michael
>>
>>
>>
>>    =20
>
> Dominik
>
>  =20
> -----------------------------------------------------------------------=
-
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


--------------060300080206040801080807
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
Maybe this is an hint that will enable you to find the problem. I just
looked at the dmesg messages right after I tried ./simpledvbtune -f
11954 and well this are the messages:<br>
<br>
pctv452e_power_ctrl: 1<br>
ioctl32(simpledvbtune:5591): Unknown cmd fd(3)
cmd(80046f57){t:'o';sz:4} arg(ff8c43e8) on /dev/dvb/adapter0/frontend0<br=
>
lnbp22_set_voltage: 1 (18V=3D1 13V=3D0)<br>
lnbp22_set_voltage: 0x72)<br>
ioctl32(simpledvbtune:5591): Unknown cmd fd(3)
cmd(80ac6f53){t:'o';sz:172} arg(ff8c433c) on /dev/dvb/adapter0/frontend0<=
br>
lnbp22_set_voltage: 2 (18V=3D1 13V=3D0)<br>
lnbp22_set_voltage: 0x60)<br>
pctv452e_power_ctrl: 0<br>
<br>
Maybe that helps..<br>
Oh I almost forgot. The leds on the Receiver. After loading the kernel
modules they go from orange to green. After trying simpledvbtune they
go from green to orange and never back.<br>
<br>
Michael<br>
<br>
Dominik Kuhlen schrieb:
<blockquote cite=3D"mid:200806092248.01786.dkuhlen@gmx.net" type=3D"cite"=
>
  <pre wrap=3D"">On Sunday 08 June 2008, Michael Sch=F6ller wrote:
  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">Dominik Kuhlen schrieb:
    </pre>
    <blockquote type=3D"cite">
      <pre wrap=3D"">Hi,

I have attached a step-by-step howto for these devices


Happy testing,
 Dominik

 =20
------------------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:linux-dvb@linuxtv.or=
g">linux-dvb@linuxtv.org</a>
<a class=3D"moz-txt-link-freetext" href=3D"http://www.linuxtv.org/cgi-bin=
/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listi=
nfo/linux-dvb</a>
      </pre>
    </blockquote>
    <pre wrap=3D"">Well bad news...it's not working.
I try to notice any difference in my system to your description and well=20
it's not much...
My dmesg line:

stb0899_get_dev_id: Device ID=3D[3], Release=3D[1]

Your dmesg line:

stb0899_get_dev_id: Device ID=3D[3], Release=3D[0]

all other dmesg messages are identical.

 next difference

ls -l /dev/dvb/adapter0/
# total 0
# crw------- 1 schomi root 212, 4 Jun  7 15:37 demux0
# crw------- 1 schomi root 212, 5 Jun  7 15:37 dvr0
# crw------- 1 schomi root 212, 3 Jun  7 15:37 frontend0
# crw------- 1 schomi root 212, 7 Jun  7 15:37 net0

well just do be sure I also tried chmod a+rw * but that didn't change any=
thing. Well since schomi is my user I think that should be ok...

So now to the real problem...
./simpledvbtune -f 11954
using '/dev/dvb/adapter0/frontend0' as frontend
frontend fd=3D3: type=3D0
DVBFE_SET_DELSYS: Invalid argument
ioclt: FE_SET_VOLTAGE : 1
High band
tone: 1
dvbfe setparams :  delsys=3D1 1354MHz / Rate : 27500kBPS
DVBFE_SET_PARAMS: Invalid argument
tuning qpsk failed
    </pre>
  </blockquote>
  <pre wrap=3D""><!---->Hmm, this is strange. looks like you are using ol=
d drivers or old dvb-core module that doesn't support the new ioctls
Did you load the modules with
insmod ./dvb-core.ko
insmod ./dvb-usb.ko
insmod ./lnbp22.ko
insmod ./stb0899.ko
insmod ./stb6100.ko
insmod ./dvb-usb-pctv452e.ko
to be sure that no old/other modules were used?

  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">@Dominik
By any chance do you live in austria and can visit me ^^.
    </pre>
  </blockquote>
  <pre wrap=3D""><!---->No, sorry I don't.
  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">Michael



    </pre>
  </blockquote>
  <pre wrap=3D""><!---->
Dominik

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

--------------060300080206040801080807--


--===============2094312601==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2094312601==--
