Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61678 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2DGVcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2012 17:32:33 -0400
Received: by iagz16 with SMTP id z16so4447202iag.19
        for <linux-media@vger.kernel.org>; Sat, 07 Apr 2012 14:32:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F80A06D.8080504@schinagl.nl>
References: <CALnoPX4UJuzC9svAVPAs56YfDE7Ex92c1kpj+2X5shWRVQ4JxQ@mail.gmail.com>
 <4F80A06D.8080504@schinagl.nl>
From: Jan Prunk <janprunk@gmail.com>
Date: Sat, 7 Apr 2012 23:32:13 +0200
Message-ID: <CALnoPX40aQDKDt-a5Psm=Z0BgUKPmwBJi132Xu2YB13knQJN4A@mail.gmail.com>
Subject: Re: ASUS U3100 Mini
To: Oliver Schinagl <oliverlist@schinagl.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver !

Thank you for your quick response.

I assume that mine is a non-plus version.
Do you know how I could proceed tuning the channel list,
which I could then use in the combination with MPlayer ?

Kind regards,
Jan

On Sat, Apr 7, 2012 at 10:15 PM, Oliver Schinagl <oliverlist@schinagl.nl> wrote:
> Hi Jan,
>
> That page is probably not supported by linux-media and shows support
> (currently not working afaik) forthe U3100 mini PLUS. yes, minor difference
> in name, huge difference inside. The non-plus is a dib0700 based device,
> whereas the Plus is a af9035 based device. The non-plus should work out of
> the box on most distro's.
>
> Oliver
>
>
> On 07-04-12 20:21, Jan Prunk wrote:
>>
>> Hi !
>>
>> I have ASUS U3100 Mini USB Dongle and I would like to watch DVB-T
>> TV streams with it on Debian. The dongle when its plugged in lights with
>> the green light. Performing "(dvb)scan" segfaults.
>>
>> I (partially) followed these guides:
>>
>> http://linuxtv.org/wiki/index.php/Asus_U3100_Mini_plus_DVB-T
>>
>> I am using debian testing and it seems the device gets somehow recognised:
>>
>> [15120.976095] usb 3-1: USB disconnect, device number 2
>> [15124.716041] usb 1-3: new high-speed USB device number 5 using ehci_hcd
>> [15124.848958] usb 1-3: New USB device found, idVendor=0b05,
>> idProduct=173f
>> [15124.848964] usb 1-3: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [15124.848970] usb 1-3: Product: ASUS DVBT Tuner
>> [15124.848974] usb 1-3: Manufacturer: ASUSTeK
>> [15124.848977] usb 1-3: SerialNumber: 8500500875
>> [15125.344564] IR NEC protocol handler initialized
>> [15125.370992] IR RC5(x) protocol handler initialized
>> [15125.409376] dib0700: loaded with support for 21 different device-types
>> [15125.409588] dvb-usb: found a 'ASUS My Cinema U3100 Mini DVBT Tuner'
>> in cold state, will try to load a firmware
>> [15125.412893] IR RC6 protocol handler initialized
>> [15125.440888] IR JVC protocol handler initialized
>> [15125.463698] dvb-usb: downloading firmware from file
>> 'dvb-usb-dib0700-1.20.fw'
>> [15125.465236] IR Sony protocol handler initialized
>> [15125.468745] IR MCE Keyboard/mouse protocol handler initialized
>> [15125.473597] lirc_dev: IR Remote Control driver registered, major 249
>> [15125.474883] IR LIRC bridge handler initialized
>> [15125.671203] dib0700: firmware started successfully.
>> [15126.172240] dvb-usb: found a 'ASUS My Cinema U3100 Mini DVBT Tuner'
>> in warm state.
>> [15126.172346] dvb-usb: will pass the complete MPEG2 transport stream
>> to the software demuxer.
>> [15126.172902] DVB: registering new adapter (ASUS My Cinema U3100 Mini
>> DVBT Tuner)
>> [15126.390206] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
>> [15126.607078] DiB0070: successfully identified
>> [15126.708031] Registered IR keymap rc-dib0700-rc5
>> [15126.708271] input: IR-receiver inside an USB DVB receiver as
>> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc0/input12
>> [15126.709054] rc0: IR-receiver inside an USB DVB receiver as
>> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc0
>> [15126.710265] dvb-usb: schedule remote query interval to 50 msecs.
>> [15126.710273] dvb-usb: ASUS My Cinema U3100 Mini DVBT Tuner
>> successfully initialized and connected.
>> [15126.710492] usbcore: registered new interface driver dvb_usb_dib0700
>> [15557.359129] scan[3798]: segfault at 3 ip b7620aa6 sp bfc268ac error
>> 4 in libc-2.13.so[b75e2000+156000]
>> [15650.161033] scan[3836]: segfault at 3 ip b766faa6 sp bf9974dc error
>> 4 in libc-2.13.so[b7631000+156000]
>>
>> After this I used the guide at:
>> http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device
>>
>> Which resulted into:
>> yang@vaio:~$ scan /usr/share/dvb/dvb-t/si-Ljubljana>
>>  ~/.tzap/channels.conf
>> scanning /usr/share/dvb/dvb-t/si-Ljubljana
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder 602000000 0 2 9 3 1 3 0
>> initial transponder 514000000 0 2 9 3 1 2 0
>>>>>
>>>>> tune to:
>>>>> 602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>
>> WARNING:>>>  tuning failed!!!
>>>>>
>>>>> tune to:
>>>>> 602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>>>> (tuning failed)
>>
>> WARNING:>>>  tuning failed!!!
>>>>>
>>>>> tune to:
>>>>> 514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>
>> WARNING:>>>  tuning failed!!!
>>>>>
>>>>> tune to:
>>>>> 514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>>> (tuning failed)
>>
>> WARNING:>>>  tuning failed!!!
>> ERROR: initial tuning failed
>> dumping lists (0 services)
>> Done.
>>
>> So I seem to be stuck here.
>>
>> I please for some guidance here, thank you !
>>
>> Kind regards,
>> Jan Prunk
>
>



-- 
Jan Prunk   http://www.prunk.si
0x00E80E86  http://pgp.prunk.si
http://AS50763.peeringdb.com
