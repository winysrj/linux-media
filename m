Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Jo80V-0004xV-Js
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 04:13:22 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZP004HOFH6VW51@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 21 Apr 2008 22:12:43 -0400 (EDT)
Date: Mon, 21 Apr 2008 22:12:42 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <1208817758.10519.13.camel@pc10.localdom.local>
To: Trevor Boon <trevor_boon@yahoo.com>
Message-id: <480D499A.2040806@linuxtv.org>
MIME-version: 1.0
References: <685282.37355.qm@web55614.mail.re4.yahoo.com>
	<1208817758.10519.13.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR1200 / HVR1700 / TDA10048 support
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

hermann pitton wrote:
> Hi, Trevor and Amitay,
> 
> Am Dienstag, den 22.04.2008, 07:38 +1000 schrieb Trevor Boon:
>> Hi Amitay,
>>
>> I specified the i2c_scan=1 option in my
>> /etc/modprobe.d/saa7134 file and the following
>> addresses were returned..
>>
>> saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
>> saa7130[0]: i2c scan: found device @ 0xc0  [tuner
>> (analog)]
>>
>> Regards,
>> Trevor.
>>
> 
> the 0x10 >> 1 for the digital demod is in the eeprom, if it follows
> usual rules, at least the tuner is correct there.
> 
> Likely there are more possibilities, why the tda10048 does not appear,
> powered off for example to safe energy, but since you also had a crash
> previously, try a cold boot at first, means wait some time without any
> power connected, depending on capacitors of the mobo, but 30 seconds
> without any power should be always safe, and then just let it auto
> detect card=0 without a tuner again and let i2c_scan=1 enabled one more
> time.
> 
> If still the same, you are likely above that basic testing step and can
> scratch heads on what doing next.

If this doesn't work then you may need to drive a GPIO to being the part 
out of reset.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
