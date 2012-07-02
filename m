Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54911 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab2GBV13 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jul 2012 17:27:29 -0400
Message-ID: <4FF21238.1000002@iki.fi>
Date: Tue, 03 Jul 2012 00:27:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>,
	htl10@users.sourceforge.net
Subject: Re: DVB core enhancements - comments please?
References: <4FEBA656.7060608@iki.fi> <4FED2FE0.9010602@redhat.com> <4FED3714.2080901@iki.fi> <2601054.j5eSD2QU7J@dibcom294> <4FEDBB9B.9010400@redhat.com>
In-Reply-To: <4FEDBB9B.9010400@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/29/2012 05:28 PM, Mauro Carvalho Chehab wrote:
> Em 29-06-2012 08:24, Patrick Boettcher escreveu:
>> On Friday 29 June 2012 08:03:16 Antti Palosaari wrote:
>>> On 06/29/2012 07:32 AM, Mauro Carvalho Chehab wrote:
>>>> Em 27-06-2012 21:33, Antti Palosaari escreveu:
>>>>> SDR - Softaware Defined Radio support DVB API
>>>>> --------------------------------------------------
>>>>> *
>>>>> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructu
>>>>> re/44461 * there is existing devices that are SDR (RTL2832U "rtl-sdr")
>>>>> * SDR is quite near what is digital TV streaming
>>>>> * study what is needed
>>>>> * new delivery system for frontend API called SDR?
>>>>> * some core changes needed, like status (is locked etc)
>>>>> * how about demuxer?
>>>>> * stream conversion, inside Kernel?
>>>>> * what are new parameters needed for DVB API?
>>>>
>>>> Let's not mix APIs: the radio control should use the V4L2 API, as this
>>>> is not DVB. The V4L2 API has already everything needed for radio. The
>>>> only missing part ther is the audio stream. However, there are a few
>>>> drivers that provide audio via the radio device node, using
>>>> read()/poll() syscalls, like pvrusb. On this specific driver, audio
>>>> comes through a MPEG stream. As SDR provides audio on a different
>>>> format, it could make sense to use VIDIOC_S_STD/VIDIOC_G_STD to
>>>> set/retrieve the type of audio stream, for SDR, but maybe it better to
>>>> just add capabilities flag at VIDIOC_QUERYCTL or VIDIOC_G_TUNER to
>>>> indicate that the audio will come though the radio node and if the
>>>> format is MPEG or SDR.
>>> SDR is not a radio in mean of V4L2 analog audio radios. SDR can receive
>>> all kind of signals, analog audio, analog television, digital radio,
>>> digital television, cellular phones, etc. You can even receive DVB-T,
>>> but hardware I have is not capable to receive such wide stream.
>>>
>>> That chip supports natively DVB-T TS but change be switched to SDR mode.
>>> Is it even possible to switch from DVB API (DVB-T delivery system) to
>>> V4L2 API at runtime?
>>
>> It could be possible that neither the DVB-API nor the V4L2 API is the right
>> user-interface for such devices. The output of such devices is the
>> acquisition of raw (digitalized) data of a signal and here signal is meant
>> in the sense of anything which can be digitalized (e.g.: sensors, tuners,
>> ADCs).
>>
>> Such device will surely be have a device-specific (user-space?) library to
>> do the post/pre-processing before putting this data into a generic format.
>
> That's one more reason why using the V4L2 API is better: at the V4L2 API, the
> output format is represented by a 32 bits unique code. There are several
> standard fourcc codes there, plus several proprietary formats represented.
> The decoding between the proprietary formats is done via libv4l. Libv4l
> can be used with any pre-compiled userspace application, via LD_PRELOAD,
> although almost all V4L2 userspace applications[1] are using the libv4l to decode
> data. Adding SDR decoding there should not be hard.
>
> [1] Radio applications don't use it yet, as almost all radio devices output
> audio via ALSA API, so some work will be needed there to add SDR radio
> support.
>
>>> That said, IMO, the rtl-sdr driver should sit on the DVB-API. Maybe V4L2
>>> provides a device-specific control path (to configure the hardware) if not
>>> somewhere else, or something new needs to be created.
>
>> *argl* I wanted to say, ... should _not_ sit on the DVB-API...
>
> Agreed. Tuning with the V4L2 API is more direct, as doesn't have any
> threads looking for DVB demod status, in order to do frequency zig-zag.
>
> It also have support for hardware frequency scanning, which can be an
> interesting feature if supported.

OK, I have now played (too) many hours. Looking existing code and 
testing. But I cannot listen even simple FM-radio station. What are most 
famous / best radio applications ? I tried gnomeradio, gqradio and fmscan...

That is USB radio based si470x chipset.

Jul  3 00:12:18 localhost kernel: [27988.288783] usb 5-2: New USB device 
found, idVendor=10c5, idProduct=819a
Jul  3 00:12:18 localhost kernel: [27988.288787] usb 5-2: New USB device 
strings: Mfr=1, Product=2, SerialNumber=0
Jul  3 00:12:18 localhost kernel: [27988.288789] usb 5-2: Manufacturer: 
www.rding.cn
Jul  3 00:12:18 localhost udevd[409]: specified group 'plugdev' unknown
Jul  3 00:12:18 localhost kernel: [27988.310751] radio-si470x 5-2:1.2: 
DeviceID=0x1242 ChipID=0x060c
Jul  3 00:12:18 localhost kernel: [27988.310754] radio-si470x 5-2:1.2: 
This driver is known to work with firmware version 15,
Jul  3 00:12:18 localhost kernel: [27988.310756] radio-si470x 5-2:1.2: 
but the device has firmware version 12.
Jul  3 00:12:18 localhost kernel: [27988.312750] radio-si470x 5-2:1.2: 
software version 1, hardware version 7
Jul  3 00:12:18 localhost kernel: [27988.312753] radio-si470x 5-2:1.2: 
This driver is known to work with software version 7,
Jul  3 00:12:18 localhost kernel: [27988.312755] radio-si470x 5-2:1.2: 
but the device has software version 1.
Jul  3 00:12:18 localhost kernel: [27988.312756] radio-si470x 5-2:1.2: 
If you have some trouble using this driver,
Jul  3 00:12:18 localhost kernel: [27988.312757] radio-si470x 5-2:1.2: 
please report to V4L ML at linux-media@vger.kernel.org


regards
Antti

-- 
http://palosaari.fi/


