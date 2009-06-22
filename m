Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f206.google.com ([209.85.220.206])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lkustan@gmail.com>) id 1MIdwV-0006Qj-NT
	for linux-dvb@linuxtv.org; Mon, 22 Jun 2009 09:27:51 +0200
Received: by fxm2 with SMTP id 2so3017417fxm.17
	for <linux-dvb@linuxtv.org>; Mon, 22 Jun 2009 00:27:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9def9db0906212339k3af44f3dg80fe119784391dfe@mail.gmail.com>
References: <88b49f150906211444u39a8eae1v77a15f32e4062775@mail.gmail.com>
	<d9def9db0906212339k3af44f3dg80fe119784391dfe@mail.gmail.com>
Date: Mon, 22 Jun 2009 10:27:18 +0300
Message-ID: <88b49f150906220027n17820baaxd4d4f63238a18de8@mail.gmail.com>
From: Laszlo Kustan <lkustan@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Kworld DVB-T 323UR problems
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1017151371=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1017151371==
Content-Type: multipart/alternative; boundary=000e0cd248f8d36257046ceacda4

--000e0cd248f8d36257046ceacda4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Markus,
Sorry, it seems that sometimes my usb is not recognized as 2.0, I wonder why
this happens.
Anyway, I'll send you in the afternoon a correct dmesg output, but the
results are the same: same problems with analog routing and no remote.
After I installed your tvtime version (had to install the deb version as the
sources are not available on your site (internal server error)), there were
some problems with libswscale (the link had other name than tvtime was
looking for), I renamed the link and that's how I ended up with the error
message I already wrote:
Access type not available

Any idea how to get rid of this or any feasible solution for the analog
audio?

Thanks, Laszlo


> please pay attention to that line... it probably will not work with usb
> 1.0.
>
> Markus
>

--000e0cd248f8d36257046ceacda4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote"><div>Hi Markus, <br>Sorry, it seems that sometim=
es my usb is not recognized as 2.0, I wonder why this happens.<br>Anyway, I=
&#39;ll send you in the afternoon a correct dmesg output, but the results a=
re the same: same problems with analog routing and no remote.<br>
After I installed your tvtime version (had to install the deb version as th=
e sources are not available on your site (internal server error)), there we=
re some problems with libswscale (the link had other name than tvtime was l=
ooking for), I renamed the link and that&#39;s how I ended up with the erro=
r message I already wrote: <br>
Access type not available<br><br>Any idea how to get rid of this or any fea=
sible solution for the analog audio?<br><br>Thanks, Laszlo<br></div><div>=
=A0</div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid =
rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
please pay attention to that line... it probably will not work with usb 1.0=
.<br>
<br>
Markus<br>
</blockquote></div><br>

--000e0cd248f8d36257046ceacda4--


--===============1017151371==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1017151371==--
