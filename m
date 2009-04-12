Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:1058 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbZDLILg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2009 04:11:36 -0400
From: Wayne and Holly <wayneandholly@alice.it>
To: stev391@email.com
Subject: Re: Leadtek WinFast PxDVR3200 H
Date: Sun, 12 Apr 2009 10:11:20 +0200
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
References: <20090126225350.DBB5C105CF@ws1-3.us4.outblaze.com> <200904081205.51790.wayneandholly@alice.it>
In-Reply-To: <200904081205.51790.wayneandholly@alice.it>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_pIa4JS+IA6KlG/5"
Message-Id: <200904121011.21238.wayneandholly@alice.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_pIa4JS+IA6KlG/5
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 08 April 2009 12:05:50 Wayne and Holly wrote:
> > > > > Hello list,
> > > > > I have a Leadtek WinFast PxDVR3200 H that I am attempting to
> > > > > utilise
> > > > >
> > > > > > with MythTV.  The
> > > >
> > > > Wiki site states that experimental support exists > for the DVB side
> > > > and that "Successful tuning of typical Australian > channels" has
> > > > been achieved. I am able to create a channels.conf > (attached) using
> > > > scan, and am then able to tune using mythtv-setup, > however none of
> > > > these channels are viewable with the mythfrontend due > to it being
> > > > unable to gain a lock.
> > > >
> > > > > > Relevant bits and pieces:
> > > > > > scan, using the latest it-Varese file scan is able to tune to
> > > > > > three of > the five
> > > >
> > > > transponders as per the attached file "scan".  It also scans > on
> > > > 800000000Hz but I have no idea why.
> > > >
> > > > > > The file leadtek.dmesg contains the relevant info from dmesg (and
> > > > >
> > > > > messages.log) regarding the initialisation of the card itself. 
> > > > > There
> > > > >
> > > > > > are no error
> > > >
> > > > messages at any time (that I am aware of) despite all of > my
> > > > fiddling about.
> > > >
> > > > > > Of the three transponders that are in my channels.conf file, the
> > > > > > third > one
> > > > >
> > > > > (618000000Hz) causes an error when tuning in mythtv-setup.  It
> > > > > states that channels are found but the tsid is incorrect.  As such,
> > > > > only the first two successful transponders (706000000 and
> > > > > 602000000) are tuned by myth.
> > > > >
> > > > > > When I attempt to view the tuned channels, myth is unable to gain
> > > > > > a
> > > > > >
> > > > > > > lock on any of them.
> > > >
> > > >  The reported signal strength is about 58% and > the S/N varies
> > > > between 3 and 3.8dB.  I am able to tune DVB-T channels > on my TV
> > > > using the same aerial cable but am wondering if signal
> > > >
> > > > > strength is an issue.
> > > > >
> > > > > > I am running it on Kubuntu with a 2.6.24-19 kernel, I have a
> > > > > > recent
> > > > > >
> > > > > > > version of the
> > > >
> > > > v4l-dvb tree (approx Nov 08) and am using firmware > version 2.7.  I
> > > > haven't updated the drivers or the firmware as I have > no reason to
> > > > believe there are changes that would effect this.  That > said, if
> > > > someone thinks there has been changes I will get straight on > it.
> > > >
> > > > > > I am more than happy to provide more debugging info if required
> > > > > > (if
> > > > > >
> > > > > > > you are willing to
> > > >
> > > > tell me where else to look) and appreciate any help > provided.
> > > >
> > > > > > Cheers
> > > > >
> > > > > Wayne
> > > >
> > > > Wayne,
> > > >
> > > > Can you load the cx23885 and tuner_xc2028 module with debug enabled
> > > > and provide the dmesg output.
> > > >
> > > > You can do this by putting the following lines in
> > > > /etc/modprobe.d/options options tuner_xc2028 debug=1 options cx23885
> > > > debug=1
> > > >
> > > > Can you split the dmesg output into the following sections:
> > > > 1) Initial boot up or first module load
> > > > 2) First access of the card for tuning/scanning
> > > > 3) while scanning for channels with scan-dvb
> > > > 4) while scanning for channels with MythTV
> > > > 5) while trying to tune channels with MythTV
> > > >
> > > > Have you tried to watch TV with xine or other non-MythTV programs?
> > > > (at one stage I did have a problem with MythTV but it worked in
> > > > gxine).
> > > >
> > > > Regards,
> > > >
> > > > Stephen.
> > >
> > > It would appear that Myth is the source of the problem.  Of the three
> > > transponders that scan finds, only the last one contains unencrypted
> > > channels actually transmitting content.  Using the same channels.conf
> > > file gxine is able to tune to the channels.  I have tried carrying out
> > > a full manual scan in myth using the good transponder's details and
> > > myth is now able to detect the channels, but still won't show them.
> > > I suspect this is purely a myth problem, do you still want me to post
> > > the debug info for the two modules?
> > >
> > > Cheers
> > > Wayne
> >
> > Wayne,
> >
> > When replying to emails, please ensure that the mailing list is in the
> > CC. So if anyone else is having the same issue they can join the thread
> > or use this information in the future.  Also please post the reply at the
> > bottom of the email, so that anybody later can read the responses in
> > chronological order from top to bottom.
> >
> > I would be interested to see the debug output, for the following
> > conditions: 1) scan-dvb vs MythTV scan
> > 2) Tuning channels in gxine Vs MythTV
> >
> > If we can spot an obvious problem, we can possibly provide the
> > information to the MythTV devs (or I might get adventurous write a patch
> > for them)
> >
> > Regards,
> > Stephen.
>
> Stephen,
> you are right, and I know better.  Put it down to distraction, which is
> also probably why it has taken me 2 or 3 months to get around to replying. 
> My apologies for my tardiness.  I have also moved my reply into its correct
> position in this email stream so that it reads correctly from now on.  I
> hope by doing so I haven't mis-stepped again.
>
> I have attached a number of excerpts taken from my syslog with the
> debugging enabled.  All actions were carried out in a single session and I
> have attached them in chronological order as follows:
>
> - boot.pxdvr - initial boot up.
>
> - scan.dvb - a scan using "scan" to create a channels.conf.  This was also
> the first initialisation of the PxDVR3200 H.
>
> - mythtv.scan.channels.conf - attempted scan of transponder in mythtv using
> channels.conf created above.  Failed after timed out.
>
> - mythtv.scan.tuned - successful mythtv scan of transponder using "tuned"
> option with parameters extracted from channels.conf.
>
> - mythtv.tune - failed attempt to watch channels in mythtv frontend (with a
> handful of channel changes).
>
> -gxine.tune - successful viewing of channels using gxine and original
> channels.conf (with channels changes)
>
> It is quite clear that the difference between mythtv and gxine is that
> mythtv is failing to initialise the tuner; I however have no idea what to
> do about it.
> Again, sorry for the late reply.  As always, any and all help is greatly
> appreciated.
>
> Cheers
> Wayne

Resend after initial email rejected.  Have truncated the attached files, 
hopefully they will be let through this time.
Cheers
Wayne

--Boundary-00=_pIa4JS+IA6KlG/5
Content-Type: text/plain;
  charset="UTF-8";
  name="boot.pxdvr"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="boot.pxdvr"

Apr  7 18:02:21 HTPC kernel: [   28.924258] cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe bridge type 885
Apr  7 18:02:21 HTPC kernel: [   28.924262] cx23885[0]/0: cx23885_init_tsport(portno=2)
Apr  7 18:02:21 HTPC kernel: [   28.924278] CORE cx23885[0]: subsystem: 107d:6681, board: Leadtek Winfast PxDVR3200 H [card=12,autodetected]
Apr  7 18:02:21 HTPC kernel: [   28.924281] cx23885[0]/0: cx23885_pci_quirks()
Apr  7 18:02:21 HTPC kernel: [   28.924285] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr = 0x0
Apr  7 18:02:21 HTPC kernel: [   28.924287] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0
Apr  7 18:02:21 HTPC kernel: [   28.924289] cx23885[0]/0: cx23885_reset()
Apr  7 18:02:21 HTPC kernel: [   29.023402] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [VID A]
Apr  7 18:02:21 HTPC kernel: [   29.023410] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]
Apr  7 18:02:21 HTPC kernel: [   29.023413] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS1 B]
Apr  7 18:02:21 HTPC kernel: [   29.023424] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]
Apr  7 18:02:21 HTPC kernel: [   29.023426] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]
Apr  7 18:02:21 HTPC kernel: [   29.023428] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
Apr  7 18:02:21 HTPC kernel: [   29.023440] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch7]
Apr  7 18:02:21 HTPC kernel: [   29.023442] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]
Apr  7 18:02:21 HTPC kernel: [   29.023444] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]
Apr  7 18:02:21 HTPC kernel: [   29.068888] tuner' 3-0061: chip found @ 0xc2 (cx23885[0])
Apr  7 18:02:21 HTPC kernel: [   29.155029] AR5210, AR5211, AR5212, AR5416, RF5111, RF5112, RF2413, RF5413, RF2133, RF2425, RF2417)
Apr  7 18:02:21 HTPC kernel: [   29.236772] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
Apr  7 18:02:21 HTPC kernel: [   29.324991] cx23885_dvb_register() allocating 1 frontend(s)
Apr  7 18:02:21 HTPC kernel: [   29.324996] cx23885[0]: cx23885 based dvb card
Apr  7 18:02:21 HTPC kernel: [   29.480365] xc2028: Xcv2028/3028 init called!
Apr  7 18:02:21 HTPC kernel: [   29.480369] xc2028 3-0061: creating new instance
Apr  7 18:02:21 HTPC kernel: [   29.480372] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
Apr  7 18:02:21 HTPC kernel: [   29.480374] xc2028 3-0061: xc2028_set_config called
Apr  7 18:02:21 HTPC kernel: [   29.480379] DVB: registering new adapter (cx23885[0])
Apr  7 18:02:21 HTPC kernel: [   29.480386] DVB: registering adapter 2 frontend 0 (Zarlink ZL10353 DVB-T)...
Apr  7 18:02:21 HTPC kernel: [   29.480621] cx23885_dev_checkrevision() Hardware revision = 0xb0
Apr  7 18:02:21 HTPC kernel: [   29.480628] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 20, latency: 0, mmio: 0xfd000000

--Boundary-00=_pIa4JS+IA6KlG/5
Content-Type: text/plain;
  charset="UTF-8";
  name="scan.dvb"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="scan.dvb"

