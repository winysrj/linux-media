Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:47392 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaDYVeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Apr 2014 17:34:16 -0400
Received: by mail-vc0-f178.google.com with SMTP id hu19so5440584vcb.37
        for <linux-media@vger.kernel.org>; Fri, 25 Apr 2014 14:34:15 -0700 (PDT)
Received: from [192.168.25.238] ([177.19.81.144])
        by mx.google.com with ESMTPSA id xr10sm11455293vec.2.2014.04.25.14.34.13
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 25 Apr 2014 14:34:14 -0700 (PDT)
From: Roberto Alcantara <roberto@eletronica.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Subject: Help to solve compile errors in smsusb driver.
Message-Id: <F721A259-EEC8-4531-AA3A-E10F58ED4120@eletronica.org>
Date: Fri, 25 Apr 2014 18:34:03 -0300
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guys,

I’m trying to compile most recent Siano drivers with old kernel tree (3.4.75 linux-sunxi). The module seems compile but final linker (?) give me a few errors. 

smsendian_handle_tx_message is in media/common/siano/smsendian.c as expected.  All tips are appreciated  ;-)

Thank you !
- Roberto


robertoalcantara@ubuntu:/media/robertoalcantara/awsom-linux-sunxi/linux-sunxi$ ./build.sh -p awsom20

		Using previous  config file .config.awsom20
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHK     kernel/config_data.h
  CC [M]  drivers/gpu/mali/ump/../mali/linux/mali_osk_atomics.o
  CC [M]  drivers/gpu/mali/ump/../mali/linux/mali_osk_locks.o
  CC [M]  drivers/gpu/mali/ump/../mali/linux/mali_osk_memory.o
  CC [M]  drivers/media/dvb/siano/smsusb.o
  CC [M]  drivers/gpu/mali/ump/../mali/linux/mali_osk_math.o
  CC [M]  drivers/gpu/mali/ump/../mali/linux/mali_osk_misc.o
  LD [M]  drivers/gpu/mali/ump/ump.o
  Kernel: arch/arm/boot/Image is ready
  Building modules, stage 2.
  Kernel: arch/arm/boot/zImage is ready
  Image arch/arm/boot/uImage is ready
  MODPOST 138 modules
ERROR: "smsendian_handle_tx_message" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smscore_registry_getmode" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "sms_board_load_modules" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smscore_start_device" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smscore_set_board_id" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smscore_register_device" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "sms_get_board" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smscore_translate_msg" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smscore_onresponse" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smsendian_handle_rx_message" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smsendian_handle_message_header" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smscore_getbuffer" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smscore_unregister_device" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "smscore_putbuffer" [drivers/media/dvb/siano/smsusb.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
robertoalcantara@ubuntu:/media/robertoalcantara/awsom-linux-sunxi/linux-sunxi$ 