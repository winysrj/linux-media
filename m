Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72GTeJQ022800
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 12:29:40 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m72GTSg2005144
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 12:29:29 -0400
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id E48FAB0136
	for <video4linux-list@redhat.com>;
	Sat,  2 Aug 2008 18:29:27 +0200 (CEST)
Received: from velvet (mur31-2-82-243-122-54.fbx.proxad.net [82.243.122.54])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 9835FB01FC
	for <video4linux-list@redhat.com>;
	Sat,  2 Aug 2008 18:29:27 +0200 (CEST)
To: video4linux-list@redhat.com
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 02 Aug 2008 18:29:26 +0200
Message-ID: <87d4krv0rd.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Micron MT9M111 driver
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

These patches begin the cycle of Micron MT9M111 camera chip support.
The driver is quite simple compared to the possibilities of the chip, but
provides good ground for video capture with this chip.

These patches follow the patch serie about soc_camera and pxa_camera
suspend/resume in Guennadi's tree.

Happy review.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
