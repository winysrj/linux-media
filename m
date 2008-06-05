Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1K4IMn-0000gt-BF
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 18:31:10 +0200
Message-ID: <4848149A.10900@linuxtv.org>
From: mkrufky@linuxtv.org
To: crope@iki.fi
Date: Thu, 5 Jun 2008 12:30:18 -0400 
MIME-Version: 1.0
in-reply-to: <48480E9D.9000004@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PEAK DVB-T Digital Dual Tuner PCI - anyone got t	his
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

Antti Palosaari wrote:
> Serge Nikitin wrote:
>> Andrew,
>>
>> PEAK DVB-T Dual tuner PCI (221544AGPK) is either renamed or rebadged 
>> KWorld DVB-T PC160 card.
>>
>> I'm using first tuner on this card with help of the driver from 
>> following source tree (snapshot was taken around 20/05/2008):
>> http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/
>> and latest firmware from
>>
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_fil
es/ 
>>
>>
>> Small modification for sources (file af9015.c) was needed (just add 
>> one more USB Device ID (1b80:c160)) and the card is "just work" as a 
>> single-tuner card.
>
> Thank you for this information, I will add this USB-ID to the driver.
>
>> I have not test second tuner due to following issue:
>>  
>> Second tuner identified itself correctly only after really "cold 
>> restart" (power down, wait some time, power up):
>> May 20 23:39:09 dvbbird kernel: DVB: registering new adapter (KWorld  
>> PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)
>> May 20 23:39:10 dvbbird kernel: af9013: firmware version:4.95.0
>> May 20 23:39:10 dvbbird kernel: tda18271 3-00c0: creating new instance
>> May 20 23:39:10 dvbbird kernel: TDA18271HD/C1 detected @ 3-00c0
>> May 20 23:39:10 dvbbird kernel: dvb-usb: will pass the complete MPEG2 
>> transportstream to the software demuxer.
>> May 20 23:39:10 dvbbird kernel: DVB: registering new adapter (KWorld  
>> PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)
>> May 20 23:39:11 dvbbird kernel: af9013: firmware version:4.95.0
>> May 20 23:39:11 dvbbird kernel: tda18271 4-00c0: creating new instance
>> May 20 23:39:11 dvbbird kernel: TDA18271HD/C1 detected @ 4-00c0
>>
>> For any sort of "not-really-cold" restarts second tuner fails to 
>> respond correctly:
>> May 21 00:10:10 dvbbird kernel: DVB: registering new adapter (KWorld  
>> PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)
>> May 21 00:10:11 dvbbird kernel: af9013: firmware version:4.95.0
>> May 21 00:10:11 dvbbird kernel: tda18271 3-00c0: creating new instance
>> May 21 00:10:11 dvbbird kernel: TDA18271HD/C1 detected @ 3-00c0
>> May 21 00:10:11 dvbbird kernel: dvb-usb: will pass the complete MPEG2 
>> transportstream to the software demuxer.
>> May 21 00:10:11 dvbbird kernel: DVB: registering new adapter (KWorld  
>> PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)
>> May 21 00:10:12 dvbbird kernel: af9013: firmware version:4.95.0
>> May 21 00:10:12 dvbbird kernel: tda18271 4-00c0: creating new instance
>> May 21 00:10:12 dvbbird kernel: Unknown device detected @ 4-00c0, 
>> device not supported.
>
> Hmm, Mike have you any idea why it does not detect this tuner 
> correctly  when "warm  restart" done ? 


Maybe the tuner is behind an i2c gate that is closed at the time of 
attach / detection?

tda18271 driver will refuse to attach to the driver if the ID register 
does not contain a valid value.  The ID register is a single byte.

if ID_REGISTER & 0x7F == 3 then
    TDA18271c1
else if ID_REGISTER & 0x7F == 4 then
    TDA18271c2
else
    INVALID

I suggest disabling the ability to close the i2c gate -- force it to 
stay always open.  That should help you to determine whether or not the 
i2c gate is the cause of this problem.

-Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