Apr  7 18:05:22 HTPC kernel: [  137.926336] xc2028 3-0061: xc2028_set_params called
Apr  7 18:05:22 HTPC kernel: [  137.926342] xc2028 3-0061: generic_set_freq called
Apr  7 18:05:22 HTPC kernel: [  137.926344] xc2028 3-0061: should set frequency 226500 kHz
Apr  7 18:05:22 HTPC kernel: [  137.926346] xc2028 3-0061: check_firmware called
Apr  7 18:05:22 HTPC kernel: [  137.926348] xc2028 3-0061: load_all_firmwares called
Apr  7 18:05:22 HTPC kernel: [  137.926350] xc2028 3-0061: Reading firmware xc3028-v27.fw
Apr  7 18:05:22 HTPC kernel: [  137.936434] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Apr  7 18:05:22 HTPC kernel: [  137.936462] xc2028 3-0061: Reading firmware type BASE F8MHZ (3), id 0, size=8718.
Apr  7 18:05:22 HTPC kernel: [  137.936477] xc2028 3-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=8712.
Apr  7 18:05:22 HTPC kernel: [  137.936493] xc2028 3-0061: Reading firmware type BASE FM (401), id 0, size=8562.
Apr  7 18:05:22 HTPC kernel: [  137.936508] xc2028 3-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=8576.
Apr  7 18:05:22 HTPC kernel: [  137.936524] xc2028 3-0061: Reading firmware type BASE (1), id 0, size=8706.
Apr  7 18:05:22 HTPC kernel: [  137.936537] xc2028 3-0061: Reading firmware type BASE MTS (5), id 0, size=8682.
Apr  7 18:05:22 HTPC kernel: [  137.936544] xc2028 3-0061: Reading firmware type (0), id 100000007, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936548] xc2028 3-0061: Reading firmware type MTS (4), id 100000007, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936551] xc2028 3-0061: Reading firmware type (0), id 200000007, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936554] xc2028 3-0061: Reading firmware type MTS (4), id 200000007, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936557] xc2028 3-0061: Reading firmware type (0), id 400000007, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936560] xc2028 3-0061: Reading firmware type MTS (4), id 400000007, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936563] xc2028 3-0061: Reading firmware type (0), id 800000007, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936566] xc2028 3-0061: Reading firmware type MTS (4), id 800000007, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936569] xc2028 3-0061: Reading firmware type (0), id 3000000e0, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936572] xc2028 3-0061: Reading firmware type MTS (4), id 3000000e0, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936575] xc2028 3-0061: Reading firmware type (0), id c000000e0, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936578] xc2028 3-0061: Reading firmware type MTS (4), id c000000e0, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936581] xc2028 3-0061: Reading firmware type (0), id 200000, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936584] xc2028 3-0061: Reading firmware type MTS (4), id 200000, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936587] xc2028 3-0061: Reading firmware type (0), id 4000000, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936590] xc2028 3-0061: Reading firmware type MTS (4), id 4000000, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936593] xc2028 3-0061: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=149.
Apr  7 18:05:22 HTPC kernel: [  137.936597] xc2028 3-0061: Reading firmware type D2620 DTV6 QAM (68), id 0, size=149.
Apr  7 18:05:22 HTPC kernel: [  137.936600] xc2028 3-0061: Reading firmware type D2633 DTV6 QAM (70), id 0, size=149.
Apr  7 18:05:22 HTPC kernel: [  137.936604] xc2028 3-0061: Reading firmware type D2620 DTV7 (88), id 0, size=149.
Apr  7 18:05:22 HTPC kernel: [  137.936607] xc2028 3-0061: Reading firmware type D2633 DTV7 (90), id 0, size=149.
Apr  7 18:05:22 HTPC kernel: [  137.936611] xc2028 3-0061: Reading firmware type D2620 DTV78 (108), id 0, size=149.
Apr  7 18:05:22 HTPC kernel: [  137.936614] xc2028 3-0061: Reading firmware type D2633 DTV78 (110), id 0, size=149.
Apr  7 18:05:22 HTPC kernel: [  137.936618] xc2028 3-0061: Reading firmware type D2620 DTV8 (208), id 0, size=149.
Apr  7 18:05:22 HTPC kernel: [  137.936621] xc2028 3-0061: Reading firmware type D2633 DTV8 (210), id 0, size=149.
Apr  7 18:05:22 HTPC kernel: [  137.936624] xc2028 3-0061: Reading firmware type FM (400), id 0, size=135.
Apr  7 18:05:22 HTPC kernel: [  137.936627] xc2028 3-0061: Reading firmware type (0), id 10, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936630] xc2028 3-0061: Reading firmware type MTS (4), id 10, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936633] xc2028 3-0061: Reading firmware type (0), id 1000400000, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936636] xc2028 3-0061: Reading firmware type (0), id c00400000, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936638] xc2028 3-0061: Reading firmware type (0), id 800000, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936641] xc2028 3-0061: Reading firmware type (0), id 8000, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936644] xc2028 3-0061: Reading firmware type LCD (1000), id 8000, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936647] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id 8000, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936651] xc2028 3-0061: Reading firmware type MTS (4), id 8000, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936654] xc2028 3-0061: Reading firmware type (0), id b700, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936657] xc2028 3-0061: Reading firmware type LCD (1000), id b700, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936660] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id b700, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936663] xc2028 3-0061: Reading firmware type (0), id 2000, size=161.
Apr  7 18:05:22 HTPC kernel: [  137.936666] xc2028 3-0061: Reading firmware type MTS (4), id b700, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936669] xc2028 3-0061: Reading firmware type MTS LCD (1004), id b700, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936672] xc2028 3-0061: Reading firmware type MTS LCD NOGD (3004), id b700, size=169.
Apr  7 18:05:22 HTPC kernel: [  137.936676] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3280 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936680] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3300 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936683] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3440 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936687] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3460 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936690] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN36 SCODE HAS_IF_3800 (60210020), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936695] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4000 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936698] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE HAS_IF_4080 (60410020), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936717] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4200 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936721] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_4320 (60008000), id 8000, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936725] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4450 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936729] xc2028 3-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id b700, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936734] xc2028 3-0061: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600 (60023000), id 8000, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936739] xc2028 3-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936744] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4940 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936747] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5260 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936751] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_5320 (60008000), id f00000007, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936755] xc2028 3-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936761] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936765] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5640 (60000000), id 300000007, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936769] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5740 (60000000), id c00000007, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936773] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5900 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936776] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6000 (60008000), id c04c000f0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936780] xc2028 3-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936785] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6240 (60000000), id 10, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936789] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6320 (60008000), id 200000, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936793] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6340 (60000000), id 200000, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936797] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6500 (60008000), id c044000e0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936801] xc2028 3-0061: Reading firmware type DTV6 ATSC ATI638 SCODE HAS_IF_6580 (60090020), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936805] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6600 (60000000), id 3000000e0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936809] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6680 (60008000), id 3000000e0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936813] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE HAS_IF_8140 (60810020), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936818] xc2028 3-0061: Reading firmware type SCODE HAS_IF_8200 (60000000), id 0, size=192.
Apr  7 18:05:22 HTPC kernel: [  137.936831] xc2028 3-0061: Firmware files loaded.
Apr  7 18:05:22 HTPC kernel: [  137.936833] xc2028 3-0061: checking firmware, user requested type=F8MHZ D2633 DTV7 (92), id 0000000000000000, int_freq 4760, scode_nr 0
Apr  7 18:05:22 HTPC kernel: [  138.031304] xc2028 3-0061: load_firmware called
Apr  7 18:05:22 HTPC kernel: [  138.031309] xc2028 3-0061: seek_firmware called, want type=BASE F8MHZ D2633 DTV7 (93), id 0000000000000000.
Apr  7 18:05:22 HTPC kernel: [  138.031315] xc2028 3-0061: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Apr  7 18:05:22 HTPC kernel: [  138.031319] xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Apr  7 18:05:23 HTPC kernel: [  138.573028] xc2028 3-0061: Load init1 firmware, if exists
Apr  7 18:05:23 HTPC kernel: [  138.573032] xc2028 3-0061: load_firmware called
Apr  7 18:05:23 HTPC kernel: [  138.573034] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 F8MHZ D2633 DTV7 (4093), id 0000000000000000.
Apr  7 18:05:23 HTPC kernel: [  138.573042] xc2028 3-0061: Can't find firmware for type=BASE INIT1 F8MHZ (4003), id 0000000000000000.
Apr  7 18:05:23 HTPC kernel: [  138.573045] xc2028 3-0061: load_firmware called
Apr  7 18:05:23 HTPC kernel: [  138.573047] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 D2633 DTV7 (4091), id 0000000000000000.
Apr  7 18:05:23 HTPC kernel: [  138.573052] xc2028 3-0061: Can't find firmware for type=BASE INIT1 (4001), id 0000000000000000.
Apr  7 18:05:23 HTPC kernel: [  138.573055] xc2028 3-0061: load_firmware called
Apr  7 18:05:23 HTPC kernel: [  138.573057] xc2028 3-0061: seek_firmware called, want type=F8MHZ D2633 DTV7 (92), id 0000000000000000.
Apr  7 18:05:23 HTPC kernel: [  138.573062] xc2028 3-0061: Found firmware for type=D2633 DTV7 (90), id 0000000000000000.
Apr  7 18:05:23 HTPC kernel: [  138.573065] xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
Apr  7 18:05:23 HTPC kernel: [  138.579630] xc2028 3-0061: Trying to load scode 0
Apr  7 18:05:23 HTPC kernel: [  138.579634] xc2028 3-0061: load_scode called
Apr  7 18:05:23 HTPC kernel: [  138.579635] xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
Apr  7 18:05:23 HTPC kernel: [  138.594909] xc2028 3-0061: xc2028_get_reg 0004 called
Apr  7 18:05:23 HTPC kernel: [  138.595252] xc2028 3-0061: xc2028_get_reg 0008 called
Apr  7 18:05:23 HTPC kernel: [  138.595592] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Apr  7 18:05:23 HTPC kernel: [  138.659592] xc2028 3-0061: divisor= 00 00 37 f0 (freq=226.500)
Apr  7 18:05:24 HTPC kernel: [  139.138367] xc2028 3-0061: xc2028_set_params called
Apr  7 18:05:24 HTPC kernel: [  139.138372] xc2028 3-0061: generic_set_freq called
Apr  7 18:05:24 HTPC kernel: [  139.138376] xc2028 3-0061: should set frequency 226500 kHz
Apr  7 18:05:24 HTPC kernel: [  139.138378] xc2028 3-0061: check_firmware called
Apr  7 18:05:24 HTPC kernel: [  139.138380] xc2028 3-0061: checking firmware, user requested type=F8MHZ D2633 DTV7 (92), id 0000000000000000, int_freq 4760, scode_nr 0
Apr  7 18:05:24 HTPC kernel: [  139.138385] xc2028 3-0061: BASE firmware not changed.
Apr  7 18:05:24 HTPC kernel: [  139.138387] xc2028 3-0061: Std-specific firmware already loaded.
Apr  7 18:05:24 HTPC kernel: [  139.138389] xc2028 3-0061: SCODE firmware already loaded.
Apr  7 18:05:24 HTPC kernel: [  139.138391] xc2028 3-0061: xc2028_get_reg 0004 called
Apr  7 18:05:24 HTPC kernel: [  139.138732] xc2028 3-0061: xc2028_get_reg 0008 called
Apr  7 18:05:24 HTPC kernel: [  139.139072] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Apr  7 18:05:24 HTPC kernel: [  139.203657] xc2028 3-0061: divisor= 00 00 37 f0 (freq=226.500)
Apr  7 18:05:25 HTPC kernel: [  139.590598] xc2028 3-0061: xc2028_set_params called
Apr  7 18:05:25 HTPC kernel: [  139.590603] xc2028 3-0061: generic_set_freq called
Apr  7 18:05:25 HTPC kernel: [  139.590608] xc2028 3-0061: should set frequency 226500 kHz
Apr  7 18:05:25 HTPC kernel: [  139.590610] xc2028 3-0061: check_firmware called
Apr  7 18:05:25 HTPC kernel: [  139.590612] xc2028 3-0061: checking firmware, user requested type=F8MHZ D2633 DTV7 (92), id 0000000000000000, int_freq 4760, scode_nr 0
Apr  7 18:05:25 HTPC kernel: [  139.590618] xc2028 3-0061: BASE firmware not changed.
Apr  7 18:05:25 HTPC kernel: [  139.590619] xc2028 3-0061: Std-specific firmware already loaded.
Apr  7 18:05:25 HTPC kernel: [  139.590621] xc2028 3-0061: SCODE firmware already loaded.
Apr  7 18:05:25 HTPC kernel: [  139.590624] xc2028 3-0061: xc2028_get_reg 0004 called
Apr  7 18:05:25 HTPC kernel: [  139.590964] xc2028 3-0061: xc2028_get_reg 0008 called
Apr  7 18:05:25 HTPC kernel: [  139.591305] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Apr  7 18:05:25 HTPC kernel: [  139.656412] xc2028 3-0061: divisor= 00 00 37 f0 (freq=226.500)
Apr  7 18:05:26 HTPC kernel: [  140.135182] xc2028 3-0061: xc2028_set_params called
Apr  7 18:05:26 HTPC kernel: [  140.135186] xc2028 3-0061: generic_set_freq called
Apr  7 18:05:26 HTPC kernel: [  140.135191] xc2028 3-0061: should set frequency 226500 kHz
Apr  7 18:05:26 HTPC kernel: [  140.135193] xc2028 3-0061: check_firmware called
Apr  7 18:05:26 HTPC kernel: [  140.135195] xc2028 3-0061: checking firmware, user requested type=F8MHZ D2633 DTV7 (92), id 0000000000000000, int_freq 4760, scode_nr 0
Apr  7 18:05:26 HTPC kernel: [  140.135201] xc2028 3-0061: BASE firmware not changed.
Apr  7 18:05:26 HTPC kernel: [  140.135202] xc2028 3-0061: Std-specific firmware already loaded.
Apr  7 18:05:26 HTPC kernel: [  140.135205] xc2028 3-0061: SCODE firmware already loaded.
Apr  7 18:05:26 HTPC kernel: [  140.135207] xc2028 3-0061: xc2028_get_reg 0004 called
Apr  7 18:05:26 HTPC kernel: [  140.135547] xc2028 3-0061: xc2028_get_reg 0008 called
Apr  7 18:05:26 HTPC kernel: [  140.135888] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Apr  7 18:05:27 HTPC kernel: [  140.200478] xc2028 3-0061: divisor= 00 00 37 f0 (freq=226.500)
Apr  7 18:05:27 HTPC kernel: [  140.587420] xc2028 3-0061: xc2028_set_params called
Apr  7 18:05:27 HTPC kernel: [  140.587425] xc2028 3-0061: generic_set_freq called
Apr  7 18:05:27 HTPC kernel: [  140.587429] xc2028 3-0061: should set frequency 706000 kHz
Apr  7 18:05:27 HTPC kernel: [  140.587431] xc2028 3-0061: check_firmware called
Apr  7 18:05:27 HTPC kernel: [  140.587432] xc2028 3-0061: checking firmware, user requested type=F8MHZ D2633 DTV78 (112), id 0000000000000000, int_freq 4760, scode_nr 0
Apr  7 18:05:27 HTPC kernel: [  140.587438] xc2028 3-0061: BASE firmware not changed.
Apr  7 18:05:27 HTPC kernel: [  140.587440] xc2028 3-0061: load_firmware called
Apr  7 18:05:27 HTPC kernel: [  140.587441] xc2028 3-0061: seek_firmware called, want type=F8MHZ D2633 DTV78 (112), id 0000000000000000.
Apr  7 18:05:27 HTPC kernel: [  140.587446] xc2028 3-0061: Found firmware for type=D2633 DTV78 (110), id 0000000000000000.
Apr  7 18:05:27 HTPC kernel: [  140.587449] xc2028 3-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
Apr  7 18:05:27 HTPC kernel: [  140.594464] xc2028 3-0061: Trying to load scode 0
Apr  7 18:05:27 HTPC kernel: [  140.594468] xc2028 3-0061: load_scode called
Apr  7 18:05:27 HTPC kernel: [  140.594471] xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
Apr  7 18:05:27 HTPC kernel: [  140.609473] xc2028 3-0061: xc2028_get_reg 0004 called
Apr  7 18:05:27 HTPC kernel: [  140.609816] xc2028 3-0061: xc2028_get_reg 0008 called
Apr  7 18:05:27 HTPC kernel: [  140.610159] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Apr  7 18:05:28 HTPC kernel: [  140.674264] xc2028 3-0061: divisor= 00 00 af d0 (freq=706.000)
Apr  7 18:05:28 HTPC kernel: [  140.776428] cx23885[0]/0: cx23885_buf_prepare: f6fccc00
Apr  7 18:05:28 HTPC kernel: [  140.776460] cx23885[0]/0: cx23885_buf_prepare: f742fb40
Apr  7 18:05:28 HTPC kernel: [  140.776478] cx23885[0]/0: cx23885_buf_prepare: f742f0c0
Apr  7 18:05:28 HTPC kernel: [  140.776496] cx23885[0]/0: cx23885_buf_prepare: f5679000
Apr  7 18:05:28 HTPC kernel: [  140.776513] cx23885[0]/0: cx23885_buf_prepare: f5679240
Apr  7 18:05:28 HTPC kernel: [  140.776529] cx23885[0]/0: cx23885_buf_prepare: f5679300
Apr  7 18:05:28 HTPC kernel: [  140.776545] cx23885[0]/0: cx23885_buf_prepare: f5679e40
Apr  7 18:05:28 HTPC kernel: [  140.776561] cx23885[0]/0: cx23885_buf_prepare: f5679840
Apr  7 18:05:28 HTPC kernel: [  140.776576] cx23885[0]/0: cx23885_buf_prepare: f56790c0
Apr  7 18:05:28 HTPC kernel: [  140.776591] cx23885[0]/0: cx23885_buf_prepare: f5679480
Apr  7 18:05:28 HTPC kernel: [  140.776606] cx23885[0]/0: cx23885_buf_prepare: f56793c0
Apr  7 18:05:28 HTPC kernel: [  140.776622] cx23885[0]/0: cx23885_buf_prepare: f5679c00
Apr  7 18:05:28 HTPC kernel: [  140.776637] cx23885[0]/0: cx23885_buf_prepare: f5679180
Apr  7 18:05:28 HTPC kernel: [  140.776653] cx23885[0]/0: cx23885_buf_prepare: f6665840
Apr  7 18:05:28 HTPC kernel: [  140.776689] cx23885[0]/0: cx23885_buf_prepare: f6665000
Apr  7 18:05:28 HTPC kernel: [  140.776706] cx23885[0]/0: cx23885_buf_prepare: f6665cc0
Apr  7 18:05:28 HTPC kernel: [  140.776724] cx23885[0]/0: cx23885_buf_prepare: f66656c0
Apr  7 18:05:28 HTPC kernel: [  140.776745] cx23885[0]/0: cx23885_buf_prepare: f6665a80
Apr  7 18:05:28 HTPC kernel: [  140.776764] cx23885[0]/0: cx23885_buf_prepare: f6665f00
Apr  7 18:05:28 HTPC kernel: [  140.776781] cx23885[0]/0: cx23885_buf_prepare: f6665d80
Apr  7 18:05:28 HTPC kernel: [  140.776799] cx23885[0]/0: cx23885_buf_prepare: f6665540
Apr  7 18:05:28 HTPC kernel: [  140.776821] cx23885[0]/0: cx23885_buf_prepare: f66716c0
Apr  7 18:05:28 HTPC kernel: [  140.776839] cx23885[0]/0: cx23885_buf_prepare: f66719c0
Apr  7 18:05:28 HTPC kernel: [  140.776857] cx23885[0]/0: cx23885_buf_prepare: f6671480
Apr  7 18:05:28 HTPC kernel: [  140.776903] cx23885[0]/0: cx23885_buf_prepare: f6671cc0
Apr  7 18:05:28 HTPC kernel: [  140.776931] cx23885[0]/0: cx23885_buf_prepare: f6671900
Apr  7 18:05:28 HTPC kernel: [  140.776954] cx23885[0]/0: cx23885_buf_prepare: f6671300
Apr  7 18:05:28 HTPC kernel: [  140.776977] cx23885[0]/0: cx23885_buf_prepare: f66713c0
Apr  7 18:05:28 HTPC kernel: [  140.777001] cx23885[0]/0: cx23885_buf_prepare: f6671000
Apr  7 18:05:28 HTPC kernel: [  140.777022] cx23885[0]/0: cx23885_buf_prepare: f6671e40
Apr  7 18:05:28 HTPC kernel: [  140.777049] cx23885[0]/0: cx23885_buf_prepare: f6671b40
Apr  7 18:05:28 HTPC kernel: [  140.777072] cx23885[0]/0: cx23885_buf_prepare: f66bde40
Apr  7 18:05:28 HTPC kernel: [  140.777095] cx23885[0]/0: queue is empty - first active
Apr  7 18:05:28 HTPC kernel: [  140.777097] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2
Apr  7 18:05:28 HTPC kernel: [  140.777101] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
Apr  7 18:05:28 HTPC kernel: [  140.777202] cx23885[0]/0: cx23885_start_dma() enabling TS int's and DMA
Apr  7 18:05:28 HTPC kernel: [  140.777208] cx23885[0]/0: [f6fccc00/0] cx23885_buf_queue - first active
Apr  7 18:05:28 HTPC kernel: [  140.777210] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777214] cx23885[0]/0: [f742fb40/1] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777216] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777218] cx23885[0]/0: [f742f0c0/2] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777220] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777222] cx23885[0]/0: [f5679000/3] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777224] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777227] cx23885[0]/0: [f5679240/4] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777230] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777232] cx23885[0]/0: [f5679300/5] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777234] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777236] cx23885[0]/0: [f5679e40/6] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777239] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777241] cx23885[0]/0: [f5679840/7] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777243] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777245] cx23885[0]/0: [f56790c0/8] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777248] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777250] cx23885[0]/0: [f5679480/9] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777252] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777254] cx23885[0]/0: [f56793c0/10] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777257] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777259] cx23885[0]/0: [f5679c00/11] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777261] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777263] cx23885[0]/0: [f5679180/12] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777266] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777268] cx23885[0]/0: [f6665840/13] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777270] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777272] cx23885[0]/0: [f6665000/14] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777275] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777277] cx23885[0]/0: [f6665cc0/15] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777279] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777281] cx23885[0]/0: [f66656c0/16] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777284] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777286] cx23885[0]/0: [f6665a80/17] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777288] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777290] cx23885[0]/0: [f6665f00/18] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777293] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777295] cx23885[0]/0: [f6665d80/19] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777297] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777299] cx23885[0]/0: [f6665540/20] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777302] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777304] cx23885[0]/0: [f66716c0/21] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777306] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777308] cx23885[0]/0: [f66719c0/22] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777311] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777313] cx23885[0]/0: [f6671480/23] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777315] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777317] cx23885[0]/0: [f6671cc0/24] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777320] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777322] cx23885[0]/0: [f6671900/25] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777324] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777326] cx23885[0]/0: [f6671300/26] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777329] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777331] cx23885[0]/0: [f66713c0/27] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777333] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777335] cx23885[0]/0: [f6671000/28] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777338] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777340] cx23885[0]/0: [f6671e40/29] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777342] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777344] cx23885[0]/0: [f6671b40/30] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777347] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.777349] cx23885[0]/0: [f66bde40/31] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.781074] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.781076] cx23885[0]/0: [f6fccc00/0] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.784863] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.784865] cx23885[0]/0: [f742fb40/1] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.788657] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.788659] cx23885[0]/0: [f742f0c0/2] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.792457] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.792460] cx23885[0]/0: [f5679000/3] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.796249] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.796251] cx23885[0]/0: [f5679240/4] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.800042] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.800044] cx23885[0]/0: [f5679300/5] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.803837] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.803839] cx23885[0]/0: [f5679e40/6] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.807631] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.807634] cx23885[0]/0: [f5679840/7] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.811427] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.811430] cx23885[0]/0: [f56790c0/8] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.815230] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.815233] cx23885[0]/0: [f5679480/9] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.819014] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.819016] cx23885[0]/0: [f56793c0/10] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.822808] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.822810] cx23885[0]/0: [f5679c00/11] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.826603] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.826605] cx23885[0]/0: [f5679180/12] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.830398] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.830401] cx23885[0]/0: [f6665840/13] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.834192] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.834195] cx23885[0]/0: [f6665000/14] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.837986] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.837989] cx23885[0]/0: [f6665cc0/15] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.841787] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.841790] cx23885[0]/0: [f66656c0/16] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.845601] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.845604] cx23885[0]/0: [f6665a80/17] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.849379] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.849382] cx23885[0]/0: [f6665f00/18] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.853173] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.853176] cx23885[0]/0: [f6665d80/19] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.856968] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.856971] cx23885[0]/0: [f6665540/20] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.860763] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.860765] cx23885[0]/0: [f66716c0/21] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.864557] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.864560] cx23885[0]/0: [f66719c0/22] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.868352] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.868355] cx23885[0]/0: [f6671480/23] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.872152] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.872155] cx23885[0]/0: [f6671cc0/24] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.875953] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.875956] cx23885[0]/0: [f6671900/25] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.879725] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.879728] cx23885[0]/0: [f6671300/26] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.883519] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.883522] cx23885[0]/0: [f66713c0/27] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.887314] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.887316] cx23885[0]/0: [f6671000/28] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.891108] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.891111] cx23885[0]/0: [f6671e40/29] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.894902] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.894905] cx23885[0]/0: [f6671b40/30] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.898696] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.898699] cx23885[0]/0: [f66bde40/31] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.902491] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.902494] cx23885[0]/0: [f6fccc00/0] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.906286] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.906289] cx23885[0]/0: [f742fb40/1] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.910080] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.910083] cx23885[0]/0: [f742f0c0/2] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.913874] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.913877] cx23885[0]/0: [f5679000/3] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.917671] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.917674] cx23885[0]/0: [f5679240/4] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.921468] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.921471] cx23885[0]/0: [f5679300/5] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.925264] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.925266] cx23885[0]/0: [f5679e40/6] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.929052] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.929055] cx23885[0]/0: [f5679840/7] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.932847] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.932850] cx23885[0]/0: [f56790c0/8] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.936641] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.936644] cx23885[0]/0: [f5679480/9] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.940436] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.940438] cx23885[0]/0: [f56793c0/10] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.944230] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.944234] cx23885[0]/0: [f5679c00/11] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.948025] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.948028] cx23885[0]/0: [f5679180/12] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.951820] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.951823] cx23885[0]/0: [f6665840/13] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.955614] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.955617] cx23885[0]/0: [f6665000/14] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.959407] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.959410] cx23885[0]/0: [f6665cc0/15] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.963203] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.963206] cx23885[0]/0: [f66656c0/16] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.966997] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.967000] cx23885[0]/0: [f6665a80/17] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.970792] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.970795] cx23885[0]/0: [f6665f00/18] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.974586] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.974589] cx23885[0]/0: [f6665d80/19] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.978380] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.978383] cx23885[0]/0: [f6665540/20] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.982175] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.982178] cx23885[0]/0: [f66716c0/21] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.985970] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.985973] cx23885[0]/0: [f66719c0/22] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.989764] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.989767] cx23885[0]/0: [f6671480/23] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.993558] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.993561] cx23885[0]/0: [f6671cc0/24] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  140.997353] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  140.997356] cx23885[0]/0: [f6671900/25] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.001147] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.001150] cx23885[0]/0: [f6671300/26] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.004942] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.004945] cx23885[0]/0: [f66713c0/27] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.008737] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.008740] cx23885[0]/0: [f6671000/28] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.012531] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.012534] cx23885[0]/0: [f6671e40/29] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.016325] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.016328] cx23885[0]/0: [f6671b40/30] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.020119] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.020122] cx23885[0]/0: [f66bde40/31] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.023915] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.023918] cx23885[0]/0: [f6fccc00/0] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.027709] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.027711] cx23885[0]/0: [f742fb40/1] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.031504] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.031507] cx23885[0]/0: [f742f0c0/2] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.035298] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.035301] cx23885[0]/0: [f5679000/3] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.039092] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.039095] cx23885[0]/0: [f5679240/4] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.042887] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.042890] cx23885[0]/0: [f5679300/5] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.046680] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.046683] cx23885[0]/0: [f5679e40/6] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.050476] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.050479] cx23885[0]/0: [f5679840/7] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.054270] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.054273] cx23885[0]/0: [f56790c0/8] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.058064] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.058067] cx23885[0]/0: [f5679480/9] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.061859] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.061862] cx23885[0]/0: [f56793c0/10] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.065654] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.065656] cx23885[0]/0: [f5679c00/11] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.069448] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.069451] cx23885[0]/0: [f5679180/12] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.073242] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.073245] cx23885[0]/0: [f6665840/13] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.077037] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.077040] cx23885[0]/0: [f6665000/14] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.080831] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.080834] cx23885[0]/0: [f6665cc0/15] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.084626] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.084629] cx23885[0]/0: [f66656c0/16] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.088420] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.088423] cx23885[0]/0: [f6665a80/17] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.092215] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.092218] cx23885[0]/0: [f6665f00/18] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.096012] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.096015] cx23885[0]/0: [f6665d80/19] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.099811] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.099813] cx23885[0]/0: [f6665540/20] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.103598] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.103601] cx23885[0]/0: [f66716c0/21] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.107392] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.107395] cx23885[0]/0: [f66719c0/22] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.111189] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.111193] cx23885[0]/0: [f6671480/23] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.114981] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.114984] cx23885[0]/0: [f6671cc0/24] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.118776] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.118779] cx23885[0]/0: [f6671900/25] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.122570] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.122573] cx23885[0]/0: [f6671300/26] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.126373] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.126376] cx23885[0]/0: [f66713c0/27] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.130159] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.130162] cx23885[0]/0: [f6671000/28] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.133953] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.133956] cx23885[0]/0: [f6671e40/29] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.137748] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.137751] cx23885[0]/0: [f6671b40/30] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.141542] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.141545] cx23885[0]/0: [f66bde40/31] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.145338] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:28 HTPC kernel: [  141.145341] cx23885[0]/0: [f6fccc00/0] cx23885_buf_queue - append to active
Apr  7 18:05:28 HTPC kernel: [  141.149132] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.149135] cx23885[0]/0: [f742fb40/1] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.152927] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.152930] cx23885[0]/0: [f742f0c0/2] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.156721] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.156724] cx23885[0]/0: [f5679000/3] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.160515] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.160518] cx23885[0]/0: [f5679240/4] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.164309] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.164312] cx23885[0]/0: [f5679300/5] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.168104] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.168107] cx23885[0]/0: [f5679e40/6] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.171899] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.171902] cx23885[0]/0: [f5679840/7] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.175693] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.175695] cx23885[0]/0: [f56790c0/8] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.179487] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.179490] cx23885[0]/0: [f5679480/9] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.183282] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.183284] cx23885[0]/0: [f56793c0/10] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.187076] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.187079] cx23885[0]/0: [f5679c00/11] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.190871] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.190874] cx23885[0]/0: [f5679180/12] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.194665] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.194668] cx23885[0]/0: [f6665840/13] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.198459] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.198462] cx23885[0]/0: [f6665000/14] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.202254] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.202257] cx23885[0]/0: [f6665cc0/15] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.206049] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.206052] cx23885[0]/0: [f66656c0/16] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.209843] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.209846] cx23885[0]/0: [f6665a80/17] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.213637] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.213640] cx23885[0]/0: [f6665f00/18] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.217432] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.217435] cx23885[0]/0: [f6665d80/19] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.221226] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.221229] cx23885[0]/0: [f6665540/20] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.225021] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.225024] cx23885[0]/0: [f66716c0/21] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.228816] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.228818] cx23885[0]/0: [f66719c0/22] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.232611] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.232613] cx23885[0]/0: [f6671480/23] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.236404] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.236407] cx23885[0]/0: [f6671cc0/24] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.240199] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.240202] cx23885[0]/0: [f6671900/25] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.243994] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.243996] cx23885[0]/0: [f6671300/26] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.247788] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.247791] cx23885[0]/0: [f66713c0/27] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.251583] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.251585] cx23885[0]/0: [f6671000/28] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.255377] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.255380] cx23885[0]/0: [f6671e40/29] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.259171] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.259174] cx23885[0]/0: [f6671b40/30] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.262966] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.262969] cx23885[0]/0: [f66bde40/31] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.266760] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.266763] cx23885[0]/0: [f6fccc00/0] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.270555] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.270558] cx23885[0]/0: [f742fb40/1] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.274349] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.274352] cx23885[0]/0: [f742f0c0/2] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.278144] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.278147] cx23885[0]/0: [f5679000/3] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.281938] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.281941] cx23885[0]/0: [f5679240/4] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.285732] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.285735] cx23885[0]/0: [f5679300/5] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.289527] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.289530] cx23885[0]/0: [f5679e40/6] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.293322] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.293324] cx23885[0]/0: [f5679840/7] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.297116] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.297119] cx23885[0]/0: [f56790c0/8] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.300884] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.300892] cx23885[0]/0: [f5679480/9] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.304708] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.304711] cx23885[0]/0: [f56793c0/10] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.308500] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.308503] cx23885[0]/0: [f5679c00/11] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.312294] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.312297] cx23885[0]/0: [f5679180/12] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.316089] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.316092] cx23885[0]/0: [f6665840/13] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.319883] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.319886] cx23885[0]/0: [f6665000/14] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.323678] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.323681] cx23885[0]/0: [f6665cc0/15] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.327472] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.327475] cx23885[0]/0: [f66656c0/16] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.331267] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.331270] cx23885[0]/0: [f6665a80/17] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.335061] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.335064] cx23885[0]/0: [f6665f00/18] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.338855] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.338858] cx23885[0]/0: [f6665d80/19] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.342649] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.342652] cx23885[0]/0: [f6665540/20] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.346445] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.346448] cx23885[0]/0: [f66716c0/21] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.350239] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.350242] cx23885[0]/0: [f66719c0/22] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.354034] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.354037] cx23885[0]/0: [f6671480/23] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.357828] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.357831] cx23885[0]/0: [f6671cc0/24] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.361622] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.361625] cx23885[0]/0: [f6671900/25] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.365417] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.365420] cx23885[0]/0: [f6671300/26] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.369211] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.369214] cx23885[0]/0: [f66713c0/27] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.373006] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.373009] cx23885[0]/0: [f6671000/28] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.376800] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.376803] cx23885[0]/0: [f6671e40/29] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.380595] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.380598] cx23885[0]/0: [f6671b40/30] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.384389] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.384392] cx23885[0]/0: [f66bde40/31] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.388183] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.388186] cx23885[0]/0: [f6fccc00/0] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.391979] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.391982] cx23885[0]/0: [f742fb40/1] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.395773] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.395775] cx23885[0]/0: [f742f0c0/2] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.399567] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.399570] cx23885[0]/0: [f5679000/3] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.403362] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.403365] cx23885[0]/0: [f5679240/4] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.407156] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.407159] cx23885[0]/0: [f5679300/5] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.410951] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.410954] cx23885[0]/0: [f5679e40/6] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.414745] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.414748] cx23885[0]/0: [f5679840/7] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.418539] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.418542] cx23885[0]/0: [f56790c0/8] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.422334] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.422337] cx23885[0]/0: [f5679480/9] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.426128] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.426131] cx23885[0]/0: [f56793c0/10] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.429923] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.429926] cx23885[0]/0: [f5679c00/11] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.433718] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.433721] cx23885[0]/0: [f5679180/12] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.437512] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.437515] cx23885[0]/0: [f6665840/13] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.441306] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.441309] cx23885[0]/0: [f6665000/14] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.445101] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.445104] cx23885[0]/0: [f6665cc0/15] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.448895] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.448898] cx23885[0]/0: [f66656c0/16] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.452690] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.452693] cx23885[0]/0: [f6665a80/17] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.456484] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.456487] cx23885[0]/0: [f6665f00/18] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.460279] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.460282] cx23885[0]/0: [f6665d80/19] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.464073] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.464076] cx23885[0]/0: [f6665540/20] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.467867] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.467870] cx23885[0]/0: [f66716c0/21] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.471662] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.471665] cx23885[0]/0: [f66719c0/22] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.475456] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.475459] cx23885[0]/0: [f6671480/23] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.479251] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.479254] cx23885[0]/0: [f6671cc0/24] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.483045] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.483048] cx23885[0]/0: [f6671900/25] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.486840] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.486843] cx23885[0]/0: [f6671300/26] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.490634] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.490637] cx23885[0]/0: [f66713c0/27] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.494429] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.494432] cx23885[0]/0: [f6671000/28] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.498224] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.498226] cx23885[0]/0: [f6671e40/29] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.502018] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.502021] cx23885[0]/0: [f6671b40/30] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.505813] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.505815] cx23885[0]/0: [f66bde40/31] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.509607] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.509610] cx23885[0]/0: [f6fccc00/0] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.513401] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.513404] cx23885[0]/0: [f742fb40/1] cx23885_buf_queue - append to active
Apr  7 18:05:29 HTPC kernel: [  141.517203] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:29 HTPC kernel: [  141.517206] cx23885[0]/0: [f742f0c0/2] cx23885_buf_queue - append to active
Apr  7 18:05:30 HTPC kernel: [  141.641449] xc2028 3-0061: xc2028_set_params called
Apr  7 18:05:30 HTPC kernel: [  141.641453] xc2028 3-0061: generic_set_freq called
Apr  7 18:05:30 HTPC kernel: [  141.641455] xc2028 3-0061: should set frequency 602000 kHz
Apr  7 18:05:30 HTPC kernel: [  141.641457] xc2028 3-0061: check_firmware called
Apr  7 18:05:30 HTPC kernel: [  141.641459] xc2028 3-0061: checking firmware, user requested type=F8MHZ D2633 DTV78 (112), id 0000000000000000, int_freq 4760, scode_nr 0
Apr  7 18:05:30 HTPC kernel: [  141.641465] xc2028 3-0061: BASE firmware not changed.
Apr  7 18:05:30 HTPC kernel: [  141.641467] xc2028 3-0061: Std-specific firmware already loaded.
Apr  7 18:05:30 HTPC kernel: [  141.641469] xc2028 3-0061: SCODE firmware already loaded.
Apr  7 18:05:30 HTPC kernel: [  141.641471] xc2028 3-0061: xc2028_get_reg 0004 called
Apr  7 18:05:30 HTPC kernel: [  141.641812] xc2028 3-0061: xc2028_get_reg 0008 called
Apr  7 18:05:30 HTPC kernel: [  141.642152] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Apr  7 18:05:30 HTPC kernel: [  141.705214] xc2028 3-0061: divisor= 00 00 95 d0 (freq=602.000)
Apr  7 18:05:30 HTPC kernel: [  141.830524] cx23885[0]/0: cx23885_buf_prepare: f566d000
Apr  7 18:05:30 HTPC kernel: [  141.830554] cx23885[0]/0: cx23885_buf_prepare: f566d780
Apr  7 18:05:30 HTPC kernel: [  141.830570] cx23885[0]/0: cx23885_buf_prepare: f566d300
Apr  7 18:05:30 HTPC kernel: [  141.830586] cx23885[0]/0: cx23885_buf_prepare: f566d840
Apr  7 18:05:30 HTPC kernel: [  141.830601] cx23885[0]/0: cx23885_buf_prepare: f566d600
Apr  7 18:05:30 HTPC kernel: [  141.830618] cx23885[0]/0: cx23885_buf_prepare: f566d240
Apr  7 18:05:30 HTPC kernel: [  141.830634] cx23885[0]/0: cx23885_buf_prepare: f566d9c0
Apr  7 18:05:30 HTPC kernel: [  141.830650] cx23885[0]/0: cx23885_buf_prepare: f566dcc0
Apr  7 18:05:30 HTPC kernel: [  141.830666] cx23885[0]/0: cx23885_buf_prepare: f566db40
Apr  7 18:05:30 HTPC kernel: [  141.830683] cx23885[0]/0: cx23885_buf_prepare: f566df00
Apr  7 18:05:30 HTPC kernel: [  141.830699] cx23885[0]/0: cx23885_buf_prepare: f566d540
Apr  7 18:05:30 HTPC kernel: [  141.830715] cx23885[0]/0: cx23885_buf_prepare: f7c2b9c0
Apr  7 18:05:30 HTPC kernel: [  141.830732] cx23885[0]/0: cx23885_buf_prepare: f66e9600
Apr  7 18:05:30 HTPC kernel: [  141.830749] cx23885[0]/0: cx23885_buf_prepare: f66e9540
Apr  7 18:05:30 HTPC kernel: [  141.830776] cx23885[0]/0: cx23885_buf_prepare: f66e9300
Apr  7 18:05:30 HTPC kernel: [  141.830795] cx23885[0]/0: cx23885_buf_prepare: f66e9c00
Apr  7 18:05:30 HTPC kernel: [  141.830813] cx23885[0]/0: cx23885_buf_prepare: f66e9cc0
Apr  7 18:05:30 HTPC kernel: [  141.830830] cx23885[0]/0: cx23885_buf_prepare: f66e9d80
Apr  7 18:05:30 HTPC kernel: [  141.830850] cx23885[0]/0: cx23885_buf_prepare: f66e9e40
Apr  7 18:05:30 HTPC kernel: [  141.830868] cx23885[0]/0: cx23885_buf_prepare: f66e9f00
Apr  7 18:05:30 HTPC kernel: [  141.830887] cx23885[0]/0: cx23885_buf_prepare: f66e90c0
Apr  7 18:05:30 HTPC kernel: [  141.830906] cx23885[0]/0: cx23885_buf_prepare: f66e9780
Apr  7 18:05:30 HTPC kernel: [  141.830926] cx23885[0]/0: cx23885_buf_prepare: f66e9240
Apr  7 18:05:30 HTPC kernel: [  141.830946] cx23885[0]/0: cx23885_buf_prepare: f66e9180
Apr  7 18:05:30 HTPC kernel: [  141.830971] cx23885[0]/0: cx23885_buf_prepare: f66e99c0
Apr  7 18:05:30 HTPC kernel: [  141.830991] cx23885[0]/0: cx23885_buf_prepare: f66e93c0
Apr  7 18:05:30 HTPC kernel: [  141.831012] cx23885[0]/0: cx23885_buf_prepare: f66e9000
Apr  7 18:05:30 HTPC kernel: [  141.831034] cx23885[0]/0: cx23885_buf_prepare: f66e9840
Apr  7 18:05:30 HTPC kernel: [  141.831057] cx23885[0]/0: cx23885_buf_prepare: f66e9900
Apr  7 18:05:30 HTPC kernel: [  141.831078] cx23885[0]/0: cx23885_buf_prepare: f66e9480
Apr  7 18:05:30 HTPC kernel: [  141.831101] cx23885[0]/0: cx23885_buf_prepare: f66e9a80
Apr  7 18:05:30 HTPC kernel: [  141.831122] cx23885[0]/0: cx23885_buf_prepare: f6477d80
Apr  7 18:05:30 HTPC kernel: [  141.831144] cx23885[0]/0: queue is empty - first active
Apr  7 18:05:30 HTPC kernel: [  141.831146] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2
Apr  7 18:05:30 HTPC kernel: [  141.831150] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
Apr  7 18:05:30 HTPC kernel: [  141.831250] cx23885[0]/0: cx23885_start_dma() enabling TS int's and DMA
Apr  7 18:05:30 HTPC kernel: [  141.831256] cx23885[0]/0: [f566d000/0] cx23885_buf_queue - first active
Apr  7 18:05:30 HTPC kernel: [  141.831258] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:30 HTPC kernel: [  141.831260] cx23885[0]/0: [f566d780/1] cx23885_buf_queue - append to active
Apr  7 18:05:30 HTPC kernel: [  141.831262] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:30 HTPC kernel: [  141.831264] cx23885[0]/0: [f566d300/2] cx23885_buf_queue - append to active
Apr  7 18:05:30 HTPC kernel: [  141.831266] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:05:30 HTPC kernel: [  141.831268] cx23885[0]/0: [f566d840/3] cx23885_buf_queue - append to active
Apr  7 18:05:30 HTPC kernel: [  141.831270] cx23885[0]/0: queue is not empty - append to active
[SNIP]

