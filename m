Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bsmtp.bon.at ([213.33.87.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.schoeller@schoeller-soft.net>)
	id 1K5NY1-0008TI-4q
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 18:15:14 +0200
Message-ID: <484C056E.7010002@schoeller-soft.net>
Date: Sun, 08 Jun 2008 18:14:38 +0200
From: =?ISO-8859-15?Q?Michael_Sch=F6ller?=
	<michael.schoeller@schoeller-soft.net>
MIME-Version: 1.0
To: Dominik Kuhlen <dkuhlen@gmx.net>
References: <200806071627.30907.dkuhlen@gmx.net>
In-Reply-To: <200806071627.30907.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] pctv452e and TT-S2-3600 step-by-step howto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0109626366=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0109626366==
Content-Type: multipart/alternative;
 boundary="------------030000010706040907050902"

This is a multi-part message in MIME format.
--------------030000010706040907050902
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Dominik Kuhlen schrieb:
> Hi,
>
> I have attached a step-by-step howto for these devices
>
>
> Happy testing,
>  Dominik
>
>   
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
Well bad news...it's not working.
I try to notice any difference in my system to your description and well 
it's not much...
My dmesg line:

stb0899_get_dev_id: Device ID=[3], Release=[1]

Your dmesg line:

stb0899_get_dev_id: Device ID=[3], Release=[0]

all other dmesg messages are identical.

 next difference

ls -l /dev/dvb/adapter0/
# total 0
# crw------- 1 schomi root 212, 4 Jun  7 15:37 demux0
# crw------- 1 schomi root 212, 5 Jun  7 15:37 dvr0
# crw------- 1 schomi root 212, 3 Jun  7 15:37 frontend0
# crw------- 1 schomi root 212, 7 Jun  7 15:37 net0

well just do be sure I also tried chmod a+rw * but that didn't change anything. Well since schomi is my user I think that should be ok...

So now to the real problem...
./simpledvbtune -f 11954
using '/dev/dvb/adapter0/frontend0' as frontend
frontend fd=3: type=0
DVBFE_SET_DELSYS: Invalid argument
ioclt: FE_SET_VOLTAGE : 1
High band
tone: 1
dvbfe setparams :  delsys=1 1354MHz / Rate : 27500kBPS
DVBFE_SET_PARAMS: Invalid argument
tuning qpsk failed

@Dominik
By any chance do you live in austria and can visit me ^^.

Michael



--------------030000010706040907050902
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
Dominik Kuhlen schrieb:
<blockquote cite=3D"mid:200806071627.30907.dkuhlen@gmx.net" type=3D"cite"=
>
  <pre wrap=3D"">Hi,

I have attached a step-by-step howto for these devices


Happy testing,
 Dominik

  </pre>
  <pre wrap=3D""><pre wrap=3D""><pre wrap=3D"">
<hr size=3D"4" width=3D"90%">
_______________________________________________
linux-dvb mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:linux-dvb@linuxtv.or=
g">linux-dvb@linuxtv.org</a>
<a class=3D"moz-txt-link-freetext" href=3D"http://www.linuxtv.org/cgi-bin=
/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listi=
nfo/linux-dvb</a></pre></pre></pre>
</blockquote>
Well bad news...it's not working.<br>
I try to notice any difference in my system to your description and
well it's not much...<br>
My dmesg line:<br>
<pre wrap=3D"">stb0899_get_dev_id: Device ID=3D[3], Release=3D[1]</pre>
Your dmesg line: <br>
<pre wrap=3D"">stb0899_get_dev_id: Device ID=3D[3], Release=3D[0]</pre>
all other dmesg messages are identical.<br>
<br>
=A0next difference<br>
<pre wrap=3D"">ls -l /dev/dvb/adapter0/
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

@Dominik
By any chance do you live in austria and can visit me ^^.

Michael

</pre>
</body>
</html>

--------------030000010706040907050902--


--===============0109626366==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0109626366==--
