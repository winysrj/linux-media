Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:41859 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752608Ab3AVOwE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 09:52:04 -0500
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1TxedA-0007C2-Lc
	for linux-media@vger.kernel.org; Tue, 22 Jan 2013 06:15:16 -0800
Message-ID: <50FE9EF2.6060206@seiner.com>
Date: Tue, 22 Jan 2013 06:15:14 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [cx231xx] Support for Arm / Omap working at all?
References: <5AFD6ADC04BAC644902876711A98009E43BC3C18@ASCTECSBS2.asctec.local>	<201301211053.43912.hverkuil@xs4all.nl>	<5AFD6ADC04BAC644902876711A98009E43BCBC54@ASCTECSBS2.asctec.local> <CAGoCfiw1oSohcU=LBUxco6A2EmuNi649YiQFPgjnG1r0E4rZmw@mail.gmail.com>
In-Reply-To: <CAGoCfiw1oSohcU=LBUxco6A2EmuNi649YiQFPgjnG1r0E4rZmw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Jan 22, 2013 at 4:38 AM, Jan Stumpf <Jan.Stumpf@asctec.de> wrote:
>   
>> Thanks!
>>
>> I will try it with your patches!
>>
>> Regards
>> Jan
>>     
>
> FYI:  the cx231xx driver has worked in the past on ARM platforms,
> although I haven't tried the USBLive2 on OMAP specifically.  In fact,
> I merged the original driver support upstream as part of a project I
> did while developing a product that has it running on ARM.
>
> You may wish to try whatever kernel you have on an x86 platform, as
> people have a history of introducing regressions for the USBLive 2 in
> the past (I've fixed it multiple times since I originally submitted
> the support upstream).  It's possible that it's broken on x86 as well,
> and has nothing to do with your being on ARM at all.
>
> Regards,
>
> Devin
>
>   
I submitted this patch some time ago.  It fixes the driver for 
endiannes.  Without it will try to allocate some random amount of 
memory.  It was in the kernel for a little then it disappeared....

diff -U3 
/data10/home/yan/openwrt/backfire/trunk/build_dir/linux-brcm47xx/linux-3.0.3/drivers/media/video/cx231xx/cx231xx-pcb-cfg.c 
cx231xx-pcb-cfg.c
--- 
/data10/home/yan/openwrt/backfire/trunk/build_dir/linux-brcm47xx/linux-3.0.3/drivers/media/video/cx231xx/cx231xx-pcb-cfg.c    
2011-08-17 10:57:16.000000000 -0700
+++ cx231xx-pcb-cfg.c    2011-12-13 05:50:36.000000000 -0800
@@ -672,7 +672,9 @@
    pcb config it is related to */
    cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT, data, 4);

-    config_info = *((u32 *) data);
+    //config_info = *((u32 *) data);
+    config_info = ((u32)(*(data))) + (((u32)(*(data+1))) << 8) + 
(((u32)(*(data+2))) << 16) + (((u32)(*(data+3))) << 24);
+    cx231xx_info("config_info %x\n",config_info);
    usb_speed = (u8) (config_info & 0x1);

    /* Verify this device belongs to Bus power or Self power device */


