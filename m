Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <matpic@free.fr>) id 1OEMWp-0000nZ-7w
	for linux-dvb@linuxtv.org; Tue, 18 May 2010 15:08:12 +0200
Received: from smtp2-g21.free.fr ([212.27.42.2])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OEMWk-0004zH-BJ; Tue, 18 May 2010 15:08:10 +0200
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id D3B734B0089
	for <linux-dvb@linuxtv.org>; Tue, 18 May 2010 15:08:00 +0200 (CEST)
Received: from [192.168.1.252] (bog44-1-82-231-133-211.fbx.proxad.net
	[82.231.133.211]) by smtp2-g21.free.fr (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Tue, 18 May 2010 15:07:59 +0200 (CEST)
Message-ID: <4BF290A2.1020904@free.fr>
Date: Tue, 18 May 2010 15:05:38 +0200
From: matpic <matpic@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] new DVB-T initial tuning for fr-nantes
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0049317757=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0049317757==
Content-Type: multipart/alternative;
 boundary="------------090407080300020106030609"

This is a multi-part message in MIME format.
--------------090407080300020106030609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

hello
As from today (18/05/2010) there is new frequency since analogic signal
is stopped and is now only numeric.


guard-interval has to be set to AUTO or scan find anything
 (1/32, 1/16, 1/8 ,1/4 doesn't work)


# Nantes - France
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 538000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 490000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 546000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 658000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 682000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 738000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
#same frequency + offset 167000000 for some hardware DVB-T tuner
T 538167000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 546167000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 658167000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 682167000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 738167000 8MHz 2/3 NONE QAM64 8k AUTO NONE






--------------090407080300020106030609
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
</head>
<body text="#000000" bgcolor="#ffffff">
hello<br>
As from today (18/05/2010) there is new frequency since analogic signal
is stopped and is now only numeric.<br>
<br>
<br>
guard-interval has to be set to AUTO or scan find anything<br>
&nbsp;(1/32, 1/16, 1/8 ,1/4 doesn't work)<br>
<br>
<br>
# Nantes - France<br>
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy<br>
T 538000000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
T 490000000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
T 546000000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
T 658000000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
T 682000000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
T 738000000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
#same frequency + offset 167000000 for some hardware DVB-T tuner<br>
T 538167000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
T 546167000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
T 658167000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
T 682167000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
T 738167000 8MHz 2/3 NONE QAM64 8k AUTO NONE<br>
<br>
<br>
<pre><big><big>

</big></big></pre>
<br>
</body>
</html>

--------------090407080300020106030609--


--===============0049317757==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0049317757==--
