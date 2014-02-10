Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.pb.cz ([109.72.0.114]:57305 "EHLO smtp4.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaBJKF0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:05:26 -0500
Message-ID: <52F8A463.10003@mizera.cz>
Date: Mon, 10 Feb 2014 11:05:23 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: video from USB DVB-T get  damaged after some time
References: <52F50E0B.1060507@mizera.cz> <52F56971.8060104@iki.fi>		 <52F6429E.6070704@mizera.cz> <1391872102.3386.10.camel@canaries32-MCP7A>	 <52F678DC.2040307@mizera.cz> <1391891765.2408.13.camel@canaries32-MCP7A> <52F6CEFC.3020307@iki.fi> <52F70A9F.50200@iki.fi> <52F88BED.8010003@mizera.cz> <52F88F25.5000906@iki.fi>
In-Reply-To: <52F88F25.5000906@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

it is this one:
http://www.buyincoins.com/item/30948.html

I shop there often - lowest prices of all China e-shops I have found.
BTW: if you want try the shop - by registry/first buy give my nick 
"jipan0" as referrer. You will get 5% off :-)

--kapetr


Dne 10.2.2014 09:34, Antti Palosaari napsal(a):
> Moi!
>
> On 10.02.2014 10:21, kapetr@mizera.cz wrote:
>> Hello,
>>
>> I have test FW version 12.10.04.1
>> (FYI dmesg changes follows)
>>
>> The problem without change.
>>
>> I did want to test the DVB-T stick under Windows XP, but in VirtualBox
>> works the tuner not at all - I get just jerky sound, no video.
>> But there is older driver (12.7.6.11) - but don't thing the problem is
>> there - rather in VBOX.
>> And no free partition to test.
>
>
> OK, thank for the testing anyway.
> I have few different it9135 devices. Could you find some picture of
> yours, I would like to test myself if I had same device.
>
> regards
> Antti
>
>
>
>
>>
>> Regards.
>>
>> kapetr
>>
>>
>> ----------- old from
>> https://raw.github.com/torvalds/linux/master/Documentation/dvb/get_dvb_firmware
>>
>>
>>
>>
>> [   21.546241] usb 1-1.3: dvb_usb_af9035: prechip_version=83
>> chip_version=02 chip_type=9135
>> [   21.546613] usb 1-1.3: dvb_usb_v2: found a 'ITE 9135 Generic' in cold
>> state
>> [   21.563582] usb 1-1.3: dvb_usb_v2: downloading firmware from file
>> 'dvb-usb-it9135-02.fw'
>> [   21.594974] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
>> [   21.659449] usb 1-1.3: dvb_usb_af9035: firmware version=3.39.1.0
>> [   21.659456] usb 1-1.3: dvb_usb_v2: found a 'ITE 9135 Generic' in warm
>> state
>> [   21.660358] usb 1-1.3: dvb_usb_v2: will pass the complete MPEG2
>> transport stream to the software demuxer
>> [   21.660375] DVB: registering new adapter (ITE 9135 Generic)
>> [   21.750565] i2c i2c-16: af9033: firmware version: LINK=0.0.0.0
>> OFDM=3.9.1.0
>> [   21.750570] usb 1-1.3: DVB: registering adapter 0 frontend 0 (Afatech
>> AF9033 (DVB-T))...
>> [   22.064646] i2c i2c-16: tuner_it913x: ITE Tech IT913X successfully
>> attached
>> [   22.099994] Registered IR keymap rc-it913x-v1
>> [   22.100068] input: ITE 9135 Generic as
>> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0/input14
>> [   22.100103] rc0: ITE 9135 Generic as
>> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0
>> [   22.100106] usb 1-1.3: dvb_usb_v2: schedule remote query interval to
>> 500 msecs
>> [   22.100109] usb 1-1.3: dvb_usb_v2: 'ITE 9135 Generic' successfully
>> initialized and connected
>> [   22.100123] usbcore: registered new interface driver dvb_usb_af9035
>>
>> ---------------new from
>> http://palosaari.fi/linux/v4l-dvb/firmware/IT9135/12.10.04.1/IT9135v2_3.42.3.3_3.29.3.3/
>>
>>
>>
>> Feb  9 15:00:54 zly-hugo kernel: [12732.520617] usb 1-1.3:
>> dvb_usb_af9035: prechip_version=83 chip_version=02 chip_type=9135
>> Feb  9 15:00:54 zly-hugo kernel: [12732.520988] usb 1-1.3: dvb_usb_v2:
>> found a 'ITE 9135 Generic' in cold state
>> Feb  9 15:00:54 zly-hugo kernel: [12732.522267] usb 1-1.3: dvb_usb_v2:
>> downloading firmware from file 'dvb-usb-it9135-02.fw'
>> Feb  9 15:00:54 zly-hugo kernel: [12732.626497] usb 1-1.3:
>> dvb_usb_af9035: firmware version=3.42.3.3
>> Feb  9 15:00:54 zly-hugo kernel: [12732.626509] usb 1-1.3: dvb_usb_v2:
>> found a 'ITE 9135 Generic' in warm state
>> Feb  9 15:00:54 zly-hugo kernel: [12732.627381] usb 1-1.3: dvb_usb_v2:
>> will pass the complete MPEG2 transport stream to the software demuxer
>> Feb  9 15:00:54 zly-hugo kernel: [12732.627405] DVB: registering new
>> adapter (ITE 9135 Generic)
>> Feb  9 15:00:54 zly-hugo kernel: [12732.631208] i2c i2c-16: af9033:
>> firmware version: LINK=0.0.0.0 OFDM=3.29.3.3
>> Feb  9 15:00:54 zly-hugo kernel: [12732.631215] usb 1-1.3: DVB:
>> registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
>> Feb  9 15:00:54 zly-hugo kernel: [12732.631328] i2c i2c-16:
>> tuner_it913x: ITE Tech IT913X successfully attached
>> --------------
>>
>>
>>
>>
>> Dne 9.2.2014 05:57, Antti Palosaari napsal(a):
>>> On 09.02.2014 02:42, Antti Palosaari wrote:
>>>> Moikka!
>>>> I am going to extract new firmware. I dumped init tables out from
>>>> Windows driver version 12.07.06.1. Is there any newer?
>>>>
>>>> regards
>>>> Antti
>>>>
>>>
>>> I extracted firmwares from Windows driver 12.10.04.1. Didn't find newer
>>> driver...
>>>
>>> http://blog.palosaari.fi/2014/02/linux-it9135-driver-firmwares.html
>>>
>>> regards
>>> Antti
>>>
>
>
