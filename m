Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lindsay@softlog.com.au>) id 1KxwsC-00036o-II
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 05:53:39 +0100
Received: from [127.0.0.1] by softlog.com.au (MDaemon PRO v9.5.6)
	with ESMTP id 04-md50000009988.msg
	for <linux-dvb@linuxtv.org>; Thu, 06 Nov 2008 14:52:33 +1000
Message-ID: <4912780C.8010106@softlog.com.au>
Date: Thu, 06 Nov 2008 14:52:28 +1000
From: Lindsay Mathieson <lindsay@softlog.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Dvico Fusion Pro
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

Hi All, I have a Fusion Pro I'm testing with. Have installed the latest 
v4l-dvb drivers as per the wiki and the board is recognised correctly on 
boot and registers a /dev/dvb/adaptor0 device. However it is uable to 
tune anything - a "scan < au-Brisbane" runs with no errors, but finds no 
stations.

However if I install the pascoe drivers:
  http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/
  http://linuxtv.org/hg/~pascoe/xc-test/

Its works fine - picks up the brisbane stations and displays them via mythtv

I thought the pascoe drivers were merged into the trunk ages ago - am I 
mistaken?

Thanks,

Lindsay

p.s My setup is a test PC and I can run tests as needed - doesn't matter 
if it breaks.

-- 
Lindsay
Softlog Systems



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
