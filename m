Return-path: <mchehab@pedra>
Received: from acoma.acyna.com ([72.9.254.68]:54836 "EHLO acoma.acyna.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1EBSkj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 14:40:39 -0400
Message-ID: <4DBEFAA2.7080406@hubstar.net>
Date: Mon, 02 May 2011 19:40:34 +0100
From: linuxtv <linuxtv@hubstar.net>
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-media@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Andi Huber <hobrom@gmx.at>,
	Marlon de Boer <marlon@hyves.nl>,
	Damien Churchill <damoxc@gmail.com>
Subject: Re: cx88 sound does not always work (Re: [PATCH v2.6.38 resend 0/7]
 cx88 deadlock and data races)
References: <20110501091710.GA18263@elie> <4DBD4394.20907@hubstar.net> <20110502081924.GC16077@elie>
In-Reply-To: <20110502081924.GC16077@elie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Card Hauppage HVR-1300
Does it show up - yes
Does it work - yes.

However when testing for audio, either via mythbackend or smplayer
/dev/video1 I get no sound 75% of the time on a first run.

Of that, 75% of the time if I run smplayer /dev/video1 a few times sound
reappears and will stay there until a power off reboot. (Soft reboot
will keep the sound on).
25% of the time I cannot get sound started at all. Either via smplayer,
mplayer, mythbackend or v4lctl changes.

Have I seen this reported ever? I saw something mentioned on a mailing
list dated Aug 2010. But no resolution.

Is it hardware ? I don't believe so, same hardware I have linux Suse
11.1 kernel 2.6.27 with custom built drivers from v4l (July 2009). This
works 100%.

Drivers I was using was the default from the kernel with 11.4 (below). I
then switched to try the v4l media_build repository (plus your patch).
Unfortunately I can't build the 2009 drivers to try that level out (too
much has changed).

Hope the information below is of use.

Drivers used from the default SuSE build and also from the v4l media build.

Linux pvr1 2.6.37.1-1.2-desktop #1 SMP PREEMPT 2011-02-21 10:34:10 +0100
x86_64 x86_64 x86_64 GNU/Linux (SuSE 11.4)


04:01.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (re$
        Subsystem: Hauppauge computer works Inc. WinTV 88x Video [0070:9600]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at e4000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
                Unknown large resource type 04, will not decode more.
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx8800

04:01.1 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] [14f1:88$
        Subsystem: Hauppauge computer works Inc. WinTV 88x Audio [0070:9600]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at e5000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx88_audio


04:01.2 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:880$
        Subsystem: Hauppauge computer works Inc. WinTV 88x MPEG Encoder
[0070:9600]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at e6000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx88-mpeg driver manager



dmesg extract
[    6.341606] tda9887 1-0043: creating new
instance                                                                        

[    6.341607] tda9887 1-0043: tda988[5/6/7]
found                                                                          

[    6.342842] tuner 1-0043: Tuner 74 found with type(s) Radio
TV.                                                          
[    6.346330] tuner 1-0061: Tuner -1 found with type(s) Radio
TV.                                                          
[    6.386123] tveeprom 1-0050: Hauppauge model 96559, rev C5A0, serial#
825267                                             
[    6.386125] tveeprom 1-0050: MAC address is
00:0d:fe:0c:97:b3                                                            

[    6.386127] tveeprom 1-0050: tuner model is Philips FMD1216ME (idx
100, type 63)                                         
[    6.386129] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)         
[    6.386131] tveeprom 1-0050: audio processor is CX882 (idx
33)                                                           
[    6.386133] tveeprom 1-0050: decoder processor is CX882 (idx
25)                                                         
[    6.386134] tveeprom 1-0050: has
radio                                                                                   

[    6.386136] cx88[0]: hauppauge eeprom:
model=96559                                                                       

[    6.407438] tuner-simple 1-0061: creating new
instance                                                                   
[    6.407440] tuner-simple 1-0061: type set to 63 (Philips FMD1216ME
MK3 Hybrid Tuner)                                     
[    6.413602] cx88[0]/1: CX88x/0: ALSA support for cx2388x
boards                                                          
[    6.413710] cx88[0]/2: cx2388x 8802 Driver
Manager                                                                       

