Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JruSm-0005yS-Td
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 14:34:16 +0200
Message-ID: <481B0A34.6070800@linuxtv.org>
Date: Fri, 02 May 2008 08:33:56 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: RISCH Gilles <roodemol@cjbous.net>
References: <200804272327.20455.roodemol@cjbous.net>
	<200805020038.34997.roodemol@cjbous.net>
	<481A6495.60508@linuxtv.org>
	<200805021311.18036.roodemol@cjbous.net>
In-Reply-To: <200805021311.18036.roodemol@cjbous.net>
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Hauppauge WinTV-HVR-1200
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

RISCH Gilles wrote:
> On Friday 02 May 2008 02:47:17 you wrote:
>   
>>>> RISCH Gilles wrote:
>>>>         
>>>>> Hello,
>>>>>           
>>> On Monday 28 April 2008 17:48:46 Steven Toth wrote:
>>>       
>>>>> the Hauppauge WinTV-HVR-1200 is now listened as a supported card in the
>>>>> wiki. What I'm missing are some instructions how to get the card
>>>>> working. Does a such document already exist?
>>>>>           
>>>> No, but feel free to update the wiki so other benefit from your work.
>>>>
>>>> 1. Build and install the modules, as per the wiki instructions.
>>>> 2. Reboot and your done, as per the wiki instructions.
>>>> 3. Scan for channels or use an existing channels.conf, as per the wiki
>>>> instructions.
>>>> 4. Update the HVR1200 wiki page.
>>>>
>>>> Regards,
>>>>
>>>> Steve
>>>>         
>> RISCH Gilles wrote:
>>     
>>> Hello,
>>>
>>> my card is running, I've added some lines to the wiki:
>>> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1200
>>>
>>> can someone review / try it out
>>>
>>> Regards
>>>       
>> Please do not top-quote.  Replies should appear below the quoted text.
>>
>> Your wiki entry says,
>>
>> "
>>   5. add this line to /etc/modules.d/dvb:
>>   options cx23885 card=7
>> "
>>
>> Why?  Does the cx23885 driver not autodetect your board?
>>
>> The HVR1200 has a subsystem ID that should allow the driver to autodetect
>> your board.  If your board is not autodetected, it means one of two things:
>>
>> 1) The subsystem id of your card is missing, and we can simply add that for
>> you to avoid the need for module option.
>>
>> 2) For one reason or another, the device may be reading the eeprom
>> incorrectly, causing the subid not to show properly.  This is unlikely, but
>> I have seen it happen in certain motherboards using cx23885 based products.
>>
>> Please test without the module option -- your board should be properly
>> autodetected.  If this is not the case, please send in your full dmesg
>> output.
>>
>> Regards,
>>
>> Mike Krufky
>>     
>
> Hello,
>
> It does not work whitout the entry in /etc/modules.d/dvb and I don't know if 
> it is due to point 1 or 2, but I estimate that it is point 1 due to the 
> warning in dmesg:
>
> [   44.041711] cx23885 driver version 0.0.1 loaded
> [   44.042028] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
> [   44.042030] ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [APC6] -> GSI 16 
> (level, low) -> IRQ 16
> [   44.042043] CORE cx23885[0]: subsystem: 0070:71d3, board: Hauppauge 
> WinTV-HVR1200 [card=7,insmod option]
> [   44.190051] cx23885[0]: i2c bus 0 registered
> [   44.190066] cx23885[0]: i2c bus 1 registered
> [   44.190077] cx23885[0]: i2c bus 2 registered
> [   44.215621] tveeprom 2-0050: Hauppauge model 71949, rev H2E9, serial# 
> 2812545
> [   44.215623] tveeprom 2-0050: MAC address is 00-0D-FE-2A-EA-81
> [   44.215625] tveeprom 2-0050: tuner model is Philips 18271_8295 (idx 149, 
> type 54)
> [   44.215627] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
> PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
> [   44.215628] tveeprom 2-0050: audio processor is CX23885 (idx 39)
> [   44.215630] tveeprom 2-0050: decoder processor is CX23885 (idx 33)
> [   44.215631] tveeprom 2-0050: has no radio, has no IR receiver, has no IR 
> transmitter
> [   44.215633] cx23885[0]: warning: unknown hauppauge model #71949
> [   44.215634] cx23885[0]: hauppauge eeprom: model=71949
> [   44.218910] cx23885[0]: cx23885 based dvb card
> [   44.269356] tda829x 3-0042: type set to tda8295
> [   44.315028] tda18271 3-0060: creating new instance
> [   44.348447] TDA18271HD/C1 detected @ 3-0060
> [   44.480440] phy0: Selected rate control algorithm 'simple'
> [   44.543974] usbcore: registered new interface driver rt73usb
> [   44.925226] NET: Registered protocol family 17
> [   45.394593] DVB: registering new adapter (cx23885[0])
> [   45.394597] DVB: registering frontend 0 (NXP TDA10048HN DVB-T)...
> [   45.394795] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [   45.394801] cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 16, latency: 
> 0, mmio: 0xfd800000
>
> The card was preinstalled in a HP Pavilion 9050 and under Windows it's shown 
> as Hauppauge WinTV-HVR-1200.
>
> Regards, Gilles


Thanks -- I'll update the PCI subids list today.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
