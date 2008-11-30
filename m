Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAUJtcq1021059
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 14:55:38 -0500
Received: from nlpi025.prodigy.net (nlpi025.sbcis.sbc.com [207.115.36.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAUJtOnp008126
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 14:55:24 -0500
Message-ID: <4932EFA4.1060804@xnet.com>
Date: Sun, 30 Nov 2008 13:55:16 -0600
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: Bill Pringlemeir <bpringle@sympatico.ca>
References: <87fxlff09v.fsf@sympatico.ca> <87fxl9m0lh.fsf@sympatico.ca>
In-Reply-To: <87fxl9m0lh.fsf@sympatico.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: KWorld ATSC 110 and NTSC [was: 2.6.25+ and KWorld ATSC 110
	inputs]
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



Bill Pringlemeir wrote:
> I have experimented with this a bit further.  Here are some of my
> observations,
> 
> I switch the antenna feed between top and bottom inputs with no effect
> on getting the NTSC signal.
> 
> Loading with a 2.6.24 (non-SMP) kernel and rebooting will allow the
> NTSC signals to be found by tvtime and mplayer.  Running mplayer with
> 'dvb://' losses the NTSC signals.  I was booting *without* module
> support previously.  My kernel is now SMP with power support (I
> believe that 2.6.27 is the first kernel with SMP, but I had other
> kernels that seemed to also break the NTSC without SMP).
> 
> I change my 2.6.27.7 kernel to use modules for the saa7134.  On advice
> from others I used the /etc/modprobe.d and created a v4l.local file,
> 
> install tuner_simple modprobe -i tuner_simple debug=2 atv_input=2 dtv_input=2
> install tuner    modprobe -i tuner debug=1
> install saa7134  modprobe -i saa7134 disable_ir=1 alsa=1 video_debug=1
> install tveeprom modprobe -i tveeprom debug=1
> 
> I unloaded and reloaded modules.  When I do this, both tvtime shows no
> signal and 'mplayer tv://' give 'static'.  This seems to indicate that
> the analog path is configured, but the tuner is not working.  After I
> run 'mplayer dvb://', the 'mplayer tv://' just displays a black
> image. [the applications are functioning with the 2.6.24 kernel].
> 
> Reading about this card, I would expect the tda9887 module to be
> loaded.  It seems that loading this module re-activates the static in
> 'mplayer tv://'.  I don't see any reference to the tda9887 when I load
> the saa7134 (in debug, in /sys/module, or with lsmod).  Either that or
> something like "tuner-simple 1-0061: using tuner params #1 (analog)"
> in the dmesg output.  However, the KWorld ATSC 110 has the
> 'has_tda9887' set.  Is there some problem with my config?
> 
> $ gzip -dc /proc/config.gz | egrep '^[^\#]*(DVB|MEDIA)'
> CONFIG_DVB_CORE=y
> CONFIG_VIDEO_MEDIA=y
> CONFIG_MEDIA_ATTACH=y
> CONFIG_MEDIA_TUNER=y
> CONFIG_MEDIA_TUNER_CUSTOMIZE=y
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_VIDEOBUF_DVB=m
> CONFIG_VIDEO_SAA7134_DVB=m
> CONFIG_DVB_CAPTURE_DRIVERS=y
> CONFIG_DVB_TDA10086=m
> CONFIG_DVB_TDA826X=m
> CONFIG_DVB_TDA1004X=m
> CONFIG_DVB_MT352=y
> CONFIG_DVB_TDA10048=m
> CONFIG_DVB_TDA10021=m
> CONFIG_DVB_TDA10023=m
> CONFIG_DVB_NXT200X=m
> CONFIG_DVB_PLL=m
> CONFIG_DVB_ISL6421=m
> 
> lsmod (after modprobe saa7134)
> 
> Module                  Size  Used by
> saa7134_alsa           11712  0 
> tuner_simple           14992  1 
> tuner_types            14848  1 tuner_simple
> nxt200x                23556  1 
> saa7134_dvb            19596  0 
> videobuf_dvb            5636  1 saa7134_dvb
> tuner                  24648  0 
> saa7134               135636  2 saa7134_alsa,saa7134_dvb
> ir_common              40708  1 saa7134
> videobuf_dma_sg        12804  3 saa7134_alsa,saa7134_dvb,saa7134
> videobuf_core          18052  3 videobuf_dvb,saa7134,videobuf_dma_sg
> tveeprom               13188  1 saa7134
> 
> [start dmesg with 'mplayer dvb://']
> 
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7133[0]: found at 0000:02:09.0, rev: 240, irq: 17, latency: 64, mmio: 0xfeafe800
> saa7133[0]: subsystem: 17de:7350, board: Kworld ATSC110/115 [card=90,autodetected]
> saa7133[0]: board init: gpio is 100
> saa7133[0]: i2c eeprom 00: de 17 50 73 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> nxt200x: NXT2004 Detected
> tuner-simple 1-0061: creating new instance
> tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
> tuner-simple 1-0061: tuner 0 atv rf input will be set to input 2 (insmod option)
> tuner-simple 1-0061: tuner 0 dtv rf input will be set to input 2 (insmod option)
> DVB: registering new adapter (saa7133[0])
> DVB: registering frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
> nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
> nxt2004: Waiting for firmware upload(2)...
> nxt2004: Firmware upload complete
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xfeafe800 irq 17 registered as card -1
> tuner-simple 1-0061: using tuner params #1 (digital)
> tuner-simple 1-0061: freq = 629.00 (10064), range = 2, config = 0xc6, cb = 0x44
> tuner-simple 1-0061: Philips TUV1236D ATSC/NTSC dual in: div=10768 | buf=0x2a,0x10,0xc6,0x44
> 
> [start dmesg with tvtime]
> 
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7133[0]: found at 0000:02:09.0, rev: 240, irq: 17, latency: 64, mmio: 0xfeafe800
> saa7133[0]: subsystem: 17de:7350, board: Kworld ATSC110/115 [card=90,autodetected]
> saa7133[0]: board init: gpio is 100
> saa7133[0]: i2c eeprom 00: de 17 50 73 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> nxt200x: NXT2004 Detected
> tuner-simple 1-0061: creating new instance
> tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
> tuner-simple 1-0061: tuner 0 atv rf input will be set to input 2 (insmod option)
> tuner-simple 1-0061: tuner 0 dtv rf input will be set to input 2 (insmod option)
> DVB: registering new adapter (saa7133[0])
> DVB: registering frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
> nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
> nxt2004: Waiting for firmware upload(2)...
> nxt2004: Firmware upload complete
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xfeafe800 irq 17 registered as card -1
> saa7133[0] video (Kworld ATSC11: VIDIOC_QUERYCAP
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_STD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_TUNER
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMINPUT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMINPUT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMINPUT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMINPUT
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_INPUT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUM_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_TUNER
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMINPUT
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_INPUT
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_STD
> saa7133[0] video (Kworld ATSC11: VIDIOC_ENUMSTD
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_STD
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_FREQUENCY
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_FREQUENCY
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_FREQUENCY
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_G_FMT
> saa7133[0] video (Kworld ATSC11: VIDIOC_REQBUFS
> saa7133[0] video (Kworld ATSC11: VIDIOC_QUERYBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QUERYBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_CTRL
> saa7133[0] video (Kworld ATSC11: VIDIOC_QUERYCTRL
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_CTRL
> saa7133[0] video (Kworld ATSC11: VIDIOC_QUERYCTRL
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_CTRL
> saa7133[0] video (Kworld ATSC11: VIDIOC_QUERYCTRL
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_CTRL
> saa7133[0] video (Kworld ATSC11: VIDIOC_QUERYCTRL
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_CTRL
> saa7133[0] video (Kworld ATSC11: VIDIOC_STREAMON
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_QBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_STREAMOFF
> saa7133[0] video (Kworld ATSC11: VIDIOC_DQBUF
> saa7133[0] video (Kworld ATSC11: VIDIOC_S_CTRL
> saa7134 ALSA driver for DMA sound unloaded
> tuner-simple 1-0061: destroying instance
> 
> 
> On 26 Nov 2008, bpringle@sympatico.ca wrote:
> 
>> I use tvtime and mplayer to view ATSC and NTSC content OTA.  I have
>> the same input for both and prefer not to split it due to loss.
>> Anyways, with 2.6.24 series and below the drivers seems to pick the
>> inputs 'properly' for my needs.  Now they don't.  I looked through the
>> source and it seems that things are being structured more sanely.
>>
>> I have the following output when I set debug=1 for tuner_simple and
>> run 'mplayer dvb://',
>>
>> tuner-simple 1-0061: using tuner params #1 (digital)
>> tuner-simple 1-0061: freq = 509.00 (8144), range = 2, config = 0xc6, cb = 0x44
>> tuner-simple 1-0061: Philips TUV1236D ATSC/NTSC dual in: div=8848 | buf=0x22,0x90,0xc6,0x44
>>
>>
>> I don't get any output when running either tvtime or 'mplayer tv://'.
>> Is there some userspace ioctl call that should be made to set the
>> antenna input for NTSC content?  I also tried setting the atv_input
>> and dtv_input values.  This didn't seem to change anything.
>>
>> I started getting lost in the code.  Why does simple_std_setup() check
>> for V4L2_STD_ATSC and then unconditionally use atv_input?  Maybe that
>> simple_set_rf_input() is undone at a later time?
>>
>> Thanks for any info.  Search engines are sparse with information on
>> tuner_simple parameter information.  Although I expect I need some
>> code that does ioctls to the tuner modules.
>>
>> Regards,
>> Bill Pringlemeir.
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 

V4L support for the KWorld ATSC120 is limited.  There a numerous threads 
here which talk about the problems and some work arounds.  The 
developers have talked about adding support but consider new features at 
the cost of an overhaul of the current driver.

Right now I believe you can not use both ATSC and NTSC tuners w/o power 
cycling your computer and bringing it up with (only) the appropriate 
driver.  Also, I don't believe the IR receiver works under V4L.  This 
card replaced the Kworld 110 and Kworld 115 tuners.  If you can find 
these older Kworld ATSC tuners, I would buy them instead as I believe 
they are better supported under V4L (I also have a Kworld ATSC110 - but 
only use it for ATSC tuning as well).

Go here and read up on how people are setting this card up:
> http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_120

I'm using the Kworld 120 as an ATSC tuner and nothing else in a Debian 
mythtv slave back end system.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
