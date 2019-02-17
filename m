Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5F9C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 13:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4844B21A4A
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 13:42:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gkdPFW8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfBQNmU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 08:42:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40874 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfBQNmU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 08:42:20 -0500
Received: by mail-wm1-f68.google.com with SMTP id t15so6190869wmi.5
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2019 05:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2RVrTSLiVs3E2HR73ymR811ze1wdLic1AY3c2TN3UZg=;
        b=gkdPFW8ejc4Pqe8Xf2s1tWJFP+dZJsdlkvCMnkQAZMLJfsUhyILGzQC7Jhm3Jdxpcy
         Cgn1YOAwkz3vCys+vF2Tvdc3/45dGh0WA42XIDedoh4mtJG0NRMRuvpLJgYlN+bOd4fW
         4o58yuVjemE5w4R1F4Q5snzIruG6N5cwQaVY5tnYSd/P/hSM2pCh/pm7wGbQngMnQ11i
         E6Xy+jFnElyhizAW9jkmFecQRAHYH+JisLSsZoOM0KAwQqnmv34PS2wBwwpggVJzxx8N
         IGNBZ6JhqfvN88A3Gh7OGafzR8hs0GPd01XeWEgejUazswwUO4egBktII1QG1LKV1i6s
         yWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2RVrTSLiVs3E2HR73ymR811ze1wdLic1AY3c2TN3UZg=;
        b=HNgcW0B9KoHNphGcdYLk7k6foAsuS9E7YA6xtD93KsjXMxaNjCScLgmsHD3m7XQoQA
         M02imSywN47kmJuZAMSzhs8yRtt9ZRANgNjX3UWFEWwt1T2Rg14VVcK1ZCtL/QRy+/LY
         uq7v4L6IlnssPKYvlYeo+zdIbcmQIqMz9tRgjgjRTBg071KGfENaL7X0KEuaf1DI5wvt
         MEHISMbRUk6NCm4zkUzTr7RMwk0BdsNJj3cEHR7sqlPBd4iGyKUVPC2UONkjlHfc8rhE
         D6NqFAcre99q+ImBOqsyRaoc2HzQR0apKn9Z1rxUJ62gTvFVO3KCo652h5Y9TVUuiC0X
         q7LQ==
X-Gm-Message-State: AHQUAuaXTFTmp28zYK+8Z0CqpShKsDOgrisu4+UiwdeOY6fcfPNb/P1p
        BIP+E2M0pedi8kjD74Z4WOuOZPde9C8=
X-Google-Smtp-Source: AHgI3IYuyTLmM/962/pGGCK0Y0Zl+8CpI+EKlYIFoJ+FzINi22PVf0+YmSo2I1Dm3vjJmAF00JlEsw==
X-Received: by 2002:a1c:6c0c:: with SMTP id h12mr7133363wmc.35.1550410938641;
        Sun, 17 Feb 2019 05:42:18 -0800 (PST)
Received: from localhost.localdomain ([87.71.54.246])
        by smtp.gmail.com with ESMTPSA id o5sm39200711wrh.34.2019.02.17.05.42.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 05:42:18 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v2 0/4] Add fwht stateless decoder
Date:   Sun, 17 Feb 2019 05:42:05 -0800
Message-Id: <20190217134209.84066-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Changes from v1:

- patches 1,2 did not change

- patches 3,4 changed, main change was removing the header
from the compressed frame buffer.

Dafna Hirschfeld (4):
  v4l2-ctl: move stateful m2m decode code to a separate function
  (c)v4l-helpers.h: Add support for the request api
  v4l2-ctl: Add functions and variables to support fwht stateless
    decoder
  v4l2-ctl: Add implementation for the stateless fwht decoder.

 utils/common/cv4l-helpers.h           |   5 +
 utils/common/v4l-helpers.h            |  22 ++
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 449 +++++++++++++++++++++++---
 3 files changed, 429 insertions(+), 47 deletions(-)

-- 
2.17.1

