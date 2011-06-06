Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41175 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1FFX2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 19:28:18 -0400
Received: by fxm17 with SMTP id 17so2738317fxm.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 16:28:17 -0700 (PDT)
Message-ID: <4DED628E.9070502@gmail.com>
Date: Tue, 07 Jun 2011 02:28:14 +0300
From: Mehmet Altan Pire <baybesteci@gmail.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: DM04 USB DVB-S TUNER
References: <4DEACF3F.9090305@gmail.com>	 <1307283393.22968.12.camel@localhost> <4DEBB00D.4040202@gmail.com>	 <1307306576.2064.13.camel@localhost> <1307310455.2547.9.camel@localhost>
In-Reply-To: <1307310455.2547.9.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

06-06-2011 00:47, Malcolm Priestley yazmış:
> On Sun, 2011-06-05 at 21:42 +0100, Malcolm Priestley wrote:
>> On Sun, 2011-06-05 at 19:34 +0300, Mehmet Altan Pire wrote:
>>> 05-06-2011 17:16, Malcolm Priestley yazmış:
>>>> On Sun, 2011-06-05 at 03:35 +0300, Mehmet Altan Pire wrote:
>>>>> Hi,
>>>>> I have "DM04 USB DVBS TUNER", using ubuntu with v4l media-build
>>>>> drivers/modules but device  doesn't working (unknown device).
>>>>>
>>>>> lsusb message:
>>>>> ID 3344:22f0
>>>>>
>>>>> under of the box:
>>>>> DM04P2011050176
>>> Yes, i have windows xp driver, name is "US2B0D.sys" I sending it,
>>> attached in this mail. Thanks. 
>> Here is a modified lmedm04.c and lme2510b_fw.sh using the US2B0D.sys
>>
>> Tested here, it appears to work with the sharp7395 tuner.
>>
>> Are you sure it works under Windows?  I can't find your ID in the
>> US2B0D.sys file. It may be a blank lme2510c chip.
>>
>> I assume you are using the lastest media_build to update driver then
>> over write lmedm04.c 
>>
>> found in;
>> media_build/linux/drivers/media/dvb/dvb-usb
>>
>> If already build, just a make and sudo make install is required.
> I have done some further tests with this firmware and it does not return
> the correct signal lock data. By default the signal lock returns the
> last good lock and updated by interrupt. This just means when lock is
> lost the driver still returns lock.
>
> I will need to modify the interrupt return.
>
> However, it may be a different tuner.
>
> tvboxspy
>
>
>
>
Ok, i tested it. Device recognized on WinXP with original driver, but tv
application says "no lock".
I'm not sure it worked on WinXP but driver cd is original and
succesfully loaded and recognized.
Again tested on ubuntu with new lmedm04.c and lme2510b_fw.sh than make,
make install, and restart.

lsusb says:
Bus 001 Device 008: ID 3344:1120  (changes 22f0 to 1120)
dmesg says:
[ 1280.968068] usb 1-2: new high speed USB device using ehci_hcd and
address 7
[ 1281.101483] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
0x81 has invalid maxpacket 64
[ 1281.101497] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
0x1 has invalid maxpacket 64
[ 1281.101507] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
0x2 has invalid maxpacket 64
[ 1281.101518] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
0x8A has invalid maxpacket 64
[ 1281.102958] LME2510(C): Firmware Status: 6 (44)
[ 1281.107948] LME2510(C): FRM Loading dvb-usb-lme2510c-lg.fw file
[ 1281.107958] LME2510(C): FRM Starting Firmware Download
[ 1283.548064] LME2510(C): FRM Firmware Download Completed - Resetting
Device
[ 1283.548221] usb 1-2: USB disconnect, address 7
[ 1283.792067] usb 1-2: new high speed USB device using ehci_hcd and
address 8
[ 1283.928354] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
0x81 has invalid maxpacket 64
[ 1283.928360] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
0x1 has invalid maxpacket 64
[ 1283.928364] usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint
0x2 has invalid maxpacket 64
[ 1283.929850] LME2510(C): Firmware Status: 6 (47)
[ 1283.929855] dvb-usb: found a 'DM04_LME2510C_DVB-S' in warm state.
[ 1283.954607] dvb-usb: will use the device's hardware PID filter (table
count: 15).
[ 1283.954866] DVB: registering new adapter (DM04_LME2510C_DVB-S)
[ 1284.461395] LME2510(C): DM04 Not Supported
[ 1284.461410] dvb-usb: no frontend was attached by 'DM04_LME2510C_DVB-S'
[ 1284.461441] Registered IR keymap rc-lme2510
[ 1284.461717] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:0b.1/usb1/1-2/rc/rc2/input10
[ 1284.461913] rc2: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:0b.1/usb1/1-2/rc/rc2
[ 1284.481096] dvb-usb: DM04_LME2510C_DVB-S successfully initialized and
connected.
[ 1284.481107] LME2510(C): DEV registering device driver


me-tv and gnome-dvb-setup says: There are no DVB devices available...

My device different or chip is damaged? Label, box and driver cd title
writes "DM04P". DM04 and DM04P different devices?
Thanks again...
