Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henrik.list@gmail.com>) id 1JobC2-0000Xx-52
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 11:23:11 +0200
Received: by yw-out-2324.google.com with SMTP id 9so118815ywe.41
	for <linux-dvb@linuxtv.org>; Wed, 23 Apr 2008 02:23:03 -0700 (PDT)
Message-ID: <af2e95fa0804230223l4800884ch145fdcd22f5013a7@mail.gmail.com>
Date: Wed, 23 Apr 2008 11:23:03 +0200
From: "Henrik Beckman" <henrik.list@gmail.com>
To: "Luca Ingianni" <luca.i@gmx.net>, linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <200804230732.40813.luca.i@gmx.net>
MIME-Version: 1.0
References: <200804181939.39153.luca.i@gmx.net>
	<200804230732.40813.luca.i@gmx.net>
Subject: Re: [linux-dvb] Hauppauge Nova-TD trouble: still or again?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0658319768=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0658319768==
Content-Type: multipart/alternative;
	boundary="----=_Part_17944_3774165.1208942583554"

------=_Part_17944_3774165.1208942583554
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Working ok for me on Gutsy, Abit 630i motherboard.
About the kernel, the bug is fixed in 2.6.24-14 for ubuntu, are you running
an Ubuntu kernel or your own ?

/Henrik



On Wed, Apr 23, 2008 at 7:32 AM, Luca Ingianni <luca.i@gmx.net> wrote:

> Replying to my own post now.
> I've tried using the svn version of the dvb drivers, but am still having
> the
> same problems.
> Is there any use in me trying kernel 2.6.25, or has nothing relevant
> changed
> in there anyway?
> As I understand it, according to the list archives, the problem ought to
> be
> fixed already, right?
>
> Again, I'll be glad to assist in debugging, but I can't do it all on my
> own.
>
> TIA
> Luca
>
>
> Am Freitag 18 April 2008 19:39:38 schrieb Luca Ingianni:
> > For the last few days, I've been searching high and low for a way to get
> my
> > Nova-TD to work reliably. I've since found out about the problem with
> the
> > SB600 southbridge (after buying the Nova :(   ), but from what I
> gathered
> > it should have been fixed in kernel 2.6.24-14 . The problem is, I'm
> running
> > 2.6.24-16 (Ubuntu Hardy flavour) and still get the USB disconnects when
> > using both tuners at once.
> > As soon as I close kaffeine, it reconnects immediately and is generally
> > ready to use again.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_17944_3774165.1208942583554
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br>Working ok for me on Gutsy, Abit 630i motherboard.<br>About the kernel, the bug is fixed in 2.6.24-14 for ubuntu, are you running an Ubuntu kernel or your own ?<br><br>/Henrik<br><br><br><br><div class="gmail_quote">On Wed, Apr 23, 2008 at 7:32 AM, Luca Ingianni &lt;<a href="mailto:luca.i@gmx.net" target="_blank">luca.i@gmx.net</a>&gt; wrote:<br>

<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Replying to my own post now.<br>
I&#39;ve tried using the svn version of the dvb drivers, but am still having the<br>
same problems.<br>
Is there any use in me trying kernel 2.6.25, or has nothing relevant changed<br>
in there anyway?<br>
As I understand it, according to the list archives, the problem ought to be<br>
fixed already, right?<br>
<br>
Again, I&#39;ll be glad to assist in debugging, but I can&#39;t do it all on my own.<br>
<br>
TIA<br>
Luca<br>
<br>
<br>
Am Freitag 18 April 2008 19:39:38 schrieb Luca Ingianni:<br>
<div>&gt; For the last few days, I&#39;ve been searching high and low for a way to get my<br>
&gt; Nova-TD to work reliably. I&#39;ve since found out about the problem with the<br>
&gt; SB600 southbridge (after buying the Nova :( &nbsp; ), but from what I gathered<br>
&gt; it should have been fixed in kernel 2.6.24-14 . The problem is, I&#39;m running<br>
&gt; 2.6.24-16 (Ubuntu Hardy flavour) and still get the USB disconnects when<br>
&gt; using both tuners at once.<br>
&gt; As soon as I close kaffeine, it reconnects immediately and is generally<br>
&gt; ready to use again.<br>
<br>
</div><div><div></div><div>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org" target="_blank">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br>

------=_Part_17944_3774165.1208942583554--


--===============0658319768==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0658319768==--
