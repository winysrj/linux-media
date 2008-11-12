Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVZVm022415
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:35 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVPIQ026961
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:25 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:31 +0100
Message-Id: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: soc-camera: pixelfmt translation serie
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

Hi Guennadi,

This serie is prolongation of your work on the soc_camera
bus driver. I reposted your serie within this one, so that
this serie is a "whole", and can be applied on top of
v2.6.28-rc4 for testing purpose.
 => beware, the patch on the ov7272 was removed, shame on me

The patches are split into :

 - patch 1 .. 7 : copy paste of your patches, no
 modification (beware, ov.... was expunged, sorry again)

 - patch 8 : the translation framework
 - patch 9 : application of the framework to pxa_camera host
 - patch 10 : application of the framework to
 sh_mobile_ceu_camera host

 - patch 11 - 12 : fixes for YUV format handling in pxa_camera

This is the ground of the discussion. I know I still have to
add documentation around the new functions/structures. I
need to know if this is what you have in mind, to either
continue the work or stop and take a different path.

I should add this was tested with RGB565 and all YUV formats
on a pxa272 with a mt9m111 (as you could have expected :)).

Now is the time to improve the translation code. Happy review.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
