Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vivichrist@gmail.com>) id 1LdPDj-0007xt-2W
	for linux-dvb@linuxtv.org; Sat, 28 Feb 2009 14:27:13 +0100
Received: by ti-out-0910.google.com with SMTP id j2so2134156tid.13
	for <linux-dvb@linuxtv.org>; Sat, 28 Feb 2009 05:27:04 -0800 (PST)
Message-ID: <49A93B9E.4010401@gmail.com>
Date: Sun, 01 Mar 2009 02:26:54 +1300
From: vivian stewart <vivichrist@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1235732401.7326.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1235732401.7326.linux-dvb@linuxtv.org>
Subject: [linux-dvb] HVR3000 v4l no longer compiles with any branch and/or
	patch in 64bitOS
Reply-To: linux-media@vger.kernel.org, vivichrist@gmail.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2092114403=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============2092114403==
Content-Type: multipart/alternative;
 boundary="------------090903060806090609060800"

This is a multi-part message in MIME format.
--------------090903060806090609060800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I get this error when compiling v4l-dvb 7285 and 7879 (can't find patch 
via the links, their in the tmp directory?) under ubuntu hardy 
2.6.24-23-rt amd64:

/home/vivy/v4l-dvb/v4l/saa7134-video.c: In function 'saa7134_s_fmt_overlay':
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1674: error: size of array 'type 
name' is negative
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1674: warning: comparison of 
distinct pointer types lacks a cast
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1677: error: size of array 'type 
name' is negative
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1677: warning: comparison of 
distinct pointer types lacks a cast
make[3]: *** [/home/vivy/v4l-dvb/v4l/saa7134-video.o] Error 1
make[2]: *** [_module_/home/vivy/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-23-rt'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/vivy/v4l-dvb/v4l'
make: *** [all] Error 2

which compiled and worked before I had to reinstall (from 32bit to 
64bit)ubuntu from scratch. think I mite be missing some installed source 
code somewhere or is not amd64 compatible code.
as for 8894 I think I remember it compiling but just no dvb-s even 
though its mfe. dvb-s is really what I want

--------------090903060806090609060800
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
<font face="snap.se">I get this error when compiling v4l-dvb 7285</font><font
 face="snap.se"> and 7879</font><font face="snap.se"> (</font><font
 face="snap.se">can't find patch via the links, their in the tmp
directory?) under ubuntu hardy 2.6.24-23-rt amd64:</font><br>
<br>
/home/vivy/v4l-dvb/v4l/saa7134-video.c: In function
'saa7134_s_fmt_overlay':<br>
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1674: error: size of array 'type
name' is negative<br>
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1674: warning: comparison of
distinct pointer types lacks a cast<br>
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1677: error: size of array 'type
name' is negative<br>
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1677: warning: comparison of
distinct pointer types lacks a cast<br>
make[3]: *** [/home/vivy/v4l-dvb/v4l/saa7134-video.o] Error 1<br>
make[2]: *** [_module_/home/vivy/v4l-dvb/v4l] Error 2<br>
make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-23-rt'<br>
make[1]: *** [default] Error 2<br>
make[1]: Leaving directory `/home/vivy/v4l-dvb/v4l'<br>
make: *** [all] Error 2<br>
<br>
which compiled and worked before I had to reinstall (from 32bit to
64bit)ubuntu from scratch. think I mite be missing some installed
source code somewhere or is not amd64 compatible code.<br>
as for 8894 I think I remember it compiling but just no dvb-s even
though its mfe. dvb-s is really what I want<br>
</body>
</html>

--------------090903060806090609060800--


--===============2092114403==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2092114403==--