--Boundary-00=_pIa4JS+IA6KlG/5
Content-Type: text/plain;
  charset="UTF-8";
  name="mythtv.scan.channels.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mythtv.scan.channels.conf"

Apr  7 18:09:02 HTPC kernel: [  249.154032] xc2028 3-0061: xc2028_set_params called
Apr  7 18:09:02 HTPC kernel: [  249.154039] xc2028 3-0061: generic_set_freq called
Apr  7 18:09:02 HTPC kernel: [  249.154043] xc2028 3-0061: should set frequency 618000 kHz
Apr  7 18:09:02 HTPC kernel: [  249.154046] xc2028 3-0061: check_firmware called
Apr  7 18:09:02 HTPC kernel: [  249.154049] xc2028 3-0061: checking firmware, user requested type=F8MHZ D2633 DTV78 (112), id 0000000000000000, int_freq 4760, scode_nr 0
Apr  7 18:09:02 HTPC kernel: [  249.154056] xc2028 3-0061: BASE firmware not changed.
Apr  7 18:09:02 HTPC kernel: [  249.154058] xc2028 3-0061: Std-specific firmware already loaded.
Apr  7 18:09:02 HTPC kernel: [  249.154060] xc2028 3-0061: SCODE firmware already loaded.
Apr  7 18:09:02 HTPC kernel: [  249.154062] xc2028 3-0061: xc2028_get_reg 0004 called
Apr  7 18:09:02 HTPC kernel: [  249.154403] xc2028 3-0061: xc2028_get_reg 0008 called
Apr  7 18:09:02 HTPC kernel: [  249.154745] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Apr  7 18:09:02 HTPC kernel: [  249.218932] xc2028 3-0061: divisor= 00 00 99 d0 (freq=618.000)
Apr  7 18:09:02 HTPC kernel: [  249.280235] cx23885[0]/0: cx23885_buf_prepare: f6fcb240
Apr  7 18:09:02 HTPC kernel: [  249.280274] cx23885[0]/0: cx23885_buf_prepare: f6fcb300
Apr  7 18:09:02 HTPC kernel: [  249.280293] cx23885[0]/0: cx23885_buf_prepare: f6fcb480
Apr  7 18:09:02 HTPC kernel: [  249.280311] cx23885[0]/0: cx23885_buf_prepare: f6fcbcc0
Apr  7 18:09:02 HTPC kernel: [  249.280330] cx23885[0]/0: cx23885_buf_prepare: f6fcbb40
Apr  7 18:09:02 HTPC kernel: [  249.280349] cx23885[0]/0: cx23885_buf_prepare: f6fcb600
Apr  7 18:09:02 HTPC kernel: [  249.280366] cx23885[0]/0: cx23885_buf_prepare: f6fcbd80
Apr  7 18:09:02 HTPC kernel: [  249.280385] cx23885[0]/0: cx23885_buf_prepare: f6fcea80
Apr  7 18:09:02 HTPC kernel: [  249.280403] cx23885[0]/0: cx23885_buf_prepare: f6fce3c0
Apr  7 18:09:02 HTPC kernel: [  249.280420] cx23885[0]/0: cx23885_buf_prepare: f6fce780
Apr  7 18:09:02 HTPC kernel: [  249.280438] cx23885[0]/0: cx23885_buf_prepare: f5679180
Apr  7 18:09:02 HTPC kernel: [  249.280457] cx23885[0]/0: cx23885_buf_prepare: f5679f00
Apr  7 18:09:02 HTPC kernel: [  249.280475] cx23885[0]/0: cx23885_buf_prepare: f5679b40
Apr  7 18:09:02 HTPC kernel: [  249.280493] cx23885[0]/0: cx23885_buf_prepare: f56796c0
Apr  7 18:09:02 HTPC kernel: [  249.280511] cx23885[0]/0: cx23885_buf_prepare: f5679780
Apr  7 18:09:02 HTPC kernel: [  249.280532] cx23885[0]/0: cx23885_buf_prepare: f56799c0
Apr  7 18:09:02 HTPC kernel: [  249.280555] cx23885[0]/0: cx23885_buf_prepare: f5679000
Apr  7 18:09:02 HTPC kernel: [  249.280574] cx23885[0]/0: cx23885_buf_prepare: f56793c0
Apr  7 18:09:02 HTPC kernel: [  249.280592] cx23885[0]/0: cx23885_buf_prepare: f5679900
Apr  7 18:09:02 HTPC kernel: [  249.280612] cx23885[0]/0: cx23885_buf_prepare: f5679600
Apr  7 18:09:02 HTPC kernel: [  249.280635] cx23885[0]/0: cx23885_buf_prepare: f5679c00
Apr  7 18:09:02 HTPC kernel: [  249.280655] cx23885[0]/0: cx23885_buf_prepare: f564a780
Apr  7 18:09:02 HTPC kernel: [  249.280676] cx23885[0]/0: cx23885_buf_prepare: f564ac00
Apr  7 18:09:02 HTPC kernel: [  249.280697] cx23885[0]/0: cx23885_buf_prepare: f564a540
Apr  7 18:09:02 HTPC kernel: [  249.280718] cx23885[0]/0: cx23885_buf_prepare: f564a600
Apr  7 18:09:02 HTPC kernel: [  249.280745] cx23885[0]/0: cx23885_buf_prepare: f564a900
Apr  7 18:09:02 HTPC kernel: [  249.280767] cx23885[0]/0: cx23885_buf_prepare: f564a180
Apr  7 18:09:02 HTPC kernel: [  249.280789] cx23885[0]/0: cx23885_buf_prepare: f564a240
Apr  7 18:09:02 HTPC kernel: [  249.280811] cx23885[0]/0: cx23885_buf_prepare: f564a6c0
Apr  7 18:09:02 HTPC kernel: [  249.280838] cx23885[0]/0: cx23885_buf_prepare: f564aa80
Apr  7 18:09:02 HTPC kernel: [  249.280862] cx23885[0]/0: cx23885_buf_prepare: f564a0c0
Apr  7 18:09:02 HTPC kernel: [  249.280885] cx23885[0]/0: cx23885_buf_prepare: f564ab40
Apr  7 18:09:02 HTPC kernel: [  249.280909] cx23885[0]/0: queue is empty - first active
Apr  7 18:09:02 HTPC kernel: [  249.280913] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2
Apr  7 18:09:02 HTPC kernel: [  249.280918] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
Apr  7 18:09:02 HTPC kernel: [  249.281019] cx23885[0]/0: cx23885_start_dma() enabling TS int's and DMA
Apr  7 18:09:02 HTPC kernel: [  249.281026] cx23885[0]/0: [f6fcb240/0] cx23885_buf_queue - first active
Apr  7 18:09:02 HTPC kernel: [  249.281029] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281032] cx23885[0]/0: [f6fcb300/1] cx23885_buf_queue - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281035] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281037] cx23885[0]/0: [f6fcb480/2] cx23885_buf_queue - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281041] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281044] cx23885[0]/0: [f6fcbcc0/3] cx23885_buf_queue - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281047] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281050] cx23885[0]/0: [f6fcbb40/4] cx23885_buf_queue - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281053] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281056] cx23885[0]/0: [f6fcb600/5] cx23885_buf_queue - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281060] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281062] cx23885[0]/0: [f6fcbd80/6] cx23885_buf_queue - append to active
Apr  7 18:09:02 HTPC kernel: [  249.281066] cx23885[0]/0: queue is not empty - append to active
[SNIP]

