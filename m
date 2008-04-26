Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3QFAkEY029938
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 11:10:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3QFA44X026210
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 11:10:04 -0400
Date: Sat, 26 Apr 2008 12:08:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Igor Kuznetsov <igk72@yandex.ru>, Video <video4linux-list@redhat.com>
Message-ID: <20080426120859.0c2982e7@gaivota>
In-Reply-To: <372061209160950@webmail9.yandex.ru>
References: <20071231091423.GA3344@kmv.ru>
	<387481209112780@webmail35.yandex.ru>
	<372061209160950@webmail9.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Add Beholder TV H6 support - hybrid card - correct and tested
 patch
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

On Sat, 26 Apr 2008 02:02:30 +0400
Igor Kuznetsov <igk72@yandex.ru> wrote:

> Hi, Mauro
> 
> 
> Sorry for the mistake with the previous patch. I sent you a file is not correct - the old file with all the changes. :-))
> 
> Now send the correct and tested with the patch file for Beholder H6 (hybrid) - v4l2-beholder-h6-analog-1.patch
> 
> Secondly, send a patch file to add a new release Beholder M6 (3) - v4l2-beholder-m6-rev3.patch
Hi Igor,

Thanks for the patches.

Please, before sending a patch, check it with checkpatch.pl. The easiest way for doing this with V4L/DVB tree is just to run "make checkpatch".

Since the issues were very trivial on your patch, I've fixed and applied.

Also, instead of sending a email with two patches inside, plus one comment, you
should send one patch by email. Something like:

email 1:
Subject: [PATCH 0/2] Add Beholder TV H6 support

email 2:

Subject: [PATCH 1/2] <some patch quick description>


email 3: 
Subject: [PATCH 1/2] <another patch quick description>


the patch quick descriptions should be something like:

saa7134: add another PCI ID for Beholder M6

Inside the body of the email, if needed, you'll add a longer description of the
patch, plus your signed-off-by. The patch should be the latest thing at the
email.

If you use a different procedure, you risk of me asking you to re-do ;)

There's an interesting reference about a perfect patch, submitted via email, at:
	http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

Also: please, don't forget to copy V4L ML for patches on saa7134. This allows
more people to review.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
