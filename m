Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Mon, 22 Sep 2008 13:17:46 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48A9BAFE.8020501@linuxtv.org>
Message-ID: <Pine.LNX.4.64.0809221254150.21880@shogun.pilppa.org>
References: <200808181427.36988.ajurik@quick.cz> <48A9BAFE.8020501@linuxtv.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 driver problems - i2c error
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

>> - the firmware is loaded into the card at first time the card is opened - it
>> is okay?
>>
>> [  917.660620] cx24116_firmware_ondemand: Waiting for firmware upload
>> (dvb-fe-cx24116.fw)...
>> [  917.703010] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
>> [  922.703870] cx24116_load_firmware: FW version 1.22.82.0
>> [  922.703889] cx24116_firmware_ondemand: Firmware upload complete
>>
>> The result is that only for some channels it is possible to get lock with
>> szap2. VDR is hanging (or starting) when trying to tune to initial channel,
>> even when this channel is set to channel at which is szap2 successfull. I'm
>> not able to say criteria which channels are possible to lock.
>>
>> Any hints are appreciated.
>
> I fixed an issue with cx88 sometime ago where a value of 0 (taken from
> the cards struct) was being written to the GPIO register, resulting in
> the same i2c issues.
>
> It looks a lot like this.
>
> - Steve

I am trying to get the dvb-t tuner working with my hvr-4000 (dvb-s is 
working fine) and have tried both the latest S2 repository and the latest 
version of liplianins multiproto repository with 2.6.26 kernels.

It seems that S2 repository does not yet support DVB-T at all, am I 
correct?  At least the "options cx88-dvb frontend=1" option in 
/etc/modprope.conf prevents adapters to be created at all under
/dev/dvb. Without that option adapter is created but it can only be used 
for scanning dvb-s.

WIth liplianinis multiproto version the selection between DVB-S and DVB-T 
works by using the "options cx88-dvb frontend=1" but I am seeing the i2c
errors described below.

Could you have any URL and changeset tag to patch in some repository where 
this I2C thing has been fixed?

Btw, I tested also the HVR-1300 and it seems to be working with S2 but 
scan (from dvb-apps trunk) is failing to find channels from some 
frequencies while things with external philips dvb-t work ok.
(-5 option for scan does not make any difference)

The message I am getting with scan is.:

...
0x0000 0x1111: pmt_pid 0x0105 YLE -- YLE PEILI (running)
0x0000 0x1131: pmt_pid 0x0107 YLE -- YLEN KLASSINEN (running)
0x0000 0x1151: pmt_pid 0x0109 YLE -- YLEMONDO (running)
Network Name 'Digita Finland'
>>> tune to: 
602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 
(tuning failed)
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010

Mika

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
