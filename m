Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.pb.cz ([109.72.0.114]:56622 "EHLO smtp4.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaBHVfR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Feb 2014 16:35:17 -0500
Message-ID: <52F6A312.2040401@mizera.cz>
Date: Sat, 08 Feb 2014 22:35:14 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>, linux-media@vger.kernel.org
Subject: Re: video from USB DVB-T get  damaged after some time
References: <52F50E0B.1060507@mizera.cz> <52F56971.8060104@iki.fi>		 <52F6429E.6070704@mizera.cz> <1391872102.3386.10.camel@canaries32-MCP7A>	 <52F678DC.2040307@mizera.cz> <1391891765.2408.13.camel@canaries32-MCP7A>
In-Reply-To: <1391891765.2408.13.camel@canaries32-MCP7A>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

thanks - but in my Antenna is noway the problem - the signal is strong 
and HQ. All other tuners (STB, TVs, ...) are more then happy.

If it would not - the BERs would by HIGH all time.

No WiFi. 4GB RAM - most of them always free.


I thing the problem is - that the card loses tuned status (becomes 
detuned). That is why helps re-tune. That is why I ask about how to 
re-tune without breaking the stream.
Ideal would be if this could be done by driver.


--kapetr



Dne 8.2.2014 21:36, Malcolm Priestley napsal(a):
> On Sat, 2014-02-08 at 19:35 +0100, kapetr@mizera.cz wrote:
>> Hello,
>>
>> I have compile it (I hope) the more right way now :-)
>>
>> The patch saved as aaa.patch in media_build/backports
>> and added lines to  media_build/backports/backports.txt:
>> ----
>> [3.2.0]
>> add aaa.patch
>> ----
>>
>> Now dmesg looks like:
>> -----------------
>> [   17.643287] usb 1-1.3: dvb_usb_af9035: prechip_version=83
>> chip_version=02 chip_type=9135
>> [   17.643661] usb 1-1.3: dvb_usb_v2: found a 'ITE 9135 Generic' in cold
>> state
>> [   17.652169] usb 1-1.3: dvb_usb_v2: downloading firmware from file
>> 'dvb-usb-it9135-02.fw'
>> [   17.746382] usb 1-1.3: dvb_usb_af9035: firmware version=3.39.1.0
>> [   17.746389] usb 1-1.3: dvb_usb_v2: found a 'ITE 9135 Generic' in warm
>> state
>> [   17.747413] usb 1-1.3: dvb_usb_v2: will pass the complete MPEG2
>> transport stream to the software demuxer
>> [   17.747429] DVB: registering new adapter (ITE 9135 Generic)
>> [   17.805233] i2c i2c-16: af9033: firmware version: LINK=0.0.0.0
>> OFDM=3.9.1.0
>> [   17.805238] usb 1-1.3: DVB: registering adapter 0 frontend 0 (Afatech
>> AF9033 (DVB-T))...
>> [   17.821832] i2c i2c-16: tuner_it913x: ITE Tech IT913X successfully
>> attached
>> [   17.858231] Registered IR keymap rc-it913x-v1
>> [   17.858291] input: ITE 9135 Generic as
>> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0/input5
>> [   17.858395] rc0: ITE 9135 Generic as
>> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0
>> [   17.858398] usb 1-1.3: dvb_usb_v2: schedule remote query interval to
>> 500 msecs
>> [   17.858401] usb 1-1.3: dvb_usb_v2: 'ITE 9135 Generic' successfully
>> initialized and connected
>> [   17.858415] usbcore: registered new interface driver dvb_usb_af9035
>> ------------------
>>
>> First I have thing the problem is gone: It has run OK over 20 minutes
>> (before it goes down mostly in <10 min on CH59).
>>
>> But - unfortunately after cca 25 min it has go down again :-(
>> --------
>> status 1f | signal ffff | snr 0122 | ber 00000000 | unc 0000014f |
>> FE_HAS_LOCK
>> status 1f | signal ffff | snr 0122 | ber 0000830e | unc 0000014f |
>> FE_HAS_LOCK
>> status 1f | signal ffff | snr 0122 | ber 0001061c | unc 0000014f |
>> FE_HAS_LOCK
>> status 1f | signal ffff | snr 0122 | ber 00000000 | unc 0000014f |
>> FE_HAS_LOCK
>>
>> ...
>>
>> status 1f | signal ffff | snr 0122 | ber 003dedb0 | unc 0002fd94 |
>> FE_HAS_LOCK
>> status 07 | signal ffff | snr 0122 | ber 004c8030 | unc 0002fffd |
>> status 1f | signal ffff | snr 0118 | ber 006d50fd | unc 0003026d |
>> FE_HAS_LOCK
>> status 1f | signal ffff | snr 0122 | ber 006cfc4e | unc 00030569 |
>> FE_HAS_LOCK
>> status 1f | signal ffff | snr 0122 | ber 009d1eda | unc 00030832 |
>> FE_HAS_LOCK
>> status 1f | signal ffff | snr 0122 | ber 008924b1 | unc 00030a5e |
>> FE_HAS_LOCK
>> status 1f | signal ffff | snr 0122 | ber 00712074 | unc 00030d27 |
>> FE_HAS_LOCK
>> status 1f | signal ffff | snr 0122 | ber 008d4d85 | unc 00030f55 |
>> FE_HAS_LOCK
> That BER looks awful.
>
> If the antenna is good, it looks like local interference.
>
> Check the wifi adapter is not causing it.
>
> If possible put the TV adapter on a short 0.5m/1m USB extension cable
> away from the PC. Trouble is these devices do not have any shielding.
>
> I have heard problems of memory leak in Ubuntu 64 running low on memory
> check free memory after 30 mins.
>
> Regards
>
>
> Malcolm
>
>> ---------
>>
>>
>> So - maybe is it little better, but the problem persist.
>> Any chance to solve it in dvb driver ?
>>
>>
>> I have tested (with the old driver) - that it helps to CTRL+C the:
>> tzap -r -c /etc/channels.conf "Prima ZOOM"
>>
>> And then run it again. (It was not necessary to switch to another freq.
>> and back, as I wrote before).
>> Unfortunately it damages for  a while the recording (file.ts).
>> Is there another way how to "re-tune" (re-zap) without break
>> recording/viewing ?
>> I could then re-tune e.g. every 5 minutes and it could solve the problem.
>> Could not that be done in driver itself ?
>>
>> Thanks.
>>
>> --kapetr
>>
>>
>>
>>
>> Dne 8.2.2014 16:08, Malcolm Priestley napsal(a):
>>> On Sat, 2014-02-08 at 15:43 +0100, kapetr@mizera.cz wrote:
>>>> Hello,
>>>>
>>>> unfortunately I do not understand development, patching, compiling things.
>>>> I have try it but I need more help.
>>>>
>>>> I have done:
>>>>
>>>> git clone --depth=1 git://linuxtv.org/media_build.git
>>>> cd media_build
>>>> ./build
>>>>
>>>> it downloads and builds all. At begin of compiling I had stop it.
>>>> Then I did manual change of
>>>> ./media_build/linux/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>
>>>> ------------------- old part:
>>>>            { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
>>>>                    &af9035_props, "TerraTec Cinergy T Stick (rev. 2)",
>>>> NULL) },
>>>>            /* IT9135 devices */
>>>> #if 0
>>>>            { DVB_USB_DEVICE(0x048d, 0x9135,
>>>>                    &af9035_props, "IT9135 reference design", NULL) },
>>>>            { DVB_USB_DEVICE(0x048d, 0x9006,
>>>>                    &af9035_props, "IT9135 reference design", NULL) },
>>>> #endif
>>>>            /* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
>>>>            { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
>>>>                    &af9035_props, "TerraTec Cinergy T Stick Dual RC (rev.
>>>> 2)", NULL) },
>>>> ----------------------------- new:
>>>> 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
>>>> 		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
>>>> 	/* IT9135 devices */
>>>>
>>>> 	{ DVB_USB_DEVICE(0x048d, 0x9135,
>>>> 		&af9035_props, "IT9135 reference design", NULL) },
>>>>
>>>> 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
>>>> 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
>>>> 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
>>>> --------------------------------------------
>>>>
>>>>
>>>> But now I do not know how to "restart" build process.
>>>
>>> Just
>>>
>>> make
>>>
>>> from media_build directory.
>>>
>>>>
>>>> I have try:
>>>>
>>>> cd /tmp/media_build/linux
>>>> make
>>>>
>>>> It had compiled *. and *.ko files.
>>>>
>>> you need to run
>>> /sbin/depmod -a
>>>
>>> and reboot
>>>
>>> it best to just run with su/sudo
>>>
>>> make install
>>>
>>> I have just tested all the single ids.
>>>
>>> I am about to send a patch to add all the single tuner ids
>>> to af9035 from it913x.
>>>
>>> I haven't found any problems.
>>>
>>>
>>> Regards
>>>
>>>
>>> Malcolm
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
>
>
