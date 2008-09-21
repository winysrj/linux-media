Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dsl-202-173-134-75.nsw.westnet.com.au ([202.173.134.75]
	helo=mail.lemonrind.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex@receptiveit.com.au>) id 1KhHcO-0007g0-6N
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 07:36:25 +0200
Received: from localhost (localhost [127.0.0.1])
	by mail.lemonrind.net (Postfix) with ESMTP id 9B1FA40247
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 15:35:45 +1000 (EST)
Received: from mail.lemonrind.net ([127.0.0.1])
	by localhost (jasmin.receptiveit [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kQkfD6PkzTwx for <linux-dvb@linuxtv.org>;
	Sun, 21 Sep 2008 15:35:45 +1000 (EST)
Received: from [192.168.198.99] (unknown [192.168.198.99])
	(Authenticated sender: alex)
	by mail.lemonrind.net (Postfix) with ESMTPSA id 5E6AE40244
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 15:35:45 +1000 (EST)
Message-Id: <17918C45-7B7B-47DE-89F3-4A10CE36467C@receptiveit.com.au>
From: Alex Ferrara <alex@receptiveit.com.au>
To: linux-dvb <linux-dvb@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Sun, 21 Sep 2008 15:35:45 +1000
Subject: [linux-dvb] Dvico dual digital express - Poor tuner performance
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

I am currently seeing inconsistent performance with the dvico dual  
digital express. Some channels tune just fine, and others have the  
impression of a very low signal strength.

I know that my antenna is not the problem, as it has been  
professionally installed, with about 10m of RG6 cable from the antenna  
to the distribution amp, and about 4m of cable from the amp to the  
tuner. Other tuners in the same box work perfectly.

Are other people with this card experiencing the same problem?

btw, if it makes any difference, I am in Australia, and using Steven  
Toths perl script to extract the firmware from the Hauppage driver.

Other than the pesky tuner issue, the card appears to be picked up  
just fine, with no errors on dmesg, and both frontends available.

aF

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
