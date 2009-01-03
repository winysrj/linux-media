Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LJDQc-0005OD-N0
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 21:49:03 +0100
Received: by qw-out-2122.google.com with SMTP id 9so3350573qwb.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 12:48:58 -0800 (PST)
Message-ID: <c74595dc0901031248h3c3d002j2422331c82249d78@mail.gmail.com>
Date: Sat, 3 Jan 2009 22:48:45 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: kedgedev@centrum.cz
In-Reply-To: <op.um64vfdkrj95b0@localhost>
MIME-Version: 1.0
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<op.um64vfdkrj95b0@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1400967977=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1400967977==
Content-Type: multipart/alternative;
	boundary="----=_Part_202118_17372172.1231015725810"

------=_Part_202118_17372172.1231015725810
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Jan 3, 2009 at 9:39 PM, Roman Jarosz <roman.jarosz@gmail.com> wrote:

> On Sat, 03 Jan 2009 19:58:45 +0100, Alex Betis <alex.betis@gmail.com>
> wrote:
>
> >> I use scan from dvb-apps, the command is
> >> "scan -o vdr /root/dvb/Astra-19.2E > /etc/vdr/channels.conf"
> >> where /root/dvb/Astra-19.2E is file with "S 11567500 V 22000000 5/6"
> >
> > I think that's the main issue. *BOUWSMA w*rote that its ok to rely on
> > astra's maintainers and connect to any transponder is enough to get a
> > list
> > of all others. I personaly don't trust those maintainers since I saw too
> > many errors in NIT messages that specify the transponder, so I specify
> > all
> > the frequencies I want to scan. I don't have a dish to 19.2, but there
> > were
> > many errors with 5 other satellites I have.
> > You can get a list of those frequencies here:
> > http://www.lyngsat.com/astra19.html
>
> Could you tell me how? I've tried with S 12188000 H 27500000 3/4 and
> it doesn't find anything.

Try also scan-s2 with:
S 12188000 H 27500000 3/4 AUTO QPSK


