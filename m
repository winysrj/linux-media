Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from highwire.stanford.edu ([171.66.121.166])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <durket@rlucier-home2.stanford.edu>)
	id 1K7j44-00010p-8S
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 05:38:11 +0200
Received: from rlucier-home2.stanford.edu (rlucier-home2.Stanford.EDU
	[171.66.222.187])
	by highwire.stanford.edu (Postfix) with ESMTP id 240EB8DB7
	for <linux-dvb@linuxtv.org>; Sat, 14 Jun 2008 20:37:43 -0700 (PDT)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by rlucier-home2.stanford.edu (Postfix) with ESMTP id 8FC9817346C
	for <linux-dvb@linuxtv.org>; Sat, 14 Jun 2008 20:37:43 -0700 (PDT)
From: Michael Durket <durket@rlucier-home2.stanford.edu>
To: linux-dvb@linuxtv.org
Date: Sat, 14 Jun 2008 20:37:43 -0700
Message-Id: <1213501063.13607.8.camel@rlucier-home2.stanford.edu>
Mime-Version: 1.0
Subject: [linux-dvb] Twinhan VP1020A freezes Fedora 9 at udev
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

I have a Twinhan VP-1020A that I've been using in a RedHat 9
box for several years. I had to patch the bttv drivers in RedHat
9 (and I informed the driver author) because the VP-1020A doesn't
have any data in certain PCI registers that allowed the bttv 
driver to figure out what card it was so it locked up. (My modification
consisted of a patch to tell the bttv driver to not access the 
device if certain registers were all 0 - this was because I had my
own driver to control the card since this was before Linux DVB being
in any kind of stable state).

Fast forward to 2008 - I decided to upgrade (on a test box) to Fedora 
9, because I want to be able to run the new DVB-S2 cards without having
to write my own drivers again. I installed Fedora Core 9, got the latest
updates, plugged in my Twinhan card and.... it hangs in udev. It's kind
of unbelievable that this still isn't fixed. So I'm assuming it is fixed
and there's some other hangup, like Fedora doesn't include the Linux DVB
software and I have to rebuild the kernel to get it. So my questions 
are:

    1) Does Fedora include Linux DVB and all drivers for it by default?

    2) If so, has anybody seen this behavior plugging in a Twinhan 
       VP-1020A card to a Fedora box (having udev hang) and is there 
       a fix?

   Thanks.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
