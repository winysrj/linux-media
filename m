Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35358 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408Ab1CKAeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 19:34:25 -0500
Subject: Re: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
From: Andy Walls <awalls@md.metrocast.net>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	David Miller <davem@davemloft.net>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <1299445446.2310.157.camel@localhost>
References: <1299204400.2812.35.camel@localhost>
	 <1299362366.2570.27.camel@localhost> <1299377017.2341.50.camel@localhost>
	 <AANLkTimU9qV11p+wTDz4SCvaoYyxpja8tmJ5D7-ki==B@mail.gmail.com>
	 <1299445446.2310.157.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 19:34:38 -0500
Message-ID: <1299803678.13462.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-03-06 at 16:04 -0500, Andy Walls wrote:
> On Sun, 2011-03-06 at 10:37 -0800, Hugh Dickins wrote:

> > I do expect the underlying problem to be somewhere down the driver
> > end, given that nobody else has been reporting these issues.  I'm
> > hoping that once the cx18 guys have time to try to reproduce it,
> > they'll be better able to track it down.

Hi Hugh,

You were correct.  The mistake was in the cx18 driver, in the last thing
that I touched, of course.  The code causing the bug isn't anywhere
aside from my private repo.

All,

Sorry for all the noise.

The bug was so idiotic, I fell compelled to show the fix:

diff --git a/drivers/media/video/cx18/cx18-scb.c b/drivers/media/video/cx18/cx18
index fd89ad0..d17ffc8 100644
--- a/drivers/media/video/cx18/cx18-scb.c
+++ b/drivers/media/video/cx18/cx18-scb.c
@@ -28,8 +28,8 @@
 
 int cx18_scb_init_mdl_ent_mgmt(struct cx18 *cx)
 {
-       cx->scb_mdl_ent_map = kzalloc(BITS_TO_LONGS(SCB_MDL_ENTRIES),
-                                     GFP_KERNEL);
+       cx->scb_mdl_ent_map = kzalloc(BITS_TO_LONGS(SCB_MDL_ENTRIES)
+                                               * sizeof(long), GFP_KERNEL);
        if (cx->scb_mdl_ent_map == NULL) {
                CX18_ERR("Fatal: unable to allocate bitmap for managing SCB MDL"
                         "entries\n");

So now the subsequent call to

	bitmap_zero(cx->scb_mdl_ent_map, SCB_MDL_ENTRIES);

doesn't walk off the end of what was allocated.

Apparently BITS_TO_LONGS() is not BITS_TO_LONGS_TO_BYTES().

Regards,
Andy

