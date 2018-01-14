Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:37220 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbeANPIV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 10:08:21 -0500
Received: by mail-oi0-f41.google.com with SMTP id e144so6800951oib.4
        for <linux-media@vger.kernel.org>; Sun, 14 Jan 2018 07:08:20 -0800 (PST)
MIME-Version: 1.0
From: Mike Maravillo <maravillo@gmail.com>
Date: Sun, 14 Jan 2018 23:08:18 +0800
Message-ID: <CAKyykmyiFB6FJ9R_xV3RowOYGfA-VtheZrki8sY4Xk8kRZu6NA@mail.gmail.com>
Subject: ITE IT9303FN: af9035_ctrl_msg: command=2b failed fw error=21
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

I'm not sure if this is the right place to post this.

I have this card http://www.gadgetaddict.net/myphone-dtv-dongle/

Is there a chance to get this working on the Raspberry Pi 3 based on
below's dmesg output?

[ 2412.224084] usb 1-1: new high-speed USB device number 10 using ehci-pci
[ 2412.582937] usb 1-1: New USB device found, idVendor=048d, idProduct=9306
[ 2412.582943] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 2412.643448] [1746] usb 1-1: dvb_usbv2_probe: bInterfaceNumber=0
[ 2412.643463] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 00
03 02 00 00 12 22 db ea
[ 2412.648672] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 07 00 00 01
06 93 6b f9
[ 2412.648684] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 01
01 02 00 00 38 4f ad c6
[ 2412.652713] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 05 01 00 83 7b ff
[ 2412.652722] usb 1-1: dvb_usb_af9035: prechip_version=83
chip_version=01 chip_type=9306
[ 2412.652727] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 06 00 22 02 01 fd dc
[ 2412.656734] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 08 02 00 00
00 00 00 fd ff
[ 2412.656743] [1746] usb 1-1: af9035_identify_state: reply=00 00 00 00
[ 2412.656747] usb 1-1: dvb_usb_v2: found a 'ITE 9303 Generic' in cold state
[ 2412.656750] [1746] usb 1-1: dvb_usbv2_download_firmware:
[ 2412.656810] usb 1-1: dvb_usb_v2: downloading firmware from file
'dvb-usb-it9303-01.fw'
[ 2412.656814] [1746] usb 1-1: af9035_download_firmware:
[ 2412.656818] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 03
01 02 00 00 49 c5 35 b5
[ 2412.661103] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 05 03 00 00 fc ff
[ 2412.661116] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 04
03 00 00 03 41 00 03 41 80 06 41 93 1a 02 12 bf 02 41 93 22 00 00 a2
af e4 33 90 7c 00 f0 a2 dd e4 33 a3 f0 7e 4b 7f fc 7c 44 7d ca 7b 04
12 a1 aa 4b
[ 2412.666246] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 04 00 fb ff
[ 2412.666258] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=48
[ 2412.666285] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 05
03 00 00 01 41 ad 29 5f e4 ff 74 3b 2f f5 82 e4 34 f5 f5 83 74 ff f0
0f ef b4 40 ee c2 dd c2 af 74 89 90 f5 3b f0 74 41 a3 f0 74 4c 90 f5
5b f0 4b 6b
[ 2412.670091] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 05 00 fa ff
[ 2412.670102] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=96
[ 2412.670108] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 06
03 00 00 01 41 d6 29 74 00 a3 f0 74 2f 90 f5 3d f0 74 f5 a3 f0 74 44
90 f5 5d f0 74 76 a3 f0 74 89 90 f5 3f f0 74 2c a3 f0 74 44 90 f5 5f
f0 74 fc 3e
[ 2412.673737] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 06 00 f9 ff
[ 2412.673747] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=144
[ 2412.673753] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 07
03 00 00 01 41 ff 29 68 a3 f0 74 89 90 f5 41 f0 74 31 a3 f0 74 44 90
f5 61 f0 74 6f a3 f0 74 87 90 f5 43 f0 74 59 a3 f0 74 43 90 f5 63 f0
74 04 9e b5
[ 2412.678121] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 07 00 f8 ff
[ 2412.678133] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=192
[ 2412.678138] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 08
03 00 00 01 42 28 29 a3 f0 74 87 90 f5 45 f0 74 e1 a3 f0 74 43 90 f5
65 f0 74 e3 a3 f0 74 88 90 f5 47 f0 74 3a a3 f0 74 42 90 f5 67 f0 74
a2 a3 57 e0
[ 2412.681865] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 08 00 f7 ff
[ 2412.681875] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=240
[ 2412.681882] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 09
03 00 00 01 42 51 29 f0 90 f5 3a e0 54 fe 44 01 f0 c2 ae c2 8e 43 8e
10 d2 df 75 c0 50 53 89 0f 43 89 20 75 8b be 75 8d be d2 8e c2 c1 c2
ae d2 8d 0e
[ 2412.685887] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 09 00 f6 ff
[ 2412.685899] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=288
[ 2412.685906] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 0a
03 00 00 01 42 7a 29 be 12 88 3c e4 90 79 04 f0 90 d9 24 e0 54 fe 44
01 f0 e4 90 49 62 f0 90 7c 01 e0 24 ff 92 dd 90 7c 00 e0 24 ff 92 af
22 90 39 a9
[ 2412.690693] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 0a 00 f5 ff
[ 2412.690704] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=336
[ 2412.690710] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 0b
03 00 00 01 42 a3 29 f7 04 e0 70 24 c2 ae c2 8e 43 8e 10 d2 df 75 c0
50 53 89 0f 43 89 20 75 8b be 75 8d be d2 8e c2 c1 c2 ae 90 49 62 f0
80 24 e6 0b
[ 2412.695033] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 0b 00 f4 ff
[ 2412.695044] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=384
[ 2412.695050] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 0c
03 00 00 01 42 cc 29 c2 ae c2 8e 43 8e 10 d2 df 75 c0 d0 53 89 0f 43
89 20 75 8b be 75 8d be d2 8e c2 c1 d2 ae 90 49 62 74 01 f0 d2 be 12
88 3c 80 ed
[ 2412.698733] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 0c 00 f3 ff
[ 2412.698742] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=432
[ 2412.698747] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 0d
03 00 00 01 42 f5 29 e4 90 79 04 f0 90 d9 24 e0 54 fe 44 01 f0 22 90
49 62 e0 ff 70 31 c2 c1 90 7c 02 f0 90 f7 04 e0 fe 90 7c 02 e0 fd c3
9e 40 ec 45
[ 2412.703847] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 0d 00 f2 ff
[ 2412.703858] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=480
[ 2412.703864] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 0e
03 00 00 01 43 1e 29 03 02 43 e2 74 05 2d f5 82 e4 34 f7 f5 83 e0 f5
c1 30 c1 fd c2 c1 90 7c 02 e0 04 f0 80 d5 ef 64 01 60 03 02 43 e2 90
7c 02 32 03
[ 2412.708124] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 0e 00 f1 ff
[ 2412.708135] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=528
[ 2412.708140] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 0f
03 00 00 01 43 47 29 f0 90 f7 04 e0 ff 90 7c 02 e0 c3 9f 50 25 e0 fe
24 05 f5 82 e4 34 f7 f5 83 e0 fd 90 7a 04 e0 2e 24 05 f5 82 e4 34 79
f5 83 8b b4
[ 2412.712103] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 0f 00 f0 ff
[ 2412.712113] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=576
[ 2412.712119] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 10
03 00 00 01 43 70 29 ed f0 90 7c 02 e0 04 f0 80 ce 90 7a 04 e0 2f f0
90 49 65 e0 64 01 70 5a 90 79 04 04 f0 c2 ae c2 c1 e4 90 7c 02 f0 90
7a 04 c9 c4
[ 2412.714920] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 10 00 ef ff
[ 2412.714934] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=624
[ 2412.714940] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 11
03 00 00 01 43 99 29 e0 ff 90 7c 02 e0 fe c3 9f 50 2e 74 05 2e f5 82
e4 34 79 f5 83 e0 ff fe c3 13 6e fe 13 13 54 3f 6e fe c4 54 0f 6e fe
13 92 ca 98
[ 2412.719091] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 11 00 ee ff
[ 2412.719102] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=672
[ 2412.719108] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 12
03 00 00 01 43 c2 29 c3 8f c1 30 c1 fd c2 c1 90 7c 02 e0 04 f0 80 c4
c2 c0 12 88 3c d2 ae e4 90 49 65 f0 90 79 04 f0 22 90 49 62 e0 70 3f
c2 8e a1 16
[ 2412.723667] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 12 00 ed ff
[ 2412.723678] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=720
[ 2412.723685] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 13
03 00 00 01 43 eb 29 90 f7 04 e0 ff 14 60 13 14 60 18 24 f7 50 1c 24
0b 70 20 75 8b be 75 8d be 80 1c 75 8b df 75 8d df 80 14 75 8b ef 75
8d ef dd 6f
[ 2412.728373] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 13 00 ec ff
[ 2412.728383] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=768
[ 2412.728389] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 14
03 00 00 01 44 14 29 80 0c 75 8b be 75 8d be 80 04 8f 8b 8f 8d 12 88
3c d2 8e 22 90 49 62 e0 64 01 70 37 c2 ae c2 8e 90 f7 04 e0 ff 14 60
10 24 b2 6c
[ 2412.732140] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 14 00 eb ff
[ 2412.732149] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=816
[ 2412.732154] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 15
03 00 00 01 44 3d 29 f6 50 14 24 0b 70 18 75 8b be 75 8d be 80 14 75
8b df 75 8d df 80 0c 75 8b be 75 8d be 80 04 8f 8b 8f 8d 12 88 3c d2
8e d2 b2 a7
[ 2412.737092] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 15 00 ea ff
[ 2412.737104] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=864
[ 2412.737111] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 16
03 00 00 01 44 66 29 ae 22 75 e8 e0 75 a8 c0 22 75 e8 e3 75 a8 e5 22
90 f7 0a e0 ff 80 00 22 ef 64 0a 70 45 90 f7 08 e0 f4 70 3e a3 e0 64
01 70 d4 0d
[ 2412.741561] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 16 00 e9 ff
[ 2412.741571] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=912
[ 2412.741578] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 17
03 00 00 01 44 8f 29 38 90 f4 05 74 20 f0 90 f6 b5 e0 54 fb 44 04 f0
e0 54 fb f0 90 f7 00 74 04 f0 90 f7 03 e0 90 f7 01 f0 a3 e4 f0 a3 e0
f4 f0 f0 0c
[ 2412.745572] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 17 00 e8 ff
[ 2412.745582] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=960
[ 2412.745588] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 18
03 00 00 01 44 b8 29 a3 74 ff f0 e4 ff 12 2f ab 7a 44 79 ce 12 39 70
22 22 01 04 00 00 d0 e0 d0 e0 d0 e0 d0 e0 22 d0 04 d0 05 c0 07 c0 06
c0 05 f4 d9
[ 2412.749607] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 18 00 e7 ff
[ 2412.749619] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1008
[ 2412.749624] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 19
03 00 00 02 44 e1 0c 4c 00 1a c0 04 22 d0 e0 d0 e0 c0 07 c0 06 22 90
f7 01 e0 54 70 ff c4 54 0f fd e0 54 0f 90 7c 07 f0 90 f7 02 e0 90 47
85 f0 cc 0d
[ 2412.753629] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 19 00 e6 ff
[ 2412.753639] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1056
[ 2412.753666] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 1a
03 00 00 01 4c 1a 29 90 f7 03 e0 90 47 86 f0 e4 90 7c 04 f0 af 05 ef
b4 08 00 40 03 02 4e 80 90 4c 39 f8 28 28 73 02 4c 51 02 4d 8b 02 4d
df 02 32 67
[ 2412.757656] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 1a 00 e5 ff
[ 2412.757668] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1104
[ 2412.757674] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 1b
03 00 00 01 4c 43 29 4e 33 02 4c 51 02 4d 8b 02 4d df 02 4e 33 90 47
85 e0 64 29 70 03 02 4d 28 90 7c 07 e0 24 fe 60 22 24 fe 60 30 24 fc
60 3e 87 0d
[ 2412.761812] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 1b 00 e4 ff
[ 2412.761822] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1152
[ 2412.761828] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 1c
03 00 00 01 4c 6c 29 24 f9 60 4c 24 0e 70 5a 90 49 75 e0 90 7c 05 f0
90 49 71 e0 90 7c 06 f0 80 58 90 49 74 e0 90 7c 05 f0 90 49 70 e0 90
7c 06 72 f5
[ 2412.766075] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 1c 00 e3 ff
[ 2412.766085] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1200
[ 2412.766091] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 1d
03 00 00 01 4c 95 29 f0 80 46 90 49 73 e0 90 7c 05 f0 90 49 6f e0 90
7c 06 f0 80 34 90 49 72 e0 90 7c 05 f0 90 49 6e e0 90 7c 06 f0 80 22
90 49 1a f6
[ 2412.770019] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 1d 00 e2 ff
[ 2412.770030] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1248
[ 2412.770036] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 1e
03 00 00 01 4c be 29 64 e0 90 7c 05 f0 90 49 63 e0 90 7c 06 f0 80 10
90 49 75 e0 90 7c 05 f0 90 49 71 e0 90 7c 06 f0 90 7c 06 e0 fd 90 7c
05 e0 f4 52
[ 2412.774185] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 1e 00 e1 ff
[ 2412.774197] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1296
[ 2412.774202] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 1f
03 00 00 01 4c e7 29 fb 7f 01 12 8c 76 90 7c 04 ef f0 12 8d 1d 90 7c
03 ef f0 a3 e0 60 03 02 4e cb 90 7c 03 e0 fd d3 94 00 50 03 02 4e cb
90 7c e5 72
[ 2412.780441] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 1f 00 e0 ff
[ 2412.780457] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1344
[ 2412.780464] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 20
03 00 00 01 4d 10 29 06 e0 fb 90 7c 05 e0 90 47 7f f0 7f 01 12 8d f1
90 7c 04 ef f0 02 4e cb 90 7c 03 74 05 f0 90 7c 07 e0 ff 24 fe 60 20
24 fe 86 3b
[ 2412.784385] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 20 00 df ff
[ 2412.784395] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1392
[ 2412.784402] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 21
03 00 00 01 4d 39 29 60 29 24 fc 60 32 24 f9 60 3b 24 0e 60 03 02 4e
cb 7f 01 12 4f 24 90 7c 04 ef f0 02 4e cb 7f 02 12 4f 24 90 7c 04 ef
f0 02 9f b1
[ 2412.788136] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 21 00 de ff
[ 2412.788147] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1440
[ 2412.788154] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 22
03 00 00 01 4d 62 29 4e cb 7f 03 12 4f 24 90 7c 04 ef f0 02 4e cb 7f
04 12 4f 24 90 7c 04 ef f0 02 4e cb 7f 05 12 4f 24 90 7c 04 ef f0 02
4e cb 25 5b
[ 2412.792525] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 22 00 dd ff
[ 2412.792534] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1488
[ 2412.792539] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 23
03 00 00 01 4d 8b 29 90 4b fb e0 ff 90 7c 05 f0 fb 90 49 76 e0 ff 90
7c 06 f0 fd e4 ff 12 8c 76 90 7c 04 ef f0 12 8d 1d 90 7c 03 ef f0 a3
e0 60 69 e7
[ 2412.796048] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 23 00 dc ff
[ 2412.796059] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1536
[ 2412.796226] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 24
03 00 00 01 4d b4 29 03 02 4e cb 90 7c 03 e0 fd d3 94 00 50 03 02 4e
cb 90 7c 06 e0 fb 90 7c 05 e0 90 47 7f f0 e4 ff 12 8d f1 90 7c 04 ef
f0 02 35 dc
[ 2412.800655] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 24 00 db ff
[ 2412.800664] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1584
[ 2412.800670] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 25
03 00 00 01 4d dd 29 4e cb 90 49 78 e0 ff 90 7c 05 f0 fb 90 49 76 e0
ff 90 7c 06 f0 fd e4 ff 12 8c 76 90 7c 04 ef f0 12 8d 1d 90 7c 03 ef
f0 a3 aa fe
[ 2412.804951] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 25 00 da ff
[ 2412.804961] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1632
[ 2412.804967] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 26
03 00 00 01 4e 06 29 e0 60 03 02 4e cb 90 7c 03 e0 fd d3 94 00 50 03
02 4e cb 90 7c 06 e0 fb 90 7c 05 e0 90 47 7f f0 e4 ff 12 8d f1 90 7c
04 ef 04 6b
[ 2412.808908] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 26 00 d9 ff
[ 2412.808917] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1680
[ 2412.808922] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 27
03 00 00 01 4e 2f 29 f0 02 4e cb 90 49 77 e0 ff 90 7c 05 f0 fb 90 49
76 e0 ff 90 7c 06 f0 fd e4 ff 12 8c 76 90 7c 04 ef f0 12 8d 1d 90 7c
03 ef 0b eb
[ 2412.813563] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 27 00 d8 ff
[ 2412.813576] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1728
[ 2412.813583] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 28
03 00 00 01 4e 58 29 f0 a3 e0 70 6e 90 7c 03 e0 fd d3 94 00 40 64 90
7c 06 e0 fb 90 7c 05 e0 90 47 7f f0 e4 ff 12 8d f1 90 7c 04 ef f0 80
4b 90 40 66
[ 2412.817862] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 28 00 d7 ff
[ 2412.817873] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1776
[ 2412.817879] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 29
03 00 00 01 4e 81 29 4b fb e0 ff 90 7c 05 f0 fb 90 49 76 e0 ff 90 7c
06 f0 fd e4 ff 12 8c 76 90 7c 04 ef f0 12 8d 1d 90 7c 03 ef f0 a3 e0
70 21 b1 01
[ 2412.821564] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 29 00 d6 ff
[ 2412.821575] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1824
[ 2412.821582] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 2a
03 00 00 01 4e aa 29 90 7c 03 e0 fd d3 94 00 40 17 90 7c 06 e0 fb 90
7c 05 e0 90 47 7f f0 e4 ff 12 8d f1 90 7c 04 ef f0 90 7c 04 e0 ff 60
25 90 3c 0c
[ 2412.825531] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 2a 00 d5 ff
[ 2412.825550] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1872
[ 2412.825556] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 2b
03 00 00 01 4e d3 29 7c 03 e0 fe 60 1e 14 90 f7 00 f0 90 47 86 e0 90
f7 01 f0 a3 ef f0 12 2f 1b 90 47 83 e0 70 31 ff 12 2f ab 22 90 7c 03
e0 fb 73 15
[ 2412.829901] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 2b 00 d4 ff
[ 2412.829911] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1920
[ 2412.829916] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 2c
03 00 00 01 4e fc 29 d3 94 00 40 22 7c f0 7d 00 7f 00 7e f7 12 a1 5f
90 f7 02 e0 60 07 e0 24 80 f0 12 2f 1b 90 47 83 e0 70 04 ff 12 2f ab
22 e4 05 2d
[ 2412.834124] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 2c 00 d3 ff
[ 2412.834137] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=1968
[ 2412.834145] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 2d
03 00 00 01 4f 25 29 90 7c 08 f0 ef 24 fe 60 1f 14 60 2e 14 60 3d 14
60 4c 24 04 70 58 90 49 75 e0 90 7c 09 f0 90 49 71 e0 90 7c 0a f0 80
46 90 11 9d
[ 2412.838460] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 2d 00 d2 ff
[ 2412.838471] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=2016
[ 2412.838477] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 2e
03 00 00 01 4f 4e 29 49 74 e0 90 7c 09 f0 90 49 70 e0 90 7c 0a f0 80
34 90 49 73 e0 90 7c 09 f0 90 49 6f e0 90 7c 0a f0 80 22 90 49 72 e0
90 7c 2a ed
[ 2412.842560] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 2e 00 d1 ff
[ 2412.842569] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=2064
[ 2412.842575] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 35 00 29 2f
03 00 00 01 4f 77 29 09 f0 90 49 6e e0 90 7c 0a f0 80 10 90 49 64 e0
90 7c 09 f0 90 49 63 e0 90 7c 0a f0 90 7c 0a e0 fd 90 7c 09 e0 fb 7f
01 12 8d ab
[ 2412.848796] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 2f 00 d0 ff
[ 2412.848807] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=2112
[ 2412.848814] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 34 00 29 30
03 00 00 01 4f a0 28 8c 76 90 7c 08 ef f0 70 19 90 7c 0a e0 fb 90 7c
09 e0 90 47 7f f0 7d 05 7f 01 12 8d f1 90 7c 08 ef f0 90 7c 08 e0 ff
22 f2 4a
[ 2412.852379] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 30 00 cf ff
[ 2412.852388] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=2159
[ 2412.852394] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0f 00 29 31
03 01 00 01 41 00 03 02 46 00 ca 49
[ 2412.856568] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 31 00 ce ff
[ 2412.856578] [1746] usb 1-1: af9035_download_firmware_new: data uploaded=2169
[ 2412.856582] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 05 00 23 32 cd dc
[ 2412.861223] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 32 00 cd ff
[ 2412.861234] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 06 00 22 33 01 cc dc
[ 2412.865607] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 08 33 00 01
04 00 00 cb fb
[ 2412.865620] usb 1-1: dvb_usb_af9035: firmware version=1.4.0.0
[ 2412.865639] usb 1-1: dvb_usb_v2: found a 'ITE 9303 Generic' in warm state
[ 2412.865644] [1746] usb 1-1: dvb_usbv2_init:
[ 2412.865648] [1746] usb 1-1: dvb_usbv2_device_power_ctrl: power=1
[ 2412.865652] [1746] usb 1-1: dvb_usbv2_i2c_init:
[ 2412.866029] usb 1-1: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[ 2412.866036] [1746] usb 1-1: dvb_usbv2_adapter_stream_init: adap=0
[ 2412.866041] [1746] usb 1-1: usb_alloc_stream_buffers: all in all I
will use 613632 bytes for streaming
[ 2412.866087] [1746] usb 1-1: usb_alloc_stream_buffers: alloc buf=0
ffff880078440000 (dma 2017722368)
[ 2412.866141] [1746] usb 1-1: usb_alloc_stream_buffers: alloc buf=1
ffff880077e80000 (dma 2011693056)
[ 2412.866192] [1746] usb 1-1: usb_alloc_stream_buffers: alloc buf=2
ffff88007b140000 (dma 2064908288)
[ 2412.866243] [1746] usb 1-1: usb_alloc_stream_buffers: alloc buf=3
ffff880076500000 (dma 1984954368)
[ 2412.866256] [1746] usb 1-1: usb_urb_alloc_bulk_urbs: alloc urb=0
[ 2412.866260] [1746] usb 1-1: usb_urb_alloc_bulk_urbs: alloc urb=1
[ 2412.866263] [1746] usb 1-1: usb_urb_alloc_bulk_urbs: alloc urb=2
[ 2412.866266] [1746] usb 1-1: usb_urb_alloc_bulk_urbs: alloc urb=3
[ 2412.866292] [1746] usb 1-1: dvb_usbv2_adapter_dvb_init: adap=0
[ 2412.866297] DVB: registering new adapter (ITE 9303 Generic)
[ 2412.874164] [1746] usb 1-1: dvb_usbv2_adapter_frontend_init: adap=0
[ 2412.874176] [1746] usb 1-1: adap->id=0
[ 2412.874181] [1746] usb 1-1: af9035_add_i2c_dev: num=0
[ 2412.885836] [1746] si2168 1-0067:
[ 2412.887918] i2c i2c-1: Added multiplexed i2c bus 2
[ 2412.887927] si2168 1-0067: Silicon Labs Si2168 successfully attached
[ 2412.887960] [1746] usb 1-1: dvb_register_frontend:
[ 2412.887964] usb 1-1: DVB: registering adapter 0 frontend 0 (Silicon
Labs Si2168)...
[ 2412.888087] [1746] usb 1-1: dvb_frontend_clear_cache: Clearing
cache for delivery system 3
[ 2412.888094] [1746] usb 1-1: it930x_tuner_attach: adap->id=0
[ 2412.888099] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0c 00 01 34
01 02 00 00 f6 a7 07 22 00
[ 2412.891869] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 34 00 cb ff
[ 2412.891901] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0c 00 01 35
01 02 00 00 f1 03 07 c5 05
[ 2412.895776] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 35 00 ca ff
[ 2412.895789] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 36
01 02 00 00 d8 d4 f3 26
[ 2412.900341] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 05 36 00 00 c9 ff
[ 2412.900351] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0c 00 01 37
01 02 00 00 d8 d4 01 f2 24
[ 2412.904137] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 37 00 c8 ff
[ 2412.904627] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 38
01 02 00 00 d8 d5 f0 26
[ 2412.907924] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 05 38 00 00 c7 ff
[ 2412.907936] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0c 00 01 39
01 02 00 00 d8 d5 01 ef 24
[ 2412.912185] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 39 00 c6 ff
[ 2412.912199] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 3a
01 02 00 00 d8 d3 f0 26
[ 2412.915879] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 05 3a 00 00 c5 ff
[ 2412.915890] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0c 00 01 3b
01 02 00 00 d8 d3 01 ef 24
[ 2412.918167] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 3b 00 c4 ff
[ 2412.918178] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 3c
01 02 00 00 d8 b8 09 26
[ 2412.922473] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 05 3c 00 00 c3 ff
[ 2412.922483] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0c 00 01 3d
01 02 00 00 d8 b8 01 08 24
[ 2412.926381] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 3d 00 c2 ff
[ 2412.926392] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 3e
01 02 00 00 d8 b9 06 26
[ 2412.932225] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 05 3e 00 00 c1 ff
[ 2412.932257] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0c 00 01 3f
01 02 00 00 d8 b9 01 05 24
[ 2412.937266] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 3f 00 c0 ff
[ 2412.937277] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 40
01 02 00 00 d8 b7 06 26
[ 2412.940333] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 05 40 00 00 bf ff
[ 2412.940345] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0c 00 01 41
01 02 00 00 d8 b7 00 05 25
[ 2412.944568] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 41 00 be ff
[ 2413.148215] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 00 42
01 02 00 00 d8 b7 04 26
[ 2413.151832] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 05 42 00 00 bd ff
[ 2413.151842] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0c 00 01 43
01 02 00 00 d8 b7 01 03 24
[ 2413.154591] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 43 00 bc ff
[ 2413.154602] [1746] usb 1-1: af9035_add_i2c_dev: num=1
[ 2413.162830] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 2b 44
03 03 ce c0 0d 01 f6 f6
[ 2413.165393] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 44 15 bb ea
[ 2413.165405] [1746] usb 1-1: af9035_ctrl_msg: command=2b failed fw error=21
[ 2413.165408] [1746] usb 1-1: af9035_ctrl_msg: failed=-5
[ 2413.165415] [1746] si2168 1-0067: failed=-5
[ 2413.165419] [1746] si2168 1-0067: failed=-5
[ 2413.165426] [1746] usb 1-1: dvb_usb_v2_generic_io: >>> 0b 00 2b 45
03 03 ce c0 0d 00 f6 f6
[ 2413.169508] [1746] usb 1-1: dvb_usb_v2_generic_io: <<< 04 45 15 ba ea
[ 2413.169519] [1746] usb 1-1: af9035_ctrl_msg: command=2b failed fw error=21
[ 2413.169522] [1746] usb 1-1: af9035_ctrl_msg: failed=-5
[ 2413.169528] [1746] si2168 1-0067: failed=-5
[ 2413.169531] [1746] si2168 1-0067: failed=-5
[ 2413.169536] [1746] si2157 2-0063: failed=-5
[ 2413.169539] [1746] si2157 2-0063: failed=-5
[ 2413.169553] si2157: probe of 2-0063 failed with error -5
[ 2413.169564] [1746] usb 1-1: af9035_add_i2c_dev: failed=-19
[ 2413.169567] [1746] usb 1-1: it930x_tuner_attach: failed=-19
[ 2413.169571] [1746] usb 1-1: dvb_usbv2_adapter_frontend_init:
tuner_attach() failed=-19
[ 2413.169575] [1746] usb 1-1: dvb_unregister_frontend:
[ 2413.169578] [1746] usb 1-1: dvb_frontend_stop:
[ 2413.170728] [1746] usb 1-1: dvb_usbv2_adapter_frontend_init: failed=-19
[ 2413.170733] [1746] usb 1-1: dvb_usbv2_adapter_init: failed=-19
[ 2413.170738] [1746] usb 1-1: dvb_usbv2_device_power_ctrl: power=0
[ 2413.170742] [1746] usb 1-1: dvb_usbv2_init: failed=-19
[ 2413.170745] [1746] usb 1-1: dvb_usbv2_exit:
[ 2413.170749] [1746] usb 1-1: dvb_usbv2_remote_exit:
[ 2413.170751] [1746] usb 1-1: dvb_usbv2_adapter_exit:
[ 2413.170755] [1746] usb 1-1: dvb_usbv2_adapter_dvb_exit: adap=0
[ 2413.174942] [1746] usb 1-1: dvb_usbv2_adapter_stream_exit: adap=0
[ 2413.174950] [1746] usb 1-1: usb_urb_free_urbs: free urb=3
[ 2413.174954] [1746] usb 1-1: usb_urb_free_urbs: free urb=2
[ 2413.174957] [1746] usb 1-1: usb_urb_free_urbs: free urb=1
[ 2413.174960] [1746] usb 1-1: usb_urb_free_urbs: free urb=0
[ 2413.174963] [1746] usb 1-1: usb_free_stream_buffers: free buf=3
[ 2413.174970] [1746] usb 1-1: usb_free_stream_buffers: free buf=2
[ 2413.174974] [1746] usb 1-1: usb_free_stream_buffers: free buf=1
[ 2413.174978] [1746] usb 1-1: usb_free_stream_buffers: free buf=0
[ 2413.174983] [1746] usb 1-1: dvb_usbv2_adapter_frontend_exit: adap=0
[ 2413.174987] [1746] usb 1-1: adap->id=0
[ 2413.174990] [1746] usb 1-1: af9035_frontend_detach: adap->id=0
[ 2413.174992] [1746] usb 1-1: af9035_del_i2c_dev: num=0
[ 2413.175032] [1746] si2168 1-0067:
[ 2413.181066] [1746] usb 1-1: dvb_usbv2_i2c_exit:
[ 2413.182354] [1746] usb 1-1: dvb_usbv2_probe: failed=-19
[ 2413.182413] usbcore: registered new interface driver dvb_usb_af9035
