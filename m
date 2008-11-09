Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9H1pmh028855
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 12:01:51 -0500
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9H1cPd031903
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 12:01:38 -0500
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 5BCA432A7D2
	for <video4linux-list@redhat.com>; Sun,  9 Nov 2008 18:01:38 +0100 (CET)
Received: from velvet (mur31-2-82-243-122-54.fbx.proxad.net [82.243.122.54])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 0D00432A7C4
	for <video4linux-list@redhat.com>; Sun,  9 Nov 2008 18:01:37 +0100 (CET)
To: video4linux-list@redhat.com
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 09 Nov 2008 18:01:37 +0100
Message-ID: <87prl4x28e.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: pxa_camera: DMA alignment requirement
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

Hello,

In the pxa camera driver, the 3 DMA channels used are MMU page aligned. Does
somebody remember where that constraint comes from ?

I'm wondering because the planar YUV format generated is something like this for
a 640 * 480 image :
 - Y plane => 640 * 480 bytes = 307200 (and this happens to be a multiple of
 pagesize : 307200 = 4096 * 75)
 - U plane => 640 * 480 / 2 bytes = 153600 (and this is not a multiple of 4096)
 - padding to reach next page : 2048 bytes
 - V plane => 153600 bytes
 - padding to reach next page : 2048 bytes

This means a user space library should be kernel pagesize aware to transform the
output image. I don't really understand the necessity of page aligned DMA
channels. Would someone tell me please ?

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
