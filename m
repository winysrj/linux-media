Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LJBhy-0004QC-Ok
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 19:58:51 +0100
Received: by qw-out-2122.google.com with SMTP id 9so3338927qwb.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 10:58:46 -0800 (PST)
Message-ID: <c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
Date: Sat, 3 Jan 2009 20:58:45 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: kedgedev@centrum.cz
In-Reply-To: <op.um60szqyrj95b0@localhost>
MIME-Version: 1.0
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0836646575=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0836646575==
Content-Type: multipart/alternative;
	boundary="----=_Part_200948_5062440.1231009125845"

------=_Part_200948_5062440.1231009125845
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Jan 3, 2009 at 8:11 PM, Roman Jarosz <roman.jarosz@gmail.com> wrote:

> On Sat, 03 Jan 2009 18:28:03 +0100, Alex Betis <alex.betis@gmail.com>
> wrote:
>
> > On Sat, Jan 3, 2009 at 6:42 PM, Roman Jarosz <roman.jarosz@gmail.com>
> > wrote:
> >
> >> Hi,
> >>
> >> I have a problem with DVB-S channel searching, the scan command doesn't
> >> find all channels in Linux on Astra 19.2E.
> >> It works in Windows.
> >>
> > Please specify what driver you use, what scan application, what is the
> > command line you gave to the scan application, what is the frequency file
> > you've used for scan application, what is the result of the scan you
> > have.
> >
> > Than maybe I can help somehow.
>
> I use scan from dvb-apps, the command is
> "scan -o vdr /root/dvb/Astra-19.2E > /etc/vdr/channels.conf"
> where /root/dvb/Astra-19.2E is file with "S 11567500 V 22000000 5/6"

I think that's the main issue. *BOUWSMA w*rote that its ok to rely on
astra's maintainers and connect to any transponder is enough to get a list
of all others. I personaly don't trust those maintainers since I saw too
many errors in NIT messages that specify the transponder, so I specify all
the frequencies I want to scan. I don't have a dish to 19.2, but there were
many errors with 5 other satellites I have.
You can get a list of those frequencies here:
http://www.lyngsat.com/astra19.html



>
> I use cx88-dvb driver but many modules are loaded with it see
> http://kedge.wz.cz/dvb/lsmod.txt

I meant to ask what is the origin of the driver. I use Igor's driver from:
http://mercurial.intuxication.org/hg/s2-liplianin/

If you have a S2API driver (or will use Igor's driver), you can use my
scan-s2 application with many changes in NIT parsing that might resolve your
issue.
http://mercurial.intuxication.org/hg/scan-s2/


>
> Scan console output is in file http://kedge.wz.cz/dvb/channels.conf
> and the result in http://kedge.wz.cz/dvb/channels.conf

You've posted the same link for both outputs. Please post console output
when you run scan with "-v" parameter. Maybe even with "-vv".


>
> When console shows
> __tune_to_transponder:1508: ERROR: Setting frontend parameters failed: 22
> Invalid argument
>
> the dmesg prints
> DVB: adapter 0 frontend 0 frequency 8175750 out of range (950000..2150000)

It could be anything. Bad NIT message (most probably) or a memory smashing
in scan application.


>
>
> Roman
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_200948_5062440.1231009125845
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Sat, Jan 3, 2009 at 8:11 PM, Roman Jarosz <span dir="ltr">&lt;<a href="mailto:roman.jarosz@gmail.com">roman.jarosz@gmail.com</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On Sat, 03 Jan 2009 18:28:03 +0100, Alex Betis &lt;<a href="mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&gt; wrote:<br>
<br>
&gt; On Sat, Jan 3, 2009 at 6:42 PM, Roman Jarosz &lt;<a href="mailto:roman.jarosz@gmail.com">roman.jarosz@gmail.com</a>&gt;<br>
&gt; wrote:<br>
&gt;<br>
&gt;&gt; Hi,<br>
&gt;&gt;<br>
&gt;&gt; I have a problem with DVB-S channel searching, the scan command doesn&#39;t<br>
&gt;&gt; find all channels in Linux on Astra 19.2E.<br>
&gt;&gt; It works in Windows.<br>
&gt;&gt;<br>
&gt; Please specify what driver you use, what scan application, what is the<br>
&gt; command line you gave to the scan application, what is the frequency file<br>
&gt; you&#39;ve used for scan application, what is the result of the scan you<br>
&gt; have.<br>
&gt;<br>
&gt; Than maybe I can help somehow.<br>
<br>
I use scan from dvb-apps, the command is<br>
&quot;scan -o vdr /root/dvb/Astra-19.2E &gt; /etc/vdr/channels.conf&quot;<br>
where /root/dvb/Astra-19.2E is file with &quot;S 11567500 V 22000000 5/6&quot;</blockquote><div>I think that&#39;s the main issue. <i>BOUWSMA w</i>rote that its ok to rely on astra&#39;s maintainers and connect to any transponder is enough to get a list of all others. I personaly don&#39;t trust those maintainers since I saw too many errors in NIT messages that specify the transponder, so I specify all the frequencies I want to scan. I don&#39;t have a dish to 19.2, but there were many errors with 5 other satellites I have.<br>
You can get a list of those frequencies here:<br><a href="http://www.lyngsat.com/astra19.html">http://www.lyngsat.com/astra19.html</a><br><br><br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<br>
I use cx88-dvb driver but many modules are loaded with it see<br>
<a href="http://kedge.wz.cz/dvb/lsmod.txt" target="_blank">http://kedge.wz.cz/dvb/lsmod.txt</a></blockquote><div>I meant to ask what is the origin of the driver. I use Igor&#39;s driver from:<br><a href="http://mercurial.intuxication.org/hg/s2-liplianin/">http://mercurial.intuxication.org/hg/s2-liplianin/</a><br>
<br>If you have a S2API driver (or will use Igor&#39;s driver), you can use my scan-s2 application with many changes in NIT parsing that might resolve your issue.<br><a href="http://mercurial.intuxication.org/hg/scan-s2/">http://mercurial.intuxication.org/hg/scan-s2/</a><br>
<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
Scan console output is in file <a href="http://kedge.wz.cz/dvb/channels.conf" target="_blank">http://kedge.wz.cz/dvb/channels.conf</a><br>
and the result in <a href="http://kedge.wz.cz/dvb/channels.conf" target="_blank">http://kedge.wz.cz/dvb/channels.conf</a></blockquote><div>You&#39;ve posted the same link for both outputs. Please post console output when you run scan with &quot;-v&quot; parameter. Maybe even with &quot;-vv&quot;.<br>
<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
When console shows<br>
__tune_to_transponder:1508: ERROR: Setting frontend parameters failed: 22 Invalid argument<br>
<br>
the dmesg prints<br>
DVB: adapter 0 frontend 0 frequency 8175750 out of range (950000..2150000)</blockquote><div>It could be anything. Bad NIT message (most probably) or a memory smashing in scan application.<br>&nbsp;<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<br>
Roman<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

------=_Part_200948_5062440.1231009125845--


--===============0836646575==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0836646575==--
