Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <damien@damienandlaurel.com>) id 1Kxx24-0003yR-F8
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 06:03:49 +0100
Received: by ik-out-1112.google.com with SMTP id c28so375819ika.1
	for <linux-dvb@linuxtv.org>; Wed, 05 Nov 2008 21:03:44 -0800 (PST)
Message-ID: <ee0ad0230811052103u16edf7d9ia7b1e13440257724@mail.gmail.com>
Date: Thu, 6 Nov 2008 16:03:43 +1100
From: "Damien Morrissey" <damien@damienandlaurel.com>
To: "Lindsay Mathieson" <lindsay@softlog.com.au>
In-Reply-To: <4912780C.8010106@softlog.com.au>
MIME-Version: 1.0
References: <4912780C.8010106@softlog.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dvico Fusion Pro
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1595220381=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1595220381==
Content-Type: multipart/alternative;
	boundary="----=_Part_556_6978479.1225947823740"

------=_Part_556_6978479.1225947823740
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Nov 6, 2008 at 3:52 PM, Lindsay Mathieson <lindsay@softlog.com.au>wrote:

> Hi All, I have a Fusion Pro I'm testing with. Have installed the latest
> v4l-dvb drivers as per the wiki and the board is recognised correctly on
> boot and registers a /dev/dvb/adaptor0 device. However it is uable to
> tune anything - a "scan < au-Brisbane" runs with no errors, but finds no
> stations.
>
> However if I install the pascoe drivers:
>  http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/<http://www.itee.uq.edu.au/%7Echrisp/Linux-DVB/DVICO/>
>  http://linuxtv.org/hg/~pascoe/xc-test/<http://linuxtv.org/hg/%7Epascoe/xc-test/>
>
> Its works fine - picks up the brisbane stations and displays them via
> mythtv
>
> I thought the pascoe drivers were merged into the trunk ages ago - am I
> mistaken?
>
> Thanks,
>
> Lindsay
>
> p.s My setup is a test PC and I can run tests as needed - doesn't matter
> if it breaks.
>
> --
> Lindsay
> Softlog Systems
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
Lindsay,
I too seem to have an issue with tuning and DVICO drivers. Since I upgraded
to mythbuntu 8.10 I have found my DViCO Dual Digital 4 has loaded proprly
with no errors (thanks to the inclusion of xc... firmware), however no
stations could be scanned with the firmware that came with it.

When I used the pascoe drivers in 8.04 I was able to tune stations.

Might this be related to the 7MHz issues in the past (with Australia having
7MHz channels)?

Cheers,
Damien.

------=_Part_556_6978479.1225947823740
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Thu, Nov 6, 2008 at 3:52 PM, Lindsay Mathieson <span dir="ltr">&lt;<a href="mailto:lindsay@softlog.com.au">lindsay@softlog.com.au</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi All, I have a Fusion Pro I&#39;m testing with. Have installed the latest<br>
v4l-dvb drivers as per the wiki and the board is recognised correctly on<br>
boot and registers a /dev/dvb/adaptor0 device. However it is uable to<br>
tune anything - a &quot;scan &lt; au-Brisbane&quot; runs with no errors, but finds no<br>
stations.<br>
<br>
However if I install the pascoe drivers:<br>
 &nbsp;<a href="http://www.itee.uq.edu.au/%7Echrisp/Linux-DVB/DVICO/" target="_blank">http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/</a><br>
 &nbsp;<a href="http://linuxtv.org/hg/%7Epascoe/xc-test/" target="_blank">http://linuxtv.org/hg/~pascoe/xc-test/</a><br>
<br>
Its works fine - picks up the brisbane stations and displays them via mythtv<br>
<br>
I thought the pascoe drivers were merged into the trunk ages ago - am I<br>
mistaken?<br>
<br>
Thanks,<br>
<br>
Lindsay<br>
<br>
p.s My setup is a test PC and I can run tests as needed - doesn&#39;t matter<br>
if it breaks.<br>
<br>
--<br>
Lindsay<br>
Softlog Systems<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div>Lindsay,<br>I too seem to have an issue with tuning and DVICO drivers. Since I upgraded to mythbuntu 8.10 I have found my DViCO Dual Digital 4 has loaded proprly with no errors (thanks to the inclusion of xc... firmware), however no stations could be scanned with the firmware that came with it.<br>
<br>When I used the pascoe drivers in 8.04 I was able to tune stations.<br><br>Might this be related to the 7MHz issues in the past (with Australia having 7MHz channels)?<br><br>Cheers,<br>Damien.<br>

------=_Part_556_6978479.1225947823740--


--===============1595220381==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1595220381==--
