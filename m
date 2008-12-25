Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBP87KB1024101
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 03:07:20 -0500
Received: from outbound.mail.nauticom.net (outbound.mail.nauticom.net
	[72.22.18.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBP876wH032150
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 03:07:06 -0500
Received: from [192.168.0.124] (27.craf1.xdsl.nauticom.net [209.195.160.60])
	(authenticated bits=0)
	by outbound.mail.nauticom.net (8.13.8/8.13.8) with ESMTP id
	mBP870VT041664
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 03:07:05 -0500 (EST)
From: Rick Bilonick <rab@nauticom.net>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Thu, 25 Dec 2008 03:06:57 -0500
Message-Id: <1230192418.3450.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Compiling v4l-dvb-kernel for Ubuntu and F10
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

I'm trying to get em28xx working on both Ubuntu 8.10 and Fedora 10. In
Ubuntu, I've installed the linux-ports-headers (which contains dmxdev.h,
etc.) but when I "make", I get errors saying demxdev.h, dvb_demux.h,
dvb_net.h, and dvb_frontend.h can't be found (no such file).

Any help would be greatly appreciated.

Rick B.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
