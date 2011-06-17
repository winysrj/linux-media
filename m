Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:46810 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab1FQJFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 05:05:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QXUz9-0002Cb-TL
	for linux-media@vger.kernel.org; Fri, 17 Jun 2011 11:05:03 +0200
Received: from a170-143.dialup.iol.cz ([194.228.143.170])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 17 Jun 2011 11:05:03 +0200
Received: from xhpohanka by a170-143.dialup.iol.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 17 Jun 2011 11:05:03 +0200
To: linux-media@vger.kernel.org
From: "Jan Pohanka" <xhpohanka@gmail.com>
Subject: at91sam9g20 - image sensor interface - mt9v011 image sensor
Date: Fri, 17 Jun 2011 10:57:11 +0200
Message-ID: <op.vw7ptl18yxxkfz@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I'm trying to get working the combination from mail subject. Unfortunately  
there is no driver for atmel isi interface in current kernel (2.6.39.1),  
but I discovered a recent patch from Josh Wu, which is adding the support  
for the similar atmel interface (ISI v2) as my chip has. I have modified  
it to work with ISI v1, and now I would like to test it.

I have only the mt9v011 CMOS chip but if I understand it right its driver  
provided in kernel is not soc_camera based, which is needed by the driver.  
Is my observation correct? I think I will have to modify the drivers for  
similar sensor to support mt9v011.

I also wanted to try my ISI driver with some artificial data, but no  
/dev/video* device appeared. I'm not sure if it is an udev issue (Linux  
video capture interface: v2.00, and ISI drivers are loaded) but reading  
 from node created by mknod /dev/videox c 81 0 returns 'no such device or  
address'

Could please someone give me any advice? It is my first experience with  
v4l drivers, so excuse me if my questions are silly.

best regards
Jan

-- 
Tato zpráva byla vytvořena převratným poštovním klientem Opery:  
http://www.opera.com/mail/

