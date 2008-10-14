Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <klaas.de.waal@gmail.com>) id 1KpeJZ-0003Yv-1m
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 09:27:35 +0200
Received: by qw-out-2122.google.com with SMTP id 9so607464qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 00:27:27 -0700 (PDT)
Message-ID: <7b41dd970810140027h41924a98oe343fb5d8c2ef485@mail.gmail.com>
Date: Tue, 14 Oct 2008 09:27:27 +0200
From: "klaas de waal" <klaas.de.waal@gmail.com>
To: "Arthur Konovalov" <artlov@gmail.com>
In-Reply-To: <48F3A113.50805@gmail.com>
MIME-Version: 1.0
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>
	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
	<1223598995.4825.12.camel@pc10.localdom.local>
	<7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>
	<48F3A113.50805@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1092998914=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1092998914==
Content-Type: multipart/alternative;
	boundary="----=_Part_2068_27390161.1223969247480"

------=_Part_2068_27390161.1223969247480
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Oct 13, 2008 at 9:27 PM, Arthur Konovalov <artlov@gmail.com> wrote:

> klaas de waal wrote:
> > I have now put in a frequency map table tda827x_dvbc
> > for DVB-C tuners only. This works OK for me and it should not modify the
> > behaviour with other non-DVB-C demodulators.
>
> Unfortunately still does not works with 386MHz, at least in my case.
> No lock, no picture...
> Is it possible that 386MHz and 388MHz are in different frequency
> segments? Which values I should tune? Any hint, please.
>
> AK
>
>
Hi Arthur,

My first patch extended the frequency segment to above 388MHz so the 386MHz
is in the same segment.
It is of course possible that 386MHz does not work but this is difficult to
test for me.

Question: which provider do you have?

Assuming you use "zap" to tune, you have a configuration file like this
(valid for some Dutch UPC regio's):
Ned1:386750000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:2001:2012:12141
Ned2:386750000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:2301:2312:12142
Ned3:386750000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:2601:2612:12143

Hints:
- use the exact frequency. if it is 386.75 use that and not 386
- fill in the correct symbol rate: 6900000 for UPC, 6875000 for Ziggo
  if this number is wrong you will not receive anything
- fill in the modulation exact, for both UPC and Ziggo this is QAM_64

Groetjes,
Klaas

------=_Part_2068_27390161.1223969247480
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br><div class="gmail_quote">On Mon, Oct 13, 2008 at 9:27 PM, Arthur Konovalov <span dir="ltr">&lt;<a href="mailto:artlov@gmail.com">artlov@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">klaas de waal wrote:<br>
&gt; I have now put in a frequency map table tda827x_dvbc<br>
&gt; for DVB-C tuners only. This works OK for me and it should not modify the<br>
&gt; behaviour with other non-DVB-C demodulators.<br>
<br>
</div>Unfortunately still does not works with 386MHz, at least in my case.<br>
No lock, no picture...<br>
Is it possible that 386MHz and 388MHz are in different frequency<br>
segments? Which values I should tune? Any hint, please.<br>
<font color="#888888"><br>
AK<br>
</font><div><div></div><div class="Wj3C7c"><br>
</div></div></blockquote><div><br></div></div>Hi Arthur,<br><br>My first patch extended the frequency segment to above 388MHz so the 386MHz is in the same segment.<br>It is of course possible that 386MHz does not work but this is difficult to test for me.<br>
<br>Question: which provider do you have? <br><br>Assuming you use &quot;zap&quot; to tune, you have a configuration file like this (valid for some Dutch UPC regio&#39;s):<br>Ned1:386750000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:2001:2012:12141<br>
Ned2:386750000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:2301:2312:12142<br>Ned3:386750000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:2601:2612:12143<br><br>Hints:<br>- use the exact frequency. if it is 386.75 use that and not 386<br>
- fill in the correct symbol rate: 6900000 for UPC, 6875000 for Ziggo<br>&nbsp; if this number is wrong you will not receive anything<br>- fill in the modulation exact, for both UPC and Ziggo this is QAM_64<br><br>Groetjes,<br>
Klaas<br><br><br></div>

------=_Part_2068_27390161.1223969247480--


--===============1092998914==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1092998914==--
