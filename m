Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD79FC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 18:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8734020818
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 18:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549045432;
	bh=FhnII6v0nQOZ8lsezYzxTMm1Mm024mt54I6RJ2KN2gA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=r3abN0xAkPT0QMH66PbRLSPUxPeyzpqjqjpEM5xQaLJ/4rA+TEvxRB9fmLPHECPs8
	 JNoke0lLuV2qJt+p27jL1MsFyA63sqH2DxqB3unt+Vnnt0AtkbkUYFI6TxZTEtODcU
	 TOWHKkkubgbdOFeqb3QGUnntAF1C4En1/BiO8nrc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbfBASXw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 13:23:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729984AbfBASXv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 13:23:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2iRmlCqEphDSer6VJeKqPpxuyAXp+Lgt3b8tDHHawn4=; b=MAxNifWJVJ8mv+tlUa7bnfYXY
        jLNZRVZGc106wFlGvvML+9teTw5U+40sT+LQpfwch4m3V/nlVqDtHlYgaXQl+JkLOd+P0mgo6fW87
        rwm8fzjd1MSW8Vhq631m0WDkfa2j+l4+sIPMmRFH36+GyIwGrxwfcyKdVZfLNisYQUaoYdhSRg35W
        gm4LkTsuRixv3UlwHkTtCGsAVH9QwTYhqL+yNDS1/vkkIjrKvft4nk+j2N6Y4aY1Z/w3MXBTJAbEk
        1ESiQvcGbMnXEVEWOUpykLJuGwpatucPBLwH1NABCl1jmQmVaWALDm7jsvZ+yjXb93KlkLjSkocd3
        jTPRJ9Gcg==;
Received: from 179.187.106.61.dynamic.adsl.gvt.net.br ([179.187.106.61] helo=silica.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gpdTi-00008x-BI; Fri, 01 Feb 2019 18:23:51 +0000
Date:   Fri, 1 Feb 2019 16:23:46 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     linux-media@vger.kernel.org, gstreamer-devel@freedesktop.org
Subject: Re: Gstreamer and vim2m with bayer capture formats
Message-ID: <20190201162346.729cf830@silica.lan>
In-Reply-To: <20190201155506.76354195@silica.lan>
References: <20190201123239.7d4eacfb@silica.lan>
        <f253a1ac6af48b03e6e49ef46af3aef8e77a3186.camel@ndufresne.ca>
        <20190201155506.76354195@silica.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 1 Feb 2019 15:55:06 -0200
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Em Fri, 01 Feb 2019 12:03:49 -0500
> Nicolas Dufresne <nicolas@ndufresne.ca> escreveu:
> 
> > If my change you have resources or time to work on a proper patch, be
> > aware that patch submissions works through gitlab.freedesktop.org Merge
> > Request (basically pushing a branch on a fork there and doing couple of
> > webui clicks).  
> 
> Ah, ok. Well, the intention here was just to do a RFC and check with
> you about the proper solution.
> 
> While I do have a limited amount of time, due to my kernel duties,
> I could try to write a different patch for it once I understand
> better what should be done.
> 
> While that doesn't happen, IMHO, the best is to send RFC patches via
> e-mail, as it allows c/c the discussions to the linux-media ML.

Cheers,
Mauro

Ah, I guess I see the issue... gst_v4l2_object_get_raw_caps() doesn't
associate bayer formats as a format that a v4l2transform would accept.

So, a change like the one below would make it to recognize the 4 bayer
formats that was added to vim2m as belonging to a v4l2convert type, right?

Indeed with this patch it is now recognizing the formats and a
v4l2video0convert block was recognized.

Unfortunately, this is not working yet:

$ gst-launch-1.0 videotestsrc ! video/x-raw,format=BGR ! v4l2video0convert disable-passthrough=1 extra-controls="s,horizontal_flip=1,vertical_flip=1" ! video/x-bayer,format=bggr ! bayer2rgb ! videoconvert ! ximagesink

Maybe I need to change something else too for it to negotiate between
a v4l2 capture sink from videoconvert and bayer2rgb source.

-

diff --git a/sys/v4l2/gstv4l2object.c b/sys/v4l2/gstv4l2object.c
index 124c778c626d..5a1e52989903 100644
--- a/sys/v4l2/gstv4l2object.c
+++ b/sys/v4l2/gstv4l2object.c
@@ -157,10 +157,10 @@ static const GstV4L2FormatDesc gst_v4l2_formats[] = {
   {V4L2_PIX_FMT_NV42, TRUE, GST_V4L2_RAW},
 
   /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
-  {V4L2_PIX_FMT_SBGGR8, TRUE, GST_V4L2_CODEC},
-  {V4L2_PIX_FMT_SGBRG8, TRUE, GST_V4L2_CODEC},
-  {V4L2_PIX_FMT_SGRBG8, TRUE, GST_V4L2_CODEC},
-  {V4L2_PIX_FMT_SRGGB8, TRUE, GST_V4L2_CODEC},
+  {V4L2_PIX_FMT_SBGGR8, TRUE, GST_V4L2_RAW | GST_V4L2_CODEC},
+  {V4L2_PIX_FMT_SGBRG8, TRUE, GST_V4L2_RAW | GST_V4L2_CODEC},
+  {V4L2_PIX_FMT_SGRBG8, TRUE, GST_V4L2_RAW | GST_V4L2_CODEC},
+  {V4L2_PIX_FMT_SRGGB8, TRUE, GST_V4L2_RAW | GST_V4L2_CODEC},
 
   /* compressed formats */
   {V4L2_PIX_FMT_MJPEG, FALSE, GST_V4L2_CODEC},

