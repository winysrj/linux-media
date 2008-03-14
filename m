Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <krzysztof.burghardt@gmail.com>) id 1JaHQz-0002bC-4S
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 22:27:25 +0100
Received: by el-out-1112.google.com with SMTP id o28so2376477ele.2
	for <linux-dvb@linuxtv.org>; Fri, 14 Mar 2008 14:27:21 -0700 (PDT)
Message-ID: <80bd11420803141427t78e3251ck2f0bfbbbb2be4d45@mail.gmail.com>
Date: Fri, 14 Mar 2008 22:27:20 +0100
From: "Krzysztof Burghardt" <krzysztof@burghardt.pl>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Initial scan file for Warsaw, Poland
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello all,

I found that there is no pl-Warsaw DVB-T file with initial information
for scan. After scanning I found 15 services on two multiplexes. Both
muxes are intended for test purpose only and theirs parameters may
change (thus all fields set to auto).

Available services:
690 MHz (channel 48): TVP POLONIA, TVP2, TVP INFO, TVP HISTORIA, TVP
KULTURA, TVP SPORT, PR1, PR2, PR3, TVP1 (AC3).
746 MHz (channel 55): TVN_AVC, TV4_AVC, Polsat_AVC, TVN Siedem, HD test.

dvb-t/pl-Warsaw:
---[ cut here ]---
# DVB-T in Warsaw, Poland
# (test emission only, all parameters may change)
T 690000000 AUTO AUTO AUTO AUTO AUTO AUTO NONE
T 746000000 AUTO AUTO AUTO AUTO AUTO AUTO NONE
---[ cut here ]---

Regards,
-- 
Krzysztof Burghardt <krzysztof@burghardt.pl>
http://www.burghardt.pl/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
