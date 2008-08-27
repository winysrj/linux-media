Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1KYH4W-0004SN-5S
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 11:12:12 +0200
Received: by yx-out-2324.google.com with SMTP id 8so1187139yxg.41
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 02:12:08 -0700 (PDT)
Message-ID: <617be8890808270212m192b2951x4d5e8313cd788557@mail.gmail.com>
Date: Wed, 27 Aug 2008 11:12:08 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0808271021040.18085@pub6.ifh.de>
MIME-Version: 1.0
References: <617be8890808270010j640f4cb7je46e74c7234b978b@mail.gmail.com>
	<alpine.LRH.1.10.0808271021040.18085@pub6.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 new i2c implementation
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0520797181=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0520797181==
Content-Type: multipart/alternative;
	boundary="----=_Part_17606_2079751.1219828328178"

------=_Part_17606_2079751.1219828328178
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Well, regarding the Nova-T 500 I must say that, using the current HG driver
code and 1.10 firmware, it's pretty rock solid. I've had no USB disconnects
nor hangs of any time since a long time ago (since lastest patches for this
card were merged).

That's the reason I'm very reluctant to use the new firmware, specially if
the effect seems to be a constantly rebooting machine, as Nicolas Will
described ;-). However, if the above patche solves the problems then I'll b=
e
very pleased to test it.

Regards,
  Eduard





2008/8/27 Patrick Boettcher <patrick.boettcher@desy.de>

> Hi Eduard,
>
> We had some problems with previous I2C implementation and the 1.20 is
> really fixing them - they were hard to find. But the problem we had were =
not
> on the Nova-T 500... Still I think it could be related.
>
> So depending on any previous behaviour of the device it can only be bette=
r
> or worse, both results are interesting in order to know whether this
> firmware can be become the main one or not.
>
> best regards,
> Patrick.
>
>
> On Wed, 27 Aug 2008, Eduard Huguet wrote:
>
>       ---------- Missatge reenviat ----------
>>      From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
>>      To: linux-dvb <linux-dvb@linuxtv.org>
>>      Date: Tue, 26 Aug 2008 21:15:20 -0400
>>      Subject: [linux-dvb] dib0700 new i2c implementation
>>      The attached patch implements the new dib0700 i2c API, which requir=
es
>>      v1.20 of the firmware.  It addresses some classes of i2c problems (=
in
>>      particular the one I had where i2c reads were being sent onto the b=
us
>>      as i2c write calls)
>>
>>      I would appreciate it if those with dib0700 based devices would try
>>      out the patch and provide feedback as to whether they have any
>>      problems.  I've done testing with the Pinnacle PCTV HD Pro USB 801e
>>      stick, but I don't have any other dib0700 based devices.
>>
>>      Thanks to Patrick Boettcher for providing the firmware, sample code=
,
>>      and peer review of the first version of this patch.
>>
>>      Regards,
>>
>>      Devin
>>
>>      --
>>      Devin J. Heitmueller
>>      http://www.devinheitmueller.com
>>      AIM: devinheitmueller
>>
>>
>>
>> Hi,
>>     Thanks for your work, first of all. =BFDo you think this patch might
>> solve the problems that seem to be appeared since the new firmware is ou=
t
>> with the Hauppauge Nova-T 500, like random reboots, etc... (what's ths
>> state on this, anyway?) ?
>>
>> I delayed the adoption of the new 1.20 firmware because of those problem=
s,
>> because I didn't want to leave the machine in a complete unusable
>> state...
>>
>> Best regards,
>>   Eduard Huguet
>>
>>
>>
>>
>>

