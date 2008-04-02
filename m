Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <daniel.akerud@gmail.com>) id 1JhAoV-0003lp-Hy
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 23:48:12 +0200
Received: by wf-out-1314.google.com with SMTP id 28so2840386wfa.17
	for <linux-dvb@linuxtv.org>; Wed, 02 Apr 2008 14:47:55 -0700 (PDT)
Message-ID: <b000da060804021447i741236c0r40d78295c2644efd@mail.gmail.com>
Date: Wed, 2 Apr 2008 23:47:55 +0200
From: "=?ISO-8859-1?Q?daniel_=E5kerud?=" <daniel.akerud@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <b000da060803300606n49a3106dj26efdd1b50e5d7c0@mail.gmail.com>
MIME-Version: 1.0
References: <b000da060803300606n49a3106dj26efdd1b50e5d7c0@mail.gmail.com>
Subject: Re: [linux-dvb] problem loading modules for pvr-150,
	exports duplicate symbols
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2077000889=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2077000889==
Content-Type: multipart/alternative;
	boundary="----=_Part_111_20614309.1207172875645"

------=_Part_111_20614309.1207172875645
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sun, Mar 30, 2008 at 3:06 PM, daniel =E5kerud <daniel.akerud@gmail.com>
wrote:

> I did an hg pull a few weeks ago and have since then problems loading
> drivers for my pvr-150 card. The first error message comes when v4l2_comm=
on
> is loaded:
>   FATAL: Error inserting v4l2_common
> (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/v4l2-common.ko=
):
> Invalid module format
> dmesg reveals:
>   [ 3259.775779] v4l2_common: exports duplicate symbol v4l_printk_ioctl
> (owned by videodev)
>
> Trying to unload videodev and then loading it works, but the ivtv module
> seems to require the symbols exported by videodev:
> da@brutus:~$ sudo modprobe -r videodev
> da@brutus:~$ sudo modprobe v4l2_common
> da@brutus:~$ sudo modprobe ivtv
> WARNING: Error inserting videodev
> (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/videodev.ko):
> Invalid module format
> FATAL: Error inserting ivtv
> (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/ivtv/ivtv.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> and dmesg reveals:
> [ 3346.365132] ivtv: Unknown symbol video_unregister_device
> [ 3346.365189] ivtv: Unknown symbol video_device_alloc
> [ 3346.365242] ivtv: Unknown symbol video_register_device
> [ 3346.365507] ivtv: Unknown symbol video_usercopy
> [ 3346.365553] ivtv: Unknown symbol video_device_release
>
> now loading videodev again this happens:
> da@brutus:~$ sudo modprobe videodev
> FATAL: Error inserting videodev
> (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/videodev.ko):
> Invalid module format
>
> dmesg reveals:
> [ 3385.071755] videodev: exports duplicate symbol v4l_printk_ioctl (owned
> by v4l2_common)
>
> I have done make clean which didn't solve it. Any help is appreciated. I
> am running trunk v4l-dvb drivers on ubuntu 7.10. The problem appeard abou=
t
> 2 weeks ago.
>
> /D
>
>
>
For future reference, if anyone gets this problem, I found the solution
here:
https://bugs.launchpad.net/ubuntu/+source/gspca/+bug/160814
ReInstalling all the headers and image for current kernel worked for me.

/D

------=_Part_111_20614309.1207172875645
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sun, Mar 30, 2008 at 3:06 PM, daniel =E5kerud &lt;<a href=3D"mailto:dani=
el.akerud@gmail.com">daniel.akerud@gmail.com</a>&gt; wrote:<br><div class=
=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"border-left: 1p=
x solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I did an hg pull a few weeks ago and have since then problems loading drive=
rs for my pvr-150 card. The first error message comes when v4l2_common is l=
oaded:<br>&nbsp; FATAL: Error inserting v4l2_common (/lib/modules/2.6.22-14=
-generic/kernel/drivers/media/video/v4l2-common.ko): Invalid module format<=
br>

dmesg reveals:<br>&nbsp; [ 3259.775779] v4l2_common: exports duplicate symb=
ol v4l_printk_ioctl (owned by videodev)<br><br>Trying to unload videodev an=
d then loading it works, but the ivtv module seems to require the symbols e=
xported by videodev:<br>

da@brutus:~$ sudo modprobe -r videodev<br>da@brutus:~$ sudo modprobe v4l2_c=
ommon<br>da@brutus:~$ sudo modprobe ivtv<br>WARNING: Error inserting videod=
ev (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/videodev.ko):=
 Invalid module format<br>

FATAL: Error inserting ivtv (/lib/modules/2.6.22-14-generic/kernel/drivers/=
media/video/ivtv/ivtv.ko): Unknown symbol in module, or unknown parameter (=
see dmesg)<br>and dmesg reveals:<br>[ 3346.365132] ivtv: Unknown symbol vid=
eo_unregister_device<br>

[ 3346.365189] ivtv: Unknown symbol video_device_alloc<br>[ 3346.365242] iv=
tv: Unknown symbol video_register_device<br>[ 3346.365507] ivtv: Unknown sy=
mbol video_usercopy<br>[ 3346.365553] ivtv: Unknown symbol video_device_rel=
ease<br>

<br>now loading videodev again this happens:<br>da@brutus:~$ sudo modprobe =
videodev<br>FATAL: Error inserting videodev (/lib/modules/2.6.22-14-generic=
/kernel/drivers/media/video/videodev.ko): Invalid module format<br><br>

dmesg reveals:<br>[ 3385.071755] videodev: exports duplicate symbol v4l_pri=
ntk_ioctl (owned by v4l2_common)<br><br>I have done make clean which didn&#=
39;t solve it. Any help is appreciated. I am running trunk v4l-dvb drivers =
on ubuntu 7.10. The problem appeard about 2 weeks ago.<br>
<font color=3D"#888888">
<br>/D<br><br><br>
</font></blockquote></div><br>For future reference, if anyone gets this pro=
blem, I found the solution here:<br><a href=3D"https://bugs.launchpad.net/u=
buntu/+source/gspca/+bug/160814">https://bugs.launchpad.net/ubuntu/+source/=
gspca/+bug/160814</a><br>
ReInstalling all the headers and image for current kernel worked for me. <b=
r><br>/D<br><br>

------=_Part_111_20614309.1207172875645--


--===============2077000889==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2077000889==--
