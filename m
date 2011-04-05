Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ltrifonov@gmail.com>) id 1Q73AM-0007H1-CA
	for linux-dvb@linuxtv.org; Tue, 05 Apr 2011 12:07:19 +0200
Received: from mail-iy0-f182.google.com ([209.85.210.182])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1Q73AL-0001z2-G5; Tue, 05 Apr 2011 12:07:18 +0200
Received: by iyj12 with SMTP id 12so253714iyj.41
	for <linux-dvb@linuxtv.org>; Tue, 05 Apr 2011 03:07:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=NyyfvEgho9VhBnP6Vs_gv7TqG3w@mail.gmail.com>
References: <BANLkTi=NyyfvEgho9VhBnP6Vs_gv7TqG3w@mail.gmail.com>
Date: Tue, 5 Apr 2011 13:07:15 +0300
Message-ID: <BANLkTi=6CW8pmyBqedTGkwWcE8zpoQReEg@mail.gmail.com>
From: Lubomir Trifonov <ltrifonov@gmail.com>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend Connect S-1200 STC problem
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1319199998=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============1319199998==
Content-Type: multipart/alternative; boundary=002215048b976e9e9e04a0290a35

--002215048b976e9e9e04a0290a35
Content-Type: text/plain; charset=ISO-8859-1

I guess it is too late for this answer, but I had the same problem and I
managed to get this device working. Although late, it may be useful to
others.
Answer can be found here:
http://www.linuxtv.org/pipermail/linux-dvb/2005-March/000386.html

this is valid only for devices with:

APLS-BSBE1-502A (label on tuner)




Gregor Kroesen reported non-working ttusb-budget, which has an Alps
BSBE1-502A.

The ID is 1003, so it's the same as the BSRU6-Box, but the BSBE1
requires different parameters in both the stv0299 inittab and the pll

(someone once posted the description into this ML, topic was "
ALPS-BSRV2-301A tuner problem, would like to use APLS-BSBE1-701A", and
this modification work)

a patch like:
dvb-ttusb-budget.c:1295:

>>* -  buf[3] = 0xC4;
*>>* -
*>>* -  if (params->frequency > 1530000)
*>>* -    buf[3] = 0xc0;
*>>* +  buf[3] = 0xE4;
*>>* +
*>>* +  if (params->frequency > 1530000)
*>>* +    buf[3] = 0xE0;
*>>* dvb-ttusb-budget.c:1243:
*>>* -  0x0f, 0x52,
*>>* +  0x0f, 0xD2,
*fixes it, however hardcodes it to bsbe1.

--002215048b976e9e9e04a0290a35
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><div class=3D"gmail_quote"><span lang=3D"en"><span title=3D"Click for a=
lternate translations">I guess</span> <span title=3D"Click for alternate tr=
anslations">it is too</span> <span title=3D"Click for alternate translation=
s">late</span> <span title=3D"Click for alternate translations">for</span> =
<span title=3D"Click for alternate translations">this</span> <span title=3D=
"Click for alternate translations">answer</span><span title=3D"Click for al=
ternate translations">,</span> <span title=3D"Click for alternate translati=
ons">but</span> <span title=3D"Click for alternate translations">I had the =
same</span> <span title=3D"Click for alternate translations">problem</span>=
 <span title=3D"Click for alternate translations">and</span> <span title=3D=
"Click for alternate translations">I managed</span> <span title=3D"Click fo=
r alternate translations">to</span> <span title=3D"Click for alternate tran=
slations">get</span> <span title=3D"Click for alternate translations">this<=
/span> <span title=3D"Click for alternate translations">device</span> <span=
 title=3D"Click for alternate translations">working</span><span title=3D"Cl=
ick for alternate translations">.</span> <span title=3D"Click for alternate=
 translations">Although</span> <span title=3D"Click for alternate translati=
ons">late,</span> <span title=3D"Click for alternate translations">it may b=
e</span> <span title=3D"Click for alternate translations">useful</span> <sp=
an title=3D"Click for alternate translations">to</span> <span title=3D"Clic=
k for alternate translations">others.</span><br>

<span title=3D"Click for alternate translations">Answer</span> <span title=
=3D"Click for alternate translations">can be found here</span><span title=
=3D"Click for alternate translations">: <a href=3D"http://www.linuxtv.org/p=
ipermail/linux-dvb/2005-March/000386.html" target=3D"_blank">http://www.lin=
uxtv.org/pipermail/linux-dvb/2005-March/000386.html</a><br>
<br>this is valid only for devices with:</span></span><br><pre>APLS-BSBE1-5=
02A (label on tuner)<br><br><br><br></pre><span lang=3D"en"><span title=3D"=
Click for alternate translations">
<br></span></span><pre>Gregor Kroesen reported non-working ttusb-budget, wh=
ich has an Alps<br>BSBE1-502A.<br><br>The ID is 1003, so it&#39;s the same =
as the BSRU6-Box, but the BSBE1<br>requires different parameters in both th=
e stv0299 inittab and the pll<br>

(someone once posted the description into this ML, topic was &quot;<br>ALPS=
-BSRV2-301A tuner problem, would like to use APLS-BSBE1-701A&quot;, and<br>=
this modification work)<br><br>a patch like:<br>dvb-ttusb-budget.c:1295:<br=
>

&gt;&gt;<i> -  buf[3] =3D 0xC4;<br></i>&gt;&gt;<i> -<br></i>&gt;&gt;<i> -  =
if (params-&gt;frequency &gt; 1530000)<br></i>&gt;&gt;<i> -    buf[3] =3D 0=
xc0;<br></i>&gt;&gt;<i> +  buf[3] =3D 0xE4;<br></i>&gt;&gt;<i> +<br></i>&gt=
;&gt;<i> +  if (params-&gt;frequency &gt; 1530000)<br>

</i>&gt;&gt;<i> +    buf[3] =3D 0xE0;<br></i>&gt;&gt;<i> dvb-ttusb-budget.c=
:1243:<br></i>&gt;&gt;<i> -  0x0f, 0x52,<br></i>&gt;&gt;<i> +  0x0f, 0xD2,<=
br></i>fixes it, however hardcodes it to bsbe1.<br><br></pre><br><span lang=
=3D"en"><span title=3D"Click for alternate translations"><br>

</span></span>
</div><br>

--002215048b976e9e9e04a0290a35--


--===============1319199998==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1319199998==--
