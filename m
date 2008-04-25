Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3PBAKpx000954
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 07:10:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3PBA7t6016442
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 07:10:07 -0400
Date: Fri, 25 Apr 2008 08:08:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Igor Kuznetsov <igk72@yandex.ru>
Message-ID: <20080425080856.635581a0@gaivota>
In-Reply-To: <387481209112780@webmail35.yandex.ru>
References: <20071231091423.GA3344@kmv.ru>
	<387481209112780@webmail35.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Add Beholder TV H6 support - hybrid card
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

Hi Igor,

On Fri, 25 Apr 2008 12:39:40 +0400
Igor Kuznetsov <igk72@yandex.ru> wrote:

> Beholder TV H6 - hybrid card
> 
> 
> Add support - analog tv, radio, remote control
> 
> --
> Igor Kuznetsov "IgK"
> Web: www.igk.ru
> Email: igk@igk.ru, igk72@yandex.ru
> ICQ: 6651879

Thanks for the patch.

Sorry, but your patch failed to apply against the devel tree:

$ patch -p1 -i /tmp/v4l2-beholder-2.6.24-hg.patch
patching file linux/Documentation/video4linux/CARDLIST.saa7134
Hunk #1 FAILED at 116.
1 out of 1 hunk FAILED -- saving rejects to file linux/Documentation/video4linux/CARDLIST.saa7134.rej
patching file linux/drivers/media/common/ir-keymaps.c
Hunk #1 FAILED at 1893.
1 out of 1 hunk FAILED -- saving rejects to file linux/drivers/media/common/ir-keymaps.c.rej
patching file linux/drivers/media/video/ir-kbd-i2c.c
Reversed (or previously applied) patch detected!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
2 out of 2 hunks ignored -- saving rejects to file linux/drivers/media/video/ir-kbd-i2c.c.rej
patching file linux/drivers/media/video/saa7134/saa7134-cards.c
Hunk #1 succeeded at 4290 with fuzz 2 (offset 701 lines).
Hunk #2 succeeded at 5410 with fuzz 2 (offset 767 lines).
Hunk #3 FAILED at 5728.
Hunk #4 FAILED at 5777.
Hunk #5 FAILED at 5799.
3 out of 5 hunks FAILED -- saving rejects to file linux/drivers/media/video/saa7134/saa7134-cards.c.rej
patching file linux/drivers/media/video/saa7134/saa7134-i2c.c
Reversed (or previously applied) patch detected!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
2 out of 2 hunks ignored -- saving rejects to file linux/drivers/media/video/saa7134/saa7134-i2c.c.rej
patching file linux/drivers/media/video/saa7134/saa7134-input.c
Hunk #1 succeeded at 57 with fuzz 2 (offset 13 lines).
Hunk #2 succeeded at 160 (offset 20 lines).
Hunk #3 FAILED at 335.
Hunk #4 succeeded at 591 with fuzz 2 (offset 91 lines).
1 out of 4 hunks FAILED -- saving rejects to file linux/drivers/media/video/saa7134/saa7134-input.c.rej
patching file linux/drivers/media/video/saa7134/saa7134.h
Hunk #1 FAILED at 247.
1 out of 1 hunk FAILED -- saving rejects to file linux/drivers/media/video/saa7134/saa7134.h.rej
patching file linux/include/media/ir-common.h
patch: **** malformed patch at line 836: diff -r 59987f33c150 linux/drivers/media/video/saa7134/saa7134-i2c.c

Could you please re-generate it?

Ah, there were some recent Beholder driver additions, with the support of the
manufacturer. Maybe you could try first if your board is already supported on
the latest version.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
