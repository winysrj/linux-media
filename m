Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L7bV5-0006ua-H6
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 21:05:40 +0100
Received: by qw-out-2122.google.com with SMTP id 9so880192qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 12:05:35 -0800 (PST)
Message-ID: <c74595dc0812021205x22936540w9ce74549f07339ff@mail.gmail.com>
Date: Tue, 2 Dec 2008 22:05:35 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: e9hack <e9hack@googlemail.com>
In-Reply-To: <49358FE8.9020701@googlemail.com>
MIME-Version: 1.0
References: <492168D8.4050900@googlemail.com>
	<19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>
	<c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>
	<49358FE8.9020701@googlemail.com>
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
Content-Type: multipart/mixed; boundary="===============0488520883=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0488520883==
Content-Type: multipart/alternative;
	boundary="----=_Part_108095_23449740.1228248335250"

------=_Part_108095_23449740.1228248335250
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Dec 2, 2008 at 9:43 PM, e9hack <e9hack@googlemail.com> wrote:

> Alex Betis schrieb:
>  > I don't understand what's wrong with NIT advartised frequency?
> > For example, many satelite sites (such as lyngsat) have different
> > frequencies listed for the same channel, generally a difference of 1 MHz
> > here and there.
>
> If I do scan the tuned transponder only (parameter '-c'), scan will copy
> all NIT entries
> to the same transponder data. The output contains the last frequency, which
> was found. On
> DVB-C, the NIT contains the frequencies of all transponders. If VDR has
> tuned to the
> 113MHz transponder and I scan this transponder, I should got 113MHz and
> QAM64 modulation,
> but I get e.g. 466MHz and QAM256 modulation. The frequency changes on every
> scan.

What driver and scan utility do you use?
If you use S2API driver, please try my scan-s2 from here:
http://mercurial.intuxication.org/hg/scan-s2/

I did several fixes in that area. If it still doesn't work, please run it
with "-vv" or "-vvv", (don't remember what level is needed) until you'll see
a HEX dump of the messages, send it to me and I'll take a look.


>
> -Hartmut
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_108095_23449740.1228248335250
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Tue, Dec 2, 2008 at 9:43 PM, e9hack <span dir="ltr">&lt;<a href="mailto:e9hack@googlemail.com">e9hack@googlemail.com</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Alex Betis schrieb:<br>
<div class="Ih2E3d">&nbsp;&gt; I don&#39;t understand what&#39;s wrong with NIT advartised frequency?<br>
&gt; For example, many satelite sites (such as lyngsat) have different<br>
&gt; frequencies listed for the same channel, generally a difference of 1 MHz<br>
&gt; here and there.<br>
<br>
</div>If I do scan the tuned transponder only (parameter &#39;-c&#39;), scan will copy all NIT entries<br>
to the same transponder data. The output contains the last frequency, which was found. On<br>
DVB-C, the NIT contains the frequencies of all transponders. If VDR has tuned to the<br>
113MHz transponder and I scan this transponder, I should got 113MHz and QAM64 modulation,<br>
but I get e.g. 466MHz and QAM256 modulation. The frequency changes on every scan.</blockquote><div>What driver and scan utility do you use?<br>If you use S2API driver, please try my scan-s2 from here:<br><a href="http://mercurial.intuxication.org/hg/scan-s2/">http://mercurial.intuxication.org/hg/scan-s2/</a><br>
<br>I did several fixes in that area. If it still doesn&#39;t work, please run it with &quot;-vv&quot; or &quot;-vvv&quot;, (don&#39;t remember what level is needed) until you&#39;ll see a HEX dump of the messages, send it to me and I&#39;ll take a look.<br>
<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
-Hartmut<br>
<div><div></div><div class="Wj3C7c"><br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_108095_23449740.1228248335250--


--===============0488520883==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0488520883==--
