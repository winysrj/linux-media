Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mbox2.netikka.net ([213.250.81.203])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rippe.shacknet@gmail.com>) id 1Kp7cW-0000Ry-FC
	for linux-dvb@linuxtv.org; Sun, 12 Oct 2008 22:33:04 +0200
Received: from [192.168.0.199] (z179.ip6.netikka.fi [85.157.155.179])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mbox2.netikka.net (Postfix) with ESMTP id C85FF408055
	for <linux-dvb@linuxtv.org>; Sun, 12 Oct 2008 23:32:21 +0300 (EEST)
Message-ID: <48F25EFA.1080105@gmail.com>
Date: Sun, 12 Oct 2008 23:32:58 +0300
From: Risto Pajula <rippe.shacknet@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-T-500 Remote & dvb-usb-dib0700-1.20.fw
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

Hello.

I can confirm the problem reported in the email:
http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029625.html

I tested using the v4l-dvb mercurial from today and when 
dvb-usb-dib0700-1.20.fw is used the remote always repeats the last 
pressed key until the another key is pressed. If I use the same v4l-dvb 
drivers and the dvb-usb-dib0700-1.10.fw the remote works just fine. The 
cold boot is required between the tests to see any difference.

However I can not get any "dib0700: Unknown remote controller key:" but 
dtv_property_cache_sync() appears in few minutes in the dmesg.

My system is:
Suse 11.0 2.6.25.16-0.1-default x86_64

I looked at the code and by making a lot of assumptions.... ;) I guess 
the call to the dib0700_rc_setup() from the dib0700_rc_query() wont 
erase the last IR code from the chip anymore if the new firmware is 
used...? However I really don't have idea how to fix it.. I would be 
happy to test anything if you have some suggestions.

BR.
Risto Pajula

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
