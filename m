Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAB9CVcE004691
	for <video4linux-list@redhat.com>; Wed, 11 Nov 2009 04:12:31 -0500
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAB9CSrp023617
	for <video4linux-list@redhat.com>; Wed, 11 Nov 2009 04:12:28 -0500
Received: by bwz6 with SMTP id 6so817717bwz.11
	for <video4linux-list@redhat.com>; Wed, 11 Nov 2009 01:12:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <921ad39e0911101048i31535b25l88aa4d158ff7dd7f@mail.gmail.com>
References: <921ad39e0808031338v506fd1dcta49ded269bc82a7e@mail.gmail.com>
	<921ad39e0911101048i31535b25l88aa4d158ff7dd7f@mail.gmail.com>
Date: Wed, 11 Nov 2009 09:12:27 +0000
Message-ID: <921ad39e0911110112m21472a55ud325935218a89e9e@mail.gmail.com>
From: Roman Gaufman <hackeron@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: cx88_alsa - getting loud white noise with capture card.
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

It sounds like I've not tuned the channel, but there is no channel -
it's a capture card with 8 inputs. When I try to change channels with
mplayer 'h' key, the sound changes slightly and I can hear it turn
sound off and turn it back on.

Is there a specific frequency I need to set? - I tried all channels
available in mplayer and all I hear is loud static/white noise.

Anyone?

2009/11/10 Roman Gaufman <roman@xanview.com>:
> Tried this again on 2.6.31-14 and still not able to get audio working.
> Using this command:
>
> mplayer -vo null tv:// -tv
> driver=v4l2:device=/dev/video1:alsa:adevice=hw.2,0:amode=1:audiorate=48000:forceaudio:volume=100:immediatemode=0:norm=PAL-BG:fps=25:input=0
>
> Video works but getting nothing but loud static on audio. Please help :(
>
>
> 2008/8/3 Roman Gaufman <hackeron@gmail.com>:
>> Hi,
>>
>> I have an 8 audio + 8 video PCI-Express Conexant 23881 DVR Card I'm
>> trying to get working in Linux.
>>
>> The video channels all work flawlessly and the audio is recognized,
>> but I just get very loud white noise no matter what I try.
>>
>> I tried the following commands and been googling for days to no avail:
>>
>> for i in 0 1 2 3 4 5 6 7; do /usr/bin/mencoder tv:// -tv
>> driver=v4l2:device=/dev/video$i:alsa:adevice=hw.$i,0:amode=0:audiorate=32000:volume=100:immediatemode=0:norm=PAL-DK:input=0:width=720:height=576:outfmt=yuy2
>> -oac mp3lame -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=5000 -frames
>> 300 -o test$i.avi &  done
>>
>> for i in 0 1 2 3 4 5 6 7; do arecord -d 10 -D hw:$i,0 -c 2 -f S16_LE
>> --period-size=65536 --buffer-size=524288 -r 48000 test$i.wav & done
>>
>> I had to boot the kernel with acpi=off irqpoll for video not to give
>> me input/output errors, but audio still gives me loud white noise.
>>
>> The only error messages I see are:
>>
>> [ 3758.546252] cx88[4]/1: IRQ loop detected, disabling interrupts
>> [ 3758.546323] cx88[4]: irq aud [0x1000] dn_sync*
>> [ 3758.546329] cx88[4]: irq aud [0x1001] dn_risci1* dn_sync*
>>
>> My bios Plug & Play OS setting is set to no.
>>
>> This is what arecord -l returns:
>>
>> **** List of CAPTURE Hardware Devices ****
>> card 0: CX8801_1 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
>>  Subdevices: 1/1
>>  Subdevice #0: subdevice #0
>> card 1: CX8801 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
>>  Subdevices: 1/1
>>  Subdevice #0: subdevice #0
>> card 2: CX8801_2 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
>>  Subdevices: 1/1
>>  Subdevice #0: subdevice #0
>> card 3: CX8801_3 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
>>  Subdevices: 1/1
>>  Subdevice #0: subdevice #0
>> card 4: CX8801_4 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
>>  Subdevices: 1/1
>>  Subdevice #0: subdevice #0
>> card 5: CX8801_5 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
>>  Subdevices: 1/1
>>  Subdevice #0: subdevice #0
>> card 6: CX8801_6 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
>>  Subdevices: 1/1
>>  Subdevice #0: subdevice #0
>> card 7: CX8801_7 [Conexant CX8801], device 0: CX88 Digital [CX88 Digital]
>>  Subdevices: 1/1
>>  Subdevice #0: subdevice #0
>>
>> This is what lspci -v returns (both with and without -n)
>>
>> - [ ] 04:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI
>>      Video and Audio Decoder (rev 05)
>>        Subsystem: Unknown device c180:c980
>>        Flags: bus master, medium devsel, latency 64, IRQ 19
>>        Memory at d0000000 (32-bit, non-prefetchable) [size=16M]
>>        Capabilities: [44] Vital Product Data
>>        Capabilities: [4c] Power Management version 2
>> - [ ] 04:07.0 0400: 14f1:8800 (rev 05)
>>        Subsystem: c180:c980
>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
>>      ParErr- Stepping- SERR- FastB2B-
>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>>      <TAbort- <MAbort- >SERR- <PERR-
>>        Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
>>        Interrupt: pin A routed to IRQ 19
>>        Region 0: Memory at d0000000 (32-bit, non-prefetchable)
>>      [size=16M]
>>        Capabilities: [44] Vital Product Data
>>        Capabilities: [4c] Power Management version 2
>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>      PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>
>> - [ ] 04:07.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video
>>      and Audio Decoder [Audio Port] (rev 05)
>>        Subsystem: Unknown device c180:c980
>>        Flags: bus master, medium devsel, latency 64, IRQ 19
>>        Memory at d1000000 (32-bit, non-prefetchable) [size=16M]
>>        Capabilities: [4c] Power Management version 2
>> - [ ] 04:07.1 0480: 14f1:8801 (rev 05)
>>        Subsystem: c180:c980
>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
>>      ParErr- Stepping- SERR- FastB2B-
>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>>      <TAbort- <MAbort- >SERR- <PERR-
>>        Latency: 64 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
>>        Interrupt: pin A routed to IRQ 19
>>        Region 0: Memory at d1000000 (32-bit, non-prefetchable)
>>      [size=16M]
>>        Capabilities: [4c] Power Management version 2
>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>      PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>
>> Any ideas at all?
>>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
