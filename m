Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]
	helo=friskymail-a2.g.dreamhost.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <list@gosub5000.net>) id 1JzBwp-00033P-Dd
	for linux-dvb@linuxtv.org; Thu, 22 May 2008 16:39:18 +0200
Received: from [192.168.1.6] (unknown [87.14.150.16])
	by friskymail-a2.g.dreamhost.com (Postfix) with ESMTP id EE1E0131B28
	for <linux-dvb@linuxtv.org>; Thu, 22 May 2008 07:39:08 -0700 (PDT)
Message-ID: <48358570.8070207@gosub5000.net>
Date: Thu, 22 May 2008 16:38:40 +0200
From: gio <list@gosub5000.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] kword dvb-t 210
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

I have a issue with kword dvb-t 210.
The i2c module are loaded, but remote still not recognized and audio 
input from composite input isn't redirected to standard output, when 
select (with tvtime or xawtv) the external input I can see the pictures 
but no heared audio.

if I try to configure the device created with saa7134-alsa module with 
alsaconf, I can obtain audio in this way: check to mute input2 and 
recheck to activate input2.

ideas?
(apologize for bad english)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
