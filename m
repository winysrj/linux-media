Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jswet-0003BA-0g
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 11:06:58 +0200
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0K0E006IE1AKG960@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Mon, 05 May 2008 12:06:20 +0300 (EEST)
Received: from spam5.suomi.net (spam5.suomi.net [212.50.131.165])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0K0E005FZ1AKN000@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Mon, 05 May 2008 12:06:20 +0300 (EEST)
Date: Mon, 05 May 2008 12:06:06 +0300
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <481EBF63.2050601@optusnet.com.au>
To: pjama <pjama@optusnet.com.au>
Message-id: <481ECDFE.40203@iki.fi>
MIME-version: 1.0
References: <481E7399.1040909@optusnet.com.au> <481E91D8.7010404@wentink.de>
	<481EBF63.2050601@optusnet.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] probs with af901x on mythbuntu
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

pjama wrote:
> Now (while donning my flame proof suit), I must confess that I hadn't thoroughly gone through the mailing list (google failed me) but since posting I've discovered a few things....
> 
> 1) in dmesg where it says "af9013: firmware version:4.73.0" Does this mean it found version 4.73.0 on the device or in the /lib/firmware/kernel<blah>/dvb_usb_af9015 file? I believe I installed version 4.95.0 (but being a binary file it's hard to confirm). Should they match, Can I upgrade the device or should I downgrade the dvb_usb_af9015 file?

yes (you have old one), install the new one. Probably it does not matter 
but it is still better use newest available.

> 2) A post from Antti back in the beginning of April (http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025267.html) says the driver works but tuning fails because of the MXL5005 tuner. Bummer! 

It (now) should work, even both tuners. You should use different devel-tree:
http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/

Using both tuners same time got it hangs, due to broken mutex lock for 
i2c-bus. I have been a little busy now to fix this, but probably in this 
week I got it fixed.

> Antti, did you get the usb sniff that you were after? If not, can you recommend an application that can dump a suitable file?

Thanx for help but I have got needed logs already.

> 
> Cheers
> peter
> 

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
