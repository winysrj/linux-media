Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5RKuDJh015942
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 16:56:13 -0400
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5RKtK57010190
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 16:55:26 -0400
Received: by gv-out-0910.google.com with SMTP id n8so116007gve.13
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 13:55:20 -0700 (PDT)
Message-ID: <486553B5.9070609@gmail.com>
Date: Fri, 27 Jun 2008 23:55:17 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: linux-uvc-devel@lists.berlios.de,
	video4linux-list <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: UVCVIDEO for 2.6.27 ?
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

Is UVC driver planned for inclusion in 2.6.27?

As a new user of this driver, I confirm that it works almost perfectly.

cheese/xawtv/kdetv/zapping/ekiga work fine.
tvtime complains about 'too short video frames'

zapping crashes when trying to see settings dialog - almost for sure
unrelated bug, this application is not stable.

kdetv hangs on exit, app buggy as well, but maybe it triggers some race
in videobuf, I have already triggered one race with this app once.

The camera used to hang minutes after launch, but after I installed latest svn of
uvcvideo the bug disappeared.

Oh, almost forgot, I have Acer Crystal eye webcam integrated
in my new laptop. aspire 5720.

Best regards,
	Maxim Levitsky

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
