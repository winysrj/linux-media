Return-path: <linux-media-owner@vger.kernel.org>
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:17378
	"EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbaJPHNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 03:13:09 -0400
From: Rodney Baker <rodney.baker@iinet.net.au>
To: Linux-Media <linux-media@vger.kernel.org>
Reply-To: rodney.baker@iinet.net.au
Subject: Kernel 3.17.0 broke xc4000-based DTV1800h
Date: Thu, 16 Oct 2014 17:33:51 +1030
Message-ID: <1637119.5DTscVEVRC@mako>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since installing kernel 3.17.0-1.gc467423-desktop (on openSuSE 13.1) my 
xc4000/zl10353/cx88 based DTV card has failed to initialise on boot.

The following messages are from dmesg; 

[   78.468221] xc4000: I2C read failed
[   80.074604] xc4000: I2C read failed
[   80.074605] Unable to read tuner registers.
[   82.622062] Selecting best matching firmware (7 bits differ) for type=(0), 
id 000000200000b700:
[   82.626375] i2c i2c-0: sendbytes: NAK bailout.
[  148.063594] xc4000: I2C read failed
[  149.669994] xc4000: I2C read failed
[  149.669995] Unable to read tuner registers.
[  149.670198] cx88[0]/0: registered device video1 [v4l2]
[  149.670287] cx88[0]/0: registered device vbi0
[  149.670338] cx88[0]/0: registered device radio0
[  149.670340] cx88[0]/0: failed to create cx88 audio thread, err=-4
[  149.670382] cx88[0]/2: cx2388x based DVB/ATSC card
[  149.670384] cx8802_alloc_frontends() allocating 1 frontend(s)
[  149.670515] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[  151.305364] zl10353_read_register: readreg error (reg=127, ret==-6)
[  151.305367] cx88[0]/2: frontend initialization failed
[  151.305369] cx88[0]/2: dvb_register failed (err = -22)
[  151.305370] cx88[0]/2: cx8802 probe failed, err = -22

It worked with 3.16.3-1.gd2bbe7f-desktop on the same machine.

Regards,
Rodney.

-- 
==============================================================
Rodney Baker VK5ZTV
rodney.baker@iinet.net.au
==============================================================
