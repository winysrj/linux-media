Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4M1KfuX008112
	for <video4linux-list@redhat.com>; Wed, 21 May 2008 21:20:41 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4M1K300016221
	for <video4linux-list@redhat.com>; Wed, 21 May 2008 21:20:22 -0400
Received: by wa-out-1112.google.com with SMTP id j32so3036154waf.7
	for <video4linux-list@redhat.com>; Wed, 21 May 2008 18:20:03 -0700 (PDT)
Message-ID: <a93d57c00805211820k5e1b4920ga548e1d541f20b3e@mail.gmail.com>
Date: Wed, 21 May 2008 21:20:02 -0400
From: "Ryan Churches" <ryan.churches@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: scrambled video with bttv driver and bt848 (card=98)
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

I built the bttv driver as a module, and modprobed it with and without
card=98...

http://www.ubintel.com/files/nph-zms.jpeg  <---this is a still shot of
the video I get as seen from ZoneMinder.  In case you can't tell what
you are looking at, the bottom and top of the image are transposed
across the black horizontal bar going through the shot.  That bar
moves as the video is played, giving it the appearance of an 8mm movie
film which has gone off track.  The others are worse than that.  I
have 12 non-identical cameras which all do that to varying degrees.

If i cat the video to a file and try to play it in VLC, i get no
video, and the output of VLC says:

[mp3 @ 0x2aaabda32340]Could not find codec parameters (Audio: mp1, 448 kb/s)
[00000308] ffmpeg demuxer error: av_find_stream_info failed
[00000308] ps demuxer error: cannot peek
[00000304] main input error: no suitable demux module for
`/:///home/brian/Desktop/test.mpg'
[00000232] main playlist: nothing to play
[00000232] main playlist: stopping playback



When I load the module, I got one of these in my dmeg for every PVR chip:

isabel ~ # modprobe bttv
card=98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98 (i have 2x8chip
cards so i pass 16 '98's)
isabel ~ # dmesg |tail -n 16

bttv: Bt8xx card found (15).
bttv15: Bt878 (rev 17) at 0000:05:0b.0, irq: 21, latency: 32, mmio: 0xfdbf1000
bttv15: subsystem: 1836:1540 (UNKNOWN)
please mail id, board name and the correct card= insmod option to
video4linux-list@redhat.com
bttv15: using: ProVideo PV150 [card=98,insmod option]
bttv15: gpio: en=00000000, out=00000000 in=00ffffff [init]
i2c-adapter i2c-15: adapter [bt878 #15 [sw]] registered
i2c-dev: adapter [bt878 #15 [sw]] registered as minor 15
i2c-adapter i2c-15: found normal entry for adapter 15, addr 0x50
i2c-adapter i2c-15: master_xfer[0] W, addr=0x50, len=0
i2c-adapter i2c-15: master_xfer[0] W, addr=0x50, len=0
i2c-adapter i2c-15: client [tveeprom] registered with bus id 15-0050
bttv15: tuner absent
bttv15: registered device video16
bttv15: registered device vbi15
bttv15: PLL: 28636363 => 35468950 . ok



If i dont pass the card=98 option and I load the module, it autodetects card=0

lspci says:

isabel ~ # lspci -vv|grep -A 12 -m 1 Brooktree
04:04.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
        Subsystem: Credence Systems Corporation Device 1540
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at fdcff000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: bttv
        Kernel modules: bttv


Interestingly, only ZoneMinder gives me any playable "video" in the
form of mjpeg, while neither mplayer nor VLC can play the files i make
from catting /dev/videoX.  Not sure how exactly it does it, but in ZM
Ive tried PAL vs NTSC, RGB24 vs Everything Else, and standard monitor
resolutions like 640x480, 320x240. etc.  Nothing seems to stabilize
the video.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
