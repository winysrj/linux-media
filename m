Return-path: <mchehab@pedra>
Received: from mout.perfora.net ([74.208.4.195]:51228 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab1APW0h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 17:26:37 -0500
Message-ID: <4D337098.50009@vorgon.com>
Date: Sun, 16 Jan 2011 15:26:32 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: too few arguments   to function 'i2c_new_probed_device'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-09/msg12477.html

hg v4l today (01/16/2011). Doesn't do it when using linux-2.6.34 x64, 
but when trying to compile under linux-2.6.37 on a 32bit:

/usr/local/dvb/drivers/v4l-20110116/v4l-dvb/v4l/bttv-i2c.c: In function 
'init_bttv_i2c_ir':
/usr/local/dvb/drivers/v4l-20110116/v4l-dvb/v4l/bttv-i2c.c:437: error: 
too few arguments to function 'i2c_new_probed_device'
make[3]: *** 
[/usr/local/dvb/drivers/v4l-20110116/v4l-dvb/v4l/bttv-i2c.o] Error 1
make[2]: *** [_module_/usr/local/dvb/drivers/v4l-20110116/v4l-dvb/v4l] 
Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.37'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/local/dvb/drivers/v4l-20110116/v4l-dvb/v4l'
make: *** [all] Error 2
