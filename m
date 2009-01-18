Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0IBnlQg013952
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 06:49:47 -0500
Received: from mta2.glocalnet.net (mta2.glocalnet.net [213.163.128.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0IBnVHk001429
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 06:49:31 -0500
Received: from mail.jarkeborn.se (78.82.254.235) by mta2.glocalnet.net
	(7.3.130) (authenticated as 4integration@glocalnet.net)
	id 492BECA800799664 for video4linux-list@redhat.com;
	Sun, 18 Jan 2009 12:49:31 +0100
Received: from [192.168.1.3] (DD-WRT.highway [192.168.1.20])
	by mail.jarkeborn.se (Postfix) with ESMTPSA id CD5DC66141
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 12:49:30 +0100 (CET)
Message-ID: <4973174A.30406@jarkeborn.se>
Date: Sun, 18 Jan 2009 12:49:30 +0100
From: Jocke <maillist@jarkeborn.se>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Removed drivers...help
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

I have a fresh Ubuntu Server 8.10 and it had support for my DVB cards 
but since I have used the latest v4l-dvb drivers before I did the same 
this time.

I am struggeling with my TV cards and tried with the latest v4l-dvb 
source/firmware and from a v4l-dvb perspective it looked fine. However I 
have problem with opensascng so I wanted to revert to the default 
v4l-dvb drivers to see if that work.

So I executed "make rminstall" but that seems to remove all video drivers :(

- How can I get back to the default Ubuntu drivers?

Best Regards
Joacim
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
