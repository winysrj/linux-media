Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1K6ie1-0007U8-O5
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 10:58:58 +0200
Received: by ug-out-1314.google.com with SMTP id m3so306612uge.20
	for <linux-dvb@linuxtv.org>; Thu, 12 Jun 2008 01:58:54 -0700 (PDT)
Message-ID: <e37d7f810806120158g6257b7a9h429dd8b8f885321e@mail.gmail.com>
Date: Thu, 12 Jun 2008 09:58:53 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <4850566E.8030001@iki.fi>
MIME-Version: 1.0
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
	<4850566E.8030001@iki.fi>
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0966762925=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0966762925==
Content-Type: multipart/alternative;
	boundary="----=_Part_18580_32022064.1213261133203"

------=_Part_18580_32022064.1213261133203
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/6/11 Antti Palosaari <crope@iki.fi>:

> Andrew Websdale wrote:
>
>> I got the front end info from dvbsnoop last night & it says its a Zarlink
>> MT352, but I should try to open the stick anyway to clear up exactly what
>> chips it uses, although I think its moulded plastics so I'll have to cut it
>> open.
>> Andrew
>>
>
> If dvbsnoop says that there is Zarlink MT352, then there should be.
>
> It should be also seen from the log, try to look your message.log again to
> see if there is mention about Zarlink MT352 demodulator / frontend and
> Quantek QT1010 tuner.
>
> It could be also possible that tuner is not working.
>
> Antti
> --
> http://palosaari.fi/




I've examined the logs, & I can find no mention of a Quantek tuner - your
suggestion of a non-working tuner seems likely, as tuning is what doesn't
seem to work when I run e.g. w_scan - can you make any suggestion as to
where I go from here? I'm more than willing to test new code etc.
regards Andrew

------=_Part_18580_32022064.1213261133203
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">2008/6/11 Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">Andrew Websdale wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I got the front end info from dvbsnoop last night &amp; it says its a Zarlink MT352, but I should try to open the stick anyway to clear up exactly what chips it uses, although I think its moulded plastics so I&#39;ll have to cut it open.<br>

Andrew <br>
</blockquote>
<br></div>
If dvbsnoop says that there is Zarlink MT352, then there should be.<br>
<br>
It should be also seen from the log, try to look your message.log again to see if there is mention about Zarlink MT352 demodulator / frontend and Quantek QT1010 tuner.<br>
<br>
It could be also possible that tuner is not working.<br>
<br>
Antti<br><font color="#888888">
-- <br>
<a href="http://palosaari.fi/" target="_blank">http://palosaari.fi/</a></font></blockquote><div><br><br><br>I&#39;ve examined the logs, &amp; I can find no mention of a Quantek tuner - your suggestion of a non-working tuner seems likely, as tuning is what doesn&#39;t seem to work when I run e.g. w_scan - can you make any suggestion as to where I go from here? I&#39;m more than willing to test new code etc.<br>
regards Andrew<br></div></div><br>

------=_Part_18580_32022064.1213261133203--


--===============0966762925==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0966762925==--
