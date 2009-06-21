Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5L64Io4011856
	for <video4linux-list@redhat.com>; Sun, 21 Jun 2009 02:04:18 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n5L63wlj021584
	for <video4linux-list@redhat.com>; Sun, 21 Jun 2009 02:03:59 -0400
Received: by an-out-0708.google.com with SMTP id b38so1286338ana.36
	for <video4linux-list@redhat.com>; Sat, 20 Jun 2009 23:03:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6ab2c27e0906202158u3f447019pbd47805bbac5c07b@mail.gmail.com>
References: <COL103-W5519F2238C4DF5D14AA5488380@phx.gbl>
	<6ab2c27e0906202158u3f447019pbd47805bbac5c07b@mail.gmail.com>
Date: Sun, 21 Jun 2009 02:03:58 -0400
Message-ID: <829197380906202303n19397cbenb7176a9b7c2de3f8@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Terry Wu <terrywu2009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Can't use my Pinnacle PCTV HD Pro stick - what am I doing wrong?
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

On Sun, Jun 21, 2009 at 12:58 AM, Terry Wu<terrywu2009@gmail.com> wrote:
> Hi,
>
> The attach_xc3028() of em28xx-dvb.c does not give the firmware filename:
> static int attach_xc3028(u8 addr, struct em28xx *dev)
> {
>        struct dvb_frontend *fe;
>        struct xc2028_config cfg;
>
>        memset(&cfg, 0, sizeof(cfg));
>        cfg.i2c_adap  = &dev->i2c_adap;
>        cfg.i2c_addr  = addr;
>
>        if (!dev->dvb->frontend) {
>                printk(KERN_ERR "%s/2: dvb frontend not attached. "
>                                "Can't attach xc3028\n",
>                       dev->name);
>                return -EINVAL;
>        }
>
>        fe = dvb_attach(xc2028_attach, dev->dvb->frontend, &cfg);
>        if (!fe) {
>                printk(KERN_ERR "%s/2: xc3028 attach failed\n",
>                       dev->name);
>                dvb_frontend_detach(dev->dvb->frontend);
>                dev->dvb->frontend = NULL;
>                return -EINVAL;
>        }
>
>        printk(KERN_INFO "%s/2: xc3028 attached\n", dev->name);
>
>        return 0;
> }
>
> And in the check_firmware() of tuner-xc2028.c, the
> load_all_firmwares() will not be called because the xc2028/3028
> firmware name not set:
>                if (!priv->ctrl.fname) {
>                        tuner_info("xc2028/3028 firmware name not set!\n");
>                        return -EINVAL;
>                }
>                rc = load_all_firmwares(fe);
>
> Best Regards,
> Terry
>
> 2009/6/21 George Adams <g_adams27@hotmail.com>:
>>
>> Hello. áI'm having problems getting my (USB) PCTV HD Pro Stick (800e,
>> the "old" style) to work under V4L. áCould anyone spot the problem in
>> what I'm doing?
>>
>> I'm running Ubuntu 8.04.2 LTS (the 2.6.24-24-server kernel), and am
>> following this procedure (based on
>> http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers).
>> I intend to use this to tune to USA NTSC channel 3 (to capture a
>> close-captioned feed inside our building)
>>
>> 1) Extract and copy the firmware file I need
>> á (xc3028-v27.fw) to /lib/firmware
>>
>> 2) cd /usr/local/src
>>
>> 3) hg clone http://linuxtv.org/hg/v4l-dvb
>>
>> 4) cd v4l-dvb
>>
>> 5) make rminstall; make distclean; make; make install
>>
>> These seems to do what it's supposed to - installs the drivers into
>> /lib/modules/2.6.24-24-server . áMy PCTV HD Pro Stick uses the em28xx
>> drivers.
>>
>>> find /lib/modules/ -type f -name "em28*" -mtime -1
>> á á/lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx.ko
>> á á/lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
>>
>> 6) Reboot with the USB capture device plugged in
>>
>> 7) Examine "dmesg" for details related to the capture device
>>
>> - em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps (2304:0227, interface 0, class 0)
>> - em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
>> - em28xx #0: chip ID is em2882/em2883
>> - - -> GSI 22 (level, low) -> IRQ 22
>> - PCI: Setting latency timer of device 0000:00:1b.0 to 64
>> - em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
>> - em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
>> - em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
>> - em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
>> - em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> - em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> - em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
>> - em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
>> - em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
>> - em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
>> - em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00
>> - em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00
>> - em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> - em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> - em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> - em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> - em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
>> - em28xx #0: EEPROM info:
>> - em28xx #0: á á á AC97 audio (5 sample rates)
>> - em28xx #0: á á á 500mA max power
>> - em28xx #0: á á á Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
>> - hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
>> - input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb4/4-3/input/input6
>> - - -> GSI 20 (level, low) -> IRQ 23
>> - Vortex: init.... em28xx #0: Config register raw data: 0xd0
>> - em28xx #0: AC97 vendor ID = 0xffffffff
>> - em28xx #0: AC97 features = 0x6a90
>> - em28xx #0: Empia 202 AC97 audio processor detected
>> - em28xx #0: v4l2 driver version 0.1.2
>> - em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
>> - usbcore: registered new interface driver em28xx
>> - em28xx driver loaded
>> - xc2028 0-0061: creating new instance
>> - xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
>> - em28xx #0/2: xc3028 attached
>> - DVB: registering new adapter (em28xx #0)
>> - DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
>> - Successfully loaded em28xx-dvb
>> - Em28xx: Initialized (Em28xx dvb Extension) extension
>> - done.
>>
>> Everything looks good - the drivers are getting called and the card is
>> recognized. áHowever, all my attempts to get something "out of it"
>> aren't working. áI tried firing up "tvtime", but it just launches a
>> blank, black screen and hanges. áThe menu won't come up, the channel
>> won't change, right-clicking isn't responsive, it won't close, and I
>> have to kill it.
>>
>> I also tried mencoder, but I get this:
>>
>>> mencoder -nosound -tv driver=v4l2:width=640:height=480 tv://3 -o /tmp/tv.avi -ovc raw -endpos 5
>>
>> MEncoder 2:1.0~rc2-0ubuntu13.1+medibuntu1 (C) 2000-2007 MPlayer Team
>> CPU: Intel(R) Core(TM)2 Quad CPU á áQ9550 á@ 2.83GHz
>> á(Family: 6, Model: 23, Stepping: 10)
>> CPUflags: Type: 6 MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
>> Compiled with runtime CPU detection.
>> success: format: 9 ádata: 0x0 - 0x0
>> TV file format detected.
>> Selected driver: v4l2
>> áname: Video 4 Linux 2 input
>> áauthor: Martin Olschewski
>> ácomment: first try, more to come ;-)
>> Selected device: Pinnacle PCTV HD Pro Stick
>> áTuner cap:
>> áTuner rxs:
>> áCapabilites: ávideo capture átuner áaudio áread/write ástreaming
>> ásupported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4
>> á = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK;
>> á 10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 =
>> á SECAM-B; 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20
>> á = SECAM-Lc;
>> áinputs: 0 = Television; 1 = Composite1; 2 = S-Video;
>> áCurrent input: 0
>> áCurrent format: YUYV
>> v4l2: ioctl set format failed: Invalid argument
>> v4l2: ioctl set format failed: Invalid argument
>> v4l2: ioctl set format failed: Invalid argument
>> v4l2: ioctl query control failed: Invalid argument
>> v4l2: ioctl query control failed: Invalid argument
>> v4l2: ioctl query control failed: Invalid argument
>> v4l2: ioctl query control failed: Invalid argument
>> [V] filefmt:9 áfourcc:0x32595559 ásize:640x480 áfps:25.00 áftime:=0.0400
>> Opening video filter: [expand osd=1]
>> Expand: -1 x -1, -1 ; -1, osd: 1, aspect: 0.000000, round: 1
>> ==========================================================================
>> Opening video decoder: [raw] RAW Uncompressed Video
>> VDec: vo config request - 640 x 480 (preferred colorspace: Packed YUY2)
>> VDec: using Packed YUY2 as output csp (no 0)
>> Movie-Aspect is undefined - no prescaling applied.
>> Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
>> ==========================================================================
>> Forcing audio preload to 0, max pts correction to 0.
>> v4l2: select timeout
>>
>> Skipping frame!
>> Pos: á 0.0s á á á1f ( 0%) á0.96fps Trem: á 0min á 0mb áA-V:0.000 [0:0]
>> Skipping frame!
>> v4l2: select timeout( 0%) á1.28fps Trem: á 0min á 0mb áA-V:0.000 [0:0]
>>
>> Skipping frame!
>> Pos: á 0.0s á á á3f ( 0%) á1.44fps Trem: á 0min á 0mb áA-V:0.000 [0:0]
>> Skipping frame!
>> v4l2: select timeout( 0%) á1.54fps Trem: á 0min á 0mb áA-V:0.000 [0:0]
>>
>> Skipping frame!
>> Pos: á 0.0s á á á5f ( 0%) á1.60fps Trem: á 0min á 0mb áA-V:0.000 [0:0]
>> Skipping frame!
>> v4l2: select timeout( 0%) á1.65fps Trem: á 0min á 0mb áA-V:0.000 [0:0]
>>
>> Skipping frame!
>> Pos: á 0.0s á á á7f ( 0%) á1.68fps Trem: á 0min á 0mb áA-V:0.000 [0:0]
>> Skipping frame!
>> Pos: á 0.0s á á á8f ( 0%) á1.71fps Trem: á 0min á 0mb áA-V:0.000 [0:0]
>>
>>
>> The resulting file (/tmp/tv.avi) is only 4K and not a valid AVI file.
>>
>>
>>
>> One thing I noticed that differs from what I was expecting is that
>> nowhere in the "dmesg" output does it say anything about the firmware
>> file. áI was expecting to see this in "dmesg":
>>
>> - firmware: requesting xc3028-v27.fw
>> - xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,
>> - á type: xc2028 firmware, ver 2.7
>>
>> but nothing approximating those lines appears at all. áI tried deleting
>> /lib/firmware/xc3028-v27.fw entirely to see if it would complain, but
>> it loaded up exactly the same way after I rebooted... áand still didn't
>> work.
>>
>> So my questions are:
>>
>> 1) Why is the firmware file not being read? áHas something happened to
>> the em28xx drivers recently that causes this file not to be needed
>> anymore? áOr is something else going wrong?
>>
>> 2) Is that the reason for the problem, or have you spotted something
>> else I've done wrong?
>>
>> Thanks greatly to anyone who can help!
>>
>> _________________________________________________________________
>> Insert movie times and more without leaving Hotmail«.
>> http://windowslive.com/Tutorial/Hotmail/QuickAdd?ocid=TXT_TAGLM_WL_HM_Tutorial_QuickAdd_062009
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

Terry,

On hybrid analog/digital em28xx boards, the firmware is set in the
analog phase and then whatever value specified is reused in the
digital phase.  For the Pinnacle 800e, the xc3028 firmware is
specified in em28xx-cards.c:1898.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
