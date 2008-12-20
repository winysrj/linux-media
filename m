Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK0ElfL001871
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:14:47 -0500
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK0EUXw005129
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:14:31 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Gene Heskett <gene.heskett@verizon.net>
In-Reply-To: <200812191503.13730.gene.heskett@verizon.net>
References: <200812191503.13730.gene.heskett@verizon.net>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 01:08:30 +0100
Message-Id: <1229731710.4072.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: kaffeine vs dtvscan
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Gene,

Am Freitag, den 19.12.2008, 15:03 -0500 schrieb Gene Heskett:
> Greetings all;
> 
> I an instantly running 2.6.28-rc9
> I have a pcHDTV-3000 card installed, from lspci:
> 01:08.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
> Video and Audio Decoder (rev 05)
> 01:08.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video 
> and Audio Decoder [MPEG Port] (rev 05)
> 
> According to /var/log/messages,
> Dec 19 10:55:14 coyote kernel: [ 2182.450260] or51132: Waiting for firmware 
> upload(dvb-fe-or51132-vsb.fw)...
> Dec 19 10:55:14 coyote kernel: [ 2182.450265] i2c-adapter i2c-2: firmware: 
> requesting dvb-fe-or51132-vsb.fw
> Dec 19 10:55:16 coyote kernel: [ 2185.071438] or51132: Version: 
> 10001134-19430000 (113-4-194-3)
> Dec 19 10:55:16 coyote kernel: [ 2185.072154] or51132: Firmware upload 
> complete.
> 
> After the firmware upload,
> dtvsignal 33 reports readings in the 45-48 range
> dtvsnr 33 reports an snr of 14db average (the station is 70 miles away, big 
> rooftop antenna with rotator)
> 
> dtvscan reports a weak find on 6, which is our local temporary, but its 100  
> watts, 3.1 miles away, and being drowned out by a 100kw ntsc signal on 
> channel 5 on the same 3.1 mile distant tower, and a good, our digital tv's 
> see it about 90% of the time with wet weather causing just enough loss to 
> lose it on channel 33,  587mhz.
> 
> As the docs for dvb-atsc-tools-1.0.7, which is the package written for this 
> card, are non-existent, and the scan function in kaffeine seems to be broken 
> by a bug that translates (for instance, the 85,000,000 for channel 6 is being 
> divided by 100 and sent to the card as 85000, which according to the messages 
> log is out of range:
> 
> Dec 19 13:47:07 coyote kernel: [12495.883556] DVB: adapter 0 frontend 0 
> frequency 85000 out of range (44000000..958000000)
> Dec 19 13:50:08 coyote kernel: [12676.431821] DVB: adapter 0 frontend 0 
> frequency 85000 out of range (44000000..958000000)
> Dec 19 13:54:57 coyote kernel: [12965.802937] or51132: unknown status 0x00
> 
> So kaffeine cannot work. kdetv seems to be for analogue ntsc/pal/secam only.
> 
> I see a new 'klear' viewer has been added and I installed that, but it reports 
> no channels file of some acronym defined format (t-,s-,c-,Zap) found and 
> exits rather than offer to scan for available channels.
> 
> Can dtvscan be trained to output this format of a channels.txt file?
> 
> vlc, which usually can play anything, can't find the device's 'url'.
> 
> xine/.gxine locks up and has to be killed manually when dvb has been selected.
> 
> tvtime used to work for ntsc only before I rebuilt this machine and had to 
> change the video card, but its output mode (YUY) appears to have been 
> delegated to the trash heap never to be supported by the radeonhd driver on 
> an rv610 based video card, a diamond HD2400-Pro.
> 
> So what app can I use to watch terrestrial broadcast digital tv on this 
> receiver card, on this video card?
> 

can't tell much about the current ATI stuff for your card, Nvidia is on
the way with GPU hardware acceleration for h264 and others ...

Did you try to run "scan" from current mercurial "dvb-apps" at
linuxtv.org?

There is a file in
dvb-apps/util/scan/atsc/us-ATSC-center-frequencies-8VSB
you might let it try on.

Cheers,
Hermann








--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
