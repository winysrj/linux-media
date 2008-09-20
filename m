Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Kh6p1-0001wx-6a
	for linux-dvb@linuxtv.org; Sat, 20 Sep 2008 20:04:44 +0200
Message-ID: <48D53B37.6020001@iki.fi>
Date: Sat, 20 Sep 2008 21:04:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dirk Vornheder <dirk_vornheder@yahoo.de>
References: <200809152345.37786.dirk_vornheder@yahoo.de>	<200809201916.01736.dirk_vornheder@yahoo.de>	<48D53190.60901@iki.fi>
	(sfid-20080920_192922_012008_3ACD590C)
	<200809201953.39006.dirk_vornheder@yahoo.de>
In-Reply-To: <200809201953.39006.dirk_vornheder@yahoo.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] UNS: Re: UNS: Re: UNS: Re: New unspported device
 AVerMedia DVB-T
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

Dirk Vornheder wrote:
>>> But i found no device entries in /dev/dvb.
>> Looks like tuner is not identified. Could you load af9015 with some
>> debugging enabled to see more information?
>>
>> 1) remove all dvb-modules "make rmmod"
>> 2) load af9015 with debug enabled "modprobe dvb-usb-af9015 debug=3"
>>
>> after that there should be more information in message-log.
>>
> 
> Sep 20 19:51:13 lappc kernel: af9015: command failed:255
> Sep 20 19:51:13 lappc kernel: af9015: eeprom read failed:-1
> Sep 20 19:51:13 lappc kernel: dvb_usb_af9015: probe of 3-3:1.0 failed with 
> error -1
> Sep 20 19:51:13 lappc kernel: usbcore: registered new interface driver 
> dvb_usb_af9015

hmm, now it even fails to read eeprom :( I have no idea why. Could you 
try to poweroff and do cold start to see if it loads driver properly then...

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
