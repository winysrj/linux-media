Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab2HLKI5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 06:08:57 -0400
Message-ID: <502780B3.60205@redhat.com>
Date: Sun, 12 Aug 2012 07:08:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: Fix height setting on non-progressive captures
References: <1344016352-20302-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1344016352-20302-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-08-2012 14:52, Ezequiel Garcia escreveu:
> This was introduced on commit c2a6b54a9:
> "em28xx: fix: don't do image interlacing on webcams"
> It is a known bug that has already been reported several times
> and confirmed by Mauro.

Thanks for reminding us about that.

> Tested by compilation only.
> 
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
> Hi,
> 
> I have no idea why this hasn't been fixed before.

The reason was because that patch didn't work ;)

> 
> See this mail for Mauro's confirmation
> http://www.digipedia.pl/usenet/thread/18550/7691/#post7685
> where he requested a patch on reporter. 
> 
> I guess the patch never came in.


Did some tests here with both TV and Webcam (progressive)
devices. The enclosed patch fixes the issue.

Regards,
Mauro.

[media] em28xx: Fix height setting on non-progressive captures

This was introduced on commit c2a6b54a9:
"em28xx: fix: don't do image interlacing on webcams"

The proposed patch by Ezequiel is wrong. The right fix here is to just
don't bother here if either the image is progressive or not.

Reported-by: Ezequiel Garcia <elezegarcia@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index de2cb20..bed07a6 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -785,12 +785,8 @@ int em28xx_resolution_set(struct em28xx *dev)
 	else
 		dev->vbi_height = 18;
 
-	if (!dev->progressive)
-		height >>= norm_maxh(dev);
-
 	em28xx_set_outfmt(dev);
 
-
 	em28xx_accumulator_set(dev, 1, (width - 4) >> 2, 1, (height - 4) >> 2);
 
 	/* If we don't set the start position to 2 in VBI mode, we end up