--Boundary-00=_pIa4JS+IA6KlG/5
Content-Type: text/plain;
  charset="UTF-8";
  name="mythtv.scan.tuned"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mythtv.scan.tuned"

Apr  7 18:10:32 HTPC kernel: [  291.884296] xc2028 3-0061: xc2028_set_params called
Apr  7 18:10:32 HTPC kernel: [  291.884302] xc2028 3-0061: generic_set_freq called
Apr  7 18:10:32 HTPC kernel: [  291.884304] xc2028 3-0061: should set frequency 618000 kHz
Apr  7 18:10:32 HTPC kernel: [  291.884306] xc2028 3-0061: check_firmware called
Apr  7 18:10:32 HTPC kernel: [  291.884308] xc2028 3-0061: checking firmware, user requested type=F8MHZ D2633 DTV78 (112), id 0000000000000000, int_freq 4760, scode_nr 0
Apr  7 18:10:32 HTPC kernel: [  291.884315] xc2028 3-0061: BASE firmware not changed.
Apr  7 18:10:32 HTPC kernel: [  291.884317] xc2028 3-0061: Std-specific firmware already loaded.
Apr  7 18:10:32 HTPC kernel: [  291.884319] xc2028 3-0061: SCODE firmware already loaded.
Apr  7 18:10:32 HTPC kernel: [  291.884321] xc2028 3-0061: xc2028_get_reg 0004 called
Apr  7 18:10:32 HTPC kernel: [  291.884661] xc2028 3-0061: xc2028_get_reg 0008 called
Apr  7 18:10:32 HTPC kernel: [  291.885002] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Apr  7 18:10:32 HTPC kernel: [  291.951182] xc2028 3-0061: divisor= 00 00 99 d0 (freq=618.000)
Apr  7 18:10:32 HTPC kernel: [  292.045508] cx23885[0]/0: cx23885_buf_prepare: f6475780
Apr  7 18:10:32 HTPC kernel: [  292.045545] cx23885[0]/0: cx23885_buf_prepare: f663fe40
Apr  7 18:10:32 HTPC kernel: [  292.045564] cx23885[0]/0: cx23885_buf_prepare: f663f840
Apr  7 18:10:32 HTPC kernel: [  292.045583] cx23885[0]/0: cx23885_buf_prepare: f663f480
Apr  7 18:10:32 HTPC kernel: [  292.045605] cx23885[0]/0: cx23885_buf_prepare: f663f9c0
Apr  7 18:10:32 HTPC kernel: [  292.045626] cx23885[0]/0: cx23885_buf_prepare: f6679d80
Apr  7 18:10:32 HTPC kernel: [  292.045646] cx23885[0]/0: cx23885_buf_prepare: f6679b40
Apr  7 18:10:32 HTPC kernel: [  292.045666] cx23885[0]/0: cx23885_buf_prepare: f742f0c0
Apr  7 18:10:32 HTPC kernel: [  292.045687] cx23885[0]/0: cx23885_buf_prepare: df97f300
Apr  7 18:10:32 HTPC kernel: [  292.045706] cx23885[0]/0: cx23885_buf_prepare: f652b300
Apr  7 18:10:32 HTPC kernel: [  292.045725] cx23885[0]/0: cx23885_buf_prepare: f679ab40
Apr  7 18:10:32 HTPC kernel: [  292.045744] cx23885[0]/0: cx23885_buf_prepare: f679ac00
Apr  7 18:10:32 HTPC kernel: [  292.045762] cx23885[0]/0: cx23885_buf_prepare: f679a300
Apr  7 18:10:32 HTPC kernel: [  292.045783] cx23885[0]/0: cx23885_buf_prepare: f679a180
Apr  7 18:10:32 HTPC kernel: [  292.045803] cx23885[0]/0: cx23885_buf_prepare: f679a840
Apr  7 18:10:32 HTPC kernel: [  292.045824] cx23885[0]/0: cx23885_buf_prepare: f679a9c0
Apr  7 18:10:32 HTPC kernel: [  292.045845] cx23885[0]/0: cx23885_buf_prepare: f679a3c0
Apr  7 18:10:32 HTPC kernel: [  292.045866] cx23885[0]/0: cx23885_buf_prepare: f679af00
Apr  7 18:10:32 HTPC kernel: [  292.045889] cx23885[0]/0: cx23885_buf_prepare: f679a600
Apr  7 18:10:32 HTPC kernel: [  292.045912] cx23885[0]/0: cx23885_buf_prepare: f679aa80
Apr  7 18:10:32 HTPC kernel: [  292.045933] cx23885[0]/0: cx23885_buf_prepare: f679ae40
Apr  7 18:10:32 HTPC kernel: [  292.045953] cx23885[0]/0: cx23885_buf_prepare: f679a780
Apr  7 18:10:32 HTPC kernel: [  292.045974] cx23885[0]/0: cx23885_buf_prepare: f679a900
Apr  7 18:10:32 HTPC kernel: [  292.046000] cx23885[0]/0: cx23885_buf_prepare: f679a0c0
Apr  7 18:10:32 HTPC kernel: [  292.046023] cx23885[0]/0: cx23885_buf_prepare: f65f1f00
Apr  7 18:10:32 HTPC kernel: [  292.046045] cx23885[0]/0: cx23885_buf_prepare: f65f1480
Apr  7 18:10:32 HTPC kernel: [  292.046067] cx23885[0]/0: cx23885_buf_prepare: f65f1d80
Apr  7 18:10:32 HTPC kernel: [  292.046088] cx23885[0]/0: cx23885_buf_prepare: f65f1780
Apr  7 18:10:32 HTPC kernel: [  292.046116] cx23885[0]/0: cx23885_buf_prepare: f65f1b40
Apr  7 18:10:32 HTPC kernel: [  292.046138] cx23885[0]/0: cx23885_buf_prepare: f65f1e40
Apr  7 18:10:32 HTPC kernel: [  292.046160] cx23885[0]/0: cx23885_buf_prepare: f66e3540
Apr  7 18:10:32 HTPC kernel: [  292.046184] cx23885[0]/0: cx23885_buf_prepare: f66e30c0
Apr  7 18:10:32 HTPC kernel: [  292.046214] cx23885[0]/0: queue is empty - first active
Apr  7 18:10:32 HTPC kernel: [  292.046217] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2
Apr  7 18:10:32 HTPC kernel: [  292.046222] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
Apr  7 18:10:32 HTPC kernel: [  292.046323] cx23885[0]/0: cx23885_start_dma() enabling TS int's and DMA
Apr  7 18:10:32 HTPC kernel: [  292.046329] cx23885[0]/0: [f6475780/0] cx23885_buf_queue - first active
Apr  7 18:10:32 HTPC kernel: [  292.046333] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:10:32 HTPC kernel: [  292.046336] cx23885[0]/0: [f663fe40/1] cx23885_buf_queue - append to active
Apr  7 18:10:32 HTPC kernel: [  292.046339] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:10:32 HTPC kernel: [  292.046342] cx23885[0]/0: [f663f840/2] cx23885_buf_queue - append to active
Apr  7 18:10:32 HTPC kernel: [  292.046345] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:10:32 HTPC kernel: [  292.046348] cx23885[0]/0: [f663f480/3] cx23885_buf_queue - append to active
Apr  7 18:10:32 HTPC kernel: [  292.046352] cx23885[0]/0: queue is not empty - append to active
[SNIP]

