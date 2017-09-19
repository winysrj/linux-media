Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:52458 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdISTQv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 15:16:51 -0400
Message-ID: <59C16D1E.80308@googlemail.com>
Date: Tue, 19 Sep 2017 20:16:46 +0100
From: Nigel Kettlewell <nigel.kettlewell@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support HVR-1200 analog video as a clone of HVR-1500.
 Tested, composite and s-video inputs.
References: <59BEEC39.2030609@googlemail.com> <CAGoCfizQS3fg2Sqjtg2ypiCqa5cMQ=irMZ1nwEVJ8+TeBuAZCA@mail.gmail.com> <59C1044E.8060805@googlemail.com>
In-Reply-To: <59C1044E.8060805@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------090502020803070407090705"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090502020803070407090705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[adding kernel mailing lists missed from my reply]

Thank you, yes I think I cribbed too much from the 1500. I think the 
tuner part is not necessary: I have no analog over-the-air signal so I 
cannot test it, hence I have removed the tuner element from the patch 
(below).

I have tested DVB-T which works fine. dmesg shows no errors (attached).

DISPLAY=xxx:0.0 vlc dvb-t://frequency=498000000:bandwidth=8 
--dvb-adapter=0 --programs=8373
<works>

/usr/local/bin/v4l2-ctl --set-input 1
/usr/local/bin/v4l2-ctl -s 0x000000f7
cat /dev/video0 > /tmp/svideo.raw
<ctrl-c>
ffmpeg -f rawvideo -pix_fmt yuyv422 -r 25 -s:v 720x576 -i 
/tmp/svideo.raw -vcodec mpeg2video -vb 2000k -y /tmp/svideo.mpg
<svideo.mpg plays>

Revised patch:

---
  drivers/media/pci/cx23885/cx23885-cards.c | 16 ++++++++++++++++
  1 file changed, 16 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c 
