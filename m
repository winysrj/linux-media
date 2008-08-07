Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m782dIdh008669
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 22:39:18 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m782d2pB031913
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 22:39:03 -0400
Received: by fg-out-1718.google.com with SMTP id e21so455094fga.7
	for <video4linux-list@redhat.com>; Thu, 07 Aug 2008 19:39:02 -0700 (PDT)
Date: Fri, 8 Aug 2008 06:40:29 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080808064029.67a42946@dimon-PC.ttk.local>
In-Reply-To: <20080804212204.GA3853@potty.ifup.org>
References: <20080804212204.GA3853@potty.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Andrey J. Melnikov" <temnota@kmv.ru>, v4l <video4linux-list@redhat.com>,
	Igor Kuznetsov <igk72@yandex.ru>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: BeholdTV 505FM Input Causing Repeating Zeros
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

Hello All.

The Beholder company don't support hacked tuners of other vendors.
A 3 month a go I made complex patch and fix all Beholder's gpio mask to correct. Please look:

saa7134-input.c
changeset 7677	50835af51a9d

http://linuxtv.org/hg/v4l-dvb/rev/50835af51a9d

As I see user who send this bug is russian readable. You can send him to

http://www.beholder.ru/bb/viewforum.php?f=11
for reading and patching his kernel.

> I have received a bug report[1] from a user who's card used to work
> as a SAA7134_BOARD_UNKNOWN before the patch[2] that added support for
> SAA7134_BOARD_BEHOLD_505FM.
> 
> The IR input isn't setup properly and the driver is writing an
> infinite number of zeros to the users terminal.
> 
> Is there a way to figure out the correct mask_keycode and mask_keyup
> for this card?  Otherwise I recommend that we don't report has_remote
> for this card.
> 
> Thanks,
> 
> 	Brandon
> 
> 
> [1] https://bugzilla.novell.com/show_bug.cgi?id=403904
> [2] http://linuxtv.org/hg/v4l-dvb/rev/8bdb58e63ea1

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
