Return-path: <linux-media-owner@vger.kernel.org>
Received: from svr1.mitlab.de ([46.4.219.213]:52306 "EHLO mail.mitlab.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978Ab1KQMfs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 07:35:48 -0500
Received: from [192.168.220.100] ([85.16.235.123]:44719)
	by mail.mitlab.de with [XMail 1.27 ESMTP Server]
	id <S6DD08> for <linux-media@vger.kernel.org> from <ralf.moeller@mitlab.de>;
	Thu, 17 Nov 2011 13:27:32 +0100
Message-ID: <4EC4FDB4.2050104@mitlab.de>
Date: Thu, 17 Nov 2011 13:27:32 +0100
From: Ralf Moeller <ralf.moeller@mitlab.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: problems getting v4l to start
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I tried to compile v4l media_build in case of getting a dvb-t card to run.
(it uses saa7134)

when i made "make install" and reboot, it says the module saa7134 have
unknown symbols.

then I tried it by removing older dvb/v4l support from my customkernel 
(2.6.37.2)
rebuild media_build again, but same problem. modprobe says error about 
unknown
symbols and with dmesg there is written "saa7134: unknown parameter index"

what went wrong ?
is there help available ?

kind regards,
ralf moeller

-- 
MOELLER IT ELECTRONICS
Ralf Moeller
SchlachthofStr. 12A
D-27576 Bremerhaven
Telefon : +49-471-3095737
Mailbox : +49-471-3069320
Mobil   : +49-178-1483064
http://www.mitlab.de

