Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JaWK6-0001To-Jq
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 14:21:24 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1629358tia.13
	for <linux-dvb@linuxtv.org>; Sat, 15 Mar 2008 06:21:13 -0700 (PDT)
Message-ID: <abf3e5070803150621k501c451lc7fc8a74efcf0977@mail.gmail.com>
Date: Sun, 16 Mar 2008 00:21:12 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>
MIME-Version: 1.0
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>
	<47D9C33E.6090503@iki.fi>
	<abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>
	<47D9EED4.8090303@linuxtv.org>
	<abf3e5070803132022g3e2c638fxc218030c535372b@mail.gmail.com>
	<47DA0F01.8010707@iki.fi> <47DA7008.8010404@linuxtv.org>
	<47DAC42D.7010306@iki.fi> <47DAC4BE.5090805@iki.fi>
	<abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0977304857=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0977304857==
Content-Type: multipart/alternative;
	boundary="----=_Part_6392_9079191.1205587273081"

------=_Part_6392_9079191.1205587273081
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>  Michael's patch didn't produce any interesting dmesg output. I included
>  dmesg for plugging in and tuning with antti's patch.
>
>  Jarryd.
>

Just realised I didn't have debug enabled for Michael's patch. When
tuning I got lots of this:

tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
tda18271_init_regs: initializing registers for device @ 1-00c0
tda18271_tune: freq = 219500000, ifc = 3800000, bw = 7000000, std = 0x1d

My keyboard was fine this time (that was the point it normally responded
really slowly), and the driver loaded instantly instead of taking nearly
half a minute.
It looks like it might be a step in the right direction, but it's still not
tuning.

Jarryd.

------=_Part_6392_9079191.1205587273081
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

&gt; &nbsp;Michael&#39;s patch didn&#39;t produce any interesting dmesg output. I included<br>&gt; &nbsp;dmesg for plugging in and tuning with antti&#39;s patch.<br>&gt; &nbsp;<br>&gt; &nbsp;Jarryd.<br>&gt; &nbsp;<br><br>Just realised I didn&#39;t have debug enabled for Michael&#39;s patch. When<br>
tuning I got lots of this:<br><br>tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0<br>tda18271_init_regs: initializing registers for device @ 1-00c0<br>tda18271_tune: freq = 219500000, ifc = 3800000, bw = 7000000, std = 0x1d<br>
<br>My keyboard was fine this time (that was the point it normally responded<br>really slowly), and the driver loaded instantly instead of taking nearly<br>half a minute.<br>It looks like it might be a step in the right direction, but it&#39;s still not tuning.<br>
<br>Jarryd.<br>

------=_Part_6392_9079191.1205587273081--


--===============0977304857==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0977304857==--
