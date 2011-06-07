Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49983 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab1FGFb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 01:31:56 -0400
Received: by wya21 with SMTP id 21so3284451wya.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 22:31:55 -0700 (PDT)
Subject: Re: DM04 USB DVB-S TUNER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mehmet Altan Pire <baybesteci@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4DED628E.9070502@gmail.com>
References: <4DEACF3F.9090305@gmail.com>
	 <1307283393.22968.12.camel@localhost> <4DEBB00D.4040202@gmail.com>
	 <1307306576.2064.13.camel@localhost> <1307310455.2547.9.camel@localhost>
	 <4DED628E.9070502@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 06:31:41 +0100
Message-ID: <1307424701.2117.13.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-06-07 at 02:28 +0300, Mehmet Altan Pire wrote:
> 06-06-2011 00:47, Malcolm Priestley yazmış:
> > On Sun, 2011-06-05 at 21:42 +0100, Malcolm Priestley wrote:
> >> On Sun, 2011-06-05 at 19:34 +0300, Mehmet Altan Pire wrote:
> >>> 05-06-2011 17:16, Malcolm Priestley yazmış:
> >>>> On Sun, 2011-06-05 at 03:35 +0300, Mehmet Altan Pire wrote:
> >>>>> Hi,
> >>>>> I have "DM04 USB DVBS TUNER", using ubuntu with v4l media-build
> >>>>> drivers/modules but device  doesn't working (unknown device).
> >>>>>
> >>>>> lsusb message:
> >>>>> ID 3344:22f0
> >>>>>
> >>>>> under of the box:
> >>>>> DM04P2011050176
> >>> Yes, i have windows xp driver, name is "US2B0D.sys" I sending it,
> >>> attached in this mail. Thanks. 
> >> Here is a modified lmedm04.c and lme2510b_fw.sh using the US2B0D.sys
> >>
> to modify the interrupt return.
> >

> >
> Ok, i tested it. Device recognized on WinXP with original driver, but tv
> application says "no lock".
> I'm not sure it worked on WinXP but driver cd is original and
> succesfully loaded and recognized.
> Again tested on ubuntu with new lmedm04.c and lme2510b_fw.sh than make,
> make install, and restart.
> 
> lsusb says:
> Bus 001 Device 008: ID 3344:1120  (changes 22f0 to 1120)
> dmesg says:
Yes this should happen. The firmware will reboot with the correct id.

> [ 1281.102958] LME2510(C): Firmware Status: 6 (44)
> [ 1281.107948] LME2510(C): FRM Loading dvb-usb-lme2510c-lg.fw file
> [ 1281.107958] LME2510(C): FRM Starting Firmware Download
> [ 1283.548064] LME2510(C): FRM Firmware Download Completed - Resetting
> Device
It found a LG tuner

remove the dvb-usb-lme2510c-lg.fw firmware file.

rename dvb-usb-lme2510c-s7395.fw to dvb-usb-lme2510c-lg.fw.

> [ 1283.548221] usb 1-2: USB disconnect, address 7
> [ 1283.792067] usb 1-2: new high speed USB device using ehci_hcd and
> address 8
> [ 1283.928354] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
> 0x81 has invalid maxpacket 64
> [ 1283.928360] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
> 0x1 has invalid maxpacket 64
> [ 1283.928364] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
> 0x2 has invalid maxpacket 64
> [ 1283.929850] LME2510(C): Firmware Status: 6 (47)
> [ 1283.929855] dvb-usb: found a 'DM04_LME2510C_DVB-S' in warm state.
> [ 1283.954607] dvb-usb: will use the device's hardware PID filter (table
> count: 15).

> My device different or chip is damaged? Label, box and driver cd title
> writes "DM04P". DM04 and DM04P different devices?

I think the id of the chip is faulty or default.

I will test the firmware with LG tuner later.

tvboxspy

