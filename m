Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8401C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 14:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3E222184C
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 14:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfAXOk1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:40:27 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41044 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727600AbfAXOk1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 09:40:27 -0500
Received: from [IPv6:2001:420:44c1:2579:b544:2b8b:2897:10d8] ([IPv6:2001:420:44c1:2579:b544:2b8b:2897:10d8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id mgB3gKP0JBDyImgB7geM4y; Thu, 24 Jan 2019 15:40:25 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] vb2 + cedrus fixes/improvements
Message-ID: <f291168f-d77f-4869-a1a7-3bf56a869239@xs4all.nl>
Date:   Thu, 24 Jan 2019 15:40:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPO3A6ecTR7+r3udxDZJ6M4DI0De4Picavi7/KoKUixvA71zWJ4+KugAbazsJDFQj89oGkA3o+b3kzxLZt7rj15c4egJ/pCv7Sf9xzWRRBIlZ+VKr+0q
 VC4L3ypj40OdycvJSj7azsmwYmxmpvSauqP+GWItigfouc+t1V02/4VX0R03usIO8Fn2j+/JOvZsQESQSf3SCvdLPLo+fWy5/QcKgb6OY8jbrrfoT0gcb3kZ
 IWKyL0B1y1kaa1P9WpoICr/2ZWBupPQZ864G32HOQAH/bkEi0UHsXKGsnq+tcEh4LWcOI4b68gOvYwCQA7ubbzeB3qi+yQYsXrD4KbLns4A=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The first two patches simplify the function to find buffers based on a
timestamp: the current code only considered DONE and DEQUEUED buffers,
but that is unnecessarily restrictive.

The next two patches keep dmabuf-based buffers mapped when they are
dequeued. This avoids having to re-map them if they are referenced as key
frames in a stateless codec. This patch has been in use by ChromeOS for
quite some time and it makes sense.

It is more efficient in general anyway since you don't want to have to
map a dmabuf every time you queue it if there is no need for it.

The final 5 patches fix the sole remaining v4l2-compliance bug vivid and
vimc for output field handling in requests.

Regards,

	Hans

The following changes since commit 337e90ed028643c7acdfd0d31e3224d05ca03d66:

  media: imx-csi: Input connections to CSI should be optional (2019-01-21 16:46:02 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1i

for you to fetch changes up to 808fa39bd7bff7d1a3fa8659a8cf9157314107eb:

  vb2: check that buf_out_validate is present (2019-01-24 15:32:52 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (6):
      vb2: vb2_find_timestamp: drop restriction on buffer state
      vb2: add buf_out_validate callback
      vim2m: add buf_out_validate callback
      vivid: add buf_out_validate callback
      cedrus: add buf_out_validate callback
      vb2: check that buf_out_validate is present

Paul Kocialkowski (2):
      Revert "media: cedrus: Allow using the current dst buffer as reference"
      media: cedrus: Remove completed item from TODO list (dma-buf references)

Pawel Osciak (1):
      media: vb2: Keep dma-buf buffers mapped until they are freed

 drivers/media/common/videobuf2/videobuf2-core.c   | 33 ++++++++++++++++++++++-----------
 drivers/media/common/videobuf2/videobuf2-v4l2.c   | 18 ++++++++++--------
 drivers/media/platform/vim2m.c                    | 27 ++++++++++++++++-----------
 drivers/media/platform/vivid/vivid-vid-out.c      | 23 ++++++++++++++++-------
 drivers/staging/media/sunxi/cedrus/TODO           |  5 -----
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 13 -------------
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h   |  2 --
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c | 10 ++++------
 drivers/staging/media/sunxi/cedrus/cedrus_video.c |  9 +++++++++
 include/media/videobuf2-core.h                    |  5 +++++
 include/media/videobuf2-v4l2.h                    |  3 +--
 11 files changed, 83 insertions(+), 65 deletions(-)
