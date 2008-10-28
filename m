Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KuuA9-00064V-NU
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 20:23:34 +0100
Received: by qw-out-2122.google.com with SMTP id 9so1293250qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 12:23:28 -0700 (PDT)
Message-ID: <c74595dc0810281223j25d78c9eqbcbed70a1b495b43@mail.gmail.com>
Date: Tue, 28 Oct 2008 21:23:28 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "oleg roitburd" <oroitburd@gmail.com>
In-Reply-To: <b42fca4d0810280227n44d53f03hfaa8237793fc1db9@mail.gmail.com>
MIME-Version: 1.0
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<b42fca4d0810280227n44d53f03hfaa8237793fc1db9@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0003631542=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0003631542==
Content-Type: multipart/alternative;
	boundary="----=_Part_129173_14231309.1225221808557"

------=_Part_129173_14231309.1225221808557
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Oleg,

I had plans to do most of the things you've requested, but had no time and
decided to release the utility without those options so it will be tested.
I'll send an update when it will be ready.

A question about modulation. Can you point me to a place that describe what
modulation number N means what?
"man 5 vdr" lists the options, but its impossible to understand the mapping:
"M   Modulation (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16, 32, 64, 128, 256,
512, 998, 1024)"

FEC you can specify in the frequency file as "AUTO", "1/3", "2/3" and so on.
I'll update README to make it clear. All frequency files samples show that
option.



On Tue, Oct 28, 2008 at 11:27 AM, oleg roitburd <oroitburd@gmail.com> wrote:

> Hi,
>
> 2008/10/25 Alex Betis <alex.betis@gmail.com>:
> > Hello all,
> >
> > I've setup the http://mercurial.intuxication.org/hg/scan-s2/ repository
> with
> > scan utility ported to work with Igor's S2API driver.
> > Driver is available here:
> http://mercurial.intuxication.org/hg/s2-liplianin/
> >
> > Special thanks to Igor for his driver and for szap-s2 utility that I've
> used
> > as a reference for scan-s2.
> > Thanks also to someone from the net that posted his changes to scan
> utility
> > that allowed it to work with uncommitted diseqc.
> >
> > Pay attention to parameters (see README as well), I've added some and
> > removed some that I don't think are needed.
> >
> > Scan results gave me the same channels as with multiproto driver on all
> my
> > satellites, so that confirms also that Igor's driver is working well.
> >
> > I didn't yet tested the output files with szap-s2 or with VDR, don't have
> > time right now.
> > Please test and let me know if changes are needed.
> >
> > I have only Twinhan 1041 card (stb0899), so I can't test it with DVB-T,
> > DVB-C and ATSC standarts, but theoretically it should work.
> >
> > Enjoy,
> > Alex.
>
> Thank you for this usefull tool. I have tried them with TT S2-3200.
> It works with s2-liplianin.
> Some question
> Is it possible to implement in vdr-dump
> 1. Options for Modulation (MN where N=2  is QPSK if DVB-S and N=2 for
> QPSK and N=5 for 8PSK)
> 2. Options for FEC. As I know cx24116 can't FEC AUTO for DVB-S2
> 3. ROLLOFF?
> 4. CAID dump.
> http://arvdr-dev.free-x.de:8080/freex-dvb-apps/rev/47e9dbb968fc
> 5. Channel Name encoding to UTF.
> http://arvdr-dev.free-x.de:8080/freex-dvb-apps/rev/55bf7441a602
>
> Thx a lot
> Oleg Roitburd
>

------=_Part_129173_14231309.1225221808557
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi Oleg,<br><br>I had plans to do most of the things you&#39;ve requested, but had no time and decided to release the utility without those options so it will be tested. I&#39;ll send an update when it will be ready.<br>
<br>A question about modulation. Can you point me to a place that describe what modulation number N means what?<br>&quot;man 5 vdr&quot; lists the options, but its impossible to understand the mapping:<br>&quot;M&nbsp;&nbsp; Modulation (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16, 32, 64, 128, 256, 512, 998, 1024)&quot;<br>
<br>FEC you can specify in the frequency file as &quot;AUTO&quot;, &quot;1/3&quot;, &quot;2/3&quot; and so on. I&#39;ll update README to make it clear. All frequency files samples show that option.<br><br><br><br><div class="gmail_quote">
On Tue, Oct 28, 2008 at 11:27 AM, oleg roitburd <span dir="ltr">&lt;<a href="mailto:oroitburd@gmail.com">oroitburd@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<br>
2008/10/25 Alex Betis &lt;<a href="mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&gt;:<br>
<div><div></div><div class="Wj3C7c">&gt; Hello all,<br>
&gt;<br>
&gt; I&#39;ve setup the <a href="http://mercurial.intuxication.org/hg/scan-s2/" target="_blank">http://mercurial.intuxication.org/hg/scan-s2/</a> repository with<br>
&gt; scan utility ported to work with Igor&#39;s S2API driver.<br>
&gt; Driver is available here: <a href="http://mercurial.intuxication.org/hg/s2-liplianin/" target="_blank">http://mercurial.intuxication.org/hg/s2-liplianin/</a><br>
&gt;<br>
&gt; Special thanks to Igor for his driver and for szap-s2 utility that I&#39;ve used<br>
&gt; as a reference for scan-s2.<br>
&gt; Thanks also to someone from the net that posted his changes to scan utility<br>
&gt; that allowed it to work with uncommitted diseqc.<br>
&gt;<br>
&gt; Pay attention to parameters (see README as well), I&#39;ve added some and<br>
&gt; removed some that I don&#39;t think are needed.<br>
&gt;<br>
&gt; Scan results gave me the same channels as with multiproto driver on all my<br>
&gt; satellites, so that confirms also that Igor&#39;s driver is working well.<br>
&gt;<br>
&gt; I didn&#39;t yet tested the output files with szap-s2 or with VDR, don&#39;t have<br>
&gt; time right now.<br>
&gt; Please test and let me know if changes are needed.<br>
&gt;<br>
&gt; I have only Twinhan 1041 card (stb0899), so I can&#39;t test it with DVB-T,<br>
&gt; DVB-C and ATSC standarts, but theoretically it should work.<br>
&gt;<br>
&gt; Enjoy,<br>
&gt; Alex.<br>
<br>
</div></div>Thank you for this usefull tool. I have tried them with TT S2-3200.<br>
It works with s2-liplianin.<br>
Some question<br>
Is it possible to implement in vdr-dump<br>
1. Options for Modulation (MN where N=2 &nbsp;is QPSK if DVB-S and N=2 for<br>
QPSK and N=5 for 8PSK)<br>
2. Options for FEC. As I know cx24116 can&#39;t FEC AUTO for DVB-S2<br>
3. ROLLOFF?<br>
4. CAID dump. &nbsp;<a href="http://arvdr-dev.free-x.de:8080/freex-dvb-apps/rev/47e9dbb968fc" target="_blank">http://arvdr-dev.free-x.de:8080/freex-dvb-apps/rev/47e9dbb968fc</a><br>
5. Channel Name encoding to UTF.<br>
<a href="http://arvdr-dev.free-x.de:8080/freex-dvb-apps/rev/55bf7441a602" target="_blank">http://arvdr-dev.free-x.de:8080/freex-dvb-apps/rev/55bf7441a602</a><br>
<br>
Thx a lot<br>
<font color="#888888">Oleg Roitburd<br>
</font></blockquote></div><br></div>

------=_Part_129173_14231309.1225221808557--


--===============0003631542==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0003631542==--
