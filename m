Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3-vm0.bt.bullet.mail.ukl.yahoo.com ([217.146.182.230]:36866
	"HELO nm3-vm0.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752792Ab1IDT0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 15:26:25 -0400
Message-ID: <4E63D0DD.2050508@yahoo.com>
Date: Sun, 04 Sep 2011 20:26:21 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.2] [media] em28xx: use atomic bit operations
 for devices-in-use mask
References: <E1R00r0-0005PG-6Q@www.linuxtv.org>
In-Reply-To: <E1R00r0-0005PG-6Q@www.linuxtv.org>
Content-Type: multipart/mixed;
 boundary="------------080304080400060603040008"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080304080400060603040008
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 04/09/11 00:49, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] em28xx: use atomic bit operations for devices-in-use mask
> Author:  Chris Rankin<rankincj@yahoo.com>
> Date:    Sat Aug 20 08:21:03 2011 -0300
>
> Use atomic bit operations for the em28xx_devused mask, to prevent an
> unlikely race condition should two adapters be plugged in
> simultaneously. The operations also clearer than explicit bit
> manipulation anyway.
>
> Signed-off-by: Chris Rankin<rankincj@yahoo.com>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
>   drivers/media/video/em28xx/em28xx-cards.c |   33 ++++++++++++++---------------
>   1 files changed, 16 insertions(+), 17 deletions(-)

Hi Mauro,

I think you missed this line in the merge.

Cheers,
Chris

--------------080304080400060603040008
Content-Type: text/x-patch;
 name="EM28xx-more-devunused-bits.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-more-devunused-bits.diff"

--- linux/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-09-04 20:17:00.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-cards.c	2011-09-04 20:19:21.000000000 +0100
@@ -3083,7 +3083,6 @@
 				em28xx_err(DRIVER_NAME " This is an anciliary "
 					"interface not used by the driver\n");
 
-				em28xx_devused &= ~(1<<nr);
 				retval = -ENODEV;
 				goto err;
 			}

--------------080304080400060603040008--
