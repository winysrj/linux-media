Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7D9FPiQ004527
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 05:15:26 -0400
Received: from fmmailgate04.web.de (fmmailgate04.web.de [217.72.192.242])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7D9FDMI001753
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 05:15:13 -0400
Received: from web.de
	by fmmailgate04.web.de (Postfix) with SMTP id 5BCA25E5FE73
	for <video4linux-list@redhat.com>;
	Wed, 13 Aug 2008 11:15:07 +0200 (CEST)
Date: Wed, 13 Aug 2008 11:15:06 +0200
Message-Id: <751214628@web.de>
MIME-Version: 1.0
From: Stefan Lange <sailer22@web.de>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Subject: Terratec Cinergy XS unsupported Device
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

He guys,

i am using Terratec Cinergy XS with the new em28xx modules.

I have now cleared the old v4l stuff.

But i get the following messages.

[  791.731021] em28xx: new video device (0ccd:0043): interface 0, class 255
[  791.731027] em28xx: device is attached to a USB 2.0 bus
[  791.731038] em28xx #0: Alternate settings: 8
[  791.731042] em28xx #0: Alternate setting 0, max size= 0
[  791.731045] em28xx #0: Alternate setting 1, max size= 0
[  791.731049] em28xx #0: Alternate setting 2, max size= 1448
[  791.731053] em28xx #0: Alternate setting 3, max size= 2048
[  791.731056] em28xx #0: Alternate setting 4, max size= 2304
[  791.731060] em28xx #0: Alternate setting 5, max size= 2580
[  791.731063] em28xx #0: Alternate setting 6, max size= 2892
[  791.731067] em28xx #0: Alternate setting 7, max size= 3072
[  792.172113] em2880-dvb.c: DVB Init
[  792.274627] em2880-dvb.c: unsupported device
[  792.274634] em28xx #0: Found Terratec Cinergy T XS (MT2060)


I found some entrys in google that some people had the same Problems.

I am using Kernel 2.6.24-19 on ubuntu.

Thanx a lot
Stefan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
