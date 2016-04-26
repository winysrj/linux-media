Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:35004 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbcDZGD0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 02:03:26 -0400
Received: by mail-qg0-f48.google.com with SMTP id f74so1599311qge.2
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 23:03:26 -0700 (PDT)
Received: from mail-qg0-f48.google.com (mail-qg0-f48.google.com. [209.85.192.48])
        by smtp.gmail.com with ESMTPSA id 72sm8378669qkc.18.2016.04.25.23.03.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Apr 2016 23:03:25 -0700 (PDT)
Received: by mail-qg0-f48.google.com with SMTP id f74so1599248qge.2
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 23:03:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160425181423.5a5876c1@spock>
References: <20160423125131.GB1122@spock.oenings.local>
	<CAAZRmGzG72hm_sd9qpYx7Mo28oSxBgRghPRt42OPN-3xnj94uw@mail.gmail.com>
	<20160424180038.03776e74@spock>
	<CAAZRmGyDJJPRgNKD25DL=a1fyYX3rP0-tcbxcP+7AJv5wVz_Uw@mail.gmail.com>
	<20160425181423.5a5876c1@spock>
Date: Tue, 26 Apr 2016 09:03:24 +0300
Message-ID: <CAAZRmGyDAhE6caz+wmJySQ-xjESiE5-=h9YCE7VamHxXNV8sBQ@mail.gmail.com>
Subject: Re: dvb-s2 card "TeVii S472" (cx23885)
From: Olli Salonen <olli.salonen@iki.fi>
To: Hendrik Oenings <debian@oenings.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mailinglist linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hendrik, Hans,

My media_tree Hendrik is pulling from Github is just a rather recent
copy of the media_tree master branch on git.linuxtv.org (it's missing
like the last 10 patches that have been added within the last 24
hours) with 2 simple patches on top that should not break anything.

Also, the media_build is recent, since you just cloned it.

Hans, do you know if there are any known issues with the current
media_build/media_tree on certain kernels?

Thanks.

Cheers,
-olli