--Boundary-00=_pIa4JS+IA6KlG/5
Content-Type: text/plain;
  charset="UTF-8";
  name="mythtv.tune"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mythtv.tune"

Apr  7 18:11:50 HTPC kernel: [  329.116463] DVB: adapter 2 frontend 0 frequency 0 out of range (174000000..862000000)
Apr  7 18:11:50 HTPC kernel: [  329.125486] DVB: adapter 2 frontend 0 frequency 0 out of range (174000000..862000000)

Apr  7 18:12:32 HTPC kernel: [  355.899489] DVB: adapter 2 frontend 0 frequency 0 out of range (174000000..862000000)
Apr  7 18:12:47 HTPC kernel: [  362.886233] DVB: adapter 2 frontend 0 frequency 0 out of range (174000000..862000000)

Apr  7 18:13:04 HTPC kernel: [  371.173093] DVB: adapter 2 frontend 0 frequency 0 out of range (174000000..862000000)
Apr  7 18:13:14 HTPC kernel: [  375.935118] DVB: adapter 2 frontend 0 frequency 0 out of range (174000000..862000000)


--Boundary-00=_pIa4JS+IA6KlG/5
Content-Type: text/plain;
  charset="UTF-8";
  name="gxine.tune"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="gxine.tune"

Apr  7 18:14:13 HTPC kernel: [  403.664350] xc2028 3-0061: xc2028_set_params called
Apr  7 18:14:13 HTPC kernel: [  403.664356] xc2028 3-0061: generic_set_freq called
Apr  7 18:14:13 HTPC kernel: [  403.664358] xc2028 3-0061: should set frequency 618000 kHz
Apr  7 18:14:13 HTPC kernel: [  403.664360] xc2028 3-0061: check_firmware called
Apr  7 18:14:13 HTPC kernel: [  403.664362] xc2028 3-0061: checking firmware, user requested type=F8MHZ D2633 DTV78 (112), id 0000000000000000, int_freq 4760, scode_nr 0
Apr  7 18:14:13 HTPC kernel: [  403.664369] xc2028 3-0061: BASE firmware not changed.
Apr  7 18:14:13 HTPC kernel: [  403.664371] xc2028 3-0061: Std-specific firmware already loaded.
Apr  7 18:14:13 HTPC kernel: [  403.664373] xc2028 3-0061: SCODE firmware already loaded.
Apr  7 18:14:13 HTPC kernel: [  403.664375] xc2028 3-0061: xc2028_get_reg 0004 called
Apr  7 18:14:13 HTPC kernel: [  403.664707] xc2028 3-0061: xc2028_get_reg 0008 called
Apr  7 18:14:13 HTPC kernel: [  403.665046] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Apr  7 18:14:13 HTPC kernel: [  403.730980] xc2028 3-0061: divisor= 00 00 99 d0 (freq=618.000)
Apr  7 18:14:13 HTPC kernel: [  404.024487] cx23885[0]/0: cx23885_buf_prepare: f665f840
Apr  7 18:14:13 HTPC kernel: [  404.024692] cx23885[0]/0: cx23885_buf_prepare: f665f780
Apr  7 18:14:13 HTPC kernel: [  404.024860] cx23885[0]/0: cx23885_buf_prepare: f665f9c0
Apr  7 18:14:13 HTPC kernel: [  404.025026] cx23885[0]/0: cx23885_buf_prepare: f665ff00
Apr  7 18:14:13 HTPC kernel: [  404.025191] cx23885[0]/0: cx23885_buf_prepare: f665f240
Apr  7 18:14:13 HTPC kernel: [  404.025356] cx23885[0]/0: cx23885_buf_prepare: f665f480
Apr  7 18:14:13 HTPC kernel: [  404.025522] cx23885[0]/0: cx23885_buf_prepare: f665f0c0
Apr  7 18:14:13 HTPC kernel: [  404.025688] cx23885[0]/0: cx23885_buf_prepare: f665fc00
Apr  7 18:14:13 HTPC kernel: [  404.025860] cx23885[0]/0: cx23885_buf_prepare: f665fa80
Apr  7 18:14:13 HTPC kernel: [  404.026026] cx23885[0]/0: cx23885_buf_prepare: f665f600
Apr  7 18:14:13 HTPC kernel: [  404.026192] cx23885[0]/0: cx23885_buf_prepare: f665fb40
Apr  7 18:14:13 HTPC kernel: [  404.026359] cx23885[0]/0: cx23885_buf_prepare: f665f300
Apr  7 18:14:13 HTPC kernel: [  404.026525] cx23885[0]/0: cx23885_buf_prepare: f665fd80
Apr  7 18:14:13 HTPC kernel: [  404.026691] cx23885[0]/0: cx23885_buf_prepare: f665f3c0
Apr  7 18:14:13 HTPC kernel: [  404.026859] cx23885[0]/0: cx23885_buf_prepare: f665f000
Apr  7 18:14:13 HTPC kernel: [  404.027027] cx23885[0]/0: cx23885_buf_prepare: f665fcc0
Apr  7 18:14:13 HTPC kernel: [  404.027194] cx23885[0]/0: cx23885_buf_prepare: f665f540
Apr  7 18:14:13 HTPC kernel: [  404.027362] cx23885[0]/0: cx23885_buf_prepare: f6f97f00
Apr  7 18:14:13 HTPC kernel: [  404.027532] cx23885[0]/0: cx23885_buf_prepare: f6f97840
Apr  7 18:14:13 HTPC kernel: [  404.027701] cx23885[0]/0: cx23885_buf_prepare: f6f97cc0
Apr  7 18:14:13 HTPC kernel: [  404.027881] cx23885[0]/0: cx23885_buf_prepare: df807840
Apr  7 18:14:13 HTPC kernel: [  404.028050] cx23885[0]/0: cx23885_buf_prepare: df807240
Apr  7 18:14:13 HTPC kernel: [  404.028220] cx23885[0]/0: cx23885_buf_prepare: df807000
Apr  7 18:14:13 HTPC kernel: [  404.028391] cx23885[0]/0: cx23885_buf_prepare: f7748300
Apr  7 18:14:13 HTPC kernel: [  404.028564] cx23885[0]/0: cx23885_buf_prepare: f66bd480
Apr  7 18:14:13 HTPC kernel: [  404.028735] cx23885[0]/0: cx23885_buf_prepare: f66bd9c0
Apr  7 18:14:13 HTPC kernel: [  404.028902] cx23885[0]/0: cx23885_buf_prepare: f66bde40
Apr  7 18:14:13 HTPC kernel: [  404.029078] cx23885[0]/0: cx23885_buf_prepare: f66bd540
Apr  7 18:14:13 HTPC kernel: [  404.029252] cx23885[0]/0: cx23885_buf_prepare: f66bd300
Apr  7 18:14:13 HTPC kernel: [  404.029423] cx23885[0]/0: cx23885_buf_prepare: dfa56f00
Apr  7 18:14:13 HTPC kernel: [  404.029592] cx23885[0]/0: cx23885_buf_prepare: dfa56240
Apr  7 18:14:13 HTPC kernel: [  404.029766] cx23885[0]/0: cx23885_buf_prepare: dfa56600
Apr  7 18:14:13 HTPC kernel: [  404.029937] cx23885[0]/0: queue is empty - first active
Apr  7 18:14:13 HTPC kernel: [  404.029940] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2
Apr  7 18:14:13 HTPC kernel: [  404.029944] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
Apr  7 18:14:13 HTPC kernel: [  404.030044] cx23885[0]/0: cx23885_start_dma() enabling TS int's and DMA
Apr  7 18:14:13 HTPC kernel: [  404.030050] cx23885[0]/0: [f665f840/0] cx23885_buf_queue - first active
Apr  7 18:14:13 HTPC kernel: [  404.030052] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030055] cx23885[0]/0: [f665f780/1] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030057] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030059] cx23885[0]/0: [f665f9c0/2] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030061] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030063] cx23885[0]/0: [f665ff00/3] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030065] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030067] cx23885[0]/0: [f665f240/4] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030069] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030071] cx23885[0]/0: [f665f480/5] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030073] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030075] cx23885[0]/0: [f665f0c0/6] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030077] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030079] cx23885[0]/0: [f665fc00/7] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030081] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030083] cx23885[0]/0: [f665fa80/8] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030085] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030087] cx23885[0]/0: [f665f600/9] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030089] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030091] cx23885[0]/0: [f665fb40/10] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030093] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030095] cx23885[0]/0: [f665f300/11] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030097] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030099] cx23885[0]/0: [f665fd80/12] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030101] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030103] cx23885[0]/0: [f665f3c0/13] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030105] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030107] cx23885[0]/0: [f665f000/14] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030109] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030111] cx23885[0]/0: [f665fcc0/15] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030113] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030115] cx23885[0]/0: [f665f540/16] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030117] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030119] cx23885[0]/0: [f6f97f00/17] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030121] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030123] cx23885[0]/0: [f6f97840/18] cx23885_buf_queue - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030125] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:13 HTPC kernel: [  404.030127] cx23885[0]/0: [f6f97cc0/19] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030129] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030131] cx23885[0]/0: [df807840/20] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030133] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030135] cx23885[0]/0: [df807240/21] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030137] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030139] cx23885[0]/0: [df807000/22] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030141] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030143] cx23885[0]/0: [f7748300/23] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030145] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030147] cx23885[0]/0: [f66bd480/24] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030149] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030151] cx23885[0]/0: [f66bd9c0/25] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030153] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030155] cx23885[0]/0: [f66bde40/26] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030157] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030159] cx23885[0]/0: [f66bd540/27] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030160] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030163] cx23885[0]/0: [f66bd300/28] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030164] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030166] cx23885[0]/0: [dfa56f00/29] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030168] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030170] cx23885[0]/0: [dfa56240/30] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030172] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.030174] cx23885[0]/0: [dfa56600/31] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.036270] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.036272] cx23885[0]/0: [f665f840/0] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.046086] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.046090] cx23885[0]/0: [f665f780/1] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.046108] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.046110] cx23885[0]/0: [f665f9c0/2] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.046122] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.046124] cx23885[0]/0: [f665ff00/3] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.185238] cx23885[0]/0: cx23885_buf_prepare: f66adcc0
Apr  7 18:14:14 HTPC kernel: [  404.185262] cx23885[0]/0: cx23885_buf_prepare: f66ad600
Apr  7 18:14:14 HTPC kernel: [  404.185279] cx23885[0]/0: cx23885_buf_prepare: f66ad540
Apr  7 18:14:14 HTPC kernel: [  404.185295] cx23885[0]/0: cx23885_buf_prepare: f66ad3c0
Apr  7 18:14:14 HTPC kernel: [  404.185313] cx23885[0]/0: cx23885_buf_prepare: f66ade40
Apr  7 18:14:14 HTPC kernel: [  404.185329] cx23885[0]/0: cx23885_buf_prepare: f66ad240
Apr  7 18:14:14 HTPC kernel: [  404.185346] cx23885[0]/0: cx23885_buf_prepare: f66ad000
Apr  7 18:14:14 HTPC kernel: [  404.185363] cx23885[0]/0: cx23885_buf_prepare: f66ad480
Apr  7 18:14:14 HTPC kernel: [  404.185381] cx23885[0]/0: cx23885_buf_prepare: f66ad9c0
Apr  7 18:14:14 HTPC kernel: [  404.185398] cx23885[0]/0: cx23885_buf_prepare: f66ad300
Apr  7 18:14:14 HTPC kernel: [  404.185415] cx23885[0]/0: cx23885_buf_prepare: f66adb40
Apr  7 18:14:14 HTPC kernel: [  404.185433] cx23885[0]/0: cx23885_buf_prepare: f66ad840
Apr  7 18:14:14 HTPC kernel: [  404.185451] cx23885[0]/0: cx23885_buf_prepare: f66adc00
Apr  7 18:14:14 HTPC kernel: [  404.185468] cx23885[0]/0: cx23885_buf_prepare: f704dcc0
Apr  7 18:14:14 HTPC kernel: [  404.185490] cx23885[0]/0: cx23885_buf_prepare: f704dd80
Apr  7 18:14:14 HTPC kernel: [  404.185509] cx23885[0]/0: cx23885_buf_prepare: f6477900
Apr  7 18:14:14 HTPC kernel: [  404.185529] cx23885[0]/0: cx23885_buf_prepare: f6477480
Apr  7 18:14:14 HTPC kernel: [  404.185547] cx23885[0]/0: cx23885_buf_prepare: f64779c0
Apr  7 18:14:14 HTPC kernel: [  404.185569] cx23885[0]/0: cx23885_buf_prepare: f6477300
Apr  7 18:14:14 HTPC kernel: [  404.185588] cx23885[0]/0: cx23885_buf_prepare: f64776c0
Apr  7 18:14:14 HTPC kernel: [  404.185607] cx23885[0]/0: cx23885_buf_prepare: f6548a80
Apr  7 18:14:14 HTPC kernel: [  404.185627] cx23885[0]/0: cx23885_buf_prepare: f66e63c0
Apr  7 18:14:14 HTPC kernel: [  404.185647] cx23885[0]/0: cx23885_buf_prepare: f6452300
Apr  7 18:14:14 HTPC kernel: [  404.185672] cx23885[0]/0: cx23885_buf_prepare: f6452d80
Apr  7 18:14:14 HTPC kernel: [  404.185695] cx23885[0]/0: cx23885_buf_prepare: f6452600
Apr  7 18:14:14 HTPC kernel: [  404.185718] cx23885[0]/0: cx23885_buf_prepare: f6452e40
Apr  7 18:14:14 HTPC kernel: [  404.185741] cx23885[0]/0: cx23885_buf_prepare: f64523c0
Apr  7 18:14:14 HTPC kernel: [  404.185763] cx23885[0]/0: cx23885_buf_prepare: f6452f00
Apr  7 18:14:14 HTPC kernel: [  404.185791] cx23885[0]/0: cx23885_buf_prepare: f6452240
Apr  7 18:14:14 HTPC kernel: [  404.185813] cx23885[0]/0: cx23885_buf_prepare: f6452480
Apr  7 18:14:14 HTPC kernel: [  404.185836] cx23885[0]/0: cx23885_buf_prepare: f6452a80
Apr  7 18:14:14 HTPC kernel: [  404.185860] cx23885[0]/0: cx23885_buf_prepare: f6452000
Apr  7 18:14:14 HTPC kernel: [  404.185886] cx23885[0]/0: queue is empty - first active
Apr  7 18:14:14 HTPC kernel: [  404.185888] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2
Apr  7 18:14:14 HTPC kernel: [  404.185892] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
Apr  7 18:14:14 HTPC kernel: [  404.186100] cx23885[0]/0: cx23885_start_dma() enabling TS int's and DMA
Apr  7 18:14:14 HTPC kernel: [  404.186110] cx23885[0]/0: [f66adcc0/0] cx23885_buf_queue - first active
Apr  7 18:14:14 HTPC kernel: [  404.186113] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186115] cx23885[0]/0: [f66ad600/1] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186117] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186119] cx23885[0]/0: [f66ad540/2] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186121] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186123] cx23885[0]/0: [f66ad3c0/3] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186125] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186127] cx23885[0]/0: [f66ade40/4] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186129] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186131] cx23885[0]/0: [f66ad240/5] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186133] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186135] cx23885[0]/0: [f66ad000/6] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186137] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186139] cx23885[0]/0: [f66ad480/7] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186141] cx23885[0]/0: queue is not empty - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186143] cx23885[0]/0: [f66ad9c0/8] cx23885_buf_queue - append to active
Apr  7 18:14:14 HTPC kernel: [  404.186145] cx23885[0]/0: queue is not empty - append to active
[SNIP]
--Boundary-00=_pIa4JS+IA6KlG/5--
