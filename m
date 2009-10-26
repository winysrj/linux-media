Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44571 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZJZPrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 11:47:19 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Roel Kluin <roel.kluin@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 26 Oct 2009 10:47:05 -0500
Subject: RE: [PATCH] V4L/DVB: keep index within bound in vpfe_cropcap()
Message-ID: <A69FA2915331DC488A831521EAE36FE4015568F206@dlee06.ent.ti.com>
References: <4AE586F2.9060501@gmail.com>
In-Reply-To: <4AE586F2.9060501@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Roel,

Thanks for fixing this.

Mauro,

Could you merge this please?

Acked-by Muralidharan Karicheri <m-karicheri2@ti.com> 

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Roel Kluin [mailto:roel.kluin@gmail.com]
>Sent: Monday, October 26, 2009 7:25 AM
>To: Mauro Carvalho Chehab; linux-media@vger.kernel.org; Andrew Morton;
>Karicheri, Muralidharan
>Subject: [PATCH] V4L/DVB: keep index within bound in vpfe_cropcap()
>
>If vpfe_dev->std_index equals ARRAY_SIZE(vpfe_standards), that is
>one too large
>
>Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>---
> drivers/media/video/davinci/vpfe_capture.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/media/video/davinci/vpfe_capture.c
>b/drivers/media/video/davinci/vpfe_capture.c
>index 402ce43..6b31e59 100644
>--- a/drivers/media/video/davinci/vpfe_capture.c
>+++ b/drivers/media/video/davinci/vpfe_capture.c
>@@ -1577,7 +1577,7 @@ static int vpfe_cropcap(struct file *file, void *priv,
>
> 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_cropcap\n");
>
>-	if (vpfe_dev->std_index > ARRAY_SIZE(vpfe_standards))
>+	if (vpfe_dev->std_index >= ARRAY_SIZE(vpfe_standards))
> 		return -EINVAL;
>
> 	memset(crop, 0, sizeof(struct v4l2_cropcap));

