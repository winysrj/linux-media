Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1KsEIS-0001In-3j
	for linux-dvb@linuxtv.org; Tue, 21 Oct 2008 12:17:06 +0200
Received: by gxk13 with SMTP id 13so5204931gxk.17
	for <linux-dvb@linuxtv.org>; Tue, 21 Oct 2008 03:16:30 -0700 (PDT)
Message-ID: <617be8890810210316o42542943uf0e8c77fbf4fca11@mail.gmail.com>
Date: Tue, 21 Oct 2008 12:16:28 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] v4l-dvb gspca modules conflict with standalone
	gspca module
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1902133818=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1902133818==
Content-Type: multipart/alternative;
	boundary="----=_Part_1244_11984905.1224584188848"

------=_Part_1244_11984905.1224584188848
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, Matthias
   That's an interesting thing to know :D. Last week I upgraded to 2.6.26
and noticed that my webcam stopped working for some unknown reason, even if
I reemerged gspcav package to recompile the drivers. The webcam appears in
Kopete (KDE4) devices list, but I get no image from it.

Do you think it might be related to this (i.e. I need to emerge that new
library they were talking about)? I initially thought it was KDE4 Kopete's
fault, but maybe it's not.

Best regards,
  Eduard

PS: BTW, the drivers you wrote for the AverMedia DVB-S Pro (A700) work
rock-solid for me. Any hope they get merged into the DVB tree anytime soon?



>
> ---------- Missatge reenviat ----------
> From: Matthias Schwarzott <zzam@gentoo.org>
> To: linux-dvb@linuxtv.org
> Date: Tue, 21 Oct 2008 09:28:02 +0200
> Subject: Re: [linux-dvb] v4l-dvb gspca modules conflict with standalone
> gspca module
> On Montag, 20. Oktober 2008, Thomas Kaiser wrote:
>
> >
> > Hans de Goede (j.w.r.degoede@hhs.nl) is writing a user space lib to
> > convert/decode all the stuff which was done in the old gspca in kernel
> > space, his lib does it now in user space. That's the way to go!
> >
> > The development of this is rather new and I think it is not included in
> > any distro at the moment. But it will be soon.
> >
>
> Well, gentoo already has it since october, 18th :)
>
> Regards
> Matthias
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_1244_11984905.1224584188848
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, Matthias<br><div class="gmail_quote">&nbsp;&nbsp; That&#39;s an interesting thing to know :D. Last week I upgraded to 2.6.26 and noticed that my webcam stopped working for some unknown reason, even if I reemerged gspcav package to recompile the drivers. The webcam appears in Kopete (KDE4) devices list, but I get no image from it.<br>

<br>Do you think it might be related to this (i.e. I need to emerge that new library they were talking about)? I initially thought it was KDE4 Kopete&#39;s fault, but maybe it&#39;s not.<br><br>Best regards, <br>&nbsp; Eduard<br>

<br>PS: BTW, the drivers you wrote for the AverMedia DVB-S Pro (A700) work rock-solid for me. Any hope they get merged into the DVB tree anytime soon?<br><div class="gmail_quote"><div><br>&nbsp;</div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>---------- Missatge reenviat ----------<br>From:&nbsp;Matthias Schwarzott &lt;<a href="mailto:zzam@gentoo.org" target="_blank">zzam@gentoo.org</a>&gt;<br>To:&nbsp;<a href="mailto:linux-dvb@linuxtv.org" target="_blank">linux-dvb@linuxtv.org</a><br>
Date:&nbsp;Tue, 21 Oct 2008 09:28:02 +0200<br>
Subject:&nbsp;Re: [linux-dvb] v4l-dvb gspca modules conflict with	standalone	gspca module<br>On Montag, 20. Oktober 2008, Thomas Kaiser wrote:<br>
<br>
&gt;<br>
&gt; Hans de Goede (<a href="mailto:j.w.r.degoede@hhs.nl" target="_blank">j.w.r.degoede@hhs.nl</a>) is writing a user space lib to<br>
&gt; convert/decode all the stuff which was done in the old gspca in kernel<br>
&gt; space, his lib does it now in user space. That&#39;s the way to go!<br>
&gt;<br>
&gt; The development of this is rather new and I think it is not included in<br>
&gt; any distro at the moment. But it will be soon.<br>
&gt;<br>
<br>
Well, gentoo already has it since october, 18th :)<br>
<br>
Regards<br>
Matthias<br>
<br>
<br>
<br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org" target="_blank">linux-dvb@linuxtv.org</a><div class="Ih2E3d"><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></div></blockquote></div><br>
</div><br>

------=_Part_1244_11984905.1224584188848--


--===============1902133818==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1902133818==--
