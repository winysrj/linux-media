Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9NKDF7n000578
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 16:13:15 -0400
Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9NKBOdv013345
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 16:11:32 -0400
Received: from localhost (localhost.lie-comtel.li [127.0.0.1])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id 580069FEC42
	for <video4linux-list@redhat.com>;
	Thu, 23 Oct 2008 21:11:24 +0100 (GMT-1)
Received: from [192.168.0.16] (217-173-228-198.cmts.powersurf.li
	[217.173.228.198])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id 003C99FEC11
	for <video4linux-list@redhat.com>;
	Thu, 23 Oct 2008 21:11:23 +0100 (GMT-1)
Message-ID: <4900DA6B.4050902@kaiser-linux.li>
Date: Thu, 23 Oct 2008 22:11:23 +0200
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: Video 4 Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: gspca, what do I am wrong?
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

Hey

I think this mail came not through, so I send it again. Sorry, when it 
comes twice.

I just pasted the interesting things into this email (With some comments
inline). Hope somebody can help:

thomas@LAPI01:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 8.04.1
Release:	8.04
Codename:	hardy

thomas@LAPI01:~$ uname -a
Linux LAPI01 2.6.24-21-generic #1 SMP Mon Aug 25 17:32:09 UTC 2008 i686
GNU/Linux

thomas@LAPI01:~/Projects/webcams$ hg clone http://linuxtv.org/hg/v4l-dvb
to get the newest v4l source.

make menuconfig in ~/Projects/webcams/v4l-dvb and remove all stuff
except the gspca and V4l2.
After this, I did not find a .config file in the
~/Projects/webcams/v4l-dvb folder. Where is the .config stored?
Several dvb and/or analog capture driver where made. Why?, I disabled!

