Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail10.dotsterhost.com ([66.11.233.3])
	by mail.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <john@orthfamily.net>) id 1LtZLo-0000FX-7K
	for linux-dvb@linuxtv.org; Tue, 14 Apr 2009 05:30:42 +0200
Received: from [127.0.0.1] (lancer.orthfamily.net [10.182.115.3])
	(Authenticated sender: jmorth)
	by lucas.orthfamily.net (Postfix) with ESMTPA id EB5ABBFCA18
	for <linux-dvb@linuxtv.org>; Tue, 14 Apr 2009 00:43:50 -0400 (EDT)
Message-ID: <49E40322.5040600@orthfamily.net>
Date: Mon, 13 Apr 2009 23:29:38 -0400
From: John Orth <john@orthfamily.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Pinnacle HD Stick (801e SE) and i2c issues
Reply-To: linux-media@vger.kernel.org
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

First, thanks to all for the wonderful v4l project.  I am able to get 
this card going in Ubuntu 9.04 on my laptop (Dell Vostro 1700) with no 
changes apart from copying the correct firmware.  What fantastic 
progress. :)

I have been trying very hard to get this USB tuner to work on my Asus 
M3A78-EM board in Ubuntu 9.04 with no success.  I have tried the stock 
Jaunty kernel, the mainline (vanilla?) kernel, the included kernel 
modules, and modules compiled from v4l Mercurial with no success.  
Generally speaking, after a cold boot, the stick will work for a while.  
It will scan channels, lock one or two, and then I will receive a filter 
timeout.  Once the filter has timed out, not even a cold boot will 
revive the stick.  I have to power down the system, remove the stick, 
and place it in a different USB port.  Once I have done this, I am able 
to filter/lock with varying degrees of success.  Sometimes it will allow 
me to generate a full channels.conf, sometimes not.  However, once 
hitting the "filter timeout" error, dmesg gets flooded with:

---
s5h1411_writereg: writereg error 0x19 0xf5 0x0000, ret == 0)
dib0700: i2c write error (status = -108)
---

The filter timeout occurs after running "scan tuning.dat > channels.conf"
The file tuning.dat is generated via "w_scan -fa -x > tuning.dat"

The firmware dvb-fe-xc5000-1.1.fw was copied to /lib/firmware per the 
v4l Wiki instructions.

lspci of working system:  http://pastebin.com/f31efd30a
lspci of non-working system:  http://pastebin.com/fa80c2f7

Is there something major I'm overlooking?  Are there any known issues 
with this hardware combination?  I am willing to test any changes to the 
xc5000 driver if needed.

Thanks!
John


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
