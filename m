Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bcjenkins@tvwhere.com>) id 1K8bI2-0007We-Gq
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 15:32:03 +0200
Received: by ug-out-1314.google.com with SMTP id m3so600124uge.20
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 06:31:58 -0700 (PDT)
Message-Id: <1E35FDF4-8D68-47AA-9DA6-B880879274E2@tvwhere.com>
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v924)
Date: Tue, 17 Jun 2008 09:31:55 -0400
Subject: [linux-dvb] cx18 or tveeprom - Missing dependency?
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

Greetings,

I choose to compile only the modules which are required for the  
hardware in my system as a way to speed up compilation times. When  
compiling for the v4l-dvb I run make menuconfig and deselect the  
modules for the adapters  not in my system. If I don't compile in  
Simple tuner support the cx18 load process throws and error in tveeprom.

Brandon

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
