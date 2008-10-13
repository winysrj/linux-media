Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DMFKMv022646
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 18:15:20 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DMEWxr031859
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 18:14:33 -0400
Received: by ug-out-1314.google.com with SMTP id o38so597599ugd.13
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 15:14:28 -0700 (PDT)
Message-ID: <30353c3d0810131514o5b0a6819q9444ad4cc28c1601@mail.gmail.com>
Date: Mon, 13 Oct 2008 18:14:28 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	v4l <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: [PATCH 0/2] stk-webcam corrections
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

The following series of patches address issues in the current
for_linus branch of the mchehab's linux-2.6 tree.

1. Minor corrections to mercurial revision 9034 which was a patch
submitted for testing.
2. Corrects a crash in stk-webcam during close if the camera has been
disconnected while open.

These patches have been well tested and should be applied for 2.6.28

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
