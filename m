Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m74LMbkS002572
	for <video4linux-list@redhat.com>; Mon, 4 Aug 2008 17:22:37 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m74LMH47001237
	for <video4linux-list@redhat.com>; Mon, 4 Aug 2008 17:22:18 -0400
Received: by rv-out-0506.google.com with SMTP id f6so4833552rvb.51
	for <video4linux-list@redhat.com>; Mon, 04 Aug 2008 14:22:17 -0700 (PDT)
Date: Mon, 4 Aug 2008 14:22:04 -0700
From: Brandon Philips <brandon@ifup.org>
To: d.belimov@gmail.com, Igor Kuznetsov <igk72@yandex.ru>,
	"Andrey J. Melnikov" <temnota@kmv.ru>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080804212204.GA3853@potty.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: v4l <video4linux-list@redhat.com>
Subject: BeholdTV 505FM Input Causing Repeating Zeros
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

Hello All-

I have received a bug report[1] from a user who's card used to work as a
SAA7134_BOARD_UNKNOWN before the patch[2] that added support for
SAA7134_BOARD_BEHOLD_505FM.

The IR input isn't setup properly and the driver is writing an infinite
number of zeros to the users terminal.

Is there a way to figure out the correct mask_keycode and mask_keyup for
this card?  Otherwise I recommend that we don't report has_remote for
this card.

Thanks,

	Brandon


[1] https://bugzilla.novell.com/show_bug.cgi?id=403904
[2] http://linuxtv.org/hg/v4l-dvb/rev/8bdb58e63ea1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
