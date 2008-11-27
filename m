Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAR7XSlg014643
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 02:33:28 -0500
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAR7WTw1007640
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 02:32:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Thu, 27 Nov 2008 08:32:22 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811270832.22341.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: RFC: drop support for kernels < 2.6.22
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

Hi all,

It been my opinion for quite some time now that we are too generous in 
the number of kernel versions we support. I think that the benefits no 
longer outweight the effort we have to put in.

This is true in particular for the i2c support since that changed a lot 
over time. Kernel 2.6.22 is a major milestone for that since it 
introduced the new-style i2c API.

In order to keep the #ifdefs to a minimum I introduced the 
v4l2-i2c-drv.h and v4l2-i2c-drv-legacy.h headers. These make sense when 
used in the v4l-dvb tree context, but when they are stripped and used 
in the actual kernel source they look very weird.

My proposal is to stop supporting kernels < 2.6.22 so that we no longer 
have to put a lot of effort in supporting the old-style i2c API.

In addition, I would suggest that for every new kernel release we also 
drop support for the oldest kernel. The only exception being that once 
2.6.27 is the oldest supported kernel we stick with that one since that 
is the new long-term maintained kernel. Unless we end up again with 
major compatibility issues.

Comments?

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
