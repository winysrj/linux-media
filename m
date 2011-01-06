Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p06DNN4N007647
	for <video4linux-list@redhat.com>; Thu, 6 Jan 2011 08:23:23 -0500
Received: from subra.cognitec-systems.de (subra.cognitec-systems.de
	[217.18.180.202])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p06DNArY011145
	for <video4linux-list@redhat.com>; Thu, 6 Jan 2011 08:23:11 -0500
Received: from localhost (localhost [127.0.0.1])
	by subra.cognitec-systems.de (Postfix) with ESMTP id A63349FB01
	for <video4linux-list@redhat.com>; Thu,  6 Jan 2011 14:23:09 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by subra.cognitec-systems.de (Postfix) with ESMTP id 28D0F9FB01
	for <video4linux-list@redhat.com>; Thu,  6 Jan 2011 14:23:03 +0100 (CET)
Received: from aries.localnet (aries.cognitec-systems.de [192.168.203.129])
	by subra.cognitec-systems.de (Postfix) with ESMTP
	for <video4linux-list@redhat.com>; Thu,  6 Jan 2011 14:23:03 +0100 (CET)
From: Andreas Lubensky <lubensky@cognitec.com>
To: video4linux-list@redhat.com
Subject: Migrating a v4l1 application
Date: Thu, 6 Jan 2011 14:23:02 +0100
MIME-Version: 1.0
Message-Id: <201101061423.02462.lubensky@cognitec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <video4linux-list@redhat.com>

Hello,

i am currently investigating the necessity of migrating an old v4l1 
application to v4l2.
The scope is mostly limited to grabbing the stream from various cameras and it 
seems to be working fine at the moment.
Reading through mailing lists, it seems v4l1 support will soon be dropped 
completely. Does that also include the compatibility layer? Or can i leave the 
running system untouched for the moment?

best regards,
Andreas Lubensky

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
