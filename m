Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JsyJV-0001ck-92
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 12:53:00 +0200
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0K0E0061F67BXP00@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Mon, 05 May 2008 13:52:23 +0300 (EEST)
Received: from spam2.suomi.net (spam2.suomi.net [212.50.131.166])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0K0E008M067BZXA0@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Mon, 05 May 2008 13:52:23 +0300 (EEST)
Date: Mon, 05 May 2008 13:52:18 +0300
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <481EE22C.6090102@optusnet.com.au>
To: pjama <pjama@optusnet.com.au>
Message-id: <481EE6E2.6090301@iki.fi>
MIME-version: 1.0
References: <481E7399.1040909@optusnet.com.au> <481E91D8.7010404@wentink.de>
	<481EBF63.2050601@optusnet.com.au> <481ECDFE.40203@iki.fi>
	<481EE22C.6090102@optusnet.com.au>
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
> Do you mean in /lib/firmware/kernel.... ? Do you have a copy of the latest firmware. I think my source may be suspect.

/lib/firmware/
/lib/firmware/kernel<version>/

I think both are OK, but other is loaded bigger priority by kernel. I 
think directory with kernel version has looked first. You have 4.73.0 in 
other directory and other has 4.95.0 ?

Different firmware files can be found from:
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/

>> Using both tuners same time got it hangs, due to broken mutex lock for 
>> i2c-bus. I have been a little busy now to fix this, but probably in this 
>> week I got it fixed.
> 
> I can now watch TV while I wait ;)

:)

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