On 25 April 2016 at 19:14, Hendrik Oenings <debian@oenings.de> wrote:
> Hi Olli,
>
> I've tested the driver, it compiles well and I've installed it on my
> system.
> But there's a problem: Everytime I try to load the driver (exact: the
> module cx23885), modprobe (or insmod) is giving me the following:
> # modprobe cx23885
> modprobe: ERROR: could not insert 'cx23885': Exec format error
>
> I've also tried to compile it with the current 4.6er kernel, but it
> stays the same.
> $ uname -r
> 4.6.0-rc5
>
> I've also tried to recompile the driver, but it didn't help.
>
> Maybe it is important to mention that some patches fail at the
> beginning of the build process (pr_fmt, debug).
>
> The installed module seems to be correct file format (my arch is
> x86_64):
> $ file \
>  /lib/modules/4.6.0-rc5/kernel/drivers/media/pci/cx23885/cx23885.ko
>
> /lib/modules/4.6.0-rc5/kernel/drivers/media/pci/cx23885/cx23885.ko: ELF
> 64-bit LSB relocatable, x86-64, version 1 (SYSV),
> BuildID[sha1]=07a3f2f2fe383ab691b0022568dcd4d8315dc4b8, not stripped
>
> Regards,
> Hendrik
>
> On Mo, 25 Apr 2016 11:56:37 +0300, Olli Salonen <olli.salonen@iki.fi>
> wrote:
>
>> Hello Hendrik,
>>
>> I've created an initial version of the driver.
>> https://github.com/trsqr/media_tree/commit/b59f25b18bbe84e009618eefeaf646f5939bdd53
>>
>> To build, do the following:
>>
>> git clone git://linuxtv.org/media_build.git
>> git clone --depth=1 https://github.com/trsqr/media_tree.git -b
>> s472 ./media cd media_build
>> make dir DIR=../media
>> make distclean
>> make
>>
>> To install after a successful build:
>>
>> sudo make install
>>
>> Download also the following firmware and place it in /lib/firmware:
>> http://palosaari.fi/linux/v4l-dvb/firmware/M88DS3103/3.B/
>>
>> The thing is, I had to guess the following parameters in
>> drivers/media/pci/cx23885/cx23885-dvb.c file:
>>
>> +static const struct m88ds3103_config tevii_s472_m88ds3103_config = {
>> +       .i2c_addr = 0x68,
>> +       .clock = 27000000,
>> +       .i2c_wr_max = 33,
>> +       .clock_out = 0,
>> +       .ts_mode = M88DS3103_TS_PARALLEL,
>> +       .ts_clk = 16000,
>> +       .ts_clk_pol = 0,
>> +       .lnb_en_pol = 0,
>> +       .lnb_hv_pol = 1,
>> +       .agc = 0x99,
>> +};
>>
>> If the driver does not work (it loads and appears to tune, but does
>> not find channels), try altering ts_clk_pol, lnb_en_pol and
>> lnb_hv_pol. The possible values are 1 and 0 so there should not be
>> that many iterations needed.. Current values are based on best guess.
>>
>> Cheers,
>> -olli
>>
>>
>>
>> On 24 April 2016 at 19:00, Hendrik Oenings <debian@oenings.de> wrote:
>> > Hi Olli,
>> >
>> > I'm glad that there is someone trying to help me and of course I'm
>> > able to test a driver.
>> >
>> > Because of the attached photos, I think it is better not to send
>> > this mail to the mailing list.
>> >
>> > cx23885, m88ds3103 and m88ts2022 are the values I also think they're
>> > correct. cx23885 is also mentioned by lspci, the other values I've
>> > also seen often while searching for a solution.
>> >
>> > Here is also the full output of lspci concerning the tv card which
>> > is probably helpful.
>> > # lspci -vv
>> > [...]
>> > 03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
>> > PCI Video and Audio Decoder (rev 04) Subsystem: Device d472:9022
>> >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> > ParErr- Stepping- SERR- FastB2B- DisINTx- Status: Cap+ 66MHz- UDF-
>> > FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
>> > <PERR- INTx- Latency: 0, Cache Line Size: 64 bytes Interrupt: pin A
>> > routed to IRQ 19 Region 0: Memory at f7c00000 (64-bit,
>> > non-prefetchable) [size=2M] Capabilities: [40] Express (v1)
>> > Endpoint, MSI 00 DevCap: MaxPayload 128 bytes, PhantFunc 0,
>> > Latency L0s <64ns, L1 <1us ExtTag- AttnBtn- AttnInd- PwrInd- RBE-
>> > FLReset- DevCtl:        Report errors: Correctable- Non-Fatal-
>> > Fatal- Unsupported- RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>> >                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>> >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>> > AuxPwr- TransPend- LnkCap:      Port #0, Speed 2.5GT/s, Width x1,
>> > ASPM L0s L1, Exit Latency L0s <2us, L1 <4us ClockPM- Surprise-
>> > LLActRep- BwNot- ASPMOptComp- LnkCtl:   ASPM Disabled; RCB 64
>> > bytes Disabled- CommClk+ ExtSynch- ClockPM- AutWidDis- BWInt-
>> > AutBWInt- LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
>> > SlotClk+ DLActive- BWMgmt- ABWMgmt- Capabilities: [80] Power
>> > Management version 2 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
>> > PME(D0+,D1+,D2+,D3hot+,D3cold-) Status: D0 NoSoftRst- PME-Enable-
>> > DSel=0 DScale=0 PME- Capabilities: [90] Vital Product Data
>> >                 Product Name: "
>> >                 End
>> >         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>> >                 Address: 0000000000000000  Data: 0000
>> >         Capabilities: [100 v1] Advanced Error Reporting
>> >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
>> > UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol- UEMsk:        DLP-
>> > SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
>> > UnsupReq- ACSViol- UESvrt:      DLP+ SDES- TLP- FCP+ CmpltTO-
>> > CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>> > CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>> > CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>> > AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
>> > Capabilities: [200 v1] Virtual Channel Caps:    LPEVC=0
>> > RefClk=100ns PATEntryBits=1 Arb:        Fixed+ WRR32+ WRR64+ WRR128-
>> > Ctrl:   ArbSelect=WRR64 Status: InProgress-
>> >                 Port Arbitration Table [240] <?>
>> >                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
>> > RejSnoopTrans- Arb:     Fixed- WRR32- WRR64- WRR128- TWRR128-
>> > WRR256- Ctrl:   Enable+ ID=0 ArbSelect=Fixed
>> > TC/VC=01 Status:        NegoPending- InProgress-
>> >         Kernel driver in use: cx23885
>> >         Kernel modules: cx23885
>> > [...]
>> >
>> > Regards,
>> > Hendrik
>> >
>> > On Sun, 24 Apr 2016 08:34:14 +0300
>> > Olli Salonen <olli.salonen@iki.fi> wrote:
>> >> Hi Hendrik,
>> >>
>> >> Can you take a high resolution picture of the device? I can build
>> >> you a test driver if you're able to try it out for me?
>> >>
>> >> I believe it's CX23885, M88DS3103 and M88TS2022, but it could be
>> >> good if you can check.
>> >>
>> >> Cheers,
>> >> -olli
>> >>
>> >> On 23 April 2016 at 15:51, Hendrik Oenings <debian@oenings.de>
>> >> wrote:
>> >> > Hi all,
>> >> >
>> >> > I'm trying to use the dvb-s2 pci-express card "TeVii S472" with
>> >> > the linux kernel. I haven't found a usable driver until now, but
>> >> > I've seen that the previous cards (S471, S470) are supported by
>> >> > the current linux kernel. The driver from the manufacturer's
>> >> > site is more than one year old and doesn't compile with current
>> >> > kernels.
>> >> >
>> >> > I'd be grateful for any information or ideas.
>> >> >
>> >> > Regards,
>> >> > Hendrik
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe
>> >> > linux-media" in the body of a message to
>> >> > majordomo@vger.kernel.org More majordomo info at
>> >> > http://vger.kernel.org/majordomo-info.html
>> >
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
