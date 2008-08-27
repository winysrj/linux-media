Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1KYFAf-00061T-KP
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 09:10:26 +0200
Received: by yx-out-2324.google.com with SMTP id 8so1169966yxg.41
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 00:10:20 -0700 (PDT)
Message-ID: <617be8890808270010j640f4cb7je46e74c7234b978b@mail.gmail.com>
Date: Wed, 27 Aug 2008 09:10:20 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] dib0700 new i2c implementation
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0693529956=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0693529956==
Content-Type: multipart/alternative;
	boundary="----=_Part_16480_5368822.1219821020867"

------=_Part_16480_5368822.1219821020867
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>
> ---------- Missatge reenviat ----------
> From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
> To: linux-dvb <linux-dvb@linuxtv.org>
> Date: Tue, 26 Aug 2008 21:15:20 -0400
> Subject: [linux-dvb] dib0700 new i2c implementation
> The attached patch implements the new dib0700 i2c API, which requires
> v1.20 of the firmware.  It addresses some classes of i2c problems (in
> particular the one I had where i2c reads were being sent onto the bus
> as i2c write calls)
>
> I would appreciate it if those with dib0700 based devices would try
> out the patch and provide feedback as to whether they have any
> problems.  I've done testing with the Pinnacle PCTV HD Pro USB 801e
> stick, but I don't have any other dib0700 based devices.
>
> Thanks to Patrick Boettcher for providing the firmware, sample code,
> and peer review of the first version of this patch.
>
> Regards,
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>


Hi,
    Thanks for your work, first of all. =BFDo you think this patch might
solve the problems that seem to be appeared since the new firmware is out
with the Hauppauge Nova-T 500, like random reboots, etc... (what's ths stat=
e
on this, anyway?) ?

I delayed the adoption of the new 1.20 firmware because of those problems,
because I didn't want to leave the machine in a complete unusable state...

Best regards,
  Eduard Huguet

------=_Part_16480_5368822.1219821020867
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><div class=3D"gmail_quote"><blockquote class=3D"gmail_quot=
e" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt =
0.8ex; padding-left: 1ex;">---------- Missatge reenviat ----------<br>From:=
&nbsp;&quot;Devin Heitmueller&quot; &lt;<a href=3D"mailto:devin.heitmueller=
@gmail.com">devin.heitmueller@gmail.com</a>&gt;<br>
To:&nbsp;linux-dvb &lt;<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@l=
inuxtv.org</a>&gt;<br>Date:&nbsp;Tue, 26 Aug 2008 21:15:20 -0400<br>Subject=
:&nbsp;[linux-dvb] dib0700 new i2c implementation<br>The attached patch imp=
lements the new dib0700 i2c API, which requires<br>

v1.20 of the firmware. &nbsp;It addresses some classes of i2c problems (in<=
br>
particular the one I had where i2c reads were being sent onto the bus<br>
as i2c write calls)<br>
<br>
I would appreciate it if those with dib0700 based devices would try<br>
out the patch and provide feedback as to whether they have any<br>
problems. &nbsp;I&#39;ve done testing with the Pinnacle PCTV HD Pro USB 801=
e<br>
stick, but I don&#39;t have any other dib0700 based devices.<br>
<br>
Thanks to Patrick Boettcher for providing the firmware, sample code,<br>
and peer review of the first version of this patch.<br>
<br>
Regards,<br>
<br>
Devin<br>
<br>
--<br>
Devin J. Heitmueller<br>
<a href=3D"http://www.devinheitmueller.com" target=3D"_blank">http://www.de=
vinheitmueller.com</a><br>
AIM: devinheitmueller<br>
</blockquote></div><br><br>Hi, <br>&nbsp;&nbsp;&nbsp; Thanks for your work,=
 first of all. =BFDo you think this patch might&nbsp; solve the problems th=
at seem to be appeared since the new firmware is out with the Hauppauge Nov=
a-T 500, like random reboots, etc... (what&#39;s ths state on this, anyway?=
) ?<br>
<br>I delayed the adoption of the new 1.20 firmware because of those proble=
ms, because I didn&#39;t want to leave the machine in a complete unusable s=
tate...<br><br>Best regards, <br>&nbsp; Eduard Huguet<br><br>&nbsp; <br><br=
></div>

------=_Part_16480_5368822.1219821020867--


--===============0693529956==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0693529956==--
