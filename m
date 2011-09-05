Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2.bt.bullet.mail.ukl.yahoo.com ([217.146.183.200]:45391 "HELO
	nm2.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753559Ab1IEO0h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Sep 2011 10:26:37 -0400
Message-ID: <4E64DC18.1060308@yahoo.com>
Date: Mon, 05 Sep 2011 15:26:32 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: ERROR: "em28xx_add_into_devlist" [drivers/media/video/em28xx/em28xx.ko]
 undefined!
References: <4E640DBB.8010504@iki.fi> <4E64148A.3010704@yahoo.com> <4E6416D6.2060706@iki.fi> <4E64192E.7060505@yahoo.com> <4E64D566.4070105@redhat.com>
In-Reply-To: <4E64D566.4070105@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------030108040208010102070408"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030108040208010102070408
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/09/11 14:57, Mauro Carvalho Chehab wrote:
> Could you please provide me a patch for it? I'll merge with your original one
> when submitting it upstream.

Here you go. Did you also pick up the other merge fix and the (separate) memory 
leak fix, please?

Cheers,
Chris

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------030108040208010102070408
Content-Type: text/x-patch;
 name="EM28xx-devlist-merge-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-devlist-merge-fix.diff"

--- linux/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-09-05 15:21:38.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-cards.c	2011-09-05 15:21:55.000000000 +0100
@@ -2885,7 +2885,6 @@
 		retval = em28xx_audio_setup(dev);
 		if (retval)
 			return -ENODEV;
-		em28xx_add_into_devlist(dev);
 		em28xx_init_extension(dev);
 
 		return 0;

--------------030108040208010102070408--
