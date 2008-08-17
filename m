Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HDRpTD025651
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 09:27:51 -0400
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.180])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HDRcUN020354
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 09:27:38 -0400
Received: by ik-out-1112.google.com with SMTP id c30so2726412ika.3
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 06:27:38 -0700 (PDT)
Message-ID: <9e27f5bf0808170627n556116d5rb0af4771c525af88@mail.gmail.com>
Date: Sun, 17 Aug 2008 15:27:38 +0200
From: "litlle girl" <little.linux.girl@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Kworld mpeg tv station / PCI [KW-TV878-FBKM]
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

Hi guys,
please help,
i try to make my tv card working on linux.
My tv card is: Kworld mpeg tv station / PCI [KW-TV878-FBKM]
Conexant Fusion 878A
My linux is: Kubuntu 8.10.

My problem is: when module bttv is loaded tv card turns audio on,
then i run tvtime audio is from tv channel,
and when i turn off tvtime audio remains,
mute isnt working
this is my /etc/modprobe.d/bttv
options bttv tuner=5 radio=1 pll=1 gpiomask=0x008007 audiomux=0,3,3,3,3

when i put: audiomux=3,3,3,3,3
when module bttv is loaded tv card turns audio on,
then i run tvtime, audio is muted [when i mute audio in tvtime - audio is
unmuted],
and when i turn off tvtime always turn on and audio remains,

What i do wrong??? Why Audio is always on, until i rmmod bttv??
i was testing
audiomux=0x000000,0x000001,0x000000,0x000000,0x000003
too.
Why Audiomu acceps only 5 values? At Sound-Faq there are 6 values.

Regards
LLG


--------------------------------------------------------------------------------------------
this car runs ok on xp,
this is my snif from xp:
### BtSpy Report ###

General information:
 Name:Kworld bt878
 Chip: Bt878 , Rev: 0x00
 Subsystem: 0x00000000
 Vendor: Gammagraphx, Inc.
 Values to MUTE audio:
  Mute_GPOE  : 0x008007
  Mute_GPDATA: 0x000003
 Has TV Tuner: Yes
  TV_Mux   : 2
  TV_GPOE  : 0x008007
  TV_GPDATA: 0x000000
 Number of Composite Ins: 1
  Composite in #1
   Composite1_Mux   : 3
   Composite1_GPOE  : 0x008007
   Composite1_GPDATA: 0x000000
 Has SVideo: Yes
  SVideo_Mux   : 1
  SVideo_GPOE  : 0x008007
  SVideo_GPDATA: 0x000000
 Has Radio: Yes
  Radio_GPOE  : 0x008007
  Radio_GPDATA: 0x000001


Add here all the comments you want!
        If your card can decode Stereo TV , and
your card does NOT use one of the following
chips, you will have to "peek" the right
GPDATA and GPOE values to enable Stereo and
SAP audio. The driver already supports the
DPL3518, MSP34xx, PT2254, TDA7432, TDA8425,
TDA9840, TDA9850, TDA9855, TDA9873, TDA9874,
TDA9875, TEA6300 and TEA6420 and does not require
extra information to drive them!

If you are able to get your card working using
this program , please , mail me this file (with
any extra comments you would like to add) to:
ejtagle@tutopia.com , so I can add native support
to your card in the next driver release!

--------------------------------------------------------------------------------------------

lspci -vv
00:0b.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at ec000000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0b.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture
(rev 11)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at ec001000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

--------------------------------------------------------------------------------------------

