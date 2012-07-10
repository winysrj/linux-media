Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55712 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab2GJXNp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 19:13:45 -0400
Message-ID: <4FFCB71F.5090807@iki.fi>
Date: Wed, 11 Jul 2012 02:13:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl> <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl> <4FF77C1B.50406@iki.fi> <l2smc9-pj4.ln1@wuwek.kopernik.gliwice.pl> <4FF97DF8.4080208@iki.fi> <n1aqc9-sp4.ln1@wuwek.kopernik.gliwice.pl> <4FFA996D.9010206@iki.fi> <scerc9-bm6.ln1@wuwek.kopernik.gliwice.pl> <4FFB172A.2070009@iki.fi> <4FFB1900.6010306@iki.fi> <79vsc9-dte.ln1@wuwek.kopernik.gliwice.pl> <4FFBF6F8.7010907@iki.fi> <d7iuc9-ua5.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <d7iuc9-ua5.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/2012 12:08 AM, Marx wrote:
> W dniu 2012-07-10 11:33, Antti Palosaari pisze:
>>
>> Seems like stream is broken. It should look like that:
>>
>> Input #0, mpegts, from '/dev/dvb/adapter0/dvr0':
>>    Duration: N/A, start: 19013.637311, bitrate: 15224 kb/s
>>      Stream #0:0[0x231]: Audio: mp2, 48000 Hz, stereo, s16, 224 kb/s
>>      Stream #0:1[0x131]: Video: mpeg2video (Main), yuv420p, 720x576 [SAR
>> 64:45 DAR 16:9], 15000 kb/s, 26.89 fps, 25 tbr, 90k tbn, 50 tbc
>>
>>
>> You have said it works some times. Could you try to using tzap + ffmpeg
>> cases when it works and when it does not. Use FTA channels to analyze as
>> I think ffmpeg could not say much about encrypted streams.
>
> It's hard to say it works because I have no GUI on this PC and I don't
> know a method to share directly device/stream into PC.
> Hovewer I've tried to tune and analyze several FTA channels.
> I have now better results because:
> 1) i've disconnected pctv device (USB & power)
> 2) poweroff
> 3) poweron
> 4) connect device
> If I simply reboot or reconnect device - it doesn't help.
>
> [   67.544510] Linux media interface: v0.10
> [   67.565420] Linux video capture interface: v2.00
> [   67.834186] saa7146: register extension 'av7110'
> [ 1536.841356] usb 1-4: new high-speed USB device number 2 using ehci_hcd
> [ 1537.437957] usb 1-4: New USB device found, idVendor=2304, idProduct=021f
> [ 1537.437971] usb 1-4: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [ 1537.437980] usb 1-4: Product: PCTV452e
> [ 1537.437989] usb 1-4: Manufacturer: Pinnacle
> [ 1537.556548] usb 1-4: dvb_usbv2: found a 'PCTV HDTV USB' in warm state
> [ 1537.556560] pctv452e_power_ctrl: 1
> [ 1537.556565] pctv452e_power_ctrl: step 1
> [ 1537.556570] pctv452e_power_ctrl: step 2
> [ 1537.557057] pctv452e_power_ctrl: step 3
> [ 1537.557197] usbcore: registered new interface driver dvb_usb_pctv452e
> [ 1537.557263] pctv452e_power_ctrl: step 4
> [ 1537.557491] pctv452e_power_ctrl: step 5
> [ 1537.557610] usb 1-4: dvb_usbv2: will pass the complete MPEG2
> transport stream to the software demuxer
> [ 1537.557670] DVB: registering new adapter (PCTV HDTV USB)
> [ 1537.602916] stb0899_attach: Attaching STB0899
> [ 1537.611531] DVB: registering adapter 0 frontend 0 (STB0899
> Multistandard)...
> [ 1537.625143] stb6100_attach: Attaching STB6100
> [ 1537.625158] pctv452e_power_ctrl: 0
> [ 1537.625173] usb 1-4: dvb_usbv2: 'PCTV HDTV USB' successfully
> initialized and connected
>
> I don't know why it say device is in warm state. As I understand warm
> means with firmware loaded(?), but this device was completely switched off.

Because it does not need to firmware downloaded by the driver. It 
downloads firmware from the eeprom. As it does not need firmware to be 
downloaded by driver it is always warm from the driver point of view.

