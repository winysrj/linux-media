Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henrik.list@gmail.com>) id 1Jew9g-0003jI-1B
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 18:44:51 +0100
Received: by gv-out-0910.google.com with SMTP id o2so972288gve.16
	for <linux-dvb@linuxtv.org>; Thu, 27 Mar 2008 10:44:44 -0700 (PDT)
Message-ID: <af2e95fa0803271044lda4ac30yb242d7c9920c2051@mail.gmail.com>
Date: Thu, 27 Mar 2008 18:44:43 +0100
From: "Henrik Beckman" <henrik.list@gmail.com>
To: "Nicolas Will" <nico@youplala.net>
In-Reply-To: <1206605144.8947.18.camel@youkaida>
MIME-Version: 1.0
References: <1206139910.12138.34.camel@youkaida>
	<1206190455.6285.20.camel@youkaida> <1206270834.4521.11.camel@shuttle>
	<1206348478.6370.27.camel@youkaida>
	<1206546831.8967.13.camel@acropora>
	<af2e95fa0803261142r33a0cdb1u31f9b8abc2193265@mail.gmail.com>
	<1206563002.8947.2.camel@youkaida>
	<8ad9209c0803261352s664d40fdud2fcbf877b10484b@mail.gmail.com>
	<1206566255.8947.5.camel@youkaida> <1206605144.8947.18.camel@youkaida>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
	are back!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1378255231=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1378255231==
Content-Type: multipart/alternative;
	boundary="----=_Part_5853_6515682.1206639883418"

------=_Part_5853_6515682.1206639883418
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I think we are better of trying to pin the problem down to a point where we
can switch it on/off with a change of kernel or dvb code, may I humbly
suggest.

Verify if the current tree is stable on 2.6.22.
Verify if it breaks with a newer kernel, then check for changes in the
changelog regarding usb.
Collecting debug info about the disconnects is probably very good, let=B4s
hope someone takes pity on us.

I had problems until my recent config, at the same moment it was stable I
stopped tinkering and haven=B4t dared to upgrade anything since.
My bet is that the dibcom stuff does something ugly and that there is
changes in the kernel usb code (or even config) that makes the problem
reappear.




/Henrik


On Thu, Mar 27, 2008 at 9:05 AM, Nicolas Will <nico@youplala.net> wrote:

>
> On Wed, 2008-03-26 at 21:17 +0000, Nicolas Will wrote:
> > Well, fine.
> >
> > What we need here is a developer.
> >
> > What a developer needs is info, without it, he will not be able to
> > help.
> >
> > I've posted logs, now your turn.
> >
>
> Adding the following lines in your /etc/modprobe.d/options would be a
> good start:
>
> options dvb-usb-dib0700 debug=3D1
> options mt2060 debug=3D1
> options dibx000_common debug=3D1
> options dvb_core debug=3D1
> options dvb_core dvbdev_debug=3D1
> options dvb_core frontend_debug=3D1
> options dvb_usb debug=3D1
> options dib3000mc debug=3D1
>
> Then post the lines of /var/log/syslog and /var/log/messages around the
> disconnect event.
>
> Better post them somewhere on a web page or a pastebin.
>
> Nico
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_5853_6515682.1206639883418
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<br>I think we are better of trying to pin the problem down to a point wher=
e we can switch it on/off with a change of kernel or dvb code, may I humbly=
 suggest.<br><br>Verify if the current tree is stable on 2.6.22.<br>Verify =
if it breaks with a newer kernel, then check for changes in the changelog r=
egarding usb.<br>
Collecting debug info about the disconnects is probably very good, let=B4s =
hope someone takes pity on us.<br><br>I had problems until my recent config=
, at the same moment it was stable I stopped tinkering and haven=B4t dared =
to upgrade anything since. <br>
My bet is that the dibcom stuff does something ugly and that there is chang=
es in the kernel usb code (or even config) that makes the problem reappear.=
 <br><br><br><br><br>/Henrik<br><br><br><div class=3D"gmail_quote">On Thu, =
Mar 27, 2008 at 9:05 AM, Nicolas Will &lt;<a href=3D"mailto:nico@youplala.n=
et">nico@youplala.net</a>&gt; wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"Ih2=
E3d"><br>
On Wed, 2008-03-26 at 21:17 +0000, Nicolas Will wrote:<br>
&gt; Well, fine.<br>
&gt;<br>
&gt; What we need here is a developer.<br>
&gt;<br>
&gt; What a developer needs is info, without it, he will not be able to<br>
&gt; help.<br>
&gt;<br>
&gt; I&#39;ve posted logs, now your turn.<br>
&gt;<br>
<br>
</div>Adding the following lines in your /etc/modprobe.d/options would be a=
<br>
good start:<br>
<div class=3D"Ih2E3d"><br>
options dvb-usb-dib0700 debug=3D1<br>
options mt2060 debug=3D1<br>
options dibx000_common debug=3D1<br>
options dvb_core debug=3D1<br>
options dvb_core dvbdev_debug=3D1<br>
options dvb_core frontend_debug=3D1<br>
options dvb_usb debug=3D1<br>
options dib3000mc debug=3D1<br>
<br>
</div>Then post the lines of /var/log/syslog and /var/log/messages around t=
he<br>
disconnect event.<br>
<br>
Better post them somewhere on a web page or a pastebin.<br>
<div><div></div><div class=3D"Wj3C7c"><br>
Nico<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</div></div></blockquote></div><br>

------=_Part_5853_6515682.1206639883418--


--===============1378255231==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1378255231==--