thomas@LAPI01:~/Projects/webcams/v4l-dvb$ make
¨make -C /home/thomas/Projects/webcams/v4l-dvb/v4l
make[1]: Entering directory `/home/thomas/Projects/webcams/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.24-21-generic/build
make -C /lib/modules/2.6.24-21-generic/build
SUBDIRS=/home/thomas/Projects/webcams/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.24-21-generic'
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/m5602_s5k83a.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/m5602_s5k4aa.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/mars.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/ov519.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/pac207.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/pac7311.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/sonixb.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/sonixj.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/spca500.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/spca501.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/spca505.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/spca506.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/spca508.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/spca561.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/stk014.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/sunplus.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/t613.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tv8532.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/vc032x.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/zc3xx.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/msp3400-driver.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/msp3400-kthreads.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/uvc_driver.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/uvc_queue.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/uvc_v4l2.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/uvc_video.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/uvc_ctrl.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/uvc_status.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/uvc_isight.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/v4l2-dev.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/v4l2-ioctl.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/videodev.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/compat_ioctl32.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/v4l2-int-device.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/v4l2-common.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tvaudio.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tda7432.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tda9875.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tda9840.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tea6415c.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tea6420.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/saa7115.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/saa717x.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/saa7127.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tvp5150.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/msp3400.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/cs5345.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/cs53l32a.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/m52790.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tlv320aic23b.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/wm8775.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/wm8739.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/vp27smpx.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/cx25840.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/upd64031a.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/upd64083.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/cx2341x.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/ov7670.o
   CC [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tcm825x.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_main.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_conex.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_etoms.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_finepix.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_mars.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_ov519.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_pac207.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_pac7311.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_sonixb.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_sonixj.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca500.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca501.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca505.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca506.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca508.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca561.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_sunplus.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_stk014.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_t613.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_tv8532.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_vc032x.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_zc3xx.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_m5602.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/uvcvideo.o
   Building modules, stage 2.
   MODPOST 61 modules
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/compat_ioctl32.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/compat_ioctl32.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/cs5345.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/cs5345.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/cs53l32a.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/cs53l32a.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/cx2341x.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/cx2341x.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/cx25840.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/cx25840.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_conex.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_conex.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_etoms.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_etoms.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_finepix.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_finepix.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_m5602.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_m5602.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_main.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_main.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_mars.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_mars.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_ov519.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_ov519.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_pac207.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_pac207.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_pac7311.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_pac7311.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_sonixb.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_sonixb.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_sonixj.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_sonixj.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca500.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca500.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca501.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca501.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca505.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca505.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca506.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca506.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca508.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca508.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca561.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_spca561.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_stk014.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_stk014.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_sunplus.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_sunplus.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_t613.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_t613.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_tv8532.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_tv8532.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_vc032x.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_vc032x.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_zc3xx.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/gspca_zc3xx.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/m52790.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/m52790.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/msp3400.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/msp3400.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/mt20xx.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/mt20xx.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/ov7670.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/ov7670.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/saa7115.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/saa7115.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/saa7127.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/saa7127.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/saa717x.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/saa717x.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tcm825x.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tcm825x.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tda7432.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tda7432.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tda8290.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tda8290.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tda9840.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tda9840.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tda9875.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tda9875.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tda9887.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tda9887.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tea5761.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tea5761.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tea5767.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tea5767.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tea6415c.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tea6415c.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tea6420.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tea6420.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tlv320aic23b.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tlv320aic23b.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tuner-simple.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tuner-simple.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tuner-types.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tuner-types.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tuner-xc2028.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tuner-xc2028.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tvaudio.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tvaudio.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/tvp5150.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/tvp5150.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/upd64031a.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/upd64031a.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/upd64083.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/upd64083.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/uvcvideo.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/uvcvideo.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/v4l2-common.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/v4l2-common.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/v4l2-int-device.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/v4l2-int-device.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/videodev.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/videodev.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/vp27smpx.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/vp27smpx.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/wm8739.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/wm8739.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/wm8775.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/wm8775.ko
   CC      /home/thomas/Projects/webcams/v4l-dvb/v4l/xc5000.mod.o
   LD [M]  /home/thomas/Projects/webcams/v4l-dvb/v4l/xc5000.ko
make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-21-generic'
./scripts/rmmod.pl check
found 61 modules
make[1]: Leaving directory `/home/thomas/Projects/webcams/v4l-dvb/v4l'
thomas@LAPI01:~/Projects/webcams/v4l-dvb$ sudo make install
[sudo] password for thomas:
make -C /home/thomas/Projects/webcams/v4l-dvb/v4l install
make[1]: Entering directory `/home/thomas/Projects/webcams/v4l-dvb/v4l'
Stripping debug info from files
-e
Removing obsolete files from
/lib/modules/2.6.24-21-generic/kernel/drivers/media/video:
mt20xx.ko tea5761.ko tda8290.ko tuner-simple.ko tea5767.ko
-e
Removing obsolete files from
/lib/modules/2.6.24-21-generic/kernel/drivers/media/dvb/frontends:
mt2131.ko tda827x.ko mt2266.ko qt1010.ko mt2060.ko
Installing kernel modules under
/lib/modules/2.6.24-21-generic/kernel/drivers/media/:
	video/gspca/m5602/: gspca_m5602.ko
	common/tuners/: tuner-xc2028.ko tda9887.ko mt20xx.ko
		xc5000.ko tea5761.ko tuner-types.ko
		tda8290.ko tuner-simple.ko tea5767.ko
	video/: upd64083.ko tda9840.ko cx2341x.ko
		wm8775.ko tvaudio.ko tea6420.ko
		msp3400.ko tcm825x.ko wm8739.ko
		tda7432.ko upd64031a.ko tea6415c.ko
		videodev.ko tda9875.ko cs53l32a.ko
		saa7115.ko v4l2-common.ko tvp5150.ko
		vp27smpx.ko ov7670.ko saa7127.ko
		m52790.ko compat_ioctl32.ko v4l2-int-device.ko
		cs5345.ko saa717x.ko tlv320aic23b.ko
	video/cx25840/: cx25840.ko
	video/gspca/: gspca_pac207.ko gspca_stk014.ko gspca_spca501.ko
		gspca_spca500.ko gspca_mars.ko gspca_spca508.ko
		gspca_t613.ko gspca_sunplus.ko gspca_vc032x.ko
		gspca_spca561.ko gspca_tv8532.ko gspca_spca505.ko
		gspca_spca506.ko gspca_sonixj.ko gspca_zc3xx.ko
		gspca_main.ko gspca_conex.ko gspca_pac7311.ko
		gspca_sonixb.ko gspca_ov519.ko gspca_finepix.ko
		gspca_etoms.ko
	video/uvc/: uvcvideo.ko
/sbin/depmod -a 2.6.24-21-generic
make[1]: Leaving directory `/home/thomas/Projects/webcams/v4l-dvb/v4l'

