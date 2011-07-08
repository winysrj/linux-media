Return-path: <mchehab@localhost>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <danzax69@yahoo.gr>) id 1Qf6J1-0003YY-UU
	for linux-dvb@linuxtv.org; Fri, 08 Jul 2011 10:21:00 +0200
Received: from nm16-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.254])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with smtp
	for <linux-dvb@linuxtv.org>
	id 1Qf6J1-0004GY-I6; Fri, 08 Jul 2011 10:20:59 +0200
Message-ID: <1310113258.80136.YahooMailClassic@web28316.mail.ukl.yahoo.com>
Date: Fri, 8 Jul 2011 09:20:58 +0100 (BST)
From: Giwrgos Panou <danzax69@yahoo.gr>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] No Modules load after successfully build on Fedora/SUSE
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
Sender: <mchehab@infradead.org>
List-ID: <linux-dvb@linuxtv.org>

Hello,
I've successfully built and load the driver on Ubuntu(11.04) and Mint(11) several times, and the module for my card(pinnacle USB hybrid stick 330e) loads and works fine.
The problem is that the module doesn't load on other than ubuntu based distros that I've tested(fedora 15, suse 11.4).
The build is successfull in both situations, but after a reboot the card still don't recognized and the appropriate devices don't created.
I've tried to load the driver manually by sudo modprobe em28xx and in both fedora and SUSE I get this error:
------------------------------------------------------------------
WARNING: Error inserting media (/lib/modules/2.6.37.6-0.5-desktop/kernel/drivers/linux/drivers/media/media.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting videodev (/lib/modules/2.6.37.6-0.5-desktop/kernel/drivers/media/video/videodev.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting v4l2_common (/lib/modules/2.6.37.6-0.5-desktop/kernel/drivers/media/video/v4l2-common.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting em28xx (/lib/modules/2.6.37.6-0.5-desktop/kernel/drivers/media/video/em28xx/em28xx.ko): Unknown symbol in module, or unknown parameter (see dmesg)
-----------------------------------------------------------------------

dmesg related output is:
-----------------------------------------------------------------------
As the driver is backported to an older kernel, it doesn't offer
[    7.759153] 	enough quality for its usage in production.
[    7.759154] 	Use it with care.
[    7.759154] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
[    7.759156] 	6068c012c3741537c9f965be5b4249f989aa5efc [media] v4l: Document V4L2 control endianness as machine endianness
[    7.759157] 	17b4298fc89c655a7560fb9e141a3df9e893cad3 [media] adp1653: Add driver for LED flash controller
[    7.759158] 	87912f37ac3c1107ce5d0457eaf417fd491e3671 [media] v4l: Add flash control documentation
[    7.828489] IR NEC protocol handler initialized
--------------------------------------------------------------------
 v4l2_compat_ioctl32: Unknown symbol put_compat_timespec (err 0)
--------------------------------------------------------------------

The kernel version of Fedora is 2.6.38(same with Ubuntu's in which works fine) and of SUSE 2.6.37

Is there something more that needed to be done for these Distros??

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
