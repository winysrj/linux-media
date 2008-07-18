Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I5FdsF022228
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 01:15:39 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6I5FTxD030696
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 01:15:29 -0400
Received: by yw-out-2324.google.com with SMTP id 5so46130ywb.81
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 22:15:29 -0700 (PDT)
Message-ID: <3634de740807172215v52a624ga09449e81bb684fe@mail.gmail.com>
Date: Fri, 18 Jul 2008 10:45:29 +0530
From: John <john.maximus@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: omap3 camera patches
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
   looking at the OMAP3 camera patches posted sometime back.
   I manually applied these patches on a existing OMAP3 2.6.22 kernel.
   am trying to port an existing SOC micron driver to OMAP3 on a custom board.
   am not seeing any interrupts.

  Is anyone using the current camera patches for OMAP3. Is this working?

  Are there any existing sensor drivers that use these patches. I find
there are no sensor
  driver for OMAP3.


Regards,

John

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