> 1) Mango 24
> wuwek:~# szap -n 51 -r
> reading channels from file '/root/.szap/channels.conf'
> zapping to 51 'Mango 24;TVN':
> sat 0, frequency = 11393 MHz V, symbolrate 27500000, vpid = 0x0205, apid
> = 0x02bc sid = 0x0245
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal 01c6 | snr 0093 | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK
>
> wuwek:~# ffmpeg -i /dev/dvb/adapter0/dvr0
> p11-kit: couldn't load module:
> /usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so:
> /usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so: cannot open
> shared object file: No such file or directory
> ffmpeg version 0.8.3-6:0.8.3-4, Copyright (c) 2000-2012 the Libav
> developers
>    built on Jun 26 2012 07:23:46 with gcc 4.7.1
> *** THIS PROGRAM IS DEPRECATED ***
> This program is only provided for compatibility and will be removed in a
> future release. Please use avconv instead.
> [mpeg2video @ 0x8d47940] mpeg_decode_postinit() failure
> [mp3 @ 0x8d4a5c0] Header missing
>      Last message repeated 2 times
> [mpegts @ 0x8d43900] max_analyze_duration reached
> [mpegts @ 0x8d43900] Estimating duration from bitrate, this may be
> inaccurate
> Input #0, mpegts, from '/dev/dvb/adapter0/dvr0':
>    Duration: N/A, start: 90810.592967, bitrate: 10000 kb/s
>      Stream #0.0[0x205]: Video: mpeg2video (Main), yuv420p, 480x576 [PAR
> 32:15 DAR 16:9], 10000 kb/s, 25 fps, 25 tbr, 90k tbn, 50 tbc
>      Stream #0.1[0x2bc]: Audio: mp3, 0 channels, s16
> At least one output file must be specified
>
> 2. Eska TV
> wuwek:~# szap -n 52 -r
> reading channels from file '/root/.szap/channels.conf'
> zapping to 52 'Eska TV;ITI':
> sat 0, frequency = 11508 MHz V, symbolrate 27500000, vpid = 0x020a, apid
> = 0x02d6 sid = 0x0000
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal 01ce | snr 008e | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK
>
> wuwek:~# ffmpeg -i /dev/dvb/adapter0/dvr0
> p11-kit: couldn't load module:
> /usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so:
> /usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so: cannot open
> shared object file: No such file or directory
> ffmpeg version 0.8.3-6:0.8.3-4, Copyright (c) 2000-2012 the Libav
> developers
>    built on Jun 26 2012 07:23:46 with gcc 4.7.1
> *** THIS PROGRAM IS DEPRECATED ***
> This program is only provided for compatibility and will be removed in a
> future release. Please use avconv instead.
> [mpegts @ 0x9f1e900] max_analyze_duration reached
> [mpegts @ 0x9f1e900] Estimating duration from bitrate, this may be
> inaccurate
> Input #0, mpegts, from '/dev/dvb/adapter0/dvr0':
>    Duration: N/A, start: 94027.528811, bitrate: 10000 kb/s
>      Stream #0.0[0x2d6]: Data: [0][0][0][0] / 0x0000
>      Stream #0.1[0x20a]: Video: mpeg2video (Main), yuv420p, 704x576 [PAR
> 16:11 DAR 16:9], 10000 kb/s, 25 fps, 25 tbr, 90k tbn, 50 tbc
> At least one output file must be specified
>
> 3. again Mango
> [mpeg2video @ 0x987bb80] mpeg_decode_postinit() failure
>      Last message repeated 6 times
> [mpegts @ 0x9877900] max_analyze_duration reached
> [mpegts @ 0x9877900] Estimating duration from bitrate, this may be
> inaccurate
> Input #0, mpegts, from '/dev/dvb/adapter0/dvr0':
>    Duration: N/A, start: 91684.528967, bitrate: 10000 kb/s
>      Stream #0.0[0x205]: Video: mpeg2video (Main), yuv420p, 480x576 [PAR
> 32:15 DAR 16:9], 10000 kb/s, 26 fps, 25 tbr, 90k tbn, 50 tbc
>      Stream #0.1[0x2bc]: Data: [0][0][0][0] / 0x0000
> At least one output file must be specified
>
> 4. again Mango
> [mpeg2video @ 0x818b940] mpeg_decode_postinit() failure
>      Last message repeated 7 times
> [mpegts @ 0x8187900] max_analyze_duration reached
> [mpegts @ 0x8187900] Estimating duration from bitrate, this may be
> inaccurate
> Input #0, mpegts, from '/dev/dvb/adapter0/dvr0':
>    Duration: N/A, start: 92216.440967, bitrate: 10000 kb/s
>      Stream #0.0[0x205]: Video: mpeg2video (Main), yuv420p, 480x576 [PAR
> 32:15 DAR 16:9], 10000 kb/s, 26.20 fps, 25 tbr, 90k tbn, 50 tbc
>      Stream #0.1[0x2bc]: Data: [0][0][0][0] / 0x0000
> At least one output file must be specified
>
>
> I saved Mango file. VLC for windows doesn't play it, but Media Player
> Classic plays it.

VLC does not play such .ts files. mplayer plays. And some other apps too.

> FFMpeg says:
> wuwek:~# ffmpeg -i /mnt/video/test5.ts
> p11-kit: couldn't load module:
> /usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so:
> /usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so: cannot open
> shared object file: No such file or directory
> ffmpeg version 0.8.3-6:0.8.3-4, Copyright (c) 2000-2012 the Libav
> developers
>    built on Jun 26 2012 07:23:46 with gcc 4.7.1
> *** THIS PROGRAM IS DEPRECATED ***
> This program is only provided for compatibility and will be removed in a
> future release. Please use avconv instead.
> [mp3 @ 0x9ccb940] Header missing
>      Last message repeated 4 times
> [mpegts @ 0x9cc7900] max_analyze_duration reached
> [mpegts @ 0x9cc7900] PES packet size mismatch
> Input #0, mpegts, from '/mnt/video/test5.ts':
>    Duration: 00:00:28.00, start: 94048.816811, bitrate: 4240 kb/s
>      Stream #0.0[0x2d6]: Audio: mp3, 0 channels, s16
>      Stream #0.1[0x20a]: Video: mpeg2video (Main), yuv420p, 704x576 [PAR
> 16:11 DAR 16:9], 10000 kb/s, 25 fps, 25 tbr, 90k tbn, 50 tbc
> At least one output file must be specified

All these tests shows your device is running as it should.

Test VDR again to see if it breaks.

regards
Antti

-- 
http://palosaari.fi/


