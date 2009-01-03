Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LJDd9-000781-1y
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 22:01:59 +0100
Received: by qw-out-2122.google.com with SMTP id 9so3351476qwb.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 13:01:54 -0800 (PST)
Message-ID: <c74595dc0901031301k317f561dv1076b451ae8f36e2@mail.gmail.com>
Date: Sat, 3 Jan 2009 23:01:54 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: kedgedev@centrum.cz
In-Reply-To: <op.um68ku1qrj95b0@localhost>
MIME-Version: 1.0
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<op.um64vfdkrj95b0@localhost>
	<c74595dc0901031248h3c3d002j2422331c82249d78@mail.gmail.com>
	<op.um68ku1qrj95b0@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1033457413=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1033457413==
Content-Type: multipart/alternative;
	boundary="----=_Part_202313_13082039.1231016514679"

------=_Part_202313_13082039.1231016514679
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Jan 3, 2009 at 10:59 PM, Roman Jarosz <roman.jarosz@gmail.com>wrote:

> On Sat, 03 Jan 2009 21:48:45 +0100, Alex Betis <alex.betis@gmail.com>
> wrote:
>
> > On Sat, Jan 3, 2009 at 9:39 PM, Roman Jarosz <roman.jarosz@gmail.com>
> > wrote:
> >
> >> On Sat, 03 Jan 2009 19:58:45 +0100, Alex Betis <alex.betis@gmail.com>
> >> wrote:
> >>
> >> >> I use scan from dvb-apps, the command is
> >> >> "scan -o vdr /root/dvb/Astra-19.2E > /etc/vdr/channels.conf"
> >> >> where /root/dvb/Astra-19.2E is file with "S 11567500 V 22000000 5/6"
> >> >
> >> > I think that's the main issue. *BOUWSMA w*rote that its ok to rely on
> >> > astra's maintainers and connect to any transponder is enough to get a
> >> > list
> >> > of all others. I personaly don't trust those maintainers since I saw
> >> too
> >> > many errors in NIT messages that specify the transponder, so I specify
> >> > all
> >> > the frequencies I want to scan. I don't have a dish to 19.2, but there
> >> > were
> >> > many errors with 5 other satellites I have.
> >> > You can get a list of those frequencies here:
> >> > http://www.lyngsat.com/astra19.html
> >>
> >> Could you tell me how? I've tried with S 12188000 H 27500000 3/4 and
> >> it doesn't find anything.
> >
> > Try also scan-s2 with:
> > S 12188000 H 27500000 3/4 AUTO QPSK
>
> No luck :( http://kedge.wz.cz/dvb/scans2_2.txt

Have no more ideas. Probably a driver problem.



>
>
> > Do you have a diseqc on the way?
>
> No. I don't.


>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_202313_13082039.1231016514679
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Sat, Jan 3, 2009 at 10:59 PM, Roman Jarosz <span dir="ltr">&lt;<a href="mailto:roman.jarosz@gmail.com">roman.jarosz@gmail.com</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">On Sat, 03 Jan 2009 21:48:45 +0100, Alex Betis &lt;<a href="mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&gt; wrote:<br>
<br>
&gt; On Sat, Jan 3, 2009 at 9:39 PM, Roman Jarosz &lt;<a href="mailto:roman.jarosz@gmail.com">roman.jarosz@gmail.com</a>&gt;<br>
&gt; wrote:<br>
&gt;<br>
&gt;&gt; On Sat, 03 Jan 2009 19:58:45 +0100, Alex Betis &lt;<a href="mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&gt;<br>
&gt;&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt; &gt;&gt; I use scan from dvb-apps, the command is<br>
&gt;&gt; &gt;&gt; &quot;scan -o vdr /root/dvb/Astra-19.2E &gt; /etc/vdr/channels.conf&quot;<br>
&gt;&gt; &gt;&gt; where /root/dvb/Astra-19.2E is file with &quot;S 11567500 V 22000000 5/6&quot;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; I think that&#39;s the main issue. *BOUWSMA w*rote that its ok to rely on<br>
&gt;&gt; &gt; astra&#39;s maintainers and connect to any transponder is enough to get a<br>
&gt;&gt; &gt; list<br>
&gt;&gt; &gt; of all others. I personaly don&#39;t trust those maintainers since I saw<br>
&gt;&gt; too<br>
&gt;&gt; &gt; many errors in NIT messages that specify the transponder, so I specify<br>
&gt;&gt; &gt; all<br>
&gt;&gt; &gt; the frequencies I want to scan. I don&#39;t have a dish to 19.2, but there<br>
&gt;&gt; &gt; were<br>
&gt;&gt; &gt; many errors with 5 other satellites I have.<br>
&gt;&gt; &gt; You can get a list of those frequencies here:<br>
&gt;&gt; &gt; <a href="http://www.lyngsat.com/astra19.html" target="_blank">http://www.lyngsat.com/astra19.html</a><br>
&gt;&gt;<br>
&gt;&gt; Could you tell me how? I&#39;ve tried with S 12188000 H 27500000 3/4 and<br>
&gt;&gt; it doesn&#39;t find anything.<br>
&gt;<br>
&gt; Try also scan-s2 with:<br>
&gt; S 12188000 H 27500000 3/4 AUTO QPSK<br>
<br>
</div>No luck :( <a href="http://kedge.wz.cz/dvb/scans2_2.txt" target="_blank">http://kedge.wz.cz/dvb/scans2_2.txt</a></blockquote><div>Have no more ideas. Probably a driver problem. <br><br><br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<div class="Ih2E3d"><br>
<br>
&gt; Do you have a diseqc on the way?<br>
<br>
</div>No. I don&#39;t.</blockquote><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<div><div></div><div class="Wj3C7c"><br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_202313_13082039.1231016514679--


--===============1033457413==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1033457413==--
