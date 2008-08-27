Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1KYLul-000526-Kz
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 16:22:28 +0200
Received: by gxk13 with SMTP id 13so4447768gxk.17
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 07:21:53 -0700 (PDT)
Message-ID: <617be8890808270721u4add07cl98a90dbb87f9d320@mail.gmail.com>
Date: Wed, 27 Aug 2008 16:21:53 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0808270649t69b07207x92bb9754396ab800@mail.gmail.com>
MIME-Version: 1.0
References: <617be8890808270010j640f4cb7je46e74c7234b978b@mail.gmail.com>
	<alpine.LRH.1.10.0808271021040.18085@pub6.ifh.de>
	<617be8890808270212m192b2951x4d5e8313cd788557@mail.gmail.com>
	<412bdbff0808270649t69b07207x92bb9754396ab800@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 new i2c implementation
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2019779177=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2019779177==
Content-Type: multipart/alternative;
	boundary="----=_Part_20541_32829682.1219846913435"

------=_Part_20541_32829682.1219846913435
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Mmmh... I don't see how having "random" copies around (whatever this means)
of the 1.10 firmware can make the computer reboot. The driver attempts to
load the firmware. If it can it's loaded, if not it fails, nothing more.

Anyway, I'll be somewhat busy this week to test this. But as soon as I find
the time I'll try to i.e. compile a separate kernel that uses both this
patch and the new firmware and then provide testing. At least this way I'll
be sure I'll be able to revert back to my rock-stable configuration by just
choosing the appropiate grub entry at boot.

Otherwise, trying to fix a machine that is constantly rebooting due to a
driver can be a very nasty thing... ;)

Regards,
  Eduard



2008/8/27 Devin Heitmueller <devin.heitmueller@gmail.com>

> Hello Eduard,
>
> 2008/8/27 Eduard Huguet <eduardhc@gmail.com>:
> > Well, regarding the Nova-T 500 I must say that, using the current HG
> driver
> > code and 1.10 firmware, it's pretty rock solid. I've had no USB
> disconnects
> > nor hangs of any time since a long time ago (since lastest patches for
> this
> > card were merged).
> >
> > That's the reason I'm very reluctant to use the new firmware, specially
> if
> > the effect seems to be a constantly rebooting machine, as Nicolas Will
> > described ;-). However, if the above patche solves the problems then I'll
> be
> > very pleased to test it.
>
> It seems that Nicholas's problems had to do with having random copies
> of 1.10 in /lib/firmware.
>
> This is about more than "does it fix my problem".  The patch I am
> submitting could cause potential breakage with other devices, so I
> need people who have a stable environment to test the change and make
> sure it doesn't cause breakage.
>
> Otherwise, it just gets pushed in, you do an "hg update" and all of a
> sudden your environment is broken.
>
> The patch is known to fix several problems required to get the xc5000
> working with the dib0700, but I want to be sure people with a working
> environment don't start seeing problems.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

------=_Part_20541_32829682.1219846913435
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Mmmh... I don&#39;t see how having &quot;random&quot; copies around (whatever this means) of the 1.10 firmware can make the computer reboot. The driver attempts to load the firmware. If it can it&#39;s loaded, if not it fails, nothing more. <br>
<br>Anyway, I&#39;ll be somewhat busy this week to test this. But as soon as I find the time I&#39;ll try to i.e. compile a separate kernel that uses both this patch and the new firmware and then provide testing. At least this way I&#39;ll be sure I&#39;ll be able to revert back to my rock-stable configuration by just choosing the appropiate grub entry at boot.<br>
<br>Otherwise, trying to fix a machine that is constantly rebooting due to a driver can be a very nasty thing... ;)<br><br>Regards, <br>&nbsp; Eduard<br><br><br><br><div class="gmail_quote">2008/8/27 Devin Heitmueller <span dir="ltr">&lt;<a href="mailto:devin.heitmueller@gmail.com">devin.heitmueller@gmail.com</a>&gt;</span><br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hello Eduard,<br>
<br>
2008/8/27 Eduard Huguet &lt;<a href="mailto:eduardhc@gmail.com">eduardhc@gmail.com</a>&gt;:<br>
<div class="Ih2E3d">&gt; Well, regarding the Nova-T 500 I must say that, using the current HG driver<br>
&gt; code and 1.10 firmware, it&#39;s pretty rock solid. I&#39;ve had no USB disconnects<br>
&gt; nor hangs of any time since a long time ago (since lastest patches for this<br>
&gt; card were merged).<br>
&gt;<br>
&gt; That&#39;s the reason I&#39;m very reluctant to use the new firmware, specially if<br>
&gt; the effect seems to be a constantly rebooting machine, as Nicolas Will<br>
&gt; described ;-). However, if the above patche solves the problems then I&#39;ll be<br>
&gt; very pleased to test it.<br>
<br>
</div>It seems that Nicholas&#39;s problems had to do with having random copies<br>
of 1.10 in /lib/firmware.<br>
<br>
This is about more than &quot;does it fix my problem&quot;. &nbsp;The patch I am<br>
submitting could cause potential breakage with other devices, so I<br>
need people who have a stable environment to test the change and make<br>
sure it doesn&#39;t cause breakage.<br>
<br>
Otherwise, it just gets pushed in, you do an &quot;hg update&quot; and all of a<br>
sudden your environment is broken.<br>
<br>
The patch is known to fix several problems required to get the xc5000<br>
working with the dib0700, but I want to be sure people with a working<br>
environment don&#39;t start seeing problems.<br>
<div><div></div><div class="Wj3C7c"><br>
Devin<br>
<br>
--<br>
Devin J. Heitmueller<br>
<a href="http://www.devinheitmueller.com" target="_blank">http://www.devinheitmueller.com</a><br>
AIM: devinheitmueller<br>
</div></div></blockquote></div><br></div>

------=_Part_20541_32829682.1219846913435--


--===============2019779177==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2019779177==--
