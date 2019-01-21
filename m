Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA3BC7112F
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3569B2085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJyAg7EM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfAULqg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 06:46:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40716 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfAULqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 06:46:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id p4so22956000wrt.7
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 03:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Tfq+5BMJwTjYPWmSFx80PO/RgeO3zrdvv87GIXOZdxg=;
        b=iJyAg7EMTDAwWdtkxECniwwLNjGnnkJavy1lzeXkzbiwA2cq0FlUKWIeRuhGAoczFU
         Ei1jdaLugbp/QzH2McbQJ1BRThVY0X2dbaA4MeZqPCFSKWI+GpAZxLnK1YHfFEbCTKFN
         cm7VETwcbU15iy+/BQH3gbUnP1xuvVX0hNLLiKaYSqsWnOu5G0sEdyek5HwwRMYXiI3b
         vPTtxFSTWBWlZrcdToEj6WFrjLSksO7LGCl/vxRo0LGcFi1GjJL30JsV/I+kFil9hz5X
         RgRIxWzBn7ObjWwQqSzWs8Maj64PW/9DzY57jOfwj7uRcYwZ0Rx/dBnF/l7X694lkp4v
         kAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Tfq+5BMJwTjYPWmSFx80PO/RgeO3zrdvv87GIXOZdxg=;
        b=jg1JQOPyQFynjo62wD3HDw+3/h1oKkRaiZKHd9Ece5j9caZPGMW/eh1em7y1vC/OXL
         WgKjTQHMMqmrz3oMtuV9dhPvHgDCBKMw3qBXOlc4iIWle6f6Vcl9Z07f0QItnHDx/eqB
         oUJBdptvxoeJgIyvZAtnovEgyfGDswf2GkJ0OC1Jr7JxErtcdFuCyxiLaoCLHoMkHsRz
         2EUnahwu5EU1OsCEgQfJXH3ztwJPC+PnU2quOxNJi2JEUM17r52d1eBEgg8Kwho/o2Qa
         XhS9185pwVTG5AkwWCIID+VZEOCG3vIbiLq9lTRSv5U7hIL0NM4a292w23mNrweCiabx
         Ui6g==
X-Gm-Message-State: AJcUukfg2ZUTYJo7zC+1eut4klIV+EscNMERcnfPr+/+pZIjs0keu3Zy
        k9y27UBWNErQJ0l5JaVq4Ox04Hx3w1A=
X-Google-Smtp-Source: ALg8bN5hHzubVHSR5QKOOP7EtjRGgZloyQ9NU/Pqrj2Hhc42/6y3/0BpTui4f7JaQant5Fg3mUHZmA==
X-Received: by 2002:adf:aa9c:: with SMTP id h28mr27132267wrc.216.1548071194574;
        Mon, 21 Jan 2019 03:46:34 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id z7sm83189584wrw.22.2019.01.21.03.46.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 03:46:33 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v6 0/5] media: vicodec: source change support
Date:   Mon, 21 Jan 2019 03:46:13 -0800
Message-Id: <20190121114618.115282-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Changes from v5
cleanups of 'line too long' warnings'

Dafna Hirschfeld (5):
  media: vicodec: add support for CROP and COMPOSE selection
  media: vicodec: use 3 bits for the number of components
  media: vicodec: Add pixel encoding flags to fwht header
  media: vicodec: Separate fwht header from the frame data
  media: vicodec: Add support for resolution change event.

 drivers/media/platform/vicodec/codec-fwht.c   |  83 ++-
 drivers/media/platform/vicodec/codec-fwht.h   |  25 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 388 +++++++----
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  14 +-
 drivers/media/platform/vicodec/vicodec-core.c | 626 ++++++++++++++----
 5 files changed, 835 insertions(+), 301 deletions(-)

-- 
2.17.1

