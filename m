Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f13.google.com ([209.85.220.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <2manybills@gmail.com>) id 1LT0mw-0000xm-BV
	for linux-dvb@linuxtv.org; Fri, 30 Jan 2009 22:20:36 +0100
Received: by fxm6 with SMTP id 6so434394fxm.17
	for <linux-dvb@linuxtv.org>; Fri, 30 Jan 2009 13:20:00 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 30 Jan 2009 21:20:00 +0000
Message-ID: <157f4a8c0901301320h37c23997n9dbf193a2ee57a39@mail.gmail.com>
From: Chris Silva <2manybills@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] V4L-DVB fails to compile - I2C_DRIVERID_TVMIXER
Reply-To: linux-media@vger.kernel.org
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

Since yesterday, v4l-dvb fails to compile for me with:

  CC [M]  /usr/local/src/v4l-dvb/v4l/tvmixer.o
/usr/local/src/v4l-dvb/v4l/tvmixer.c:226: error:
'I2C_DRIVERID_TVMIXER' undeclared here (not in a function)
make[3]: *** [/usr/local/src/v4l-dvb/v4l/tvmixer.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [_module_/usr/local/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.27-11-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/local/src/v4l-dvb/v4l'
make: *** [all] Error 2

Ubuntu 8.10:
Linux version 2.6.27-11-generic - gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11)

BTW, some observed warnings, unrelated, I suppose:

  CC [M]  /usr/local/src/v4l-dvb/v4l/pvrusb2-hdw.o
/usr/local/src/v4l-dvb/v4l/pvrusb2-hdw.c: In function 'pvr2_hdw_setup_low':
/usr/local/src/v4l-dvb/v4l/pvrusb2-hdw.c:1993: warning: format not a
string literal and no format arguments

[...]

  CC [M]  /usr/local/src/v4l-dvb/v4l/pvrusb2-std.o
/usr/local/src/v4l-dvb/v4l/pvrusb2-std.c: In function 'pvr2_std_id_to_str':
/usr/local/src/v4l-dvb/v4l/pvrusb2-std.c:220: warning: format not a
string literal and no format arguments

[...]

  CC [M]  /usr/local/src/v4l-dvb/v4l/zoran_card.o
/usr/local/src/v4l-dvb/v4l/zoran_card.c: In function 'zoran_probe':
/usr/local/src/v4l-dvb/v4l/zoran_card.c:1422: warning: format not a
string literal and no format arguments
/usr/local/src/v4l-dvb/v4l/zoran_card.c:1442: warning: format not a
string literal and no format arguments
/usr/local/src/v4l-dvb/v4l/zoran_card.c:1466: warning: format not a
string literal and no format arguments
/usr/local/src/v4l-dvb/v4l/zoran_card.c:1478: warning: format not a
string literal and no format arguments

[...]

  CC [M]  /usr/local/src/v4l-dvb/v4l/v4l1-compat.o
/usr/local/src/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_i2c_new_subdev':
/usr/local/src/v4l-dvb/v4l/v4l2-common.c:947: warning: format not a
string literal and no format arguments
/usr/local/src/v4l-dvb/v4l/v4l2-common.c: In function
'v4l2_i2c_new_probed_subdev':
/usr/local/src/v4l-dvb/v4l/v4l2-common.c:1008: warning: format not a
string literal and no format arguments

[...]

  CC [M]  /usr/local/src/v4l-dvb/v4l/tvaudio.o
/usr/local/src/v4l-dvb/v4l/tvaudio.c: In function 'tvaudio_probe':
/usr/local/src/v4l-dvb/v4l/tvaudio.c:1928: warning: format not a
string literal and no format arguments

Chris

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
