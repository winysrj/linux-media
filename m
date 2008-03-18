Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.mtw.ru ([194.135.105.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a-j@a-j.ru>) id 1JbiXt-0003sY-2K
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 21:36:29 +0100
Received: from MW1J060NB (unknown [217.172.30.162])
	by smtp1.mtw.ru (Postfix) with ESMTP id 5247813B6CB
	for <linux-dvb@linuxtv.org>; Tue, 18 Mar 2008 23:32:44 +0300 (MSK)
Date: Tue, 18 Mar 2008 23:36:20 +0300
From: Andrew Junev <a-j@a-j.ru>
Message-ID: <1115343012.20080318233620@a-j.ru>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
Reply-To: Andrew Junev <a-j@a-j.ru>
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

Hello All,

I was successfully using two TT S-1401 DVB-S cards in my HTPC running
Fedora 8. One of my antennas is positioned to Astra 19.2E and its
signal quality is quite low in my area. But the setup worked just fine
for me most of the time.

Last weekend I updated my system from kernel-2.6.23.15-137.fc8 to
kernel-2.6.24.3-12.fc8. It was just a 'yum update', nothing else.
Right after that I got no lock on most of Astra transponders (other
satellites were still Ok, but they normally have a far better signal).
After checking everything twice without any success, I booted back to
2.6.23.15 and my Astra was back!

Is this a known behavior? I suppose it was not discussed before, so
this makes me think I am the only one with such a problem...
Strange... I think the problem is somehow related to the signal level / 
signal error rate. Looks like weak transponders are harder to lock
with the new kernel...
I'd appreciate any comments on this. I don't think I have an urgent
need to move to 2.6.24 now, but I'd still like to be able to do that
without loosing my TV... 


P.S. I can see there's kernel-2.6.24.3-34.fc8 already available for
Fedora 8. But I didn't try it yet...

-- 
Best regards,
 Andrew


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
