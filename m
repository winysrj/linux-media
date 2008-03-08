Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m289hvhW030015
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 04:43:57 -0500
Received: from smtp4.poczta.onet.pl (smtp4.poczta.onet.pl [213.180.130.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m289hJIu016064
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 04:43:20 -0500
Received: from enn198.neoplus.adsl.tpnet.pl ([83.20.3.198]:49098 "EHLO
	[83.20.3.198]" rhost-flags-OK-OK-OK-FAIL) by ps4.test.onet.pl
	with ESMTPA id S184559723AbYCHJnSPzaCZ (ORCPT
	<rfc822;video4linux-list@redhat.com>); Sat, 8 Mar 2008 10:43:18 +0100
Message-ID: <47D25FB5.4020400@vp.pl>
Date: Sat, 08 Mar 2008 10:43:17 +0100
From: =?ISO-8859-2?Q?=22Micha=B3_W=2E=22?= <mihalw@vp.pl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Subject: USB autosuspend feature
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

I have a simple Pinnacle tuner (Dazzle TV Hybrid Stick USB) which works 
fine,
but it's getting quite hot. This has been reported also by other users, 
so it is
rather a general problem with these devices.

I've looked at the kernel USB autosuspend feature, which should solve 
the issue
for me, but it seems there is no support for it in the drivers (em28xx, 
kernel 2.6.23).
If it is really so please consider adding support for USB autosuspend.

Regards,
Micha³

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
