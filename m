Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp20.orange.fr ([80.12.242.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <catimimi@libertysurf.fr>) id 1LNUmZ-0004pw-S9
	for linux-dvb@linuxtv.org; Thu, 15 Jan 2009 17:09:28 +0100
Message-ID: <496F5FDC.4000605@libertysurf.fr>
Date: Thu, 15 Jan 2009 17:10:04 +0100
From: Catimimi <catimimi@libertysurf.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, Linux-media <linux-media@vger.kernel.org>
References: <496CB23D.6000606@libertysurf.fr> <496D7204.6030501@rogers.com>	
	<496DB023.3090402@libertysurf.fr>
	<68676e00901150743q5576fefane2d2818dc6cd9cb0@mail.gmail.com>
In-Reply-To: <68676e00901150743q5576fefane2d2818dc6cd9cb0@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1914325804=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1914325804==
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
Luca Tettamanti a =E9crit=A0:
<blockquote
 cite=3D"mid:68676e00901150743q5576fefane2d2818dc6cd9cb0@mail.gmail.com"
 type=3D"cite">
  <pre wrap=3D"">On Wed, Jan 14, 2009 at 10:28 AM, Catimimi <a class=3D"m=
oz-txt-link-rfc2396E" href=3D"mailto:catimimi@libertysurf.fr">&lt;catimim=
i@libertysurf.fr&gt;</a> wrote:
  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">try without the ".ko", i.e. instead, use:

modprobe saa716x_hybrid

OK, shame on me, it works but nothing happens.
    </pre>
  </blockquote>
  <pre wrap=3D""><!---->
Of course ;-) The PCI ID of the card is not listed. I happen to have
the same card, you can add the ID to the list but note that the
frontend is not there yet... so the module will load, will print some
something... and that's it.
  </pre>
</blockquote>
<br>
I did that too but without success. I also loaded the frontend modules.<b=
r>
<blockquote
 cite=3D"mid:68676e00901150743q5576fefane2d2818dc6cd9cb0@mail.gmail.com"
 type=3D"cite">
  <pre wrap=3D"">I have a couple of patches queued and I plan to do some
experimentation in the weekend though ;)
  </pre>
</blockquote>
<br>
OK, If I can help, tell me. <br>
Michel.<br>
<br>
</body>
</html>



--===============1914325804==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1914325804==--