[    6.413720] cx88-mpeg driver manager 0000:04:01.2: PCI INT A -> GSI
19 (level, low) -> IRQ 19                            
[    6.413725] cx88[0]/2: found at 0000:04:01.2, rev: 5, irq: 19,
latency: 32, mmio: 0xe6000000                             
[    6.413769] cx8800 0000:04:01.0: PCI INT A -> GSI 19 (level, low) ->
IRQ 19                                              
[    6.413773] cx88[0]/0: found at 0000:04:01.0, rev: 5, irq: 19,
latency: 32, mmio: 0xe4000000                             
[    6.463568] WARNING: You are using an experimental version of the
media stack.                                           
[    6.463569]  As the driver is backported to an older kernel, it
doesn't offer                                            
[    6.463570]  enough quality for its usage in
production.                                                                 

[    6.463571]  Use it with
care.                                                                                           

[    6.463571] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):                              
[    6.463572]  847aae409344e3c2efcc58e0639e659427447388 [media]
lmedm04: get rid of on-stack dma buffers                   
[    6.463573]  d71d07543c9bd2ea6779af91a3dc185bc8710d7c [media] au6610:
get rid of on-stack dma buffer                     
[    6.463573]  036d3f3f98f8b4c513bbe0bc8ccf932e5c8a72b6 [media] ce6230:
get rid of on-stack dma buffer                     
[    6.473441] wm8775 1-001b: chip found @ 0x36
(cx88[0])                                                                   

[    6.479106] cx88/2: cx2388x dvb driver version 0.0.8
loaded                                                              
[    6.479108] cx88/2: registering cx8802 driver, type: dvb access:
shared                                                  
[    6.479110] cx88[0]/2: subsystem: 0070:9600, board: Hauppauge
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]          
[    6.479112] cx88[0]/2: cx2388x based DVB/ATSC
card                                                                       
[    6.479113] cx8802_alloc_frontends() allocating 1
frontend(s)                                                            
[    6.518120] tuner-simple 1-0061: attaching existing
instance                                                             
[    6.518123] tuner-simple 1-0061: type set to 63 (Philips FMD1216ME
MK3 Hybrid Tuner)                                     
[    6.521942] DVB: registering new adapter
(cx88[0])                                                                       

[    6.521944] DVB: registering adapter 0 frontend 0 (Conexant CX22702
DVB-T)...                                            
[    6.544641] cx88[0]/0: registered device video0
[v4l2]                                                                   
[    6.544665] cx88[0]/0: registered device
vbi0                                                                            

[    6.544686] cx88[0]/0: registered device
radio0                                                                          

[    6.667451] cx2388x blackbird driver version 0.0.8
loaded                                                                
[    6.667453] cx88/2: registering cx8802 driver, type: blackbird
access: shared                                            
[    6.667456] cx88[0]/2: subsystem: 0070:9600, board: Hauppauge
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]          
[    6.667458] cx88[0]/2: cx23416 based mpeg encoder (blackbird
reference design)                                           
[    6.667678] cx88[0]/2-bb: Firmware and/or mailbox pointer not
initialized or corrupted                                   
[    9.436018] cx88[0]/2-bb: Firmware upload
successful.                                                                    

[    9.439795] cx88[0]/2-bb: Firmware version is
0x02060039                                                                 
[    9.446678] cx88[0]/2: registered device video1 [mpeg]


On 02/05/11 09:19, Jonathan Nieder wrote:
> Hi,
>
> linuxtv wrote:
>
>   
>> FYI I too experienced the problem of hanging and used the patch dated
>> 6th April to get it working.
>> However I do have the problem that sound does not always work/come on.
>> Once it is started it stays, getting it started is not reliable.
>>     
> Could you give details?  What card do you use?  Does it show up in
> lspci -vvnn output (and if so, could you show us)?  What kernel
> version?  Could you attach your .config and dmesg?  Was this reported
> on bugzilla before?  How does sound not working manifest itself?  How
> do you go about getting it to work?
>
> See the REPORTING-BUGS file for hints.
>
> Thanks and hope that helps,
> Jonathan
>   

