Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7LMgms9022729
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 18:42:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7LMgal8031839
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 18:42:37 -0400
Date: Thu, 21 Aug 2008 19:42:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Dean A." <dean@sensoray.com>
Message-ID: <20080821194225.6ef1af35@mchehab.chehab.org>
In-Reply-To: <tkrat.e703f589e6ff1d88@sensoray.com>
References: <tkrat.e703f589e6ff1d88@sensoray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: greg@kroah.com, video4linux-list@redhat.com, dean@sensoray.com
Subject: Re: [PATCH] s2255drv for 2.6.27-rc2: firmware loading improved,
 kfree bug fixed
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

Hi Dean,

On Thu, 7 Aug 2008 16:21:34 -0700 (PDT)
"Dean A." <dean@sensoray.com> wrote:

> From: Dean Anderson <dean@sensoray.com>
> 
> This patch fixes timer issues in driver disconnect.
> It also removes the restriction of one user per channel at a time.
> Adds handshaking with USB firmware to confirm proper loading.
> 
> 
> Signed-off-by: Dean Anderson <dean@sensoray.com>

There's something wrong with your patch (tested on both Linus tree and devel
tree). It seems that some changes were applied by a previous patch. Also,
please generate it against the latest devel tree, since some API changes
happened there. The devel tree is at:
	http://linuxtv.org/hg/v4l-dvb


patching file drivers/media/video/s2255drv.c
Hunk #1 succeeded at 67 (offset 3 lines).
Hunk #3 succeeded at 155 (offset 3 lines).
Hunk #4 FAILED at 187.
Hunk #5 succeeded at 200 (offset 1 line).
Hunk #6 succeeded at 248 (offset 3 lines).
Hunk #7 FAILED at 280.
Hunk #8 FAILED at 289.
Hunk #9 succeeded at 312 (offset -5 lines).
Hunk #10 succeeded at 422 (offset 3 lines).
Hunk #11 FAILED at 492.
Hunk #12 FAILED at 512.
Hunk #13 succeeded at 552 (offset -1 lines).
Hunk #14 succeeded at 588 (offset 3 lines).
Hunk #15 succeeded at 618 (offset -1 lines).
Hunk #16 succeeded at 650 (offset 3 lines).
Hunk #17 succeeded at 659 (offset -1 lines).
Hunk #18 FAILED at 790.
Hunk #19 FAILED at 801.
Hunk #20 succeeded at 1035 (offset 13 lines).
Hunk #21 succeeded at 1082 (offset -1 lines).
Hunk #22 succeeded at 1158 (offset 13 lines).
Hunk #23 succeeded at 1190 (offset -1 lines).
Hunk #24 succeeded at 1219 (offset 13 lines).
Hunk #25 succeeded at 1214 (offset -1 lines).
Hunk #26 FAILED at 1257.
Hunk #27 succeeded at 1297 (offset 13 lines).
Hunk #28 FAILED at 1327.
Hunk #29 FAILED at 1483.
Hunk #30 FAILED at 1500.
Hunk #31 succeeded at 1588 (offset 4 lines).
Hunk #32 FAILED at 1613.
Hunk #33 FAILED at 1636.
Hunk #34 FAILED at 1686.
Hunk #35 succeeded at 1743 (offset 24 lines).
Hunk #36 succeeded at 1810 (offset 7 lines).
Hunk #37 succeeded at 1846 (offset 24 lines).
Hunk #38 succeeded at 1954 (offset 7 lines).
Hunk #39 succeeded at 1993 (offset 24 lines).
Hunk #40 succeeded at 2001 (offset 7 lines).
Hunk #41 succeeded at 2102 (offset 24 lines).
Hunk #42 succeeded at 2122 (offset 7 lines).
Hunk #43 succeeded at 2314 (offset 24 lines).
Hunk #44 succeeded at 2307 (offset 7 lines).
Hunk #45 succeeded at 2356 (offset 24 lines).
Hunk #46 succeeded at 2409 (offset 7 lines).
Hunk #47 succeeded at 2452 (offset 24 lines).
Hunk #48 succeeded at 2465 (offset 7 lines).
Hunk #49 succeeded at 2503 (offset 24 lines).
Hunk #50 succeeded at 2519 (offset 7 lines).
14 out of 50 hunks FAILED -- saving rejects to file drivers/media/video/s2255drv.c.rej


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
