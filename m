Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD97C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3BC2217D7
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:04:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nYFz+jRn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfAXKEe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:04:34 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36923 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfAXKEd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 05:04:33 -0500
Received: by mail-pf1-f195.google.com with SMTP id y126so2744364pfb.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 02:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=puJliDBLLTHE21x91aNJD4xAQUUHWOIDOL9FkwyUojM=;
        b=nYFz+jRn4HhwcWEdfJpkdPPvrtsSVAkEnZ3GB39uxdJEpCUw1Kav7EXcX6OU4apzwq
         Of7O7+jjjnbxoSHFrZVrQQihJqE8snV1yruZCu8Fxt3X2/nYj7CDexfa+AkLp/ozgl1W
         F2qGGhNv2XnzibLpfJ5rRilWeoznL10tDeULg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=puJliDBLLTHE21x91aNJD4xAQUUHWOIDOL9FkwyUojM=;
        b=NLYu6mANOlhBo6Wn0N9sEsveVw6kTmEu2z9/wVnwfWNgEExL7TqxpIjEWTbpijSExL
         KjX+jafcdpABkhplOHb4f46kStgGf8RQRKMIsCe2LVypodxqjk853Ei/vRxtz6rBTwUJ
         qFRks6x43uHwchiqF73MxYBZktudQCioxyVyO3VG8ZWjsZBKrGZ3Qk7dpV94IAj0Oq1n
         Xe3Ctkgoc6YdkyMtiCOvueCXHCDnypCks5C93COxVeC1LUmBPYZ9b895bHFSEkkDhrHA
         yjAkcMDJn9SFZyffghrYh7MK6BcR7MDTttNrH5xhWjbl7iQmtuTPWAZ955nn3l1VSGyW
         fMTQ==
X-Gm-Message-State: AJcUukc7UrYFbkLAQo273sPBrxmuitKvqOjIRTkAkm161Kmyh4JqO976
        G22q7dqCiM+mWICp3tedg9C9AIJpTEiNeA==
X-Google-Smtp-Source: ALg8bN5XO98FAs3f+z+UqhXR6XevBNgSrlhvGGM4oyA6SnPx7+8GVVWicUn+BvsYfaFFcZF8OcVLkQ==
X-Received: by 2002:a63:d747:: with SMTP id w7mr5239964pgi.360.1548324272064;
        Thu, 24 Jan 2019 02:04:32 -0800 (PST)
Received: from tfiga.tok.corp.google.com ([2401:fa00:4:4:6d27:f13:a0fa:d4b6])
        by smtp.gmail.com with ESMTPSA id r66sm33533969pfk.157.2019.01.24.02.04.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 02:04:31 -0800 (PST)
From:   Tomasz Figa <tfiga@chromium.org>
To:     linux-media@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Tiffany=20Lin=20=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?= 
        <tiffany.lin@mediatek.com>,
        =?UTF-8?q?Andrew-CT=20Chen=20=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?= 
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH v3 0/2] Document memory-to-memory video codec interfaces
Date:   Thu, 24 Jan 2019 19:04:17 +0900
Message-Id: <20190124100419.26492-1-tfiga@chromium.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Late happy new year everyone. It's been a while, but here is the v3 of
the stateful mem2mem codec interfaces documentation. Sorry for taking so
long time to respin. (Again.)

This series attempts to add the documentation of what was discussed
during Media Workshops at LinuxCon Europe 2012 in Barcelona and then
later Embedded Linux Conference Europe 2014 in Düsseldorf and then
eventually written down by Pawel Osciak and tweaked a bit by Chrome OS
video team (but mostly in a cosmetic way or making the document more
precise), during the several years of Chrome OS using the APIs in
production.

Note that most, if not all, of the API is already implemented in
existing mainline drivers, such as s5p-mfc or mtk-vcodec. Intention of
this series is just to formalize what we already have.

Thanks everyone for the huge amount of useful comments for the RFC and
v1. Much of the credits should go to Pawel Osciak too, for writing most
of the original text of the initial RFC.

Changes since v2:
(https://lore.kernel.org/patchwork/cover/1002474/)
Decoder:
 - Specified that the initial source change event is signaled
   regardless of whether the client-set format matches the
   stream format.
 - Dropped V4L2_CID_MIN_BUFFERS_FOR_OUTPUT since it's meaningless
   for the bitstream input buffers of decoders.
 - Explicitly stated that VIDIOC_REQBUFS is not allowed on CAPTURE
   if the stream information is not available.
 - Described decode error handling.
 - Mentioned that timestamps can be observed after a seek to
   determine whether the CAPTURE buffers originated from before
   or after the seek.
 - Explicitly stated that after a pair of V4L2_DEC_CMD_STOP and
   V4L2_DEC_CMD_START, the decoder is not reset and preserves
   all the state.

Encoder:
 - Specified that width and height of CAPTURE format are ignored
   and always zero.
 - Explicitly noted the common use case for the CROP target with
   macroblock-unaligned video resolutions.
 - Added a reference to Request API.
 - Dropped V4L2_CID_MIN_BUFFERS_FOR_CAPTURE since it's meaningless
   for the bitstream output buffers of encoders.
 - Explicitly stated that after a pair of V4L2_ENC_CMD_STOP and
   V4L2_ENC_CMD_START, the encoder is not reset and preserves
   all the state.

General:
 - Dropped format enumeration from "Initialization", since it's already
   a part of "Querying capabilities".
 - Many spelling, grammar, stylistic, etc. changes.
 - Changed the style of note blocks.
 - Rebased onto Hans' documentation cleanup series.
   (https://patchwork.kernel.org/cover/10775407/
    https://patchwork.kernel.org/patch/10776737/)
 - Moved the interfaces under the "Video Memory-To-Memory Interface"
   section.

For changes since v1 see the v2:
https://lore.kernel.org/patchwork/cover/1002474/

For changes since RFC see the v1:
https://patchwork.kernel.org/cover/10542207/

Tomasz Figa (2):
  media: docs-rst: Document memory-to-memory video decoder interface
  media: docs-rst: Document memory-to-memory video encoder interface

 Documentation/media/uapi/v4l/dev-decoder.rst  | 1076 +++++++++++++++++
 Documentation/media/uapi/v4l/dev-encoder.rst  |  586 +++++++++
 Documentation/media/uapi/v4l/dev-mem2mem.rst  |    6 +
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |   10 +
 Documentation/media/uapi/v4l/v4l2.rst         |   12 +-
 .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
 .../media/uapi/v4l/vidioc-encoder-cmd.rst     |   38 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
 8 files changed, 1752 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
 create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst

-- 
2.20.1.321.g9e740568ce-goog

