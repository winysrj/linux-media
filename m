Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <nmetcalf@starnewsgroup.com.au>) id 1OEs3S-0000m6-Qz
	for linux-dvb@linuxtv.org; Thu, 20 May 2010 00:47:59 +0200
Received: from [203.42.208.117] (helo=starnewsgroup.com.au)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OEs3R-00038P-1p; Thu, 20 May 2010 00:47:58 +0200
Received: from [192.168.101.247] (unknown [192.168.101.247])
	by starnewsgroup.com.au (Postfix) with ESMTP id 4103D4D404A
	for <linux-dvb@linuxtv.org>; Thu, 20 May 2010 08:47:47 +1000 (EST)
Message-ID: <4BF583EB.7080505@starnewsgroup.com.au>
Date: Fri, 21 May 2010 04:48:11 +1000
From: Nathan Metcalf <nmetcalf@starnewsgroup.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Leadtek DVT1000S W/ Phillips saa7134
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

Hey Guys,
I hope this is the correct place, I am trying to get a LEADTEK DVT1000S HD Tuner card working in Ubuntu (Latest)
When I load the saa7134_dvb kernel module, there are no errors, but /dev/dvb is not created.

I have tried enabling the debug=1 option when loading the module, but don't get any more useful information.

Can someone please assist me? Or direct me to the correct place?

Regards,
Nathan Metcalf



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
