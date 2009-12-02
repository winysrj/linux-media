Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nB2Gv0jZ012198
	for <video4linux-list@redhat.com>; Wed, 2 Dec 2009 11:57:00 -0500
Received: from mail-fx0-f215.google.com (mail-fx0-f215.google.com
	[209.85.220.215])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nB2GuhEo010168
	for <video4linux-list@redhat.com>; Wed, 2 Dec 2009 11:56:44 -0500
Received: by fxm7 with SMTP id 7so436128fxm.29
	for <video4linux-list@redhat.com>; Wed, 02 Dec 2009 08:56:42 -0800 (PST)
MIME-Version: 1.0
From: David Carlo <dcarlo@swillers.com>
Date: Wed, 2 Dec 2009 11:56:22 -0500
Message-ID: <bba9c7410912020856p5ebf561bh7160f7cd16aa28b8@mail.gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Subject: Compile Error - ir-keytable
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello.  I'm compiling the v4l kernel drivers in an attempt to use my hdpvr
with CentOS 5.4.  When I compile v4l, I'm getting this error:

=============================================================================
<snip>
  CC [M]  /usr/local/src/v4l-dvb/v4l/ir-functions.o
  CC [M]  /usr/local/src/v4l-dvb/v4l/ir-keymaps.o
  CC [M]  /usr/local/src/v4l-dvb/v4l/ir-keytable.o
/usr/local/src/v4l-dvb/v4l/ir-keytable.c: In function
'ir_g_keycode_from_table':
/usr/local/src/v4l-dvb/v4l/ir-keytable.c:181: error: implicit declaration of
function 'input_get_drvdata'
/usr/local/src/v4l-dvb/v4l/ir-keytable.c:181: warning: initialization makes
pointer from integer without a cast
/usr/local/src/v4l-dvb/v4l/ir-keytable.c: In function 'ir_input_free':
/usr/local/src/v4l-dvb/v4l/ir-keytable.c:236: warning: initialization makes
pointer from integer without a cast
make[3]: *** [/usr/local/src/v4l-dvb/v4l/ir-keytable.o] Error 1
make[2]: *** [_module_/usr/local/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.18-164.6.1.el5-x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/local/src/v4l-dvb/v4l'
make: *** [all] Error 2
=============================================================================

Here are the stats on my box:
  CentOS 5.4 x86_64
  kernel 2.6.18-164.6.1.el5-x86_64
  gcc 4.1.2

Has anyone else seen this?

    --Dave
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
