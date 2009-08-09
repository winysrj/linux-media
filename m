Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from router.gangkast.nl ([82.95.231.74] helo=mail.gangkast.nl)
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <expires-jan10@gangkast.nl>) id 1MaFuY-0003Nq-EP
	for linux-dvb@linuxtv.org; Sun, 09 Aug 2009 23:26:38 +0200
Received: from [192.168.101.150] (dhcp-150.gangkast.int [192.168.101.150])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.gangkast.nl (Postfix) with ESMTPSA id 993B4506EE
	for <linux-dvb@linuxtv.org>; Sun,  9 Aug 2009 23:25:59 +0200 (CEST)
Message-ID: <4A7F3EE9.3080506@gangkast.nl>
Date: Sun, 09 Aug 2009 23:26:01 +0200
From: Martijn <expires-jan10@gangkast.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] diseqc 2.0 on stb0899 / pctv452e (TT S2-3xxx and the
	likes)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi All,

This has been addressed before, but I cannot find any specifics on the 
list or on the net in general regarding.

I'm trying to get a Spaun SAR 411F switch to work with a TT S2-3650. The 
SAR only talks diseqc 2.0 according to the specs and works perfectly on 
an Nexus-S setup. When I try to scan through the switch using the 
S2-3650 (old dvbscan or the new scan-s2 utility) nothing happens (tuning 
status == 0x00), whilst a direct connection /without the switch/ pose no 
problem at all.

When I go through the s2-liplianin dvb drivers I noticed the DiSEqC 2.0 
freq marker in the stb0899_priv.h header file. Also according to the 
STB0899 datasheet DiSEqC 2.0 is supported. Does this mean that the 
pctv452e driver does not implement the 2.0 specifications? I have seen 
the S2-3650 work through a DiSEqC 1.0 switch without any problems.

Could someone shed some light on this matter? Am I missing something 
here? Perhaps the pragmatic approach would be to change the switch 
albeit a fine one.

thank in advance,
regards,
Martijn

-- 
31.69 nHz = once a year


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
