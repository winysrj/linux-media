Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1Jcq6P-0003W4-NV
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 23:52:46 +0100
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
Date: Fri, 21 Mar 2008 22:51:50 +0000
Message-Id: <1206139910.12138.34.camel@youkaida>
Mime-Version: 1.0
Subject: [linux-dvb] Nova-T-500 disconnects - They are back!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Guys,

I have upgraded my system to the new Ubuntu (8.04 Hardy), using 2.6.24,
64-bit.

And the disconnects are back.

I was using a rather ancient v4l-dvb tree, so I grabbed a new one, and
saw no improvement.

It may be very well linked to the remote, I was recording anything when
this one struck, just using the remote.

I may even have been tuned on the neighbouring cx88 DVB-S card.


Mar 21 21:57:54 favia kernel: [ 7283.416866] dib0700: Unknown remote controller key:  9  0  1  0
Mar 21 21:58:05 favia kernel: [ 7294.501676] dib0700: Unknown remote controller key:  9  0  1  0
Mar 21 21:58:08 favia kernel: [ 7297.111367] usb 10-1: USB disconnect, address 2
Mar 21 21:58:08 favia lircd-0.8.3pre1[5982]: error reading '/dev/input/event6'
Mar 21 21:58:08 favia lircd-0.8.3pre1[5982]: caught signal
Mar 21 21:58:08 favia lircd-0.8.3pre1[5982]: closing '/dev/input/event6'
Mar 21 21:58:08 favia kernel: [ 7297.154576] mt2060 I2C write failed
Mar 21 21:58:08 favia NetworkManager: <debug> [1206136688.229829] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_2040_9950_4028166400_logicaldev_input'). 
Mar 21 21:58:09 favia kernel: [ 7298.074147] mt2060 I2C write failed (len=2)
Mar 21 21:58:09 favia kernel: [ 7298.074153] mt2060 I2C write failed (len=6)
Mar 21 21:58:09 favia kernel: [ 7298.074156] mt2060 I2C read failed
Mar 21 21:58:09 favia kernel: [ 7298.082072] mt2060 I2C read failed
Mar 21 21:58:09 favia kernel: [ 7298.090025] mt2060 I2C read failed
Mar 21 21:58:09 favia kernel: [ 7298.098098] mt2060 I2C read failed
Mar 21 21:58:09 favia kernel: [ 7298.106028] mt2060 I2C read failed
Mar 21 21:58:09 favia kernel: [ 7298.114051] mt2060 I2C read failed
Mar 21 21:58:09 favia kernel: [ 7298.122059] mt2060 I2C read failed
Mar 21 21:58:09 favia kernel: [ 7298.129494] mt2060 I2C read failed
Mar 21 21:58:09 favia kernel: [ 7298.137497] mt2060 I2C read failed
Mar 21 21:58:09 favia kernel: [ 7298.145993] mt2060 I2C read failed
Mar 21 21:58:10 favia kernel: [ 7299.292331] mt2060 I2C write failed (len=2)
Mar 21 21:58:10 favia kernel: [ 7299.292337] mt2060 I2C write failed (len=6)
Mar 21 21:58:10 favia kernel: [ 7299.292340] mt2060 I2C read failed
Mar 21 21:58:10 favia kernel: [ 7299.300318] mt2060 I2C read failed
Mar 21 21:58:10 favia kernel: [ 7299.308313] mt2060 I2C read failed
Mar 21 21:58:10 favia kernel: [ 7299.317636] mt2060 I2C read failed
Mar 21 21:58:10 favia kernel: [ 7299.328044] mt2060 I2C read failed
Mar 21 21:58:10 favia kernel: [ 7299.332266] mt2060 I2C read failed
Mar 21 21:58:10 favia kernel: [ 7299.341351] mt2060 I2C read failed
Mar 21 21:58:10 favia kernel: [ 7299.348291] mt2060 I2C read failed


dmesg, lsusb -v, lspci -vvv in here:

http://www.youplala.net/~will/htpc/disconnects/

The system is described there:

http://www.youplala.net/linux/home-theater-pc

I have 

options dvb-usb-dib0700 force_lna_activation=1
options options usbcore autosuspend=-1

in /etc/modprobe.d/options

I remain available for any testing and documenting this new step back.

Nico
hopes that the F1 Grand Prix will be recorded tonight :o/


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
