Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.infomir.com.ua ([79.142.192.5] helo=infomir.com.ua)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdp@teletec.com.ua>) id 1KW7Vv-0006gC-6a
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 12:35:36 +0200
Received: from [10.128.0.10] (iptv.infomir.com.ua [79.142.192.146])
	by infomir.com.ua with ESMTP id 1KW7Vr-0003CJ-3H
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 13:35:31 +0300
Message-ID: <48AD44F2.5050502@teletec.com.ua>
Date: Thu, 21 Aug 2008 13:35:30 +0300
From: Dmitry Podyachev <vdp@teletec.com.ua>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Help installing with S2-3200 or with TW1034
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

Problem with /dev/dvb/adapterX/ca0 at Twinhan-1034 with CI and with
Technotrend S2-3200+CI.
I try http://www.twinhan.com/files/AW/Linux/AZLinux_v1.4.2_CI_FC6.tar.gz
and http://www.twinhan.com/files/AW/Linux/AZLinux_v1.5_CI_FC6.tar.gz
but not on Fedora6,but with the same linux-kernel: linux-2.6.18.2-34 and
linux-2.6.23.1. CI don't work (invalid PC card inserted message)
the same CAM-module (viaccess red label) and chip card ("poverhnost")
worked properly with Skystar1-ci.
Next I installed last v4l and try it with kernel 2.6.23.1-42,
linux-2.6.26 and linux-2.6.27:

git clone
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git

hg clone http://jusst.de/hg/multiproto_plus
hg clone http://linuxtv.org/hg/v4l-dvb
hg clone http://linuxtv.org/hg/dvb-apps

then try other
hg clone http://jusst.de/hg/multiproto
and multiproto_plus

and always cp /usr/src/linux-next/.config /tmp
make mrproper
cp /tmp/.config .
make clean;make bzImage;make modules;make modules_install;make install
&& reboot

when I try load budget_ci or saa, message like that:
modprobe saa7134
WARNING: Error inserting compat_ioctl32
(/lib/modules/2.6.27-rc1-git/kernel/drivers/media/video/compat_ioctl32.ko):
Invalid module format
WARNING: Error inserting v4l1_compat
(/lib/modules/2.6.27-rc1-git/kernel/drivers/media/video/v4l1-compat.ko):
Invalid argument
WARNING: Error inserting videodev
(/lib/modules/2.6.27-rc1-git/kernel/drivers/media/video/videodev.ko):
Invalid module format
The relevant part of dmesg:
kernel: compat_ioctl32: exports duplicate symbol v4l_compat_ioctl32
(owned by kernel)
kernel: v4l1_compat: module is already loaded
kernel: videodev: exports duplicate symbol video_device_alloc (owned by
kernel)

or with en50221 - invalid pc card inserted

everywhere I have't successful result.
Next I try mantis v4l and here stb0899 error

Can anybody help me out with my installation? I've tried both the latest
git (linux-next) and v4l2, mantis_v4l. I have no idea what to do.

Thank you in advance, Dmitry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