------=_Part_17606_2079751.1219828328178
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">Well, regarding the Nova-T 500 I must say that, using the =
current HG driver code and 1.10  firmware, it&#39;s pretty rock solid. I&#3=
9;ve had no USB disconnects nor hangs of any time since a long time ago (si=
nce lastest patches for this card were merged).<br>
<br>That&#39;s the reason I&#39;m very reluctant to use the new firmware, s=
pecially if the effect seems to be a constantly rebooting machine, as Nicol=
as Will described ;-). However, if the above patche solves the problems the=
n I&#39;ll be very pleased to test it.<br>
<br>Regards, <br>&nbsp; Eduard<br><br><br><br><br><br><div class=3D"gmail_q=
uote">2008/8/27 Patrick Boettcher <span dir=3D"ltr">&lt;<a href=3D"mailto:p=
atrick.boettcher@desy.de">patrick.boettcher@desy.de</a>&gt;</span><br><bloc=
kquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, =
204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi Eduard,<br>
<br>
We had some problems with previous I2C implementation and the 1.20 is reall=
y fixing them - they were hard to find. But the problem we had were not on =
the Nova-T 500... Still I think it could be related.<br>
<br>
So depending on any previous behaviour of the device it can only be better =
or worse, both results are interesting in order to know whether this firmwa=
re can be become the main one or not.<br>
<br>
best regards,<br><font color=3D"#888888">
Patrick.</font><div><div></div><div class=3D"Wj3C7c"><br>
<br>
On Wed, 27 Aug 2008, Eduard Huguet wrote:<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
 &nbsp; &nbsp; &nbsp;---------- Missatge reenviat ----------<br>
 &nbsp; &nbsp; &nbsp;From:&nbsp;&quot;Devin Heitmueller&quot; &lt;<a href=
=3D"mailto:devin.heitmueller@gmail.com" target=3D"_blank">devin.heitmueller=
@gmail.com</a>&gt;<br>
 &nbsp; &nbsp; &nbsp;To:&nbsp;linux-dvb &lt;<a href=3D"mailto:linux-dvb@lin=
uxtv.org" target=3D"_blank">linux-dvb@linuxtv.org</a>&gt;<br>
 &nbsp; &nbsp; &nbsp;Date:&nbsp;Tue, 26 Aug 2008 21:15:20 -0400<br>
 &nbsp; &nbsp; &nbsp;Subject:&nbsp;[linux-dvb] dib0700 new i2c implementati=
on<br>
 &nbsp; &nbsp; &nbsp;The attached patch implements the new dib0700 i2c API,=
 which requires<br>
 &nbsp; &nbsp; &nbsp;v1.20 of the firmware. &nbsp;It addresses some classes=
 of i2c problems (in<br>
 &nbsp; &nbsp; &nbsp;particular the one I had where i2c reads were being se=
nt onto the bus<br>
 &nbsp; &nbsp; &nbsp;as i2c write calls)<br>
<br>
 &nbsp; &nbsp; &nbsp;I would appreciate it if those with dib0700 based devi=
ces would try<br>
 &nbsp; &nbsp; &nbsp;out the patch and provide feedback as to whether they =
have any<br>
 &nbsp; &nbsp; &nbsp;problems. &nbsp;I&#39;ve done testing with the Pinnacl=
e PCTV HD Pro USB 801e<br>
 &nbsp; &nbsp; &nbsp;stick, but I don&#39;t have any other dib0700 based de=
vices.<br>
<br>
 &nbsp; &nbsp; &nbsp;Thanks to Patrick Boettcher for providing the firmware=
, sample code,<br>
 &nbsp; &nbsp; &nbsp;and peer review of the first version of this patch.<br=
>
<br>
 &nbsp; &nbsp; &nbsp;Regards,<br>
<br>
 &nbsp; &nbsp; &nbsp;Devin<br>
<br>
 &nbsp; &nbsp; &nbsp;--<br>
 &nbsp; &nbsp; &nbsp;Devin J. Heitmueller<br>
 &nbsp; &nbsp; &nbsp;<a href=3D"http://www.devinheitmueller.com" target=3D"=
_blank">http://www.devinheitmueller.com</a><br>
 &nbsp; &nbsp; &nbsp;AIM: devinheitmueller<br>
<br>
<br>
<br>
Hi,<br>
&nbsp;&nbsp;&nbsp; Thanks for your work, first of all. =BFDo you think this=
 patch might&nbsp; solve the problems that seem to be appeared since the ne=
w firmware is out<br>
with the Hauppauge Nova-T 500, like random reboots, etc... (what&#39;s ths =
state on this, anyway?) ?<br>
<br>
I delayed the adoption of the new 1.20 firmware because of those problems, =
because I didn&#39;t want to leave the machine in a complete unusable<br>
state...<br>
<br>
Best regards,<br>
&nbsp; Eduard Huguet<br>
<br>
&nbsp;<br>
<br>
<br>
</blockquote>
</div></div></blockquote></div><br></div>

------=_Part_17606_2079751.1219828328178--


--===============0520797181==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0520797181==--