>
> >
> >
> >>
> >> I use cx88-dvb driver but many modules are loaded with it see
> >> http://kedge.wz.cz/dvb/lsmod.txt
> >
> > I meant to ask what is the origin of the driver. I use Igor's driver
> > from:
> > http://mercurial.intuxication.org/hg/s2-liplianin/
>
> I use driver from vanilla kernel 2.6.28 which have DVB api version 5.0.
>
> > If you have a S2API driver (or will use Igor's driver), you can use my
> > scan-s2 application with many changes in NIT parsing that might resolve
> > your
> > issue.
> > http://mercurial.intuxication.org/hg/scan-s2/
> >
>
> See below.
>
> >>
> >> Scan console output is in file http://kedge.wz.cz/dvb/channels.conf
> >> and the result in http://kedge.wz.cz/dvb/channels.conf
> >
> > You've posted the same link for both outputs. Please post console output
> > when you run scan with "-v" parameter. Maybe even with "-vv".
> >
>
> The console output should be http://kedge.wz.cz/dvb/scanconsoleout.txt.
>
> I've tried to run scan and scan-s2 on "S 12188000 H 27500000 3/4"
> were the "RTL 2 Deutschland" channel should be and neither scan found
> anything.
>
> The console outputs are here:
> http://kedge.wz.cz/dvb/scan.txt
> http://kedge.wz.cz/dvb/scans2.txt

I don't see any problem with scan output. I don't have the same card as
yours, so only guessing...

Do you have a diseqc on the way?


>
>
>
> If you want me to run the whole scan for "S 11567500 V 22000000 5/6" with
> -vv
> let me know and I'll do it.

No, no need.

>
>
> >>
> >> When console shows
> >> __tune_to_transponder:1508: ERROR: Setting frontend parameters failed:
> >> 22
> >> Invalid argument
> >>
> >> the dmesg prints
> >> DVB: adapter 0 frontend 0 frequency 8175750 out of range
> >> (950000..2150000)
> >
> > It could be anything. Bad NIT message (most probably) or a memory
> > smashing
> > in scan application.
> >
> >
> >>
> >>
> >> Roman
> >>
> >> _______________________________________________
> >> linux-dvb mailing list
> >> linux-dvb@linuxtv.org
> >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_202118_17372172.1231015725810
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Sat, Jan 3, 2009 at 9:39 PM, Roman Jarosz <span dir="ltr">&lt;<a href="mailto:roman.jarosz@gmail.com">roman.jarosz@gmail.com</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">On Sat, 03 Jan 2009 19:58:45 +0100, Alex Betis &lt;<a href="mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&gt; wrote:<br>
<br>
&gt;&gt; I use scan from dvb-apps, the command is<br>
&gt;&gt; &quot;scan -o vdr /root/dvb/Astra-19.2E &gt; /etc/vdr/channels.conf&quot;<br>
&gt;&gt; where /root/dvb/Astra-19.2E is file with &quot;S 11567500 V 22000000 5/6&quot;<br>
&gt;<br>
</div>&gt; I think that&#39;s the main issue. *BOUWSMA w*rote that its ok to rely on<br>
<div class="Ih2E3d">&gt; astra&#39;s maintainers and connect to any transponder is enough to get a<br>
&gt; list<br>
&gt; of all others. I personaly don&#39;t trust those maintainers since I saw too<br>
&gt; many errors in NIT messages that specify the transponder, so I specify<br>
&gt; all<br>
&gt; the frequencies I want to scan. I don&#39;t have a dish to 19.2, but there<br>
&gt; were<br>
&gt; many errors with 5 other satellites I have.<br>
&gt; You can get a list of those frequencies here:<br>
&gt; <a href="http://www.lyngsat.com/astra19.html" target="_blank">http://www.lyngsat.com/astra19.html</a><br>
<br>
</div>Could you tell me how? I&#39;ve tried with S 12188000 H 27500000 3/4 and<br>
it doesn&#39;t find anything.</blockquote><div>Try also scan-s2 with:<br>S 12188000 H 27500000 3/4 AUTO QPSK <br><br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<div class="Ih2E3d"><br>
&gt;<br>
&gt;<br>
&gt;&gt;<br>
&gt;&gt; I use cx88-dvb driver but many modules are loaded with it see<br>
&gt;&gt; <a href="http://kedge.wz.cz/dvb/lsmod.txt" target="_blank">http://kedge.wz.cz/dvb/lsmod.txt</a><br>
&gt;<br>
&gt; I meant to ask what is the origin of the driver. I use Igor&#39;s driver<br>
&gt; from:<br>
&gt; <a href="http://mercurial.intuxication.org/hg/s2-liplianin/" target="_blank">http://mercurial.intuxication.org/hg/s2-liplianin/</a><br>
<br>
</div>I use driver from vanilla kernel 2.6.28 which have DVB api version 5.0.<br>
<div class="Ih2E3d"><br>
&gt; If you have a S2API driver (or will use Igor&#39;s driver), you can use my<br>
&gt; scan-s2 application with many changes in NIT parsing that might resolve<br>
&gt; your<br>
&gt; issue.<br>
&gt; <a href="http://mercurial.intuxication.org/hg/scan-s2/" target="_blank">http://mercurial.intuxication.org/hg/scan-s2/</a><br>
&gt;<br>
<br>
</div>See below.<br>
<div class="Ih2E3d"><br>
&gt;&gt;<br>
&gt;&gt; Scan console output is in file <a href="http://kedge.wz.cz/dvb/channels.conf" target="_blank">http://kedge.wz.cz/dvb/channels.conf</a><br>
&gt;&gt; and the result in <a href="http://kedge.wz.cz/dvb/channels.conf" target="_blank">http://kedge.wz.cz/dvb/channels.conf</a><br>
&gt;<br>
&gt; You&#39;ve posted the same link for both outputs. Please post console output<br>
&gt; when you run scan with &quot;-v&quot; parameter. Maybe even with &quot;-vv&quot;.<br>
&gt;<br>
<br>
</div>The console output should be <a href="http://kedge.wz.cz/dvb/scanconsoleout.txt" target="_blank">http://kedge.wz.cz/dvb/scanconsoleout.txt</a>.<br>
<br>
I&#39;ve tried to run scan and scan-s2 on &quot;S 12188000 H 27500000 3/4&quot;<br>
were the &quot;RTL 2 Deutschland&quot; channel should be and neither scan found anything.<br>
<br>
The console outputs are here:<br>
<a href="http://kedge.wz.cz/dvb/scan.txt" target="_blank">http://kedge.wz.cz/dvb/scan.txt</a><br>
<a href="http://kedge.wz.cz/dvb/scans2.txt" target="_blank">http://kedge.wz.cz/dvb/scans2.txt</a></blockquote><div>I don&#39;t see any problem with scan output. I don&#39;t have the same card as yours, so only guessing...<br>
<br>Do you have a diseqc on the way?<br>&nbsp;<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
<br>
If you want me to run the whole scan for &quot;S 11567500 V 22000000 5/6&quot; with -vv<br>
let me know and I&#39;ll do it.</blockquote><div>No, no need. <br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<div><div></div><div class="Wj3C7c"><br>
&gt;&gt;<br>
&gt;&gt; When console shows<br>
&gt;&gt; __tune_to_transponder:1508: ERROR: Setting frontend parameters failed:<br>
&gt;&gt; 22<br>
&gt;&gt; Invalid argument<br>
&gt;&gt;<br>
&gt;&gt; the dmesg prints<br>
&gt;&gt; DVB: adapter 0 frontend 0 frequency 8175750 out of range<br>
&gt;&gt; (950000..2150000)<br>
&gt;<br>
&gt; It could be anything. Bad NIT message (most probably) or a memory<br>
&gt; smashing<br>
&gt; in scan application.<br>
&gt;<br>
&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; Roman<br>
&gt;&gt;<br>
&gt;&gt; _______________________________________________<br>
&gt;&gt; linux-dvb mailing list<br>
&gt;&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt;&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;&gt;<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_202118_17372172.1231015725810--


--===============1400967977==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1400967977==--
