Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:50871 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbcCJRww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 12:52:52 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Driver Technisat Skystar S2 and Compro VideoMate S350
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <56E1A7CF.5050201@gmail.com>
Date: Thu, 10 Mar 2016 18:52:11 +0100
Cc: neil@ferme-de-la-motte.com, linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <512DBC45-9FFC-476C-A8EC-2F347DF2CCB0@darmarit.de>
References: <014e01d17ad4$45f1e070$d1d5a150$@ferme-de-la-motte.com> <56E1A7CF.5050201@gmail.com>
To: Jemma Denson <jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 10.03.2016 um 17:58 schrieb Jemma Denson <jdenson@gmail.com>:

> Hi Neil,
> 
> Sorry, I can't help with the Compro, but maybe with the Technisat :)
> 
> 
> On 10/03/16 13:53, Neil Cordwell wrote:
>> Technisat Skystar S2
>> 
>> When I first installed this card I couldn't find the firmware
>> dvb-fe-cx24120-1.20.58.2.fw. Downloaded this from github and now there are
>> no errors in dmesg, but I cannot get the card to tune in MythTV. I wondered
>> if the <access denied> in the output of lspci is anything?
>> 
>> 3:05.0 Multimedia controller [0480]: Philips Semiconductors
>> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>>         Subsystem: Compro Technology, Inc. VideoMate T750 [185b:c900]
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64 (21000ns min, 8000ns max)
>>         Interrupt: pin A routed to IRQ 20
>>         Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=2K]
>>         Capabilities: <access denied>
>>         Kernel driver in use: saa7134
> 
> The above is for the Compro and not the Skystar, but <access denied> is likely to just be that it needs root.
> 

You are in the userspace, root should not be needed: On Debian/Ubuntu you need to add your user to the group "video" ...

$ ls -la /dev/dvb/adapter0/
insgesamt 0
drwxr-xr-x  2 root root     120 Mär 10 13:59 .
drwxr-xr-x  4 root root      80 Mär 10 13:59 ..
crw-rw----+ 1 root video 212, 1 Mär 10 13:59 demux0
crw-rw----+ 1 root video 212, 2 Mär 10 13:59 dvr0
crw-rw----+ 1 root video 212, 0 Mär 10 13:59 frontend0
crw-rw----+ 1 root video 212, 3 Mär 10 13:59 net0


> <snip>
> 
>> I tried to use dvbv5-scan with a simple channel file and get an error. Scan
>> does nothing
>> 
>> neil@Sonata-Linux:~/Documents$ dvbv5-scan --input-format=CHANNEL Astra-28.2E
>> ERROR Doesn't know how to handle delimiter '[CHANNEL]' while parsing line 2
>> of Astra-28.2E
>> 
>> 
>> [CHANNEL]
>>                 DELIVERY_SYSTEM = DVBS2
>>                 FREQUENCY = 11719500
>>                 POLARIZATION = HORIZONTAL
>>                 SYMBOL_RATE = 29500000
>>                 INNER_FEC = 3/4
>>                 MODULATION = QPSK
>>                 INVERSION = AUTO
> 
> A few problems here - that's dvbv5 format and not channel so best to just skip the input-format, also 11719500 doesn't exist on 28.2E anymore, you probably want to be running this as root, and you should be specifying the lnb type.
> 
> This is how I ran it on mine quite recently whilst fixing a bug in the driver (you might need to change the adapter number on -a):
> # dvbv5-scan -a 0 -l EXTENDED /usr/share/dvbv5/dvb-s/Astra-28.2E
> 
> That bug was patched only a few weeks ago so the above will probably fail on some of the transponders. MythTV wasn't affected though so that should scan fine, aslong as all the other things with myth are setup ok - it's quite fiddly!

* Add the user to the group (video)

* logout, login,

* run dvbv5-scan as Jem mentioned (choose the right adapter with -a n)

  the -l EXTENDED is required for Astra-28.E ... more help on LNBf

   $ dvbv5-scan -l help

* does scan work? --> your card is working!

Next step: test streaming 

* with channel file (dvb_channel.conf) run ... (set ADAPTER, FRONTEND and channel to your needs)

$ dvbv5-zap \
  --adapter $ADAPTER --frontend $FRONTEND \
  -v \
  -r \
  -l EXTENDED \
  -c dvb_channel.conf \
  "$channel"
	
as output, you should see lines like ...

Lock   (0x1f) Signal= -31,52dBm C/N= 13,62dB postBER= 0

... does this work? ... OK, let it run / don't break it and ..

* open a new terminal session and type ...

$ mpv /dev/dvb/adapter${ADAPTER}/dvr0 --hwdec=auto 

... mpv shows your TV channel, right? --> everything works fine.

this was a complete roundtrip ... I have no MythTV experience, 
may you ask into a MythTV Forum.

--M--

