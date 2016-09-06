Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59175 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754316AbcIFKAO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 06:00:14 -0400
Subject: Re: v4l2-ctl does not show all parameters for HVR-1900
To: de_witte_koen@telenet.be, linux-media@vger.kernel.org
References: <611282171.287911096.1473102085377.JavaMail.root@telenet.be>
From: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mike Isely <isely@isely.net>
Message-ID: <9784dc71-e6f8-fe46-dda5-6d65cbf5123d@xs4all.nl>
Date: Tue, 6 Sep 2016 12:00:06 +0200
MIME-Version: 1.0
In-Reply-To: <611282171.287911096.1473102085377.JavaMail.root@telenet.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/16 21:01, de_witte_koen@telenet.be wrote:
>
> In short:
> Is it normal that I can use the v4l2-ctl command to adjust brightness, saturation, hue, etc but not to adjust more interesting parameters like bitrate, aspect ration, etc?
>
> Working:
> pi@raspberrypi:~ $ cat /sys/class/pvrusb2/sn-4034395926/ctl_hue/cur_val
> 0
> pi@raspberrypi:~ $ v4l2-ctl -c hue=1
> pi@raspberrypi:~ $ cat /sys/class/pvrusb2/sn-4034395926/ctl_hue/cur_val
> 1
>
>
> Not working:
> pi@raspberrypi:~ $ cat /sys/class/pvrusb2/sn-4034395926/ctl_video_bitrate/cur_val
> 6000000
> pi@raspberrypi:~ $ v4l2-ctl -c bitrate=6000000
> unknown control 'bitrate'
> pi@raspberrypi:~ $ v4l2-ctl -c video_bitrate=6000000
> unknown control 'video_bitrate'
> pi@raspberrypi:~ $ v4l2-ctl -c ctl_video_bitrate=6000000
> unknown control 'ctl_video_bitrate'
>
> the pvrusb2 driver has created all sysfs parameters and they work using the "echo" method but I thought this was also the purpose of the v4l2-ctl command, correct?
>
> Some details, let me know if you need more.

The problem here is that the pvrusb2 driver predates the V4L2 control 
framework for handling controls. Instead it has its own implementation 
and that is known to be buggy. For a variety of reasons it is not easy 
to rework this driver to use the control framework.

I've CC-ed the maintainer, perhaps he can make a patch that at least 
exposes these controls through the QUERYCTRL ioctl (they don't seem to 
turn up when enumerating the controls, which is why the above fails).

Regards,

	Hans

