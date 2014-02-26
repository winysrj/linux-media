Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38445 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaBZOIU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 09:08:20 -0500
Message-ID: <530DF551.6070609@iki.fi>
Date: Wed, 26 Feb 2014 16:08:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Paavo Leinonen <paavo@leinonen.fi>, linux-media@vger.kernel.org
Subject: Re: Unsupported Anysee version
References: <00c401cf29b8$fb50ede0$f1f2c9a0$@leinonen.fi>
In-Reply-To: <00c401cf29b8$fb50ede0$f1f2c9a0$@leinonen.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Paavo

On 14.02.2014 21:14, Paavo Leinonen wrote:
> Hi,
>
> I plugged in an old Anysee DVB-C and got “Unsupported Anysee version” error.
>
> The box is Fedora 15 running 3.11.10-100.fc18.x86_64 kernel.
>
> Can I do something to get it working or help you to support it?
>
> Note: I’m not 100% sure the Anysee HW is working, but I assume so.

I think that is some old DVB-C only Anysee E30C model, having black 
case? It should be working ages, unless there is no new hardware revisions.

  * E30 C Plus VID=1c73 PID=861f HW=15 FW=1.2 "anysee-FA(LP)"
  * PCB: 507FA (rev0.4)
  * parts: TDA10023, DTOS403IH102B TM, TDA8024
  * OEA=80 OEB=00 OEC=ff OED=ff OEE=ff
  * IOA=4d IOB=ff IOC=00 IOD=00 IOE=c0
  * IOD[5] TDA10023 1=enabled
  * IOE[0] tuner 1=enabled


regards
Antti


>
> -Paavo
>
> [75103.843017] usb 2-3: new high-speed USB device number 5 using ehci-pci
>
> [75104.593493] usb 2-3: device descriptor read/all, error -71
>
> [75105.085016] usb 2-3: new high-speed USB device number 7 using ehci-pci
>
> [75106.542413] usb 2-3: config 1 interface 0 altsetting 0 bulk endpoint
> 0x1 has invalid maxpacket 64
>
> [75106.542426] usb 2-3: config 1 interface 0 altsetting 0 bulk endpoint
> 0x81 has invalid maxpacket 64
>
> [75106.542435] usb 2-3: config 1 interface 0 altsetting 1 bulk endpoint
> 0x1 has invalid maxpacket 64
>
> [75106.542445] usb 2-3: config 1 interface 0 altsetting 1 bulk endpoint
> 0x81 has invalid maxpacket 64
>
> [75106.542786] usb 2-3: New USB device found, idVendor=1c73, idProduct=861f
>
> [75106.542797] usb 2-3: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
>
> [75106.542805] usb 2-3: Product: anysee-FA(LP)
>
> [75106.542811] usb 2-3: Manufacturer: AMT.CO.KR
>
> [75106.543148] usb 2-3: dvb_usb_v2: found a 'Anysee' in warm state
>
> [75106.544411] usb 2-3: dvb_usb_anysee: firmware version 1.2 hardware id 15
>
> [75106.544460] usb 2-3: dvb_usb_v2: will pass the complete MPEG2
> transport stream to the software demuxer
>
> [75106.544496] DVB: registering new adapter (Anysee)
>
> [75106.553168] usb 2-3: dvb_usb_anysee: Unsupported Anysee version.
> Please report to <linux-media@vger.kernel.org>.
>
> [75106.553187] usb 2-3: dvb_usb_v2: 'Anysee' error while loading driver
> (-19)
>
> [75106.554204] usb 2-3: dvb_usb_v2: 'Anysee' successfully deinitialized
> and disconnected
>


-- 
http://palosaari.fi/
