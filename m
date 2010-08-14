Return-path: <mchehab@pedra>
Received: from mp1-smtp-6.eutelia.it ([62.94.10.166]:57753 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933471Ab0HNIAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Aug 2010 04:00:14 -0400
Received: from [192.168.1.170] (ip-132-14.sn-213-198.eutelia.it [213.198.132.14])
	by smtp.eutelia.it (Eutelia) with ESMTP id 4164D5D257D
	for <linux-media@vger.kernel.org>; Sat, 14 Aug 2010 09:34:59 +0200 (CEST)
Message-ID: <4C664723.9070303@gmail.com>
Date: Sat, 14 Aug 2010 09:34:59 +0200
From: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Error building v4l
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Building the v4l, I obtain the following error:


home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c: In 
function 'mceusb_dev_probe':
/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c:923: 
error: implicit declaration of function 'usb_alloc_coherent'
/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c:923: 
warning: assignment makes pointer from integer without a cast
/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c:1003: 
error: implicit declaration of function 'usb_free_coherent'
make[3]: *** 
[/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.o] Error 1
make[2]: *** 
[_module_/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-24-generic'
make[1]: *** [default] Errore 2
make[1]: uscita dalla directory 
«/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l»
make: *** [all] Errore 2

My system is a Kubuntu 10.04 amd64 with kernel 2.6.32-24-generic 
#39-Ubuntu SMP Wed Jul 28 05:14:15 UTC 2010 x86_64 GNU/Linux

How can I solve?
Thank you,
Xwang

