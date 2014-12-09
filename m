Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38755 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbaLIFh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Dec 2014 00:37:57 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so6694129wiw.13
        for <linux-media@vger.kernel.org>; Mon, 08 Dec 2014 21:37:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141208115632.GA6220@trt2>
References: <20141207124107.GA7271@trt2>
	<CAAZRmGzEPh5VVhNdVZUAX22KSQpVLVjx6hB3ZftrEEa3RHG1Tw@mail.gmail.com>
	<20141208115632.GA6220@trt2>
Date: Tue, 9 Dec 2014 12:37:55 +0700
Message-ID: <CAAZRmGxy32eWv3tCDwLMLtffLt1g-ROxwVb==pGUZJvYWTWPuA@mail.gmail.com>
Subject: Re: TT-connect CT2-4650 CI: DVB-C: no signal, no QAM
From: Olli Salonen <olli.salonen@iki.fi>
To: Pavol Domin <pavol.domin@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavol,

Thanks. As said, I have not had any time to look into this, but will
definitely do so. I own the same device, but do not have cable TV at
home. Am using Conax CAM also successfully, so I believe that CI is
not the issue.

Some things that came to my mind still:

Can you share the results of w_scan with very verbose output with both
TT driver and the kernel driver? Also, make sure you use a recent
version of w_scan - some distributions come with a rather old
version...

w_scan -v -v -v <your_options_here> 2>&1 | tee logfile.txt

Also, if you want to try a later firmware for Si2168, have a look at this patch:
http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=1b97dc98b58dad98f13fa0a4cdc819b60f3f3bff

It is in media_tree already.

Cheers,
-olli


