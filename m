Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1K6mhv-0006yN-Jg
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 15:19:17 +0200
Received: by ug-out-1314.google.com with SMTP id m3so364254uge.20
	for <linux-dvb@linuxtv.org>; Thu, 12 Jun 2008 06:19:10 -0700 (PDT)
Message-ID: <e37d7f810806120619q28bff0d8y8f2d5319187ab6b0@mail.gmail.com>
Date: Thu, 12 Jun 2008 14:19:09 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <4850F597.9030603@iki.fi>
MIME-Version: 1.0
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
	<4850566E.8030001@iki.fi>
	<e37d7f810806120158g6257b7a9h429dd8b8f885321e@mail.gmail.com>
	<4850F597.9030603@iki.fi>
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1172219586=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1172219586==
Content-Type: multipart/alternative;
	boundary="----=_Part_19549_6823236.1213276749942"

------=_Part_19549_6823236.1213276749942
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/6/12 Antti Palosaari <crope@iki.fi>:

> Andrew Websdale wrote:
>
>> I've examined the logs, & I can find no mention of a Quantek tuner - your
>> suggestion of a non-working tuner seems likely, as tuning is what doesn't
>> seem to work when I run e.g. w_scan - can you make any suggestion as to
>> where I go from here? I'm more than willing to test new code etc.
>> regards Andrew
>>
>
> OK, then the reason might by tuner. Tuner may be changed to other one or
> tuner i2c-address is changed. I doubt whole tuner is changed. Now we should
> identify which tuner is used. There is some ways how to do that.
>
> 1) Look from Windows driver files
> 2) Open stick and look chips
> 3) Take USB-sniffs and try to identify tuner from there
>
> regards
> Antti
> --
> http://palosaari.fi/



I shall try these things tonight - thanks for your advice

------=_Part_19549_6823236.1213276749942
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">2008/6/12 Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">Andrew Websdale wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I&#39;ve examined the logs, &amp; I can find no mention of a Quantek tuner - your suggestion of a non-working tuner seems likely, as tuning is what doesn&#39;t seem to work when I run e.g. w_scan - can you make any suggestion as to where I go from here? I&#39;m more than willing to test new code etc.<br>

regards Andrew<br>
</blockquote>
<br></div>
OK, then the reason might by tuner. Tuner may be changed to other one or tuner i2c-address is changed. I doubt whole tuner is changed. Now we should identify which tuner is used. There is some ways how to do that.<br>
<br>
1) Look from Windows driver files<br>
2) Open stick and look chips<br>
3) Take USB-sniffs and try to identify tuner from there<br>
<br>
regards<br>
Antti<br><font color="#888888">
-- <br>
<a href="http://palosaari.fi/" target="_blank">http://palosaari.fi/</a></font></blockquote><div><br><br>I shall try these things tonight - thanks for your advice <br></div></div><br>

------=_Part_19549_6823236.1213276749942--


--===============1172219586==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1172219586==--
