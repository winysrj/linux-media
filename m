Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1Jiyfu-0006Gs-Uf
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 23:14:47 +0200
Received: by nf-out-0910.google.com with SMTP id d21so682666nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 07 Apr 2008 14:14:33 -0700 (PDT)
Message-ID: <ea4209750804071414g5adbe651s7ef2aaeabf407658@mail.gmail.com>
Date: Mon, 7 Apr 2008 23:14:33 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Julien Rebetez" <julien@fhtagn.net>
In-Reply-To: <1207588024.14924.12.camel@silver-laptop>
MIME-Version: 1.0
References: <1207588024.14924.12.camel@silver-laptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S no frontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1767847986=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1767847986==
Content-Type: multipart/alternative;
	boundary="----=_Part_12955_14445045.1207602873560"

------=_Part_12955_14445045.1207602873560
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Uhm... It's strange that it doesn't attach correcly the frontend... could
you send your dib0700_devices.c on v4l-dvb/linux/drivers/media/dvb/dvb-usb/
? Just to verify that it's correct... Did you rebooted after sudo make
install (just to check old drivers are not in memory)?

Albert

2008/4/7 Julien Rebetez <julien@fhtagn.net>:

> Hello,
>
> I have some problems with a Yuan EC372S card. I am using the latest (rev
> 7499:1abbd650fe07) v4l-dvb from mercurial head.
>
> The card is correctly detected and the firmware loaded but no frontend
> is attached to it.
>
> I'm running kernel 2.6.22-14-generic on an Ubuntu Gutsy.
>
> I have attached the relevant output of dmesg and lsusb -v and of course
> I'll be glad to give more informations if needed.
>
> Regards,
> Julien
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_12955_14445045.1207602873560
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Uhm... It&#39;s strange that it doesn&#39;t attach correcly the frontend... could you send your dib0700_devices.c on v4l-dvb/linux/drivers/media/dvb/dvb-usb/ ? Just to verify that it&#39;s correct... Did you rebooted after sudo make install (just to check old drivers are not in memory)?<br>
<br>Albert<br><br><div class="gmail_quote">2008/4/7 Julien Rebetez &lt;<a href="mailto:julien@fhtagn.net">julien@fhtagn.net</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hello,<br>
<br>
I have some problems with a Yuan EC372S card. I am using the latest (rev<br>
7499:1abbd650fe07) v4l-dvb from mercurial head.<br>
<br>
The card is correctly detected and the firmware loaded but no frontend<br>
is attached to it.<br>
<br>
I&#39;m running kernel 2.6.22-14-generic on an Ubuntu Gutsy.<br>
<br>
I have attached the relevant output of dmesg and lsusb -v and of course<br>
I&#39;ll be glad to give more informations if needed.<br>
<br>
Regards,<br>
<font color="#888888">Julien<br>
<br>
</font><br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div><br>

------=_Part_12955_14445045.1207602873560--


--===============1767847986==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1767847986==--
