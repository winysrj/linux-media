Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail16.syd.optusnet.com.au ([211.29.132.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1Jsxzd-0000WN-TU
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 12:32:29 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail16.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m45AWHfa004407
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Mon, 5 May 2008 20:32:18 +1000
Received: from [192.168.200.201] (emma.home.pjama.net [192.168.200.201])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m45AWCEp006633
	for <linux-dvb@linuxtv.org>; Mon, 5 May 2008 20:32:13 +1000 (EST)
Message-ID: <481EE22C.6090102@optusnet.com.au>
Date: Mon, 05 May 2008 20:32:12 +1000
From: pjama <pjama@optusnet.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <481E7399.1040909@optusnet.com.au> <481E91D8.7010404@wentink.de>
	<481EBF63.2050601@optusnet.com.au> <481ECDFE.40203@iki.fi>
In-Reply-To: <481ECDFE.40203@iki.fi>
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

Hi Antti,
You're a legend!

Antti Palosaari wrote:
> pjama wrote:
>> Now (while donning my flame proof suit), I must confess that I hadn't 
>> thoroughly gone through the mailing list (google failed me) but since 
>> posting I've discovered a few things....
>>
>> 1) in dmesg where it says "af9013: firmware version:4.73.0" Does this 
>> mean it found version 4.73.0 on the device or in the 
>> /lib/firmware/kernel<blah>/dvb_usb_af9015 file? I believe I installed 
>> version 4.95.0 (but being a binary file it's hard to confirm). Should 
>> they match, Can I upgrade the device or should I downgrade the 
>> dvb_usb_af9015 file?
> 
> yes (you have old one), install the new one. Probably it does not matter 
> but it is still better use newest available.

Do you mean in /lib/firmware/kernel.... ? Do you have a copy of the latest firmware. I think my source may be suspect.

> 
>> 2) A post from Antti back in the beginning of April 
>> (http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025267.html) 
>> says the driver works but tuning fails because of the MXL5005 tuner. 
>> Bummer! 
> 
> It (now) should work, even both tuners. You should use different 
> devel-tree:
> http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/

Yes you are right. A recompile with these drivers has scan and kaffeine finding channels now.
A quick test of kaffein confirms it works. The only problem I've seen is that one HDTV channel has no audio but I'm not sure this is related to the driver.

> 
> Using both tuners same time got it hangs, due to broken mutex lock for 
> i2c-bus. I have been a little busy now to fix this, but probably in this 
> week I got it fixed.

I can now watch TV while I wait ;)

> 
>> Antti, did you get the usb sniff that you were after? If not, can you 
>> recommend an application that can dump a suitable file?
> 
> Thanx for help but I have got needed logs already.

Cool

> 
>>
>> Cheers
>> peter
>>
> 
> Antti

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
