Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m625v6YP006283
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 01:57:06 -0400
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m625usEE010909
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 01:56:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Wed, 2 Jul 2008 07:56:53 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020756.53438.hverkuil@xs4all.nl>
Cc: 
Subject: uvc_driver.c compile error on 2.6.18
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

Hi all,

The current v4l-dvb doesn't build anymore on 2.6.18:

  CC [M]  /home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.o
/home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c: In 
function 'uvc_parse_control':
/home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c:1135: warning: implicit 
declaration of function 'usb_endpoint_is_int_in'
/home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c: At top level:
/home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c:1918: error: unknown 
field 'supports_autosuspend' specified in initializer
/home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c:1918: warning: missing 
braces around initializer
/home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c:1918: warning: (near 
initialization for 'uvc_driver.driver.dynids')
make[3]: *** [/home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.o] Error 1
make[2]: *** [_module_/home/hans/work/src/v4l/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/home/hans/work/src/kernels/linux-2.6.18.8'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/hans/work/src/v4l/v4l-dvb/v4l'
make: *** [all] Error 2

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
