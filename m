Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541AAC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 14:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CE04206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 14:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfBEOi2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 09:38:28 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41893 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfBEOi2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 09:38:28 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gr1rj-0005ZQ-R9; Tue, 05 Feb 2019 15:38:23 +0100
Message-ID: <1549377502.3929.12.camel@pengutronix.de>
Subject: Re: [PATCH] media: v4l2-tpg: Fix the memory layout of AYUV buffers
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        linux-media@vger.kernel.org
Date:   Tue, 05 Feb 2019 15:38:22 +0100
In-Reply-To: <92dbd1f9-f5dc-37ed-856a-b3b2aa2b75d5@xs4all.nl>
References: <20190129023222.10036-1-vivek.kasireddy@intel.com>
         <92dbd1f9-f5dc-37ed-856a-b3b2aa2b75d5@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Thu, 2019-01-31 at 14:36 +0100, Hans Verkuil wrote:
[...]
>
> Our YUV32 fourcc is defined as follows:
> 
> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-packed-yuv.html
> 
> As far as I see the format that the TPG generates is according to the V4L2 spec.
> 
> Philipp, can you check the YUV32 format that the imx-pxp driver uses?
> Is that according to our spec?
> 
> At some point we probably want to add a VUY32 format which is what Weston
> expects, but we certainly cannot change what the TPG generates for YUV32
> since that is correct.

I hadn't noticed as YUV32 doesn't show up in GStreamer, but testing with
v4l2-ctl, it seems to be incorrect. This script:

  #!/bin/sh
  function check() {
      PATTERN="$1"
      NAME="$2"
      echo -ne "${NAME}:\t"
      v4l2-ctl \
          --set-fmt-video-out=width=8,height=8,pixelformat=RGBP \
          --set-fmt-video=width=8,height=8,pixelformat=YUV4 \
          --stream-count 1 \
          --stream-poll \
          --stream-out-pattern "${PATTERN}" \
          --stream-out-mmap 3 \
          --stream-mmap 3 \
          --stream-to - 2>/dev/null | hexdump -v -n4 -e '/1 "%02x "'
      echo
  }
  check 6 "100% white"
  check 7 "100% red"
  check 9 "100% blue"

results in the following output:

  100% white:	80 80 ea ff 
  100% red:	f0 66 3e ff 
  100% blue:	74 f0 23 ff 

That looks like 32-bit VUYA 8-8-8-8.

regards
Philipp
