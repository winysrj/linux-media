Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:59844 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3BIORz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 09:17:55 -0500
Received: by mail-ea0-f181.google.com with SMTP id i13so2034899eaa.26
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2013 06:17:53 -0800 (PST)
Message-ID: <51165A8E.10805@gmail.com>
Date: Sat, 09 Feb 2013 15:17:50 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Andre Heider <a.heider@gmail.com>,
	Jose Alberto Reguero <jareguero@telefonica.net>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: af9035 test needed!
References: <50F05C09.3010104@iki.fi> <CAHsu+b8UAh5VD_V4Ub6g7z_5LC=NH1zuY77Yv5nBefnrEwUHMw@mail.gmail.com> <510A78D8.7030602@iki.fi> <CAHsu+b-TdcBaM_JzsON40k+4sifL27xM-AV8M6bdMt9L3ZCpeA@mail.gmail.com> <510ABD7F.6030200@iki.fi>
In-Reply-To: <510ABD7F.6030200@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 31/01/2013 19:52, Antti Palosaari ha scritto:
> Jose, Gianluca,
> 
> On 01/31/2013 08:40 PM, Andre Heider wrote:
>> Hey,
>>
>> On Thu, Jan 31, 2013 at 2:59 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>> On Fri, Jan 11, 2013 at 7:38 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>>
>>>>> Could you test that (tda18218 & mxl5007t):
>>
>> only now I see you mentioned mxl5007t too, and with the same tree as I
>> used for my 'TerraTec Cinergy T Stick Dual RC (rev. 2)', a 'AVerMedia
>> HD Volar (A867)' with a mxl5007t (and an unkown rev) works too:
>>
>> usb 3-3.1.4: new high-speed USB device number 7 using xhci_hcd
>> usb 3-3.1.4: New USB device found, idVendor=07ca, idProduct=1867
>> usb 3-3.1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> usb 3-3.1.4: Product: A867
>> usb 3-3.1.4: Manufacturer: AVerMedia TECHNOLOGIES, Inc
>> usb 3-3.1.4: SerialNumber: 0305770200261
>> usb 3-3.1.4: af9035_identify_state: prechip_version=00 chip_version=03
>> chip_type=3802
> 
> Who one as able to test with non-working AF9035 + MxL5007T combination.
> Does it report different chip versions? Same firmware used?

Hi Antti,
I finally found a friend with the Avermedia A867 (AF9035 + MxL5007T) non
working revision (A867-DP7):
http://forum.ubuntu-it.org/viewtopic.php?f=9&t=516182&start=60#p4301226

Apparently, there is no difference in the log file about the chip version:

[   90.047319] usb 1-1.3: New USB device found, idVendor=07ca,
idProduct=a867
[   90.047325] usb 1-1.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[   90.047330] usb 1-1.3: Product: A867
[   90.047334] usb 1-1.3: Manufacturer: AVerMedia TECHNOLOGIES, Inc
[   90.047337] usb 1-1.3: SerialNumber: 5037944035440
[   90.142796] usbcore: registered new interface driver dvb_usb_af9035
[   90.143779] usb 1-1.3: af9035_identify_state: prechip_version=00
chip_version=03 chip_type=3802
[   90.144178] usb 1-1.3: dvb_usb_v2: found a 'AVerMedia HD Volar
(A867)' in cold state
[   90.170437] usb 1-1.3: dvb_usb_v2: downloading firmware from file
'dvb-usb-af9035-02.fw'
[   90.495461] usb 1-1.3: dvb_usb_af9035: firmware version=12.13.15.0
[   90.495483] usb 1-1.3: dvb_usb_v2: found a 'AVerMedia HD Volar
(A867)' in warm state
[   90.498004] usb 1-1.3: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[   90.498046] DVB: registering new adapter (AVerMedia HD Volar (A867))
[   90.498401] DVB: register adapter0/demux0 @ minor: 0 (0x00)
[   90.498476] DVB: register adapter0/dvr0 @ minor: 1 (0x01)
[   90.498543] DVB: register adapter0/net0 @ minor: 2 (0x02)
[   90.549788] i2c i2c-8: af9033: firmware version: LINK=12.13.15.0
OFDM=6.20.15.0
[   90.549798] usb 1-1.3: DVB: registering adapter 0 frontend 0 (Afatech
AF9033 (DVB-T))...
[   90.549903] DVB: register adapter0/frontend0 @ minor: 3 (0x03)
[   90.913945] mxl5007t 8-0060: creating new instance
[   90.929824] Registered IR keymap rc-empty
[   90.929937] input: AVerMedia HD Volar (A867) as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0/input13
[   90.930019] rc0: AVerMedia HD Volar (A867) as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0
[   90.930027] usb 1-1.3: dvb_usb_v2: schedule remote query interval to
500 msecs
[   90.930032] usb 1-1.3: dvb_usb_v2: 'AVerMedia HD Volar (A867)'
successfully initialized and connected


Also, the stick works fine with Jose's patch, independently from the
firmware file used.

Regards,
Gianluca

> 
> 
>> usb 3-3.1.4: dvb_usb_v2: found a 'AVerMedia HD Volar (A867)' in cold
>> state
>> usb 3-3.1.4: dvb_usb_v2: downloading firmware from file
>> 'dvb-usb-af9035-02.fw'
>> usb 3-3.1.4: dvb_usb_af9035: firmware version=11.5.9.0
>> usb 3-3.1.4: dvb_usb_v2: found a 'AVerMedia HD Volar (A867)' in warm
>> state
>> usb 3-3.1.4: dvb_usb_v2: will pass the complete MPEG2 transport stream
>> to the software demuxer
>> DVB: registering new adapter (AVerMedia HD Volar (A867))
>> i2c i2c-19: af9033: firmware version: LINK=11.5.9.0 OFDM=5.17.9.1
>> usb 3-3.1.4: DVB: registering adapter 1 frontend 0 (Afatech AF9033
>> (DVB-T))...
>> mxl5007t 19-0060: creating new instance
>> mxl5007t_get_chip_id: unknown rev (3f)
>> mxl5007t_get_chip_id: MxL5007T detected @ 19-0060
>> Registered IR keymap rc-empty
>> input: AVerMedia HD Volar (A867) as
>> /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1.4/rc/rc5/input29
>> rc5: AVerMedia HD Volar (A867) as
>> /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1.4/rc/rc5
>> usb 3-3.1.4: dvb_usb_v2: schedule remote query interval to 500 msecs
>> usb 3-3.1.4: dvb_usb_v2: 'AVerMedia HD Volar (A867)' successfully
>> initialized and connected
> 
> regards
> Antti
> 