>
> Regards,
> Koen
>
>
> pi@raspberrypi:~ $ uname -a
> Linux raspberrypi 4.4.13+ #894 Mon Jun 13 12:43:26 BST 2016 armv6l GNU/Linux
> pi@raspberrypi:~ $
>
>
>
> pi@raspberrypi:~ $ v4l2-ctl --all
> Driver Info (not using libv4l2):
>         Driver name   : pvrusb2
>         Card type     : WinTV HVR-1900 Model 73xxx
>         Bus info      : usb-20980000.usb-1.3
>         Driver version: 4.4.13
>         Capabilities  : 0x81270001
>                 Video Capture
>                 Tuner
>                 Audio
>                 Radio
>                 Read/Write
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x01230001
>                 Video Capture
>                 Tuner
>                 Audio
>                 Read/Write
>                 Extended Pix Format
> Priority: 2
> Frequency for tuner 0: 980 (61.250000 MHz)
> Tuner 0:
>         Name                 :
>         Capabilities         : 62.5 kHz multi-standard stereo lang1 lang2 freq-bands
>         Frequency range      : 44.000 MHz - 958.000 MHz
>         Signal strength/AFC  : 0%/0
>         Current audio mode   : stereo
>         Available subchannels: mono lang2
> Video input : 0 (television: ok)
> Audio input : 0 (PVRUSB2 Audio)
> Video Standard = 0x00000000
> Format Video Capture:
>         Width/Height  : 720/480
>         Pixel Format  : ''
>         Field         : Interlaced
>         Bytes per Line: 0
>         Size Image    : 32768
>         Colorspace    : Unknown (00000000)
>         Flags         :
> Crop Capability Video Capture:
>         Bounds      : Left 0, Top 0, Width 0, Height 0
>         Default     : Left 0, Top 0, Width 0, Height 0
>         Pixel Aspect: 0/0
> Crop: Left 0, Top 0, Width 720, Height 480
> Streaming Parameters Video Capture:
>         Frames per second: 25.000 (25/1)
>         Read buffers     : 2
>                      brightness (int)    : min=0 max=255 step=1 default=128 value=128
>                        contrast (int)    : min=0 max=127 step=1 default=68 value=68
>                      saturation (int)    : min=0 max=127 step=1 default=64 value=64
>                             hue (int)    : min=-128 max=127 step=1 default=0 value=0
>                          volume (int)    : min=0 max=65535 step=1 default=62000 value=62000
>                         balance (int)    : min=-32768 max=32767 step=1 default=0 value=0
>                            bass (int)    : min=-32768 max=32767 step=1 default=0 value=0
>                          treble (int)    : min=-32768 max=32767 step=1 default=0 value=0
>                            mute (bool)   : default=0 value=0
>
> dmesg output:
>
>
> [    4.162258] scsi host0: usb-storage 1-1.2:1.0
> [    4.258220] usb 1-1.3: new high-speed USB device number 5 using dwc_otg
> [    4.382814] usb 1-1.3: New USB device found, idVendor=2040, idProduct=7300
> [    4.391713] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    4.400866] usb 1-1.3: Product: WinTV
> [    4.406259] usb 1-1.3: Manufacturer: Hauppauge
> [    4.412471] usb 1-1.3: SerialNumber: 7300-00-F077FF16
> ...
> [   10.463517] media: Linux media interface: v0.10
> [   10.547654] Linux video capture interface: v2.00
> [   10.660771] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [   10.781359] pvrusb2: Hardware description: WinTV HVR-1900 Model 73xxx
> [   10.798664] usbcore: registered new interface driver pvrusb2
> [   10.798702] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
> [   10.798721] pvrusb2: Debug mask is 1 (0x1)
> [   11.484744] systemd-journald[117]: Received request to flush runtime journal from PID 1
> [   11.782401] pvrusb2: Device microcontroller firmware (re)loaded; it should now reset and reconnect.
> [   11.974683] usb 1-1.3: USB disconnect, device number 5
> [   13.748236] usb 1-1.3: new high-speed USB device number 6 using dwc_otg
> [   13.858748] usb 1-1.3: New USB device found, idVendor=2040, idProduct=7300
> [   13.858790] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   13.858810] usb 1-1.3: Product: WinTV
> [   13.858827] usb 1-1.3: Manufacturer: Hauppauge
> [   13.858844] usb 1-1.3: SerialNumber: 7300-00-F077FF16
> [   13.868612] pvrusb2: Hardware description: WinTV HVR-1900 Model 73xxx
> [   13.921561] pvrusb2: Binding ir_rx_z8f0811_haup to i2c address 0x71.
> [   13.921787] pvrusb2: Binding ir_tx_z8f0811_haup to i2c address 0x70.
> [   14.099430] cx25840 3-0044: cx25843-24 found @ 0x88 (pvrusb2_a)
> [   14.118546] pvrusb2: Attached sub-driver cx25840
> [   14.415416] tuner 3-0042: Tuner -1 found with type(s) Radio TV.
> [   14.415503] pvrusb2: Attached sub-driver tuner
> ...
> [   16.664488] cx25840 3-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
> [   16.786299] tveeprom 3-00a2: Hauppauge model 73219, rev D2F5, serial# 4034395926
> [   16.786337] tveeprom 3-00a2: MAC address is 00:0d:fe:77:ff:16
> [   16.786356] tveeprom 3-00a2: tuner model is NXP 18271C2 (idx 155, type 54)
> [   16.786377] tveeprom 3-00a2: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
> [   16.786393] tveeprom 3-00a2: audio processor is CX25843 (idx 37)
> [   16.786410] tveeprom 3-00a2: decoder processor is CX25843 (idx 30)
> [   16.786426] tveeprom 3-00a2: has radio, has IR receiver, has IR transmitter
> [   16.786522] pvrusb2: Device initialization completed successfully.
> [   16.833872] pvrusb2: registered device video0 [mpeg]
> [   16.833917] DVB: registering new adapter (pvrusb2-dvb)
> [   17.724319] smsc95xx 1-1.1:1.0 eth0: hardware isn't capable of remote wakeup
> [   17.725055] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   19.185810] cx25840 3-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
> [   19.318894] tda829x 3-0042: setting tuner address to 60
> [   19.336993] smsc95xx 1-1.1:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0xCDE1
> [   19.348636] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   19.408700] tda18271 3-0060: creating new instance
> [   19.458819] TDA18271HD/C2 detected @ 3-0060
> [   20.358789] tda18271: performing RF tracking filter calibration
> [   39.498969] tda18271: RF tracking filter calibration complete
> [   39.568994] tda829x 3-0042: type set to tda8295+18271
> [   46.439239] cx25840 3-0044: 0x0000 is not a valid video input!
> [   46.498783] usb 1-1.3: DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
> [   46.507172] tda829x 3-0042: type set to tda8295
> [   46.547113] tda18271 3-0060: attaching existing instance
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

