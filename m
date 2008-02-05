Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15JVKoW011290
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 14:31:20 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.175])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m15JUx8N016162
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 14:30:59 -0500
Received: by ug-out-1314.google.com with SMTP id t39so260867ugd.6
	for <video4linux-list@redhat.com>; Tue, 05 Feb 2008 11:30:59 -0800 (PST)
Message-ID: <9e52368f0802051130v68e63072m892cb084f081f61e@mail.gmail.com>
Date: Tue, 5 Feb 2008 14:30:57 -0500
From: "De Ash" <deeash099@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: build fail
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

Folks,

I am using kernel  2.6.24  from kernel.org.
Checked out v4l-dvb and the make fails with the following ..
Would appereciate help with this.

 CC [M]  /usr/src/v4l-dvb/v4l/sn9c102_tas5110c1b.o
  CC [M]  /usr/src/v4l-dvb/v4l/sn9c102_tas5110d.o
  CC [M]  /usr/src/v4l-dvb/v4l/sn9c102_tas5130d1b.o
  CC [M]  /usr/src/v4l-dvb/v4l/bt87x.o
In file included from /usr/src/v4l-dvb/v4l/bt87x.c:34:
include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in a
function)
make[3]: *** [/usr/src/v4l-dvb/v4l/bt87x.o] Error 1
make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernel-2.6.24/linux-2.6.24'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
make: *** [all] Error 2
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
