Return-path: <mchehab@gaivota>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ramon.rebersak@gmail.com>) id 1PWahu-0002pV-Mw
	for linux-dvb@linuxtv.org; Sat, 25 Dec 2010 21:27:15 +0100
Received: from mail-qy0-f175.google.com ([209.85.216.175])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-d) with esmtps
	[TLSv1:RC4-MD5:128] for <linux-dvb@linuxtv.org>
	id 1PWahu-0001e1-0b; Sat, 25 Dec 2010 21:27:14 +0100
Received: by qyk8 with SMTP id 8so8911758qyk.20
	for <linux-dvb@linuxtv.org>; Sat, 25 Dec 2010 12:27:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <mailman.388.1293295848.2569.linux-dvb@linuxtv.org>
References: <mailman.388.1293295848.2569.linux-dvb@linuxtv.org>
Date: Sat, 25 Dec 2010 21:27:11 +0100
Message-ID: <AANLkTim1eHMpktaJSPjw+fUQWJ2G-19B72j+qBUN9E98@mail.gmail.com>
From: =?UTF-8?Q?Ramon=2DTomislav_Reber=C5=A1ak?= <ramon.rebersak@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dvb-ca driver problem
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1536004379=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <linux-dvb@linuxtv.org>

--===============1536004379==
Content-Type: multipart/alternative; boundary=0016e64b03b6842210049841edd0

--0016e64b03b6842210049841edd0
Content-Type: text/plain; charset=ISO-8859-1

Hello
I am trying to port bcm's 97325 framebuffer.
When insmod driver, got following errors:

> dvb: Unknown symbol dvb_ca_link_open
>
> dvb: Unknown symbol dvb_ca_link_write
>
> dvb: Unknown symbol dvb_ca_link_read
>
> dvb: Unknown symbol dvb_ca_link_poll
>
Any idea what I was missed to include?
As I see from log, there's common access driver, but I cannot figured which
one?
Is it bcm's or linux?
>From google no luck.
Any help is really appreciated.

-- 
-----BEGIN PGP SIGNATURE-----
Ramon-Tomislav Rebersak
Version: GnuPG v2.0.10 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknObc8ACgkQH7oLVaEQq2wlTgCdEEPzkMD3iSs6L3x1fNqLMJZ3
dKUAnR8TQuwHSZlhcuSMygznwgpaolh/
=S4EG
-----END PGP SIGNATURE-----

--0016e64b03b6842210049841edd0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello<br>I am trying to port bcm&#39;s 97325 framebuffer.<br><div class=3D"=
gmail_quote">When insmod driver, got following errors:<br>

<blockquote style=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(=
204, 204, 204); padding-left: 1ex;" class=3D"gmail_quote"><p style=3D"margi=
n: 0px; text-indent: 0px;">dvb: Unknown symbol dvb_ca_link_open</p><p style=
=3D"margin: 0px; text-indent: 0px;">

dvb: Unknown symbol dvb_ca_link_write</p><p style=3D"margin: 0px; text-inde=
nt: 0px;">dvb: Unknown symbol dvb_ca_link_read</p><p style=3D"margin: 0px; =
text-indent: 0px;">dvb: Unknown symbol dvb_ca_link_poll</p></blockquote>



Any idea what I was missed to include?<br>As I see from log, there&#39;s co=
mmon access driver, but I cannot figured which one?<br>Is it bcm&#39;s or l=
inux?<br>From google no luck.<br>Any help is really appreciated.<br clear=
=3D"all">
<br>-- <br>-----BEGIN PGP SIGNATURE-----<br>
Ramon-Tomislav Rebersak<br>Version: GnuPG v2.0.10 (Darwin)<br>Comment: Usin=
g GnuPG with Mozilla - <a href=3D"http://enigmail.mozdev.org" target=3D"_bl=
ank">http://enigmail.mozdev.org</a><br><br>iEYEARECAAYFAknObc8ACgkQH7oLVaEQ=
q2wlTgCdEEPzkMD3iSs6L3x1fNqLMJZ3<br>

dKUAnR8TQuwHSZlhcuSMygznwgpaolh/<br>=3DS4EG<br>-----END PGP SIGNATURE-----<=
br>
</div><br>

--0016e64b03b6842210049841edd0--


--===============1536004379==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1536004379==--
