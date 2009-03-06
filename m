Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:45820 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbZCFXRo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 18:17:44 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
References: <1028158815.2045371236327963888.JavaMail.root@zimbra20-e3.priv.proxad.net>
	<Pine.LNX.4.64.0903061953170.5665@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 07 Mar 2009 00:17:31 +0100
Message-ID: <87prgu2qd0.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> This implies that even if DMA is 8 bytes aligned, width x height should 
>> be a multiple of 16, not 8 as I stated in the first git comment. So that 
>> would align :
>>  - width on 4 bytes (aligning meaning the lowest multiple of 4 below or equal to width)
>>  - and height on 4 bytes (aligning meaning the lowest multiple of 4 below or equal to height)
>> 
>> Do we have an agreement on that specification, so that I can amend the code accordingly ?
>
> Yep, looks good to me.

All right, this should amend patch 1/4. I'll wait for the complete review to
resend the patch as a whole.

Cheers

--
Robert

commit 4d3bd5219dd3ef27f11c7061adf10f8249d2ba26
Author: Robert Jarzmik <robert.jarzmik@free.fr>
Date:   Fri Mar 6 22:39:41 2009 +0100

    pxa_camera: Enforce YUV422P frame sizes to be 16 multiples
    
    Due to DMA constraints, the DMA chain always transfers bytes
    from the QIF fifos to memory in 8 bytes units. In planar
    formats, that could mean 0 padding between Y and U plane
    (and between U and V plane), which is against YUV422P
    standard.
    
    Therefore, a frame size is required to be a multiple of 16
    (so U plane size is a multiple of 8). It is enforced in
    try_fmt() and set_fmt() primitives, be aligning height then
    width on 4 multiples as need be, to reach a 16 multiple.
    
    Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 54df071..f736f6b 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -162,6 +162,8 @@
 			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
 			CICR0_EOFM | CICR0_FOM)
 
+#define PIX_YUV422P_ALIGN 16	/* YUV422P pix size should be a multiple of 16 */
+
 /*
  * Structures
  */
@@ -241,11 +243,8 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 
 	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
 
-	/* planar capture requires Y, U and V buffers to be page aligned */
 	if (pcdev->channels == 3)
-		*size = roundup(icd->width * icd->height, 8) /* Y pages */
-			+ roundup(icd->width * icd->height / 2, 8) /* U pages */
-			+ roundup(icd->width * icd->height / 2, 8); /* V pages */
+		*size = icd->width * icd->height * 2;
 	else
 		*size = roundup(icd->width * icd->height *
 				((icd->current_fmt->depth + 7) >> 3), 8);
@@ -1297,6 +1296,18 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 		pix->width = 2048;
 	pix->width &= ~0x01;
 
+	/*
+	 * YUV422P planar format requires images size to be a 16 bytes
+	 * multiple. If not, zeros will be inserted between Y and U planes, and
+	 * U and V planes, and YUV422P standard would be violated.
+	 */
+	if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+		if ((pix->width * pix->height) & PIX_YUV422P_ALIGN)
+			pix->height = ALIGN(pix->height, PIX_YUV422P_ALIGN / 2);
+		if ((pix->width * pix->height) & PIX_YUV422P_ALIGN)
+			pix->width = ALIGN(pix->width, PIX_YUV422P_ALIGN / 2);
+	}
+
 	pix->bytesperline = pix->width *
 		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
 	pix->sizeimage = pix->height * pix->bytesperline;
