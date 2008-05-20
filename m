Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KIv491003696
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 14:57:04 -0400
Received: from akroyd.itverx.com.ve (akroyd.itverx.com.ve [67.205.93.243])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4KIunb4021497
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 14:56:50 -0400
Received: from trillian.ius.cc (bolivar.unesr.edu.ve [64.116.131.130])
	by akroyd.itverx.com.ve (8.13.8/8.13.8/Debian-3) with ESMTP id
	m4KIudpB009525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 18:56:42 GMT
Received: from localhost (localhost [127.0.0.1])
	by trillian.ius.cc (8.13.8/8.13.8/Debian-3) with ESMTP id
	m4KIua6P032067
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 14:26:39 -0430
From: Ernesto =?ISO-8859-1?Q?Hern=E1ndez-Novich?= <emhn@usb.ve>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 May 2008 14:26:35 -0430
Message-Id: <1211309795.25521.3.camel@trillian.ius.cc>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Problems building on Debian Etch
Reply-To: emhn@usb.ve
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

I'm trying to build the latest sources from Mercurial on an up-to-date
Debian Etch system. I've installed linux-headers-2.6.18-6-686 and
there's a corresponding link from /lib/modules/2.6.18-6-686/build
pointing to the headers.

Then I simply 'make' and after a while get

/usr/src/v4l-dvb/v4l/videodev.c:499: error: unknown field 'dev_attrs'
specified in initializer
/usr/src/v4l-dvb/v4l/videodev.c:499: warning: initialization from
incompatible pointer type
make[3]: *** [/usr/src/v4l-dvb/v4l/videodev.o] Error 1
make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.18-6-686'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
make: *** [all] Error 2

I was able to build using the _exact_ same procedure about a month and a
half ago, withouth problems. Ideas?
-- 
Prof. Ernesto Hernández-Novich - MYS-220C
Geek by nature, Linux by choice, Debian of course.
If you can't aptitude it, it isn't useful or doesn't exist.
GPG Key Fingerprint = 438C 49A2 A8C7 E7D7 1500 C507 96D6 A3D6 2F4C 85E3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
