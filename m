Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1567C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ECF72147C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfCMOmt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:42:49 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:43419 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbfCMOms (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 10:42:48 -0400
Received: from [IPv6:2001:420:44c1:2579:e8a7:494:d652:7065] ([IPv6:2001:420:44c1:2579:e8a7:494:d652:7065])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 455fhlMAT4HFn455ihPmOE; Wed, 13 Mar 2019 15:42:47 +0100
Subject: [PATCH v5 24/23] v4l2-ioctl.c: add V4L2_PIX_FMT_FWHT_STATELESS to
 v4l_fill_fmtdesc
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190306211343.15302-1-dafna3@gmail.com>
 <20190306211343.15302-21-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b4c41709-5789-9625-f83f-53365f4002a9@xs4all.nl>
Date:   Wed, 13 Mar 2019 15:42:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190306211343.15302-21-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNDvLgIaLFx4nNbJxkN/9Zsa3csixEZKNl6QVRfdgUFR8K937Kae9pRMqQqsUEYCIAH5fh+ezFivIqa1n9thkU8hqLikO1M7z3FNqufNslVheiLwyqYR
 dhEblh2OFBN9QURl6Quu55Y+16Nk8G2NlTBeDyK+NGRCPn3QpyF5KgZUXNFj7UVF/SzoTxbxu8ElExlYZrYgQgGNHRmTDIjZC4vLIxQRvfWRSMUD/SD+9pQE
 4xgDVoesDMVpaqia6DAO2DSWXsSVhfPPqgEvedwr/ica8WAg/HqKXmw1X7oniJxaznNlORGgXK0fe5uhHesswv89LJAWJLrt9+B+8DJj8FovaDPzIkJH8Mwc
 j/oPLg+n
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add V4L2_PIX_FMT_FWHT_STATELESS to the list of pixelformats that
v4l_fill_fmtdesc() understands.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Note: this patch should come after patch 20/23.
---
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f6d663934648..10133f9e27c3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1337,6 +1337,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_VP9:		descr = "VP9"; break;
 		case V4L2_PIX_FMT_HEVC:		descr = "HEVC"; break; /* aka H.265 */
 		case V4L2_PIX_FMT_FWHT:		descr = "FWHT"; break; /* used in vicodec */
+		case V4L2_PIX_FMT_FWHT_STATELESS:	descr = "FWHT Stateless"; break; /* used in vicodec */
 		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
 		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
 		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;


