Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FD0C31681
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49BD920879
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TwwXaMfE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfAUS5R (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 13:57:17 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:54553 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfAUS5R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 13:57:17 -0500
Received: by mail-wm1-f42.google.com with SMTP id a62so11849777wmh.4
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 10:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FNfMy9lml9TShZbaccDHgG3dE5teQOLQRzyjZoHhAkQ=;
        b=TwwXaMfEbxr9VOMa5lAtzKDXknCugkaftRpwEcizA3X0xYcPjpb9mjcb77xe5EUh+O
         Tosr8EnGL7TgDjBpLdsDQmb7Gxx68aXxJiQgUHC0bsjk6Xj+p3LZ8BIrxgA6AtCb1joG
         rpoUKarC0EcVyEMwq1d3sEgXbhWazZhaKmu3061LqT9lBXKmjLxYlm2qq4BICqQswD5t
         DkeIAMumOwQWdmX1JgQE+9TaYMAN7OhMdxHgy4g0nE6IgKHfZOw488DnbO/H8XJ8WbWg
         oBKjvvUx794YwPad1ypqHKyQNXivAMskxQ+5zrb7a1AvlYK5AIy691dwlpVBvbbUQZTn
         W3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FNfMy9lml9TShZbaccDHgG3dE5teQOLQRzyjZoHhAkQ=;
        b=QVAqhZsNYH7aVaYEgZDOt7gwxsjx2B2AIkkCfCK59V8xGLTDp8ixbsxhAqaqQzQlsP
         TbSQrEHLIzLTON+dEYVlLYR1MmTcfTtRiPraH1ILT80RVLdEYFgYwuoMSa8ckIRPc2Do
         RfKfcBIVKc8a636XoAOKLhaXkwxPnwqz7oYSJpvyYu+WARZnwP7zCdjJyzESYP5h3DyH
         XIH4azyMWGeCXX9QXYpM3GtnSPyYxjTJmHMW72QNuf16i733pG6T9BAWNSBWIalNLCzD
         f7y9j3QqWnTH4ksargtSoMldcOXGvZgsvXvke4Po0XqkwiTGpBhRkbtmdbt5zWQ+fFdU
         67nA==
X-Gm-Message-State: AJcUukdByi0Er3fIXMLLA/94HCZ4mQBOXjo83XG730V+J1BxOMeDlTqr
        NvwcJkUMlyKFuF+tSs5E5chUmQT+ZmE=
X-Google-Smtp-Source: ALg8bN4QbZrc2z8X0F/yfFUxMI9P+BGZ6FztYIywDPbwBQ29Ml8nAG1cbIcQmf57cdkQR6IrK+3n8g==
X-Received: by 2002:a1c:c008:: with SMTP id q8mr496459wmf.99.1548097035615;
        Mon, 21 Jan 2019 10:57:15 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id 67sm145061521wra.37.2019.01.21.10.57.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 10:57:14 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v2 0/5] source change support in v4l2-ctl
Date:   Mon, 21 Jan 2019 10:56:46 -0800
Message-Id: <20190121185651.6229-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Changes from v2:
1. reomve the patch "test the excpetion fds first in streaming_set_m2m"
instead check the last buffer at the end of each loop.
2. The fmt shoud not be queried with g_fmt at each iteration, but only
after a resolution change.
3. don't enum/get/set the new format in "Introduce capture_setup" patch

Dafna Hirschfeld (5):
  v4l2-ctl: Add support for crop and compose selection in streaming
  v4l2-ctl: Add function get_codec_type
  v4l2-ctl: Introduce capture_setup
  v4l2-ctl: Add support for source change event for m2m decoder
  v4l2-ctl: Add --stream-pixformat option

 utils/common/codec-fwht.patch         |   8 +-
 utils/common/v4l-stream.c             |  14 +-
 utils/common/v4l-stream.h             |   6 +-
 utils/qvidcap/capture.cpp             |   2 +
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 363 +++++++++++++++++++++++---
 utils/v4l2-ctl/v4l2-ctl.cpp           |  39 ++-
 utils/v4l2-ctl/v4l2-ctl.h             |   2 +
 7 files changed, 375 insertions(+), 59 deletions(-)

-- 
2.17.1

