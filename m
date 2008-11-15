Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1001.centrum.cz ([90.183.38.131])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hoppik@centrum.cz>) id 1L18dp-0004tO-AZ
	for linux-dvb@linuxtv.org; Sat, 15 Nov 2008 01:03:58 +0100
Received: by mail1001.centrum.cz id S805461087AbYKOADu (ORCPT
	<rfc822;linux-dvb@linuxtv.org>); Sat, 15 Nov 2008 01:03:50 +0100
Date: Sat, 15 Nov 2008 01:03:50 +0100
From: " =?UTF-8?Q?SKO=C4=8CDOPOLE?= =?UTF-8?Q?=20Tom=C3=A1=C5=A1?="
	<hoppik@centrum.cz>
To: <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <200811150103.6270@centrum.cz>
References: <200811150055.1169@centrum.cz> <200811150056.2998@centrum.cz>
	<200811150057.15665@centrum.cz> <200811150059.10919@centrum.cz>
	<200811150100.884@centrum.cz> <200811150101.16760@centrum.cz>
	<200811150102.22526@centrum.cz> <200811150103.22880@centrum.cz>
In-Reply-To: <200811150103.22880@centrum.cz>
Subject: [linux-dvb] S2API, TT S2-3200, getstream
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

Hello, 

I have got a TT S2-3200 card, kernel version 2.6.27. 
Now I am trying S2API drivers from Igor M. Liplianin - compiled without any problems.

I have compiled latest getstream too. It works fine with DVB-S channels (I tested 4 channels this time).
I want to try DVB-S2 channels too, but after run getstream I give this error message:
 2008-11-15 00:37:32.189 fe: Adapter 0 is an DVB-S card - config is not for DVB-S

I use same configuration file when I have old drivers - it was without any problems. 
So I think conf. file should be written without errors.

I have parabola directed to 23.5E, so I could try locking on some channels and scan-s2 utility.
Are there (23.5) any problematic channels?

Regards, Thomas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
