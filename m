Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m75EfZES010391
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 10:41:46 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m75EfAh1021670
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 10:41:11 -0400
Received: by wf-out-1314.google.com with SMTP id 25so2278563wfc.6
	for <video4linux-list@redhat.com>; Tue, 05 Aug 2008 07:41:09 -0700 (PDT)
Date: Tue, 5 Aug 2008 07:31:51 -0700
From: Brandon Philips <brandon@ifup.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080805143151.GG3853@potty.ifup.org>
References: <20080804212204.GA3853@potty.ifup.org>
	<1217899361.4980.20.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217899361.4980.20.camel@pc10.localdom.local>
Cc: "Andrey J. Melnikov" <temnota@kmv.ru>, Igor Kuznetsov <igk72@yandex.ru>,
	v4l <video4linux-list@redhat.com>,
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

On 03:22 Tue 05 Aug 2008, hermann pitton wrote:
> Am Montag, den 04.08.2008, 14:22 -0700 schrieb Brandon Philips:
> > Hello All-
> > 
> > I have received a bug report[1] from a user who's card used to work as a
> > SAA7134_BOARD_UNKNOWN before the patch[2] that added support for
> > SAA7134_BOARD_BEHOLD_505FM.
> 
> how far something detected as SAA7134_BOARD_UNKNOWN can "work" is
> another issue and not related.

It turns out that he wasn't telling the whole story here:

On 03:22 Tue 05 Aug 2008,  Sergey Lukashevich wrote:
> My TV card is actually AverMedia 503 or the like. I cannot recall it
> exactly.  Before I used AverMedia software to watch TV.  But their
> software sucks and recently I found a way to make my card look like
> Beholder to run Beholder software. I had to patch the ROM of the card
> using info found in a forum. Could it be the source of THIS bug?

https://bugzilla.novell.com/show_bug.cgi?id=403904#c10

There isn't really a bug here.  Sorry for the noise.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
