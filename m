Return-path: <linux-media-owner@vger.kernel.org>
Received: from devil.pb.cz ([109.72.0.18]:59234 "EHLO smtp4.pb.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751074AbaKYTJB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 14:09:01 -0500
Received: from [192.168.1.15] (unknown [109.72.4.22])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp4.pb.cz (Postfix) with ESMTPS id B177B82A56
	for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 20:08:53 +0100 (CET)
Message-ID: <5474D3C5.9060309@mizera.cz>
Date: Tue, 25 Nov 2014 20:08:53 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: it913x: probe of 8-001c failed with error -22
References: <5474A116.3050604@mizera.cz> <5474ABCA.9080609@iki.fi> <5474CE31.7090000@mizera.cz> <5474CFC1.3060007@iki.fi>
In-Reply-To: <5474CFC1.3060007@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Dne 25.11.2014 v 19:51 Antti Palosaari napsal(a):
> Moikka!
> RegMap does not belong to media (v4l) but driver core. Maybe kernel 3.8
> is too old and does not have that functionality.

no, it is in kernel core itself (not as module).

>
> Update your kernel. Why you don't use it9135 driver shipped with 3.8
> kernel?

while did not tune (tzap do not lock and shows snr=00000 and lines on 
output comes out very slow and irregularly). It is not normal.


There is no reason on my side, why it should not work:

I had use yet 3 months ago with 3.2.0 kernel with compiled V4L new 
AF9035 module, but unfortunately now (in 9/2014 ?) this driver has 
changed and requires now kernel >=3.4.
And I did not find out, how to get older git tree from +- 8/2014 to use 
it with my 3.2 kernel. That's why I have install newer 3.8 kernel.

--kapetr




>
> regards
> Antti
>
> On 11/25/2014 08:45 PM, kapetr@mizera.cz wrote:
>> Hello,
>>
>> # modinfo regmap-i2c
>> ERROR: modinfo: could not find module regmap-i2c
>>
>> I'm using standard Ubuntu kernel.
>>
>> -> don't know, how to get regmap-i2c module.
>>
>> It is a part of V4L ?
>>
>>
>> THX --kapetr
>>
>>
>> Dne 25.11.2014 v 17:18 Antti Palosaari napsal(a):
>>>
>>>
>>> On 11/25/2014 05:32 PM, kapetr@mizera.cz wrote:
>>>> Hello.
>>>>
>>>> U12.04 with newly installed 3.8 kernel:
>>>>
>>>> 3.8.0-44-generic #66~precise1-Ubuntu SMP Tue Jul 15 04:01:04 UTC 2014
>>>> x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>> USB dvb-t tuner:
>>>>
>>>> Bus 001 Device 005: ID 048d:9135 Integrated Technology Express, Inc.
>>>> Zolid Mini DVB-T Stick
>>>>
>>>> Newest V4L drivers installed. But there is an error in log by inserting
>>>> of the USB tuner:
>>>>
>>>> -------------------
>>>> Nov 25 16:24:38 zly-hugo kernel: [  315.927923] usb 1-1.3: new
>>>> high-speed USB device number 5 using ehci-pci
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.021755] usb 1-1.3: New USB
>>>> device found, idVendor=048d, idProduct=9135
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.021760] usb 1-1.3: New USB
>>>> device strings: Mfr=0, Product=0, SerialNumber=0
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.023071] usb 1-1.3:
>>>> dvb_usb_af9035: prechip_version=83 chip_version=02 chip_type=9135
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.023443] usb 1-1.3: dvb_usb_v2:
>>>> found a 'ITE 9135 Generic' in cold state
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.023519] usb 1-1.3: dvb_usb_v2:
>>>> downloading firmware from file 'dvb-usb-it9135-02.fw'
>>>> Nov 25 16:24:38 zly-hugo mtp-probe: checking bus 1, device 5:
>>>> "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3"
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.119961] usb 1-1.3:
>>>> dvb_usb_af9035: firmware version=3.40.1.0
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.119974] usb 1-1.3: dvb_usb_v2:
>>>> found a 'ITE 9135 Generic' in warm state
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.120972] usb 1-1.3: dvb_usb_v2:
>>>> will pass the complete MPEG2 transport stream to the software demuxer
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.120996] DVB: registering new
>>>> adapter (ITE 9135 Generic)
>>>> Nov 25 16:24:38 zly-hugo mtp-probe: bus: 1, device: 5 was not an MTP
>>>> device
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.123808] af9033 8-0038: firmware
>>>> version: LINK 3.40.1.0 - OFDM 3.40.1.0
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.123812] af9033 8-0038: Afatech
>>>> AF9033 successfully attached
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.123822] usb 1-1.3: DVB:
>>>> registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
>>>> Nov 25 16:24:38 zly-hugo kernel: [  316.125115] it913x: probe of 8-001c
>>>> failed with error -22
>>>> ---------------------
>>>>
>>>> What is wrong ?
>>>
>>> it913x_probe() fails with error -EINVAL. There is only 2 ways it could
>>> fail, kzalloc() and regmap_init_i2c(). It must be later one.
>>>
>>> Do you have regmap module installed?
>>> What says: "modinfo regmap-i2c" command?
>>>
>>> Antti
>