After plugging the cam in the kernel log:

Oct 23 20:52:54 LAPI01 kernel: [ 2015.905111] usb 1-1: new full speed
USB device using uhci_hcd and address 5
Oct 23 20:52:54 LAPI01 kernel: [ 2016.075400] usb 1-1: configuration #1
chosen from 1 choice
Oct 23 20:52:54 LAPI01 kernel: [ 2016.078879] usb 1-1: ZC0301[P] Image
Processor and Control Chip detected (vid/pid 0x041E:0x401C)
Oct 23 20:52:55 LAPI01 kernel: [ 2016.164172] usb 1-1: No supported
image sensor detected
Oct 23 20:52:55 LAPI01 kernel: [ 2016.194043] gspca_main: disagrees
about version of symbol video_ioctl2
Oct 23 20:52:55 LAPI01 kernel: [ 2016.194061] gspca_main: Unknown symbol
video_ioctl2
Oct 23 20:52:55 LAPI01 kernel: [ 2016.194447] gspca_main: disagrees
about version of symbol video_devdata
Oct 23 20:52:55 LAPI01 kernel: [ 2016.194451] gspca_main: Unknown symbol
video_devdata
Oct 23 20:52:55 LAPI01 kernel: [ 2016.194782] gspca_main: disagrees
about version of symbol video_unregister_device
Oct 23 20:52:55 LAPI01 kernel: [ 2016.194786] gspca_main: Unknown symbol
video_unregister_device
Oct 23 20:52:55 LAPI01 kernel: [ 2016.194857] gspca_main: disagrees
about version of symbol video_register_device
Oct 23 20:52:55 LAPI01 kernel: [ 2016.194860] gspca_main: Unknown symbol
video_register_device
Oct 23 20:52:55 LAPI01 kernel: [ 2016.199050] gspca_zc3xx: Unknown
symbol gspca_frame_add
Oct 23 20:52:55 LAPI01 kernel: [ 2016.199193] gspca_zc3xx: Unknown
symbol gspca_debug
Oct 23 20:52:55 LAPI01 kernel: [ 2016.199546] gspca_zc3xx: Unknown
symbol gspca_disconnect
Oct 23 20:52:55 LAPI01 kernel: [ 2016.199674] gspca_zc3xx: Unknown
symbol gspca_resume
Oct 23 20:52:55 LAPI01 kernel: [ 2016.199797] gspca_zc3xx: Unknown
symbol gspca_dev_probe
Oct 23 20:52:55 LAPI01 kernel: [ 2016.199924] gspca_zc3xx: Unknown
symbol gspca_suspend
Oct 23 20:52:55 LAPI01 kernel: [ 2016.231335]
/build/buildd/linux-ubuntu-modules-2.6.24-2.6.24/debian/build/build-generic/media/gspcav1/gspca_core.c: 

USB GSPCA camera found.(ZC3XX)
Oct 23 20:52:55 LAPI01 kernel: [ 2016.425349] usbcore: registered new
interface driver gspca
Oct 23 20:52:55 LAPI01 kernel: [ 2016.425364]
/build/buildd/linux-ubuntu-modules-2.6.24-2.6.24/debian/build/build-generic/media/gspcav1/gspca_core.c: 

gspca driver 01.00.20 registered


When I use a custom build kernel the gspca module does work, but I would
like to use it with the standard Ubuntu kernel.

Hope anybody can help me.

Thomas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
