Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38560 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab0EORU6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 13:20:58 -0400
Received: by fxm6 with SMTP id 6so2464734fxm.19
        for <linux-media@vger.kernel.org>; Sat, 15 May 2010 10:20:57 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 15 May 2010 19:20:55 +0200
Message-ID: <AANLkTilcusOnh6VdNR5Rvkd1wvSPLb2D7-EX5Ryy-LVz@mail.gmail.com>
Subject: 2.6.29 additional build errors
From: =?UTF-8?Q?Samuel_Rakitni=C4=8Dan?= <samuel.rakitnican@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Additional build errors found after disabling the non building modules
on todays mercurial tree.

Best regards,
Samuel


bash-3.1# uname -r
2.6.29.6-smp


  CC [M]  /root/v4l-dvb/v4l/saa7134-input.o
/root/v4l-dvb/v4l/saa7134-input.c: In function 'saa7134_set_i2c_ir':
/root/v4l-dvb/v4l/saa7134-input.c:1016: error:
'ir_codes_pinnacle_color_table' undeclared (first use in this
function)
/root/v4l-dvb/v4l/saa7134-input.c:1016: error: (Each undeclared
identifier is reported only once
/root/v4l-dvb/v4l/saa7134-input.c:1016: error: for each function it appears in.)
/root/v4l-dvb/v4l/saa7134-input.c:1025: error:
'ir_codes_pinnacle_grey_table' undeclared (first use in this function)
/root/v4l-dvb/v4l/saa7134-input.c:1037: error:
'ir_codes_purpletv_table' undeclared (first use in this function)
/root/v4l-dvb/v4l/saa7134-input.c:1049: error:
'ir_codes_msi_tvanywhere_plus_table' undeclared (first use in this
function)
/root/v4l-dvb/v4l/saa7134-input.c:1069: error:
'ir_codes_hauppauge_new_table' undeclared (first use in this function)
/root/v4l-dvb/v4l/saa7134-input.c:1095: error: 'ir_codes_behold_table'
undeclared (first use in this function)
/root/v4l-dvb/v4l/saa7134-input.c:1114: error: 'ir_codes_flydvb_table'
undeclared (first use in this function)
make[3]: *** [/root/v4l-dvb/v4l/saa7134-input.o] Error 1
make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.29.6'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/v4l-dvb/v4l'
make: *** [all] Error 2



  CC [M]  /root/v4l-dvb/v4l/soc_camera.o
/root/v4l-dvb/v4l/soc_camera.c:27:30: error: linux/pm_runtime.h: No
such file or directory
/root/v4l-dvb/v4l/soc_camera.c: In function 'soc_camera_open':
/root/v4l-dvb/v4l/soc_camera.c:392: error: implicit declaration of
function 'pm_runtime_enable'
/root/v4l-dvb/v4l/soc_camera.c:393: error: implicit declaration of
function 'pm_runtime_resume'
/root/v4l-dvb/v4l/soc_camera.c:422: error: implicit declaration of
function 'pm_runtime_disable'
/root/v4l-dvb/v4l/soc_camera.c: In function 'soc_camera_close':
/root/v4l-dvb/v4l/soc_camera.c:448: error: implicit declaration of
function 'pm_runtime_suspend'
make[3]: *** [/root/v4l-dvb/v4l/soc_camera.o] Error 1
make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.29.6'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/v4l-dvb/v4l'
make: *** [all] Error 2



  CC [M]  /root/v4l-dvb/v4l/em28xx-cards.o
/root/v4l-dvb/v4l/em28xx-cards.c: In function 'em28xx_set_ir':
/root/v4l-dvb/v4l/em28xx-cards.c:2410: error:
'ir_codes_em_terratec_table' undeclared (first use in this function)
/root/v4l-dvb/v4l/em28xx-cards.c:2410: error: (Each undeclared
identifier is reported only once
/root/v4l-dvb/v4l/em28xx-cards.c:2410: error: for each function it appears in.)
/root/v4l-dvb/v4l/em28xx-cards.c:2422: error:
'ir_codes_pinnacle_grey_table' undeclared (first use in this function)
/root/v4l-dvb/v4l/em28xx-cards.c:2434: error:
'ir_codes_rc5_hauppauge_new_table' undeclared (first use in this
function)
/root/v4l-dvb/v4l/em28xx-cards.c:2445: error:
'ir_codes_winfast_usbii_deluxe_table' undeclared (first use in this
function)
make[3]: *** [/root/v4l-dvb/v4l/em28xx-cards.o] Error 1
make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.29.6'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/v4l-dvb/v4l'
make: *** [all] Error 2
