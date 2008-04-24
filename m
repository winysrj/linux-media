Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OEDL5Y032362
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:13:21 -0400
Received: from mx-1.enea.se (mx-1.enea.se [192.36.1.70])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OEDAYb016920
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:13:11 -0400
From: Johan Hedlund <johan.hedlund@enea.com>
To: video4linux-list@redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Apr 2008 16:12:59 +0200
Message-Id: <1209046379.9435.5.camel@ThePenguin>
Mime-Version: 1.0
Subject: V4L2_PIX_FMT_SBGGR16 not in kernel
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

Hello

I am working on a application that will use V4L2 on a linux-2.6-22
kernel. I am interested in using the format V4L2_PIX_FMT_SBGGR16 'BA82'
for my captured images. But it seems like I only can find it the in the
V4L2 specification and not in the mainline kernel. Is this format not a
standard format that should be in the mainline kernel? Can I just add
the definition to my code and use it or will it break something else?

/Johan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
