Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBPJax1e024770
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 14:36:59 -0500
Received: from outbound.mail.nauticom.net (outbound.mail.nauticom.net
	[72.22.18.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBPJagp7024890
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 14:36:42 -0500
Received: from [192.168.0.124] (27.craf1.xdsl.nauticom.net [209.195.160.60])
	(authenticated bits=0)
	by outbound.mail.nauticom.net (8.13.8/8.13.8) with ESMTP id
	mBPJadmc022011
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 14:36:40 -0500 (EST)
From: Rick Bilonick <rab@nauticom.net>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Dec 2008 14:36:34 -0500
Message-Id: <1230233794.3450.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Compiling v4l-dvb-kernel for Ubuntu and for F8
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

I'm trying to get em28xx working under Ubuntu and F8, but when I "make"
I get errors saying that dmxdev.h, dvb_demux.h, dvb_net.h, and
dvb_frontend.h cannot be found.

I get the same errors in F7 with v4l-dvb-experimental (same with
v4l-dvb-kernel):

[root@localhost v4l-dvb-experimental]# make

running ./build.sh build

make[1]: Entering directory `/usr/local/src/v4l-dvb-experimental'
rm -rf Module.symvers; 
make -C /lib/modules/`if [ -d /lib/modules/2.6.21.4-eeepc ]; then echo
2.6.21.4-eeepc; else uname -r; fi`/build SUBDIRS=`pwd` modules
make[2]: Entering directory `/usr/src/kernels/2.6.26.6-49.fc8-i686'
  CC [M]  /usr/local/src/v4l-dvb-experimental/em2880-dvb.o
In file included
from /usr/local/src/v4l-dvb-experimental/em2880-dvb.c:33:
/usr/local/src/v4l-dvb-experimental/em28xx.h:31:20: error: dmxdev.h: No
such file or directory
/usr/local/src/v4l-dvb-experimental/em28xx.h:32:23: error: dvb_demux.h:
No such file or directory
/usr/local/src/v4l-dvb-experimental/em28xx.h:33:21: error: dvb_net.h: No
such file or directory
/usr/local/src/v4l-dvb-experimental/em28xx.h:34:26: error:
dvb_frontend.h: No such file or directory
In file included
from /usr/local/src/v4l-dvb-experimental/em2880-dvb.c:33:
/usr/local/src/v4l-dvb-experimental/em28xx.h:557: error: field ‘demux’
has incomplete type
/usr/local/src/v4l-dvb-experimental/em28xx.h:565: error: field ‘adapter’
has incomplete type
/usr/local/src/v4l-dvb-experimental/em28xx.h:568: error: field ‘dmxdev’
has incomplete type
/usr/local/src/v4l-dvb-experimental/em28xx.h:570: error: field ‘dvbnet’
has incomplete type
In file included
from /usr/local/src/v4l-dvb-experimental/em2880-dvb.c:40:
/usr/local/src/v4l-dvb-experimental/mt352/mt352.h: In function
‘mt352_write’:

I'm not sure what is missing. I followed all the steps (same set of
steps at several web sites, one was
http://mcentral.de/wiki/index.php5/Em2880 )

Any help would be appreciated.

Rick B.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
