Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m73Kci13022413
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 16:38:44 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m73KcXdV030377
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 16:38:34 -0400
Received: by wf-out-1314.google.com with SMTP id 25so1568527wfc.6
	for <video4linux-list@redhat.com>; Sun, 03 Aug 2008 13:38:33 -0700 (PDT)
Message-ID: <921ad39e0808031338v506fd1dcta49ded269bc82a7e@mail.gmail.com>
Date: Sun, 3 Aug 2008 21:38:32 +0100
From: "Roman Gaufman" <hackeron@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: cx88_alsa - getting loud white noise with capture card.
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

Hi,

I have an 8 audio + 8 video PCI-Express Conexant 23881 DVR Card I'm
trying to get working in Linux.

The video channels all work flawlessly and the audio is recognized,
but I just get very loud white noise no matter what I try.

I tried the following commands and been googling for days to no avail:

for i in 0 1 2 3 4 5 6 7; do /usr/bin/mencoder tv:// -tv
driver=v4l2:device=/dev/video$i:alsa:adevice=hw.$i,0:amode=0:audiorate=32000:volume=100:immediatemode=0:norm=PAL-DK:input=0:width=720:height=576:outfmt=yuy2
-oac mp3lame -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=5000 -frames
300 -o test$i.avi &  done

for i in 0 1 2 3 4 5 6 7; do arecord -d 10 -D hw:$i,0 -c 2 -f S16_LE
--period-size=65536 --buffer-size=524288 -r 48000 test$i.wav & done

I had to boot the kernel with acpi=off irqpoll for video not to give
me input/output errors, but audio still gives me loud white noise.

The only error messages I see are:

[ 3758.546252] cx88[4]/1: IRQ loop detected, disabling interrupts
[ 3758.546323] cx88[4]: irq aud [0x1000] dn_sync*
[ 3758.546329] cx88[4]: irq aud [0x1001] dn_risci1* dn_sync*

My bios Plug & Play OS setting is set to no.

This is what arecord -l returns:

**** List of CAPTURE Hardware Devices ****
card 0: CX8801_1 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: CX8801 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 2: CX8801_2 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 3: CX8801_3 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 4: CX8801_4 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 5: CX8801_5 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 6: CX8801_6 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 7: CX8801_7 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

This is what lspci -v returns (both with and without -n)

- [ ] 04:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI
      Video and Audio Decoder (rev 05)
      	Subsystem: Unknown device c180:c980
      	Flags: bus master, medium devsel, latency 64, IRQ 19
      	Memory at d0000000 (32-bit, non-prefetchable) [size=16M]
      	Capabilities: [44] Vital Product Data
      	Capabilities: [4c] Power Management version 2
- [ ] 04:07.0 0400: 14f1:8800 (rev 05)
      	Subsystem: c180:c980
      	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
      ParErr- Stepping- SERR- FastB2B-
      	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
      <TAbort- <MAbort- >SERR- <PERR-
      	Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
      	Interrupt: pin A routed to IRQ 19
      	Region 0: Memory at d0000000 (32-bit, non-prefetchable)
      [size=16M]
      	Capabilities: [44] Vital Product Data
      	Capabilities: [4c] Power Management version 2
      		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
      PME(D0-,D1-,D2-,D3hot-,D3cold-)
      		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

- [ ] 04:07.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video
      and Audio Decoder [Audio Port] (rev 05)
      	Subsystem: Unknown device c180:c980
      	Flags: bus master, medium devsel, latency 64, IRQ 19
      	Memory at d1000000 (32-bit, non-prefetchable) [size=16M]
      	Capabilities: [4c] Power Management version 2
- [ ] 04:07.1 0480: 14f1:8801 (rev 05)
      	Subsystem: c180:c980
      	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
      ParErr- Stepping- SERR- FastB2B-
      	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
      <TAbort- <MAbort- >SERR- <PERR-
      	Latency: 64 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
      	Interrupt: pin A routed to IRQ 19
      	Region 0: Memory at d1000000 (32-bit, non-prefetchable)
      [size=16M]
      	Capabilities: [4c] Power Management version 2
      		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
      PME(D0-,D1-,D2-,D3hot-,D3cold-)
      		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Any ideas at all?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
