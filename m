Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n14CbYwS025357
	for <video4linux-list@redhat.com>; Wed, 4 Feb 2009 07:37:34 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n14CbI6w029489
	for <video4linux-list@redhat.com>; Wed, 4 Feb 2009 07:37:18 -0500
Received: by yw-out-2324.google.com with SMTP id 5so815454ywb.81
	for <video4linux-list@redhat.com>; Wed, 04 Feb 2009 04:37:18 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Feb 2009 18:07:18 +0530
Message-ID: <ca6476860902040437h710ab4echd5e837502ce796d3@mail.gmail.com>
From: halli manjunatha <hallimanju@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Missing first 4 frames
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

Hi ,
       I am working on omap3 custom board and using the TI's camera patches
on 2.6.28 kernel  and the problem is that first 4 frames are coming 1/4 of
HVGA but i am capturing HVGA  images. after 4 frames everything is normal.

      I don't wether it is the right list to say this problem, please guid
me where to look, following is my register dump


###CM_FCLKEN_CAM=0x3
###CM_ICLKEN_CAM=0x1
###CM_CLKSEL_CAM=0x4
###CM_AUTOIDLE_CAM=0x1
###CM_CLKEN_PLL[18:16] should be 0x7, = 0x90371037
###CM_CLKSEL2_PLL[18:8] should be 0x2D, [6:0] should be 1 = 0x1b00c
###CTRL_PADCONF_CAM_HS=0x1080108
###CTRL_PADCONF_CAM_XCLKA=0x1080108
###CTRL_PADCONF_CAM_D1=0x1000100
###CTRL_PADCONF_CAM_D3=0x1080100
###CTRL_PADCONF_CAM_D5=0x1080108
###CTRL_PADCONF_CAM_D7=0x1080108
###CTRL_PADCONF_CAM_D9=0x1080108
###CTRL_PADCONF_CAM_D11=0x108
###ISP_CTRL=0x3bf188
###ISP_TCTRL_CTRL=0x9
###ISP_SYSCONFIG=0x2000
###ISP_SYSSTATUS=0x1
###ISP_IRQ0ENABLE=0x90000300
###ISP_IRQ0STATUS=0x0
###CCDC PCR=0x1
ISP_CTRL =0x3bf188
###ISP_CTRL in ccdc =0x3bf188
###ISP_IRQ0ENABLE in ccdc =0x90000300
###ISP_IRQ0STATUS in ccdc =0x0
###CCDC SYN_MODE=0x31700
###CCDC HORZ_INFO=0x13f
###CCDC VERT_START=0x0
###CCDC VERT_LINES=0x1df
###CCDC CULLING=0xffff00ff
###CCDC HSIZE_OFF=0x280
###CCDC SDOFST=0x0
###CCDC SDR_ADDR=0x4000000
###CCDC CLAMP=0x10
###CCDC COLPTN=0x0
###CCDC CFG=0x8000
###CCDC VP_OUT=0x0
###CCDC_SDR_ADDR= 0x4000000
###CCDC FMTCFG=0x4000
###CCDC FMT_HORZ=0x0
###CCDC FMT_VERT=0x0
###CCDC LSC_CONFIG=0x6600
###CCDC LSC_INIT=0x0
###CCDC LSC_TABLE BASE=0x0
###CCDC LSC TABLE OFFSET=0x0

Thanks in advance
-- 
Regards

Hall
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
