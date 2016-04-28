Return-path: <linux-media-owner@vger.kernel.org>
Received: from out.selfhost.de ([82.98.82.95]:50811 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750867AbcD1OuI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 10:50:08 -0400
Date: Thu, 28 Apr 2016 16:50:03 +0200
From: Hendrik Oenings <debian@oenings.de>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Mailinglist linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-s2 card "TeVii S472" (cx23885)
Message-ID: <20160428165003.273fe492@spock>
In-Reply-To: <CAAZRmGyoX3HTrjJn9H_YgHzt9Uexw96pz8_+U01SGkZq3ApCCw@mail.gmail.com>
References: <20160423125131.GB1122@spock.oenings.local>
	<CAAZRmGzG72hm_sd9qpYx7Mo28oSxBgRghPRt42OPN-3xnj94uw@mail.gmail.com>
	<20160424180038.03776e74@spock>
	<CAAZRmGyDJJPRgNKD25DL=a1fyYX3rP0-tcbxcP+7AJv5wVz_Uw@mail.gmail.com>
	<20160425181423.5a5876c1@spock>
	<CAAZRmGyDAhE6caz+wmJySQ-xjESiE5-=h9YCE7VamHxXNV8sBQ@mail.gmail.com>
	<20160427213934.184bc70d@spock>
	<CAAZRmGyoX3HTrjJn9H_YgHzt9Uexw96pz8_+U01SGkZq3ApCCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,

I've checked if the chip is M88DS3103 and it is not DS3103, but
DS3002b. LinuxTV says it's just like DS3000 and I've seen that the
TeVii S471 also uses that demodulator.

I've tried just to use the code used by TeVii S471, but then ds3000 says
something like:
* Invalid probe, probably not a DS3000
and there's not even a /dev/dvb/*-device then.
Maybe the card could be unusable too, because it says that there's a
ds3000 on it...

Nevertheless, I've tried your module option with m88ds3103 and my kernel
output is the following:
$ dmesg
...
[  137.641212] cx23885 driver version 0.0.4 loaded
[  137.641428] CORE cx23885[0]: subsystem: d472:9022, board: TeVii S472
[card=56,autodetected]
[  138.177366] cx23885_dvb_register() allocating
1 frontend(s)
[  138.177369] cx23885[0]: cx23885 based dvb card
[  138.177871] m88ds3103:m88ds3103_probe: m88ds3103 7-0068: chip_id=70
[  138.180730] i2c i2c-7: Added multiplexed i2c bus 9
[  138.180737] m88ds3103:m88ds3103_get_i2c_adapter: m88ds3103 7-0068: 
[  138.180739] m88ds3103:m88ds3103_get_dvb_frontend: m88ds3103 7-0068: 
[  138.235956] ts2020 9-0060: Montage Technology TS2022 successfully
identified
[  138.235961] DVB: registering new adapter (cx23885[0])
[  138.235964] cx23885 0000:03:00.0: DVB: registering adapter 0
frontend 0 (Montage Technology M88DS3103)...
[  138.236379] cx23885_dev_checkrevision() Hardware revision = 0xa5
[  138.236384] cx23885[0]/0: found at 0000:03:00.0, rev: 4, irq: 19,
latency: 0, mmio: 0xf7c00000
[  153.386612] m88ds3103:m88ds3103_init: m88ds3103 7-0068:
[  153.388582] m88ds3103:m88ds3103_init: m88ds3103 7-0068: firmware=c3
[  153.398919] m88ds3103:m88ds3103_set_voltage: m88ds3103 7-0068:
fe_sec_voltage=2
[  153.400034] m88ds3103:m88ds3103_sleep: m88ds3103 7-0068:
[  153.402477] m88ds3103:m88ds3103_init: m88ds3103 7-0068:
[  153.404436] m88ds3103:m88ds3103_init: m88ds3103 7-0068: firmware=c3
[  153.414775] m88ds3103:m88ds3103_set_tone: m88ds3103 7-0068:
fe_sec_tone_mode=1
[  153.415892] m88ds3103:m88ds3103_set_voltage: m88ds3103 7-0068:
fe_sec_voltage=0
[  153.431553] m88ds3103:m88ds3103_diseqc_send_master_cmd: m88ds3103
7-0068: msg=e0 10 39 f0
[  153.556188] m88ds3103:m88ds3103_diseqc_send_master_cmd: m88ds3103
7-0068: diseqc tx timeout
[  153.557299] m88ds3103:m88ds3103_diseqc_send_master_cmd: m88ds3103
7-0068: failed=-110
[  153.557337] m88ds3103:m88ds3103_set_tone: m88ds3103 7-0068:
fe_sec_tone_mode=1

I'll try to reinsert the card and check the EFI if there's something
concerning the card.

Regards,
Hendrik

Am Thu, 28 Apr 2016 11:27:48 +0300
schrieb Olli Salonen <olli.salonen@iki.fi>:

> Hi Hendrik,
> 
> Can you check that the chip on the board is indeed M88DS3103? I could
> not read the text on the chip on the photo you sent earlier.
> 
> Furthermore, could you load the m88ds3103 driver with debugging
> enabled before loading the cx23885 module:
> modprobe m88ds3103 dyndbg==pmf
> 
> Then send the dmesg printout and maybe we can get some hints why the
> firmware is not running.
> 
> Cheers,
> -olli
> 
> On 27 April 2016 at 22:39, Hendrik Oenings <debian@oenings.de> wrote:
> > Hi together,
> >
> > I tried to recompile with the newest media_tree, so I just copied
> > your modifications to the new media_tree. (I also refetched the
> > media_build.) It wasn't very helpful, but I've seen that there is a
> > kernel error message (which was there before too, but I hadn't seen
> > it because I worked on X).
> >
> > $ su -c "modprobe cx23885"
> > modprobe: ERROR: could not insert 'cx23885': Exec format error
> > $ dmesg
> > ...
> > [XXXXXX.XXXXXX] frame_vector: exports duplicate symbol
> > frame_vector_create (owned by kernel)
> >
> > I've looked up the reason for the re-export and I have seen that
> > frame_vector was built as an module, but is compiled into the
> > kernel.
> >
> > Changing this in the ./media/v4l/.config from m to y worked, so I
> > can now load the module.
> >
> > The kernel message is gone away, but there is another problem now,
> > dmesg says and w_scan doesn't work either:
> >
> > [XXX] m88ds3103 7-0068: found a 'Montage Technology M88DS3103' in
> > cold state
> >
> > [XXX] m88ds3103 7-0068: downloading firmware from file
> > 'dvb-demod-m88ds3103.fw'
> >
> > [XXX] m88ds3103 7-0068: firmware did not run
> >
> > I've copied the firmware as suggested to /lib/firmware.
> >
> > Regards,
> > Hendrik
> >
> > Am Tue, 26 Apr 2016 09:03:24 +0300
> > schrieb Olli Salonen <olli.salonen@iki.fi>:
> >  
> >> Hi Hendrik, Hans,
> >>
> >> My media_tree Hendrik is pulling from Github is just a rather
> >> recent copy of the media_tree master branch on git.linuxtv.org
> >> (it's missing like the last 10 patches that have been added within
> >> the last 24 hours) with 2 simple patches on top that should not
> >> break anything.
> >>
> >> Also, the media_build is recent, since you just cloned it.
> >>
> >> Hans, do you know if there are any known issues with the current
> >> media_build/media_tree on certain kernels?
> >>
> >> Thanks.
> >>
> >> Cheers,
> >> -olli
> >>
> >> On 25 April 2016 at 19:14, Hendrik Oenings <debian@oenings.de>
> >> wrote:  
> >> > Hi Olli,
> >> >
> >> > I've tested the driver, it compiles well and I've installed it
> >> > on my system.
> >> > But there's a problem: Everytime I try to load the driver (exact:
> >> > the module cx23885), modprobe (or insmod) is giving me the
> >> > following: # modprobe cx23885
> >> > modprobe: ERROR: could not insert 'cx23885': Exec format error
> >> >
> >> > I've also tried to compile it with the current 4.6er kernel, but
> >> > it stays the same.
> >> > $ uname -r
> >> > 4.6.0-rc5
> >> >
> >> > I've also tried to recompile the driver, but it didn't help.
> >> >
> >> > Maybe it is important to mention that some patches fail at the
> >> > beginning of the build process (pr_fmt, debug).
> >> >
> >> > The installed module seems to be correct file format (my arch is
> >> > x86_64):
> >> > $ file \
> >> >  /lib/modules/4.6.0-rc5/kernel/drivers/media/pci/cx23885/cx23885.ko
> >> >
> >> > /lib/modules/4.6.0-rc5/kernel/drivers/media/pci/cx23885/cx23885.ko:
> >> > ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV),
> >> > BuildID[sha1]=07a3f2f2fe383ab691b0022568dcd4d8315dc4b8, not
> >> > stripped
> >> >
> >> > Regards,
> >> > Hendrik
> >> >
> >> > On Mo, 25 Apr 2016 11:56:37 +0300, Olli Salonen
> >> > <olli.salonen@iki.fi> wrote:
> >> >  
> >> >> Hello Hendrik,
> >> >>
> >> >> I've created an initial version of the driver.
> >> >> https://github.com/trsqr/media_tree/commit/b59f25b18bbe84e009618eefeaf646f5939bdd53
> >> >>
> >> >> To build, do the following:
> >> >>
> >> >> git clone git://linuxtv.org/media_build.git
> >> >> git clone --depth=1 https://github.com/trsqr/media_tree.git -b
> >> >> s472 ./media cd media_build
> >> >> make dir DIR=../media
> >> >> make distclean
> >> >> make
> >> >>
> >> >> To install after a successful build:
> >> >>
> >> >> sudo make install
> >> >>
> >> >> Download also the following firmware and place it
> >> >> in /lib/firmware:
> >> >> http://palosaari.fi/linux/v4l-dvb/firmware/M88DS3103/3.B/
> >> >>
> >> >> The thing is, I had to guess the following parameters in
> >> >> drivers/media/pci/cx23885/cx23885-dvb.c file:
> >> >>
> >> >> +static const struct m88ds3103_config
> >> >> tevii_s472_m88ds3103_config = {
> >> >> +       .i2c_addr = 0x68,
> >> >> +       .clock = 27000000,
> >> >> +       .i2c_wr_max = 33,
> >> >> +       .clock_out = 0,
> >> >> +       .ts_mode = M88DS3103_TS_PARALLEL,
> >> >> +       .ts_clk = 16000,
> >> >> +       .ts_clk_pol = 0,
> >> >> +       .lnb_en_pol = 0,
> >> >> +       .lnb_hv_pol = 1,
> >> >> +       .agc = 0x99,
> >> >> +};
> >> >>
> >> >> If the driver does not work (it loads and appears to tune, but
> >> >> does not find channels), try altering ts_clk_pol, lnb_en_pol and
> >> >> lnb_hv_pol. The possible values are 1 and 0 so there should not
> >> >> be that many iterations needed.. Current values are based on
> >> >> best guess.
> >> >>
> >> >> Cheers,
> >> >> -olli
> >> >>
> >> >>
> >> >>
> >> >> On 24 April 2016 at 19:00, Hendrik Oenings <debian@oenings.de>
> >> >> wrote:  
> >> >> > Hi Olli,
> >> >> >
> >> >> > I'm glad that there is someone trying to help me and of course
> >> >> > I'm able to test a driver.
> >> >> >
> >> >> > Because of the attached photos, I think it is better not to
> >> >> > send this mail to the mailing list.
> >> >> >
> >> >> > cx23885, m88ds3103 and m88ts2022 are the values I also think
> >> >> > they're correct. cx23885 is also mentioned by lspci, the other
> >> >> > values I've also seen often while searching for a solution.
> >> >> >
> >> >> > Here is also the full output of lspci concerning the tv card
> >> >> > which is probably helpful.
> >> >> > # lspci -vv
> >> >> > [...]
> >> >> > 03:00.0 Multimedia video controller: Conexant Systems, Inc.
> >> >> > CX23885 PCI Video and Audio Decoder (rev 04) Subsystem: Device
> >> >> > d472:9022 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV-
> >> >> > VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx- Status:
> >> >> > Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> >> >> > <TAbort- <MAbort- >SERR- <PERR- INTx- Latency: 0, Cache Line
> >> >> > Size: 64 bytes Interrupt: pin A routed to IRQ 19 Region 0:
> >> >> > Memory at f7c00000 (64-bit, non-prefetchable) [size=2M]
> >> >> > Capabilities: [40] Express (v1) Endpoint, MSI 00 DevCap:
> >> >> > MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
> >> >> > ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
> >> >> > DevCtl:        Report errors: Correctable- Non-Fatal- Fatal-
> >> >> > Unsupported- RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> >> >> > MaxPayload 128 bytes, MaxReadReq 512 bytes DevSta: CorrErr-
> >> >> > UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
> >> >> > LnkCap:      Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> >> >> > Exit Latency L0s <2us, L1 <4us ClockPM- Surprise- LLActRep-
> >> >> > BwNot- ASPMOptComp- LnkCtl:   ASPM Disabled; RCB 64 bytes
> >> >> > Disabled- CommClk+ ExtSynch- ClockPM- AutWidDis- BWInt-
> >> >> > AutBWInt- LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
> >> >> > SlotClk+ DLActive- BWMgmt- ABWMgmt- Capabilities: [80] Power
> >> >> > Management version 2 Flags: PMEClk- DSI+ D1+ D2+
> >> >> > AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-) Status: D0
> >> >> > NoSoftRst- PME-Enable- DSel=0 DScale=0 PME- Capabilities:
> >> >> > [90] Vital Product Data Product Name: " End
> >> >> >         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable-
> >> >> > 64bit+ Address: 0000000000000000  Data: 0000
> >> >> >         Capabilities: [100 v1] Advanced Error Reporting
> >> >> >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO-
> >> >> > CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> >> >> > UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> >> >> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol- UESvrt:      DLP+
> >> >> > SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
> >> >> > ECRC- UnsupReq- ACSViol- CESta:  RxErr- BadTLP- BadDLLP-
> >> >> > Rollover- Timeout- NonFatalErr- CEMsk:  RxErr- BadTLP-
> >> >> > BadDLLP- Rollover- Timeout- NonFatalErr- AERCap: First Error
> >> >> > Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn- Capabilities:
> >> >> > [200 v1] Virtual Channel Caps:    LPEVC=0 RefClk=100ns
> >> >> > PATEntryBits=1 Arb:        Fixed+ WRR32+ WRR64+ WRR128-
> >> >> > Ctrl:   ArbSelect=WRR64 Status: InProgress- Port Arbitration
> >> >> > Table [240] <?> VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
> >> >> > RejSnoopTrans- Arb:     Fixed- WRR32- WRR64- WRR128- TWRR128-
> >> >> > WRR256- Ctrl:   Enable+ ID=0 ArbSelect=Fixed
> >> >> > TC/VC=01 Status:        NegoPending- InProgress-
> >> >> >         Kernel driver in use: cx23885
> >> >> >         Kernel modules: cx23885
> >> >> > [...]
> >> >> >
> >> >> > Regards,
> >> >> > Hendrik
> >> >> >
> >> >> > On Sun, 24 Apr 2016 08:34:14 +0300
> >> >> > Olli Salonen <olli.salonen@iki.fi> wrote:  
> >> >> >> Hi Hendrik,
> >> >> >>
> >> >> >> Can you take a high resolution picture of the device? I can
> >> >> >> build you a test driver if you're able to try it out for me?
> >> >> >>
> >> >> >> I believe it's CX23885, M88DS3103 and M88TS2022, but it
> >> >> >> could be good if you can check.
> >> >> >>
> >> >> >> Cheers,
> >> >> >> -olli
> >> >> >>
> >> >> >> On 23 April 2016 at 15:51, Hendrik Oenings
> >> >> >> <debian@oenings.de> wrote:  
> >> >> >> > Hi all,
> >> >> >> >
> >> >> >> > I'm trying to use the dvb-s2 pci-express card "TeVii S472"
> >> >> >> > with the linux kernel. I haven't found a usable driver
> >> >> >> > until now, but I've seen that the previous cards (S471,
> >> >> >> > S470) are supported by the current linux kernel. The
> >> >> >> > driver from the manufacturer's site is more than one year
> >> >> >> > old and doesn't compile with current kernels.
> >> >> >> >
> >> >> >> > I'd be grateful for any information or ideas.
> >> >> >> >
> >> >> >> > Regards,
> >> >> >> > Hendrik
> >> >> >> > --
> >> >> >> > To unsubscribe from this list: send the line "unsubscribe
> >> >> >> > linux-media" in the body of a message to
> >> >> >> > majordomo@vger.kernel.org More majordomo info at
> >> >> >> > http://vger.kernel.org/majordomo-info.html  
> >> >> >  
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe
> >> > linux-media" in the body of a message to
> >> > majordomo@vger.kernel.org More majordomo info at
> >> > http://vger.kernel.org/majordomo-info.html  
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-media" in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at
> >> http://vger.kernel.org/majordomo-info.html  
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-media" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html  
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

