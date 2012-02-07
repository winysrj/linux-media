Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47330 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2BGKJg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 05:09:36 -0500
Received: by eekc14 with SMTP id c14so2479198eek.19
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2012 02:09:35 -0800 (PST)
Message-ID: <4F30F85B.8090801@gmail.com>
Date: Tue, 07 Feb 2012 11:09:31 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Andrej Podzimek <andrej@podzimek.org>
CC: linux-media@vger.kernel.org
Subject: Re: AverTV Volar HD PRO
References: <4F2F145C.6000405@podzimek.org> <4F2F3BE1.7030801@gmail.com> <4F30B22B.9050708@podzimek.org>
In-Reply-To: <4F30B22B.9050708@podzimek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 07/02/2012 06:10, Andrej Podzimek ha scritto:
>>> Hello,
>>>
>>> this USB stick (07ca:a835) used to work fine with the 3.0 and 3.1 kernel
>>> series, using one of the howtos in this thread:
>>> http://forum.ubuntu-it.org/index.php/topic,384436.msg3370690.html
>>>
>>> However, there were some build errors with my current kernel 3.2.4, so I
>>> tried to update the entire media tree instead, as described here:
>>> http://git.linuxtv.org/media_build.git
>>>
>>> Unfortunately, the device doesn't work. These are the dmesg messages
>>> that appear after plugging the receiver in:
>>>
>>>
>>> Surprisingly, the tda18218 module doesn't load automatically (I guess it
>>> should) and loading it manually doesn't help. So the device doesn't get
>>> initialized at all and there are no messages about firmware loading.
>>> (The firmware file is in /lib/firmware, of course.)
>>>
>>> Is it possible to make the device work somehow? The receiver worked fine
>>> with older kernels (using the howto from ubuntu-it.org linked above) and
>>> the remote controller was usable as well.
>>>
>>
>> Hi Andrej,
>> here you can find an updated version of the af9035 patch:
>>
>> http://openpli.git.sourceforge.net/git/gitweb.cgi?p=openpli/openembedded;a=blob_plain;f=recipes/linux/linux-etxx00/dvb-usb-af9035.patch;hb=HEAD
>>
>>
>> There are several improvements, including support for newer kernels (3.2
>> and 3.3) as well as the current media_build tree.
>> I also added the missing "select" directives for the tda18218 and
>> mxl5007T tuners, so the modules auto-loads correctly now.
>>
>> In this version there is no remote support.
>>
>> Please let me know if it works fine for you.
>>
>> Regards,
>> Gianluca
> 
> Hi Gianluca,
> 
> the tuner seems to work now. I applied the patch directly to the 3.2.5
> kernel, without using the media_build tree. (Is this the correct
> approach?) Unlike the previous versions of the driver, this one does not
> keep the tuner hot when inactive. (There must have been a power
> management issue that is already resolved.)
> 
> This is what I see in dmesg:
> 
>     usb 3-1.2: new high-speed USB device number 9 using ehci_hcd
>     dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in cold
> state, will try to load a firmware
>     dvb-usb: downloading firmware from file 'dvb-usb-af9035-01.fw'
>     dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in warm
> state.
>     dvb-usb: will pass the complete MPEG2 transport stream to the
> software demuxer.
>     DVB: registering new adapter (Avermedia AverTV Volar HD & HD PRO
> (A835))
>     af9033: firmware version: LINK:11.15.10.0 OFDM:5.48.10.0
>     DVB: registering adapter 0 frontend 0 (Afatech AF9033 DVB-T)...
>     tda18218: NXP TDA18218HN successfully identified.
>     dvb-usb: Avermedia AverTV Volar HD & HD PRO (A835) successfully
> initialized and connected.
>     usbcore: registered new interface driver dvb_usb_af9035
> 
> However, there are still some glitches. Sometimes the initialization fails:
> 
>     usb 3-1.2: new high-speed USB device number 8 using ehci_hcd
>     dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in cold
> state, will try to load a firmware
>     dvb-usb: downloading firmware from file 'dvb-usb-af9035-01.fw'
>     af9035: bulk message failed:-71 (6/0)
>     af9035: firmware download failed:-71
>     dvb_usb_af9035: probe of 3-1.2:1.0 failed with error -71
> 
> Unloading the dvb-t modules manually and re-plugging the tuner resolves
> this. Furthermore, I had two kernel panics today. :-( They seem to occur
> when the DVB-T signal is poor for a long time. Unfortunately, I didn't
> have netconsole set up.
> 
> An attempt to scan channels in Kaffeine always fails before the progress
> bar reaches 20% and lots of messages like this appear in dmesg:
> 
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0047
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0047
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0045
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0048
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0047
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:002c
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0047
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0048
> 
> Fortunately, I have another DVB-T tuner (dvb_usb_af9015, MSI DigiVox
> Mini II V3) that scans channels just fine, so I used that one to obtain
> the list of channels. Once you have a list of channels, watching TV with
> the AverTV Volar HD PRO (dvb_usb_af9035) seems to work fine.
> 
> Andrej
> 

Hi Andrej,
thanks for the very detailed report.
I'm happy that the driver seems to work a little better for you.
Unfortunately I don't have the A835 (I have an A867 which uses a
different tuner and it has no problem scanning channels or tuning weak
signals) so there is no chance I can fix this problems.
Probably the TDA18218 tuner is not managed properly in the driver.

Gianluca
