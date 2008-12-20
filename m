Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout09.t-online.de ([194.25.134.84])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rohde.d@t-online.de>) id 1LDyEq-0004wo-1O
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 10:35:13 +0100
Message-ID: <494CBC3A.3040908@t-online.de>
Date: Sat, 20 Dec 2008 10:34:50 +0100
From: Detlef Rohde <rohde.d@t-online.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <494C2CFC.3040605@t-online.de> <494C31DA.6060904@iki.fi>
In-Reply-To: <494C31DA.6060904@iki.fi>
Cc: Antti Palosaari <crope@iki.fi>
Subject: [linux-dvb] cinergy t usb xe v2, attn: Manu Abraham,
	Jochen Friedrich
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

Hi All,
tnx to Antti writing me! Hopefully Manu or Jochen finds time to fix this 
problem. Meanwhile I will try to use the links Antti has provided. Will 
report here if being successful. One thing I should add: It's funny to 
notice that the stick is reported being in "warm state" but remains cold 
and the control LED does not lit..
Best regards + Merry Christmas
Detlef

Antti Palosaari schrieb:
> Detlef Rohde wrote:
>> Hi Antti,
>> can you please answer a simple question: Is there any effort done to 
>> fix the tuner problem with the cinergy stick?
> It is Manu Abraham driver, you should ask him (and/or Jochen 
> Friedrich). Actually there is driver and it is working, but Manu has 
> not merged it. We just talked this situation in the ml:
> http://www.linuxtv.org/pipermail/linux-dvb/2008-December/030982.html
> http://www.linuxtv.org/pipermail/linux-dvb/2008-December/030988.html
>
> Was using the AF9015 FW more
>> or less successfully when running kernel 2.6.27-7. After updating to 
>> -9 all was messed. Although the stick is known to the system and 
>> being in "warm state" tuning fails because lack of an appropriate 
>> tuner driver for "MC44S803". Tried various versions (4) from your 
>> webpage with no success. See attached some Kernel messages:
>> detlef@detlef-desktop:~$ tail -f /var/log/messages
>> Dec 19 23:46:09 detlef-desktop kernel: [  969.543794] DVB: 
>> registering new adapter (TerraTec Cinergy T USB XE)
>> Dec 19 23:46:09 detlef-desktop kernel: [  969.805306] dvb_af901x: 
>> disagrees about version of symbol dvb_usb_device_init
>> Dec 19 23:46:09 detlef-desktop kernel: [  969.805366] dvb_af901x: 
>> Unknown symbol dvb_usb_device_init
>> Dec 19 23:46:09 detlef-desktop kernel: [  969.805612] dvb_af901x: 
>> disagrees about version of symbol dvb_usb_device_exit
>> Dec 19 23:46:09 detlef-desktop kernel: [  969.805619] dvb_af901x: 
>> Unknown symbol dvb_usb_device_exit
>
> dvb_af901x output is not coming from my driver. You have mixed some 
> other driver, that print this.
>
>> Dec 19 23:46:09 detlef-desktop kernel: [  970.015208] af9013: 
>> firmware version:4.95.0
>> Dec 19 23:46:09 detlef-desktop kernel: [  970.025213] DVB: 
>> registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
>> Dec 19 23:46:09 detlef-desktop kernel: [  970.031873] af9015: 
>> Freescale MC44S803 tuner found but no driver for thattuner. Look at 
>> the Linuxtv.org for tuner driverstatus.
>> Dec 19 23:46:09 detlef-desktop kernel: [  970.031924] dvb-usb: 
>> TerraTec Cinergy T USB XE successfully initialized and connected.
>> Dec 20 00:11:09 detlef-desktop -- MARK --
>>
>> Have invested much time trying to solve this problem, hope you can 
>> help a linux newbie..
>
> Look this thread:
> http://www.linuxtv.org/pipermail/linux-dvb/2008-December/030982.html
> write to linux-dvb mailing list and ask Manu and Jochen. I cannot do 
> much because tuner driver is not mine.
>
>> Regards,
>> Detlef
>
> regards
> Antti



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