b/drivers/media/pci/cx23885/cx23885-cards.c
index 0350f13..1b685f0 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -196,7 +196,22 @@ struct cx23885_board cx23885_boards[] = {
         },
         [CX23885_BOARD_HAUPPAUGE_HVR1200] = {
                 .name           = "Hauppauge WinTV-HVR1200",
+               .porta          = CX23885_ANALOG_VIDEO,
                 .portc          = CX23885_MPEG_DVB,
+               .input          = {{
+                       .type   = CX23885_VMUX_COMPOSITE1,
+                       .vmux   =       CX25840_VIN7_CH3 |
+                                       CX25840_VIN4_CH2 |
+                                       CX25840_VIN6_CH1,
+                       .gpio0  = 0,
+               }, {
+                       .type   = CX23885_VMUX_SVIDEO,
+                       .vmux   =       CX25840_VIN7_CH3 |
+                                       CX25840_VIN4_CH2 |
+                                       CX25840_VIN8_CH1 |
+                                       CX25840_SVIDEO_ON,
+                       .gpio0  = 0,
+               } },
         },
         [CX23885_BOARD_HAUPPAUGE_HVR1700] = {
                 .name           = "Hauppauge WinTV-HVR1700",
@@ -2260,6 +2275,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
         case CX23885_BOARD_HAUPPAUGE_HVR1290:
         case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
         case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
+       case CX23885_BOARD_HAUPPAUGE_HVR1200:
         case CX23885_BOARD_HAUPPAUGE_HVR1500:
         case CX23885_BOARD_MPX885:
         case CX23885_BOARD_MYGICA_X8507:
--
2.9.4

> Nigel Kettlewell <mailto:nigel.kettlewell@googlemail.com>
> 19 September 2017 12:49
> Thank you, yes I think I cribbed too much from the 1500. I think the 
> tuner part is not necessary: I have no analog over-the-air signal so I 
> cannot test it, hence I have removed the tuner element from the patch 
> (below).
>
> I have tested DVB-T which works fine. dmesg shows no errors (attached).
>
> DISPLAY=xxx:0.0 vlc dvb-t://frequency=498000000:bandwidth=8 
> --dvb-adapter=0 --programs=8373
> <works>
>
> /usr/local/bin/v4l2-ctl --set-input 1
> /usr/local/bin/v4l2-ctl -s 0x000000f7
> cat /dev/video0 > /tmp/svideo.raw
> <ctrl-c>
> ffmpeg -f rawvideo -pix_fmt yuyv422 -r 25 -s:v 720x576 -i 
> /tmp/svideo.raw -vcodec mpeg2video -vb 2000k -y /tmp/svideo.mpg
> <svideo.mpg plays>
>
> Revised patch:
>
> ---
>  drivers/media/pci/cx23885/cx23885-cards.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c 
> b/drivers/media/pci/cx23885/cx23885-cards.c
> index 0350f13..1b685f0 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -196,7 +196,22 @@ struct cx23885_board cx23885_boards[] = {
>         },
>         [CX23885_BOARD_HAUPPAUGE_HVR1200] = {
>                 .name           = "Hauppauge WinTV-HVR1200",
> +               .porta          = CX23885_ANALOG_VIDEO,
>                 .portc          = CX23885_MPEG_DVB,
> +               .input          = {{
> +                       .type   = CX23885_VMUX_COMPOSITE1,
> +                       .vmux   =       CX25840_VIN7_CH3 |
> +                                       CX25840_VIN4_CH2 |
> +                                       CX25840_VIN6_CH1,
> +                       .gpio0  = 0,
> +               }, {
> +                       .type   = CX23885_VMUX_SVIDEO,
> +                       .vmux   =       CX25840_VIN7_CH3 |
> +                                       CX25840_VIN4_CH2 |
> +                                       CX25840_VIN8_CH1 |
> +                                       CX25840_SVIDEO_ON,
> +                       .gpio0  = 0,
> +               } },
>         },
>         [CX23885_BOARD_HAUPPAUGE_HVR1700] = {
>                 .name           = "Hauppauge WinTV-HVR1700",
> @@ -2260,6 +2275,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>         case CX23885_BOARD_HAUPPAUGE_HVR1290:
>         case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
>         case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
> +       case CX23885_BOARD_HAUPPAUGE_HVR1200:
>         case CX23885_BOARD_HAUPPAUGE_HVR1500:
>         case CX23885_BOARD_MPX885:
>         case CX23885_BOARD_MYGICA_X8507:
> --
> 2.9.4
>
>
>
> Devin Heitmueller <mailto:dheitmueller@kernellabs.com>
> 18 September 2017 13:57
> On Sun, Sep 17, 2017 at 5:42 PM, Nigel Kettlewell
>
> I'm not confident the tuner config for this board is correct. The
> HVR-1200 is much closer to the HVR-1250 as opposed to the HVR-1500,
> and IIRC it didn't have an xc3028.
>
> I don't dispute that with the patch in question the composite/s-video
> are probably working ok, but I wouldn't recommend accepting this patch
> as-is until the tuner is verified for DVB-T and analog (ideally both).
>
> Can you provide the output of dmesg on device load? If it's filled
> with a bunch of errors showing xc3028 firmware load failures, that
> would be a smoking gun that it doesn't have the xc3028.
>
> Devin
>
> Nigel Kettlewell <mailto:nigel.kettlewell@googlemail.com>
> 17 September 2017 22:42
> I propose the following patch to support Hauppauge HVR-1200 analog 
> video, nothing more than a clone of HVR-1500. Patch based on Linux 4.9 
> commit 69973b830859bc6529a7a0468ba0d80ee5117826
>
> I have tested composite and S-Video inputs.
>
> With the change, HVR-1200 devices have a /dev/video<n> entry which is 
> accessible in the normal way.
>
> Let me know if you need anything more.
>
> Nigel Kettlewell
>
>
>
> ---
>  drivers/media/pci/cx23885/cx23885-cards.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c 
> b/drivers/media/pci/cx23885/cx23885-cards.c
> index 99ba8d6..5be38f1 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -195,7 +195,30 @@ struct cx23885_board cx23885_boards[] = {
>         },
>         [CX23885_BOARD_HAUPPAUGE_HVR1200] = {
>                 .name           = "Hauppauge WinTV-HVR1200",
> +               .porta          = CX23885_ANALOG_VIDEO,
>                 .portc          = CX23885_MPEG_DVB,
> +               .tuner_type     = TUNER_XC2028,
> +               .tuner_addr     = 0x61, /* 0xc2 >> 1 */
> +               .input          = {{
> +                       .type   = CX23885_VMUX_TELEVISION,
> +                       .vmux   =       CX25840_VIN7_CH3 |
> +                                       CX25840_VIN5_CH2 |
> +                                       CX25840_VIN2_CH1,
> +                       .gpio0  = 0,
> +               }, {
> +                       .type   = CX23885_VMUX_COMPOSITE1,
> +                       .vmux   =       CX25840_VIN7_CH3 |
> +                                       CX25840_VIN4_CH2 |
> +                                       CX25840_VIN6_CH1,
> +                       .gpio0  = 0,
> +               }, {
> +                       .type   = CX23885_VMUX_SVIDEO,
> +                       .vmux   =       CX25840_VIN7_CH3 |
> +                                       CX25840_VIN4_CH2 |
> +                                       CX25840_VIN8_CH1 |
> +                                       CX25840_SVIDEO_ON,
> +                       .gpio0  = 0,
> +               } },
>         },
>         [CX23885_BOARD_HAUPPAUGE_HVR1700] = {
>                 .name           = "Hauppauge WinTV-HVR1700",
> @@ -2262,6 +2285,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>         case CX23885_BOARD_HAUPPAUGE_HVR1290:
>         case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
>         case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
> +       case CX23885_BOARD_HAUPPAUGE_HVR1200:
>         case CX23885_BOARD_HAUPPAUGE_HVR1500:
>         case CX23885_BOARD_MPX885:
>         case CX23885_BOARD_MYGICA_X8507:
> -- 
> 2.9.4
>


--------------090502020803070407090705
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[...]
[Tue Sep 19 12:22:51 2017] cx23885: cx23885 driver version 0.0.4 loaded
[Tue Sep 19 12:22:51 2017] cx23885: CORE cx23885[0]: subsystem: 0070:71d1, board: Hauppauge WinTV-HVR1200 [card=7,autodetected]
[Tue Sep 19 12:22:51 2017] tveeprom: Hauppauge model 71999, rev J1E9, serial# 4031327705
[Tue Sep 19 12:22:51 2017] tveeprom: MAC address is 00:0d:fe:49:2d:d9
[Tue Sep 19 12:22:51 2017] tveeprom: tuner model is Philips 18271_8295 (idx 149, type 54)
[Tue Sep 19 12:22:51 2017] tveeprom: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[Tue Sep 19 12:22:51 2017] tveeprom: audio processor is CX23885 (idx 39)
[Tue Sep 19 12:22:51 2017] tveeprom: decoder processor is CX23885B (idx 41)
[Tue Sep 19 12:22:51 2017] tveeprom: has no radio
[Tue Sep 19 12:22:51 2017] cx23885: cx23885[0]: hauppauge eeprom: model=71999
[Tue Sep 19 12:22:51 2017] cx25840 9-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[Tue Sep 19 12:22:51 2017] cx25840 9-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
[Tue Sep 19 12:22:51 2017] cx23885: cx23885[0]: registered device video0 [v4l2]
[Tue Sep 19 12:22:51 2017] cx23885: cx23885[0]: registered device vbi0
[Tue Sep 19 12:22:51 2017] cx23885: cx23885[0]: alsa: registered ALSA audio device
[Tue Sep 19 12:22:51 2017] cx23885: cx23885_dvb_register() allocating 1 frontend(s)
[Tue Sep 19 12:22:51 2017] cx23885: cx23885[0]: cx23885 based dvb card
[Tue Sep 19 12:22:51 2017] tda829x 8-0042: type set to tda8295
[Tue Sep 19 12:22:52 2017] tda18271 8-0060: creating new instance
[Tue Sep 19 12:22:52 2017] tda18271: TDA18271HD/C1 detected @ 8-0060
[Tue Sep 19 12:22:52 2017] dvbdev: DVB: registering new adapter (cx23885[0])
[Tue Sep 19 12:22:52 2017] cx23885 0000:02:00.0: DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[Tue Sep 19 12:22:52 2017] cx23885: cx23885_dev_checkrevision() Hardware revision = 0xb0
[Tue Sep 19 12:22:52 2017] cx23885: cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xf7c00000
[...]
[Tue Sep 19 12:24:55 2017] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
[Tue Sep 19 12:24:55 2017] tda10048_firmware_upload: firmware read 24878 bytes.
[Tue Sep 19 12:24:55 2017] tda10048_firmware_upload: firmware uploading
[Tue Sep 19 12:24:57 2017] tda10048_firmware_upload: firmware uploaded

--------------090502020803070407090705--
