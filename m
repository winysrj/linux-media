Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L7YRw-0007mp-Dt
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 17:50:13 +0100
Received: by qyk9 with SMTP id 9so3593969qyk.17
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 08:49:38 -0800 (PST)
Message-ID: <c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>
Date: Tue, 2 Dec 2008 18:49:38 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Christoph Pfister" <christophpfister@gmail.com>
In-Reply-To: <19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>
MIME-Version: 1.0
References: <492168D8.4050900@googlemail.com>
	<19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH]Fix a bug in scan,
	which outputs the wrong frequency if the current tuned transponder
	is scanned only
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0645565337=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0645565337==
Content-Type: multipart/alternative;
	boundary="----=_Part_104194_25976530.1228236578247"

------=_Part_104194_25976530.1228236578247
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Dec 2, 2008 at 6:34 PM, Christoph Pfister <
christophpfister@gmail.com> wrote:

> 2008/11/17 e9hack <e9hack@googlemail.com>:
> > Hi,
> >
> > if the current tuned transponder is scanned only and the output needs the
> frequency of the
> > transponder, it is used the last frequency, which is found during the NIT
> scanning. This
> > is wrong. The attached patch will fix this problem.

I probably missed that post (or forgot about it already :)).

What scan is being discused? dvb-apps scan utility (or the scan-s2 that I
maintain)?


>
>
> Any opinion about this patch? It seems ok from a quick look, so I'll
> apply it soon if nobody objects.

I don't understand what's wrong with NIT advartised frequency?
For example, many satelite sites (such as lyngsat) have different
frequencies listed for the same channel, generally a difference of 1 MHz
here and there. That's probably caused since wide scans are probably done on
all the possible frequencies.
Since driver tunning algorithm can zigzag in some frequency bounds it will
probably be able to lock on the channel if you'll specify frequencies such
as the following, assuming the real channel frequency is 12000000:
11998000
11999000
12000000
12001000
12002000

NIT specifies the correct frequency and that one should be used next time to
tune.

Am I missing something?

>
>
> > Regards,
> > Hartmut
>
> Thanks,
>
> Christoph
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_104194_25976530.1228236578247
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br>
<div class="gmail_quote">On Tue, Dec 2, 2008 at 6:34 PM, Christoph Pfister <span dir="ltr">&lt;<a href="mailto:christophpfister@gmail.com">christophpfister@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">2008/11/17 e9hack &lt;<a href="mailto:e9hack@googlemail.com">e9hack@googlemail.com</a>&gt;:<br>&gt; Hi,<br>
&gt;<br>&gt; if the current tuned transponder is scanned only and the output needs the frequency of the<br>&gt; transponder, it is used the last frequency, which is found during the NIT scanning. This<br>&gt; is wrong. The attached patch will fix this problem.</blockquote>

<div>I probably missed that post (or forgot about it already :)).</div>
<div>&nbsp;</div>
<div>What scan is being discused? dvb-apps scan utility (or the scan-s2 that I maintain)?</div>
<div>&nbsp;</div>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=""></span><br><br>Any opinion about this patch? It seems ok from a quick look, so I&#39;ll<br>apply it soon if nobody objects.</blockquote>

<div>I don&#39;t understand what&#39;s wrong with NIT advartised frequency?</div>
<div>For example, many satelite sites (such as lyngsat) have different frequencies listed for the same channel, generally a difference of 1 MHz here and there. That&#39;s probably caused since wide scans are probably done on all the possible frequencies.</div>

<div>Since driver tunning algorithm can zigzag in some frequency bounds it will probably be able to lock on the channel if you&#39;ll specify frequencies such as the following, assuming the real channel frequency is 12000000:</div>

<div>11998000</div>
<div>11999000</div>
<div>12000000</div>
<div>12001000</div>
<div>12002000</div>
<div>&nbsp;</div>
<div>NIT specifies the correct frequency and that one should be used next time to tune.</div>
<div>&nbsp;</div>
<div>Am I missing something?</div>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=""></span><br><br>&gt; Regards,<br>&gt; Hartmut<br><br>Thanks,<br><br>Christoph<br><br>_______________________________________________<br>
linux-dvb mailing list<br><a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

------=_Part_104194_25976530.1228236578247--


--===============0645565337==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0645565337==--