[  230.747301] bttv0: unloading
[  238.612345] bttv: driver version 0.9.17 loaded
[  238.612354] bttv: using 8 buffers with 2080k (520 pages) each for capture
[  238.612905] bttv: Bt8xx card found (0).
[  238.612923] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32,
mmio: 0xec000000
[  238.613257] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[  238.613262] bttv0: gpio config override: mask=0x8007, mux=0x3,0x3,0x3,0x3
[  238.613301] bttv0: gpio: en=00000000, out=00000000 in=003fffff [init]
[  238.617865] All bytes are equal. It is not a TEA5767
[  238.617872] tuner 1-0060: chip found @ 0xc0 (bt878 #0 [sw])
[  238.633870] tveeprom 1-0050: Huh, no eeprom present (err=-121)?
[  238.633881] bttv0: tuner type=5
[  238.634342] tuner-simple 1-0060: type set to 5 (Philips PAL_BG (FI1216
and compatibles))
[  238.634348] tuner 1-0060: type set to Philips PAL_BG (FI1
[  238.634694] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[  238.635300] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[  238.635975] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[  238.651012] bttv0: registered device video0
[  238.651344] bttv0: registered device vbi0
[  238.651524] bttv0: registered device radio0
[  238.651700] bttv0: PLL: 28636363 => 35468950 . ok
[  238.670348] bt878: AUDIO driver version 0.0.0 loaded
[  238.670404] bt878: Bt878 AUDIO function found (0).
[  238.670423] ACPI: PCI Interrupt 0000:00:0b.1[A] -> GSI 19 (level, low) ->
IRQ 19
[  238.670430] bt878_probe: card id=[0x0], Unknown card.
[  238.670432] Exiting..
[  238.670436] ACPI: PCI interrupt for device 0000:00:0b.1 disabled
[  238.670444] bt878: probe of 0000:00:0b.1 failed with error -22
[  314.583054] bttv0: unloading
[  318.080455] bttv: driver version 0.9.17 loaded
[  318.080464] bttv: using 8 buffers with 2080k (520 pages) each for capture
[  318.081013] bttv: Bt8xx card found (0).
[  318.081033] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32,
mmio: 0xec000000
[  318.081409] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[  318.081414] bttv0: gpio config override: mask=0x8003, mux=0x0,0x3,0x3,0x3
[  318.081458] bttv0: gpio: en=00000000, out=00000000 in=003fffff [init]
[  318.088073] All bytes are equal. It is not a TEA5767
[  318.088084] tuner 1-0060: chip found @ 0xc0 (bt878 #0 [sw])
[  318.100242] tveeprom 1-0050: Huh, no eeprom present (err=-121)?
[  318.100253] bttv0: tuner type=5
[  318.100707] tuner-simple 1-0060: type set to 5 (Philips PAL_BG (FI1216
and compatibles))
[  318.100713] tuner 1-0060: type set to Philips PAL_BG (FI1
[  318.101052] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[  318.101636] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[  318.105850] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[  318.118103] bttv0: registered device video0
[  318.118442] bttv0: registered device vbi0
[  318.118625] bttv0: registered device radio0
[  318.118802] bttv0: PLL: 28636363 => 35468950 . ok
[  330.146931] bt878: AUDIO driver version 0.0.0 loaded
[  330.147334] bt878: Bt878 AUDIO function found (0).
[  330.147354] ACPI: PCI Interrupt 0000:00:0b.1[A] -> GSI 19 (level, low) ->
IRQ 19
[  330.147362] bt878_probe: card id=[0x0], Unknown card.
[  330.147363] Exiting..
[  330.147367] ACPI: PCI interrupt for device 0000:00:0b.1 disabled
[  330.148097] bt878: probe of 0000:00:0b.1 failed with error -22
[  361.965990] bttv0: unloading
[  377.148325] bttv: driver version 0.9.17 loaded
[  377.148334] bttv: using 8 buffers with 2080k (520 pages) each for capture
[  377.148878] bttv: Bt8xx card found (0).
[  377.148897] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32,
mmio: 0xec000000
[  377.149226] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[  377.149231] bttv0: gpio config override: mask=0x8005, mux=0x0,0x3,0x3,0x3
[  377.149271] bttv0: gpio: en=00000000, out=00000000 in=003fffff [init]
[  377.153726] All bytes are equal. It is not a TEA5767
[  377.153732] tuner 1-0060: chip found @ 0xc0 (bt878 #0 [sw])
[  377.167665] tveeprom 1-0050: Huh, no eeprom present (err=-121)?
[  377.167676] bttv0: tuner type=5
[  377.168256] tuner-simple 1-0060: type set to 5 (Philips PAL_BG (FI1216
and compatibles))
[  377.168262] tuner 1-0060: type set to Philips PAL_BG (FI1
[  377.169440] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[  377.170386] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[  377.171291] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[  377.184888] bttv0: registered device video0
[  377.185228] bttv0: registered device vbi0
[  377.185408] bttv0: registered device radio0
[  377.185587] bttv0: PLL: 28636363 => 35468950 . ok
[  387.438264] bt878: AUDIO driver version 0.0.0 loaded
[  387.438658] bt878: Bt878 AUDIO function found (0).
[  387.438678] ACPI: PCI Interrupt 0000:00:0b.1[A] -> GSI 19 (level, low) ->
IRQ 19
[  387.438686] bt878_probe: card id=[0x0], Unknown card.
[  387.438687] Exiting..
[  387.438691] ACPI: PCI interrupt for device 0000:00:0b.1 disabled
[  387.439381] bt878: probe of 0000:00:0b.1 failed with error -22
[  407.393352] bttv0: unloading
[  428.936140] bttv: Unknown parameter `bt878'
[  432.501026] bttv: driver version 0.9.17 loaded
[  432.501035] bttv: using 8 buffers with 2080k (520 pages) each for capture
[  432.501598] bttv: Bt8xx card found (0).
[  432.501617] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32,
mmio: 0xec000000
[  432.501952] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[  432.501956] bttv0: gpio config override: mask=0x8006, mux=0x0,0x3,0x3,0x3
[  432.501996] bttv0: gpio: en=00000000, out=00000000 in=003fffff [init]
[  432.506515] All bytes are equal. It is not a TEA5767
[  432.506521] tuner 1-0060: chip found @ 0xc0 (bt878 #0 [sw])
[  432.520696] tveeprom 1-0050: Huh, no eeprom present (err=-121)?
[  432.520706] bttv0: tuner type=5
[  432.521765] tuner-simple 1-0060: type set to 5 (Philips PAL_BG (FI1216
and compatibles))
[  432.521774] tuner 1-0060: type set to Philips PAL_BG (FI1
[  432.522207] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[  432.523811] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[  432.525050] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[  432.538845] bttv0: registered device video0
[  432.539199] bttv0: registered device vbi0
[  432.539379] bttv0: registered device radio0
[  432.539554] bttv0: PLL: 28636363 => 35468950 . ok
[  435.129046] bt878: AUDIO driver version 0.0.0 loaded
[  435.129439] bt878: Bt878 AUDIO function found (0).
[  435.129459] ACPI: PCI Interrupt 0000:00:0b.1[A] -> GSI 19 (level, low) ->
IRQ 19
[  435.129467] bt878_probe: card id=[0x0], Unknown card.
[  435.129469] Exiting..
[  435.129473] ACPI: PCI interrupt for device 0000:00:0b.1 disabled
[  435.130120] bt878: probe of 0000:00:0b.1 failed with error -22
[  449.992705] bttv0: unloading
[  470.501313] bttv: driver version 0.9.17 loaded
[  470.501322] bttv: using 8 buffers with 2080k (520 pages) each for capture
[  470.501863] bttv: Bt8xx card found (0).
[  470.501882] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32,
mmio: 0xec000000
[  470.502212] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[  470.502217] bttv0: gpio config override: mask=0x8001, mux=0x0,0x3,0x3,0x3
[  470.502257] bttv0: gpio: en=00000000, out=00000000 in=003fffff [init]
[  470.506713] All bytes are equal. It is not a TEA5767
[  470.506719] tuner 1-0060: chip found @ 0xc0 (bt878 #0 [sw])
[  470.520910] tveeprom 1-0050: Huh, no eeprom present (err=-121)?
[  470.520921] bttv0: tuner type=5
[  470.521854] tuner-simple 1-0060: type set to 5 (Philips PAL_BG (FI1216
and compatibles))
[  470.521863] tuner 1-0060: type set to Philips PAL_BG (FI1
[  470.522327] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[  470.523922] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[  470.525105] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[  470.539267] bttv0: registered device video0
[  470.539599] bttv0: registered device vbi0
[  470.539978] bttv0: registered device radio0
[  470.540218] bttv0: PLL: 28636363 => 35468950 . ok
[  470.563604] bt878: AUDIO driver version 0.0.0 loaded
[  470.563669] bt878: Bt878 AUDIO function found (0).
[  470.563689] ACPI: PCI Interrupt 0000:00:0b.1[A] -> GSI 19 (level, low) ->
IRQ 19
[  470.563696] bt878_probe: card id=[0x0], Unknown card.
[  470.563698] Exiting..
[  470.563702] ACPI: PCI interrupt for device 0000:00:0b.1 disabled
[  470.563711] bt878: probe of 0000:00:0b.1 failed with error -22
[  485.253612] bttv0: unloading
[  493.269669] bttv: driver version 0.9.17 loaded
[  493.269679] bttv: using 8 buffers with 2080k (520 pages) each for capture
[  493.270218] bttv: Bt8xx card found (0).
[  493.270237] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32,
mmio: 0xec000000
[  493.270571] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[  493.270576] bttv0: gpio config override: mask=0x8007, mux=0x0,0x3,0x3,0x3
[  493.270615] bttv0: gpio: en=00000000, out=00000000 in=003fffff [init]
[  493.275346] All bytes are equal. It is not a TEA5767
[  493.275353] tuner 1-0060: chip found @ 0xc0 (bt878 #0 [sw])
[  493.289066] tveeprom 1-0050: Huh, no eeprom present (err=-121)?
[  493.289077] bttv0: tuner type=5
[  493.290065] tuner-simple 1-0060: type set to 5 (Philips PAL_BG (FI1216
and compatibles))
[  493.290074] tuner 1-0060: type set to Philips PAL_BG (FI1
[  493.290508] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[  493.292420] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[  493.293624] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[  493.307847] bttv0: registered device video0
[  493.308180] bttv0: registered device vbi0
[  493.308360] bttv0: registered device radio0
[  493.308534] bttv0: PLL: 28636363 => 35468950 . ok
[  498.395945] bt878: AUDIO driver version 0.0.0 loaded
[  498.396387] bt878: Bt878 AUDIO function found (0).
[  498.396407] ACPI: PCI Interrupt 0000:00:0b.1[A] -> GSI 19 (level, low) ->
IRQ 19
[  498.396415] bt878_probe: card id=[0x0], Unknown card.
[  498.396417] Exiting..
[  498.396421] ACPI: PCI interrupt for device 0000:00:0b.1 disabled
[  498.397065] bt878: probe of 0000:00:0b.1 failed with error -22
[ 1936.564357] bttv0: unloading
[ 1942.442190] bttv: driver version 0.9.17 loaded
[ 1942.442199] bttv: using 8 buffers with 2080k (520 pages) each for capture
[ 1942.442815] bttv: Bt8xx card found (0).
[ 1942.442834] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32,
mmio: 0xec000000
[ 1942.443313] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[ 1942.443318] bttv0: gpio config override: mask=0x8007, mux=0x3,0x3,0x3,0x3
[ 1942.443358] bttv0: gpio: en=00000000, out=00000000 in=003fffff [init]
[ 1942.449662] All bytes are equal. It is not a TEA5767
[ 1942.449671] tuner 1-0060: chip found @ 0xc0 (bt878 #0 [sw])
[ 1942.463279] tveeprom 1-0050: Huh, no eeprom present (err=-121)?
[ 1942.463290] bttv0: tuner type=5
[ 1942.463810] tuner-simple 1-0060: type set to 5 (Philips PAL_BG (FI1216
and compatibles))
[ 1942.463817] tuner 1-0060: type set to Philips PAL_BG (FI1
[ 1942.464147] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[ 1942.465204] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[ 1942.466099] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[ 1942.481559] bttv0: registered device video0
[ 1942.481893] bttv0: registered device vbi0
[ 1942.482070] bttv0: registered device radio0
[ 1942.482243] bttv0: PLL: 28636363 => 35468950 . ok
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
