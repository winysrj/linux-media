Return-path: <mchehab@pedra>
Received: from postfix.mbigroup.it ([84.233.239.88]:43421 "EHLO
	postfix.mbigroup.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab1BXObF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 09:31:05 -0500
Received: from localhost (localhost [127.0.0.1])
	by postfix.mbigroup.it (Postfix) with ESMTP id AE1D9499B3
	for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 15:25:07 +0100 (CET)
Received: from postfix.mbigroup.it ([127.0.0.1])
	by localhost (postfix.mbigroup.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c7tS3ja6eXWs for <linux-media@vger.kernel.org>;
	Thu, 24 Feb 2011 15:24:59 +0100 (CET)
Received: from mailserver0.bo.mbigroup.it (mailserver0.bo.mbigroup.it [192.168.10.30])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by postfix.mbigroup.it (Postfix) with ESMTPS id 62BC8499B2
	for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 15:24:59 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mailserver0.bo.mbigroup.it (Postfix) with ESMTP id 352A2C2059
	for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 15:24:59 +0100 (CET)
Received: from mailserver0.bo.mbigroup.it ([127.0.0.1])
	by localhost (mailserver0.bo.mbigroup.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B0aNoRiqUgzF for <linux-media@vger.kernel.org>;
	Thu, 24 Feb 2011 15:24:59 +0100 (CET)
Received: from vnocciolini.dev.mbigroup.it (vnocciolini.dev.mbigroup.it [192.168.21.13])
	by mailserver0.bo.mbigroup.it (Postfix) with ESMTP id EF3DFC1FF8
	for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 15:24:58 +0100 (CET)
Message-ID: <4D666A3A.1090701@mbigroup.it>
Date: Thu, 24 Feb 2011 15:24:58 +0100
From: Vinicio Nocciolini <vnocciolini@mbigroup.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: ec168-9295d36ab66e compiling error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all

I have problem compiling the project

regards Vinicio

----------------------------------------------------------------------------------------------------------- 


   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/vc032x.o
   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/zc3xx.o
   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hdpvr-control.o
   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hdpvr-core.o
   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hdpvr-video.o
   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hopper_cards.o
   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hopper_vp3028.o
   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-functions.o
   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.o
/home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.c: In function 
'__ir_input_register':
/home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.c:452:24: 
warning: assignment from incompatible pointer type
/home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.c:453:24: 
warning: assignment from incompatible pointer type
   CC [M]  /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.o
/home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.c: In function 
'ir_register_class':
/home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.c:268:23: error: 
'ir_raw_dev_type' undeclared (first use in this function)
/home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.c:268:23: note: 
each undeclared identifier is reported only once for each function it 
appears in
make[3]: *** [/home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.o] 
Error 1
make[2]: *** [_module_/home/vinicio/Desktop/ec168-9295d36ab66e/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.35.11-83.fc14.i686'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/vinicio/Desktop/ec168-9295d36ab66e/v4l'
make: *** [all] Error 2








[vinicio@localhost ec168-9295d36ab66e]$  cat /etc/issue
Fedora release 14 (Laughlin)
Kernel \r on an \m (\l)
