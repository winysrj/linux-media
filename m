Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <reversemirror@gmail.com>) id 1KVowf-000472-HM
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 16:45:59 +0200
Received: by yx-out-2324.google.com with SMTP id 8so180924yxg.41
	for <linux-dvb@linuxtv.org>; Wed, 20 Aug 2008 07:45:53 -0700 (PDT)
Message-ID: <12ec05d20808200745j3a6dcb89qc5c1428f4079d2a9@mail.gmail.com>
Date: Wed, 20 Aug 2008 16:45:52 +0200
From: "fred asper" <reversemirror@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] [Debian] scan with "WARNING: >>> tuning failed!!!"
	output
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2041163628=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2041163628==
Content-Type: multipart/alternative;
	boundary="----=_Part_29621_29270799.1219243552541"

------=_Part_29621_29270799.1219243552541
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello All,

I bought a Pinnacle PCTV nanostick (73e) and I have this problem:

when I scan my frequencies with 'scan' command (scan -a 0 freq.txt), my
output is like bottom:

==============================
>>> tune to:
514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
(tuning failed)
==============================
and this output is equal for all frequencies of my file.

The Pinnacle works correctly because I can capture streaming of channels
with 'dvbstream' command (with the option '-tm 8', I live in Italy).

SystemInfo:
Debian 2.6.26.2 64bit, this kernel has support for this Pinnacle embedded
[With 3 different kernel I have same error]
4 GB RAM

Someone can help me?

Thank you.

r.

------=_Part_29621_29270799.1219243552541
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hello All,<br><br>I bought a Pinnacle PCTV nanostick (73e) and I have this problem:<br><br>when I scan my frequencies with &#39;scan&#39; command (scan -a 0 freq.txt), my output is like bottom:<br><br>==============================<br>
&gt;&gt;&gt; tune to: 514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)<br>==============================<br>and this output is equal for all frequencies of my file.<br>
<br>The Pinnacle works correctly because I can capture streaming of channels with &#39;dvbstream&#39; command (with the option &#39;-tm 8&#39;, I live in Italy).<br><br>SystemInfo:<br>Debian <a href="http://2.6.26.2">2.6.26.2</a> 64bit, this kernel has support for this Pinnacle embedded [With 3 different kernel I have same error]<br>
4 GB RAM<br><br>Someone can help me?<br><br>Thank you.<br><br>r.<br></div>

------=_Part_29621_29270799.1219243552541--


--===============2041163628==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2041163628==--
