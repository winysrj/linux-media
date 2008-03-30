Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <daniel.akerud@gmail.com>) id 1JfxEx-0000LV-Na
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 15:06:29 +0200
Received: by wf-out-1314.google.com with SMTP id 28so1072849wfa.17
	for <linux-dvb@linuxtv.org>; Sun, 30 Mar 2008 06:06:19 -0700 (PDT)
Message-ID: <b000da060803300606n49a3106dj26efdd1b50e5d7c0@mail.gmail.com>
Date: Sun, 30 Mar 2008 15:06:19 +0200
From: "=?ISO-8859-1?Q?daniel_=E5kerud?=" <daniel.akerud@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] problem loading modules for pvr-150,
	exports duplicate symbols
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1888885678=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1888885678==
Content-Type: multipart/alternative;
	boundary="----=_Part_19836_5687738.1206882379295"

------=_Part_19836_5687738.1206882379295
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I did an hg pull a few weeks ago and have since then problems loading
drivers for my pvr-150 card. The first error message comes when v4l2_common
is loaded:
  FATAL: Error inserting v4l2_common
(/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/v4l2-common.ko):
Invalid module format
dmesg reveals:
  [ 3259.775779] v4l2_common: exports duplicate symbol v4l_printk_ioctl
(owned by videodev)

Trying to unload videodev and then loading it works, but the ivtv module
seems to require the symbols exported by videodev:
da@brutus:~$ sudo modprobe -r videodev
da@brutus:~$ sudo modprobe v4l2_common
da@brutus:~$ sudo modprobe ivtv
WARNING: Error inserting videodev
(/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/videodev.ko):
Invalid module format
FATAL: Error inserting ivtv
(/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/ivtv/ivtv.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
and dmesg reveals:
[ 3346.365132] ivtv: Unknown symbol video_unregister_device
[ 3346.365189] ivtv: Unknown symbol video_device_alloc
[ 3346.365242] ivtv: Unknown symbol video_register_device
[ 3346.365507] ivtv: Unknown symbol video_usercopy
[ 3346.365553] ivtv: Unknown symbol video_device_release

now loading videodev again this happens:
da@brutus:~$ sudo modprobe videodev
FATAL: Error inserting videodev
(/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/videodev.ko):
Invalid module format

dmesg reveals:
[ 3385.071755] videodev: exports duplicate symbol v4l_printk_ioctl (owned by
v4l2_common)

I have done make clean which didn't solve it. Any help is appreciated. I am
running trunk v4l-dvb drivers on ubuntu 7.10. The problem appeard about 2
weeks ago.

/D

------=_Part_19836_5687738.1206882379295
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I did an hg pull a few weeks ago and have since then problems loading drivers for my pvr-150 card. The first error message comes when v4l2_common is loaded:<br>&nbsp; FATAL: Error inserting v4l2_common (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/v4l2-common.ko): Invalid module format<br>
dmesg reveals:<br>&nbsp; [ 3259.775779] v4l2_common: exports duplicate symbol v4l_printk_ioctl (owned by videodev)<br><br>Trying to unload videodev and then loading it works, but the ivtv module seems to require the symbols exported by videodev:<br>
da@brutus:~$ sudo modprobe -r videodev<br>da@brutus:~$ sudo modprobe v4l2_common<br>da@brutus:~$ sudo modprobe ivtv<br>WARNING: Error inserting videodev (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/videodev.ko): Invalid module format<br>
FATAL: Error inserting ivtv (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/ivtv/ivtv.ko): Unknown symbol in module, or unknown parameter (see dmesg)<br>and dmesg reveals:<br>[ 3346.365132] ivtv: Unknown symbol video_unregister_device<br>
[ 3346.365189] ivtv: Unknown symbol video_device_alloc<br>[ 3346.365242] ivtv: Unknown symbol video_register_device<br>[ 3346.365507] ivtv: Unknown symbol video_usercopy<br>[ 3346.365553] ivtv: Unknown symbol video_device_release<br>
<br>now loading videodev again this happens:<br>da@brutus:~$ sudo modprobe videodev<br>FATAL: Error inserting videodev (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/videodev.ko): Invalid module format<br><br>
dmesg reveals:<br>[ 3385.071755] videodev: exports duplicate symbol v4l_printk_ioctl (owned by v4l2_common)<br><br>I have done make clean which didn&#39;t solve it. Any help is appreciated. I am running trunk v4l-dvb drivers on ubuntu 7.10. The problem appeard about 2 weeks ago.<br>
<br>/D<br><br><br>

------=_Part_19836_5687738.1206882379295--


--===============1888885678==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1888885678==--