On 8 December 2014 at 18:56, Pavol Domin <pavol.domin@gmail.com> wrote:
> Hi Olli,
>
> Thanks for feedback.
>> Are you able to provide me a trace of the USB bus when using Windows? This
>> is what I have been doing.
>>
>> 1) install USBlyzer
>> 2) start it and select the option Capture hot plugged in the menus
>> 3) start capture
>> 4) plug in the device
>> 5) start watching tv
>> 6) stop capture after 1 sec to avoid the capture file growing too much
> I've done that and shared at:
> https://drive.google.com/open?id=0B94Ll0t460PoSTdKR0xiZlU2S0E&authuser=0
>
>> Would be also good to know if gnutv -cammenu works with the open source
> Yes, it seems to work (except it coredumps after ctrl-c on fedora), e.g.
> $ gnutv -channels channels.xine.conf -cammenu "Eurosport HD"
> CAM Application type: 01
> CAM Application manufacturer: 0b00
> CAM Manufacturer code: 0001
> CAM Menu string: Conax Conditional Access
> CAM supports the following ca system ids:
>   0x0b00
>   ------------------------------
>   Conax Conditional Access
>   Main menu
>   0. Quit menu
>   1. Subscription status
>   2. Event status
>   3. Tokens status
>   4. Change CA PIN
>   5. Maturity Rating
>   6. Ordering online
>   7. About Conax CA
>   8. Messages
>   9. Language
>   10. Loader status
>   11. CI Plus Info
>   Press OK to select, or press RETURN
>
>> driver. Are all your channels encrypted? Is there any difference between
>> them?
> No, some are unencrypted. I cannot tell there are some other
> differences, windows application 'tt-viewer' does not show details
> about scanned channels. Also, the multiplex frequencies listed by
> provider do not seem to match much with what the w_scan initially found.
> Also, w_scan only scanned at QAM256, tv provider page suggests there are
> some channels at QAM64 (I havent tried to scan those).
> But again, it worked (with the TechnoTrend driver) for a short while
> from linux, even the encryted channels I think.
>
> Regards
>
> Pavol
>
>>
>> Cheers,
>> -olli
>> On 7 Dec 2014 19:41, "Pavol Domin" <pavol.domin@gmail.com> wrote:
>>
>> > Hello,
>> >
>> > I recently purchased "TechnoTrend TT-connect CT2-4650 CI" in order to
>> > watch DVB-C cable TV. I have obtained CAM and smart card from my cable
>> > TV provider.
>> >
>> > Initially, I tried the closed-source driver from the manufacturer; I have
>> > scanned (w_scan) over hundred of channels and I was able to watch few
>> > channels (vlc
>> > or xine) for several minutes. After couple of channels switches however,
>> > xine started to report 'DVB Signal Lost' for any channel. The w_scan
>> > founds nothing anymore - tried multiple kernels on different machines,
>> > during several days, nothing ;)
>> >
>> > Manufacturer is not providing linux support and directed me to
>> > linux_media instead.
>> >
>> > The situation with linux_media is not better however (tried recent
>> > media_build on ubuntu 3.16 and fedora 3.17 kernels)
>> >
>> > 1. the device is detected without any problems, no single error reported:
>> > [ 1957.068871] dvb-usb: found a 'TechnoTrend TT-connect CT2-4650 CI' in
>> > warm state.
>> > [ 1957.068999] dvb-usb: will pass the complete MPEG2 transport stream to
>> > the software demuxer.
>> > [ 1957.069182] DVB: registering new adapter (TechnoTrend TT-connect
>> > CT2-4650 CI)
>> > [ 1957.070518] dvb-usb: MAC address: bc:ea:2b:65:02:3b
>> > [ 1957.283195] i2c i2c-9: Added multiplexed i2c bus 10
>> > [ 1957.283205] si2168 9-0064: Silicon Labs Si2168 successfully attached
>> > [ 1957.287689] si2157 10-0060: Silicon Labs Si2147/2148/2157/2158
>> > successfully attached
>> > [ 1957.498312] sp2 9-0040: CIMaX SP2 successfully attached
>> > [ 1957.498348] usb 1-1.3: DVB: registering adapter 0 frontend 0 (Silicon
>> > Labs Si2168)...
>> > [ 1957.498835] Registered IR keymap rc-tt-1500
>> > [ 1957.499038] input: IR-receiver inside an USB DVB receiver as
>> > /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0/input23
>> > [ 1957.499408] rc0: IR-receiver inside an USB DVB receiver as
>> > /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0
>> > [ 1957.499413] dvb-usb: schedule remote query interval to 150 msecs.
>> > [ 1957.499419] dvb-usb: TechnoTrend TT-connect CT2-4650 CI successfully
>> > initialized and connected.
>> > [ 1963.755553] dvb_ca adapter 0: DVB CAM detected and initialised
>> > successfully
>> > [ 2016.342642] si2168 9-0064: found a 'Silicon Labs Si2168' in cold state
>> > [ 2016.342910] si2168 9-0064: downloading firmware from file
>> > 'dvb-demod-si2168-a20-01.fw'
>> > [ 2017.729882] si2168 9-0064: found a 'Silicon Labs Si2168' in warm state
>> > [ 2017.739725] si2157 10-0060: found a 'Silicon Labs
>> > Si2146/2147/2148/2157/2158' in cold state
>> > [ 2017.739805] si2157 10-0060: downloading firmware from file
>> > 'dvb-tuner-si2158-a20-01.fw'
>> >
>> > 2. yet, the full dvb-c w_scan founds zero channels (after 20+ minutes of
>> > scanning)
>> >
>> > 3. an attempt to tune a channel (czap) using the channel list scanned
>> > the first time returns:
>> > $ czap -r -c channels.xine.conf 'Eurosport HD'
>> > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> > reading channels from file 'channels.xine.conf'
>> > 141 Eurosport
>> > HD:562000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256:3000:3201:14001
>> > 141 Eurosport HD: f 562000000, s 6900000, i 2, fec 0, qam 5, v 0xbb8, a
>> > 0xc81, s 0x36b1
>> > ERROR: frontend device is not a QAM (DVB-C) device
>> >
>> >
>> > Any advice, please, what can be done to make this working? The device
>> > works without any problems from windows.
>> >
>> > Two additional notes:
>> > 1. The md5sum 0276023ce027bab05c2e7053033e2182 for the firmware linked at
>> >
>> > http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-TVStick_CT2-4400#Firmware
>> > does not match:
>> >
>> > $ wget http://www.tt-downloads.de/bda-treiber_4.2.0.0.zip
>> > ...
>> > 2014-12-07 13:12:25 (1.06 MB/s) - ‘bda-treiber_4.2.0.0.zip’ saved
>> > [352188/352188]
>> > $ unzip bda-treiber_4.2.0.0.zip
>> > Archive:  bda-treiber_4.2.0.0.zip
>> >   inflating: ttTVStick4400.inf
>> >   inflating: ttTVStick4400.sys
>> >   inflating: ttTVStick4400_64.sys
>> >   inflating: tttvstick4400.cat
>> > $ md5sum ttTVStick4400_64.sys
>> > 7ac2029e1db41b8942691df270e0f84f  ttTVStick4400_64.sys
>> >
>> > I copied firmwares from OpenELEC
>> >
>> > 2. I am getting this, with w_scan, with the media_build driver:
>> > $ cat w_scan
>> > using DVB API 5.a
>> > frontend 'Silicon Labs Si2168' supports
>> > INVERSION_AUTO
>> > QAM_AUTO
>> > FEC_AUTO
>> > FREQ (110.00MHz ... 862.00MHz)
>> > This dvb driver is *buggy*: the symbol rate limits are undefined -
>> > please report to linuxtv.org
>> > ...
>> >
>> > 3. Manufacturer driver displays no w_scan "no QAM" errors, even czap seems
>> > fine:
>> > $ czap -r -c channels.xine.conf 'Eurosport HD'
>> > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> > reading channels from file 'channels.xine.conf'
>> > 141 Eurosport
>> > HD:562000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256:3000:3201:14001
>> > 141 Eurosport HD: f 562000000, s 6900000, i 2, fec 0, qam 5, v 0xbb8, a
>> > 0xc81, s 0x36b1
>> > Version: 5.10       FE_CAN { DVB-C (A) }
>> > status 1f | signal 5453 | snr 0003 | ber 8e8dead8 | unc 000f00ed |
>> > FE_HAS_LOCK
>> > status 1f | signal 5453 | snr 0003 | ber 00000000 | unc 000f00ed |
>> > FE_HAS_LOCK
>> > ...
>> >
>> > Yet, the application reports no signal.
>> >
>> >
>> > Regards,
>> > Pavol
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
