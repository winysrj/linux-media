Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2UCWtcH028052
	for <video4linux-list@redhat.com>; Tue, 30 Mar 2010 08:32:56 -0400
Received: from cleopatra.basesoft.com (cleopatra.basesoft.com [82.199.92.137])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2UCWfYf020980
	for <video4linux-list@redhat.com>; Tue, 30 Mar 2010 08:32:43 -0400
Received: from localhost (unknown [127.0.0.1])
	by cleopatra.basesoft.com (Postfix) with ESMTP id 64E85554CC9
	for <video4linux-list@redhat.com>; Tue, 30 Mar 2010 12:32:40 +0000 (UTC)
Received: from cleopatra.basesoft.com ([127.0.0.1])
	by localhost (cleopatra.basesoft.com [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id qbkHbMDC1KfE for <video4linux-list@redhat.com>;
	Tue, 30 Mar 2010 14:32:37 +0200 (CEST)
Received: from [10.0.5.151] (unknown [89.137.114.41])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cleopatra.basesoft.com (Postfix) with ESMTPSA id 81214554CC7
	for <video4linux-list@redhat.com>;
	Tue, 30 Mar 2010 14:32:37 +0200 (CEST)
Message-ID: <4BB1EF66.9000500@basesoft.ro>
Date: Tue, 30 Mar 2010 15:32:38 +0300
From: Mircea Uifalean <mircea@basesoft.ro>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: [SOLVED] problem with streaming from two webcams with v4l2
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello.

I wrote a couple of days ago about a problem with streaming from two
webcams. I had errors when I tried to start both streams simultaneously
but individually they both worked fine.

According to a page on the matter (not sure if I'm allowed to post links
so I'll just quote):

"A USB camera uses all the bandwidth a USB1.1 controller can give. Even
at low framerates the camera reserves more than half the 11 Mb/s. This
means that the 2nd camera gets rejected. Few motherboards have more than
one controller. Often 2 or 4 physical connections on a motherboard
shares one and the same USB controller. To add more cameras you need to
put USB adapter cards. One per camera. There exists cards with full
bandwidth per USB socket. These present themselves as for example 4 USB
controllers to Linux and they work fine with 4 cameras. Also, many (if
not most) cheap PCI USB1/2 cards ($10 range) have a controller capable
of supporting 2 x USB1 cameras and an additional USB2 camera per card.
With those cards and USB1 extender cards (allowing extension of a USB1
device for up to 100m, typically 50m) you can have a capable
surveillance setup using only USB cameras.".

So the problem was fixed by adding a PCI card that had some extra USB
ports. Hope this helps others that have a similar problem.

-- 
Regards,
Mircea Uifalean

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
