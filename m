Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54951C282C6
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DB95218DE
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfAYP3Q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:29:16 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:42499 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726238AbfAYP3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 10:29:16 -0500
Received: from [IPv6:2001:420:44c1:2579:d4cf:253b:d711:6098] ([IPv6:2001:420:44c1:2579:d4cf:253b:d711:6098])
        by smtp-cloud8.xs4all.net with ESMTPA
        id n3PqgkDKQNR5yn3Pugw8Cz; Fri, 25 Jan 2019 16:29:14 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] vb2 + cedrus fixes/improvements
Message-ID: <c861f137-c626-090d-b853-5a5c39b50a51@xs4all.nl>
Date:   Fri, 25 Jan 2019 16:29:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHcJoxd7h/YFDabj5UnfYnugyjztShNuncE+nUIhCpdeAhsybqO1HTgm++dXr9G/zN2u5wWuQeczWBk09qzCI1ysSk9sWfdqhXnXWxtIOSgTtU8QW1yx
 tGEp9s/bmB0qUTMVEM4irf6gw/T4z00+QXpoSkSygeoSAjFTxQnBIQwGDIcOTreisZ8S9ZcT9o4BPF8zkZhTDb0XcsN9Z2wzzq8SDUDRlK1Al/SOND1xqSF2
 +AIZpc0PRpKq72d+eLQMGi68UltN/PA2VsDOR4Mv8+YlgGpWrWYr1FY5c1f1vzkkkKTqj6dzos/zt3lT9x9qUe+SkzYID2UCxeuHvM/J4S8=
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

This PR supersedes https://patchwork.linuxtv.org/patch/54136/, updating
the last patch with a newer version: https://patchwork.linuxtv.org/patch/54167/

The following changes since commit 337e90ed028643c7acdfd0d31e3224d05ca03d66:

  media: imx-csi: Input connections to CSI should be optional (2019-01-21 16:46:02 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1i2

for you to fetch changes up to a50568612b16fd5e42375f2f31a123ff8bc51b60:

  vb2: check that buf_out_validate is present (2019-01-25 16:24:45 +0100)

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
 drivers/media/common/videobuf2/videobuf2-v4l2.c   | 20 ++++++++++++--------
 drivers/media/platform/vim2m.c                    | 27 ++++++++++++++++-----------
 drivers/media/platform/vivid/vivid-vid-out.c      | 23 ++++++++++++++++-------
 drivers/staging/media/sunxi/cedrus/TODO           |  5 -----
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 13 -------------
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h   |  2 --
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c | 10 ++++------
 drivers/staging/media/sunxi/cedrus/cedrus_video.c |  9 +++++++++
 include/media/videobuf2-core.h                    |  5 +++++
 include/media/videobuf2-v4l2.h                    |  3 +--
 11 files changed, 85 insertions(+), 65 deletions(-)
