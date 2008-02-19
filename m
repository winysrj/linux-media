Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JRVwK-0005ki-D7
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 18:07:40 +0100
Received: by rv-out-0910.google.com with SMTP id b22so1949796rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 09:07:26 -0800 (PST)
Message-ID: <617be8890802190907s2cd687bbs1670c01c483d44a9@mail.gmail.com>
Date: Tue, 19 Feb 2008 18:07:26 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Filippo Argiolas" <filippo.argiolas@gmail.com>
In-Reply-To: <1203439741.18016.10.camel@tux>
MIME-Version: 1.0
References: <617be8890802190833h23efc669m458076b40efbac08@mail.gmail.com>
	<1203439741.18016.10.camel@tux>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
	receiver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1922718126=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1922718126==
Content-Type: multipart/alternative;
	boundary="----=_Part_8305_13346006.1203440846706"

------=_Part_8305_13346006.1203440846706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

For sure. I'll give it a try and let you know the results.

Best regards,
  Eduard Huguet


2008/2/19, Filippo Argiolas <filippo.argiolas@gmail.com>:
>
>
> Il giorno mar, 19/02/2008 alle 17.33 +0100, Eduard Huguet ha scritto:
>
> > Hi,
> >     Thanks for your efforts. =BFDo you think this patch will also be
> > useful to the unknown keycodes problem of the Nova-T 500 remote?
> >
> > If you don't know what I'm talking about here you have a brief
> > description: whenever the Nova-T 500 receiver detects "invalid" or
> > "unknown" IR codes (i.e. when you operate the TV remote, etc...) it
> > keeps logging warning messages to kernel ring buffer until a "valid"
> > code is received.
> >
> > There is a very simple patch in the wiki for this, but it doesn't cure
> > the problem, just the symptons. I was wondering if your patch is a
> > better way to solve it...
> >
> > Regards,
> >   Eduard
>
> Hi, I was not aware this was a known problem but I'm pretty sure this
> patch should solve it. That problem happens because the toggle bit
> control (on the unpatched code) is done in the keymap check cycle so
> unknown repeated keys are not ignored and since the keypress data is
> still saved into the device the error message is printed every 150ms
> untill key data changes.
> I didn't find the wiki page but I think this is the correct solution
> since it resets ir data after each poll.
> Please let me know if it works good if you are going to test the patch.
> Thanks
>
> Filippo
>
>
>

------=_Part_8305_13346006.1203440846706
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

For sure. I&#39;ll give it a try and let you know the results.<br><br>Best =
regards, <br>&nbsp; Eduard Huguet<br><br><br><div><span class=3D"gmail_quot=
e">2008/2/19, Filippo Argiolas &lt;<a href=3D"mailto:filippo.argiolas@gmail=
.com">filippo.argiolas@gmail.com</a>&gt;:</span><blockquote class=3D"gmail_=
quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt =
0pt 0.8ex; padding-left: 1ex;">
<br>Il giorno mar, 19/02/2008 alle 17.33 +0100, Eduard Huguet ha scritto:<b=
r><br>&gt; Hi,<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp; Thanks for your efforts. =BF=
Do you think this patch will also be<br>&gt; useful to the unknown keycodes=
 problem of the Nova-T 500 remote?<br>
&gt;<br>&gt; If you don&#39;t know what I&#39;m talking about here you have=
 a brief<br>&gt; description: whenever the Nova-T 500 receiver detects &quo=
t;invalid&quot; or<br>&gt; &quot;unknown&quot; IR codes (i.e. when you oper=
ate the TV remote, etc...) it<br>
&gt; keeps logging warning messages to kernel ring buffer until a &quot;val=
id&quot;<br>&gt; code is received.<br>&gt;<br>&gt; There is a very simple p=
atch in the wiki for this, but it doesn&#39;t cure<br>&gt; the problem, jus=
t the symptons. I was wondering if your patch is a<br>
&gt; better way to solve it...<br>&gt;<br>&gt; Regards,<br>&gt;&nbsp;&nbsp;=
 Eduard<br><br>Hi, I was not aware this was a known problem but I&#39;m pre=
tty sure this<br>patch should solve it. That problem happens because the to=
ggle bit<br>
control (on the unpatched code) is done in the keymap check cycle so<br>unk=
nown repeated keys are not ignored and since the keypress data is<br>still =
saved into the device the error message is printed every 150ms<br>untill ke=
y data changes.<br>
I didn&#39;t find the wiki page but I think this is the correct solution<br=
>since it resets ir data after each poll.<br>Please let me know if it works=
 good if you are going to test the patch.<br>Thanks<br><br>Filippo<br><br>
<br></blockquote></div><br>

------=_Part_8305_13346006.1203440846706--


--===============1922718126==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1922718126==--
