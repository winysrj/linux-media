Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8241DC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F17820868
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqUEPw7a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfAQUPC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:15:02 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46450 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbfAQUPC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:15:02 -0500
Received: by mail-pf1-f196.google.com with SMTP id c73so5338790pfe.13
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 12:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDP8l1fya6/pVhDoKdi933aHSEw6hJWm//pk2mLZJa4=;
        b=DqUEPw7aL+E5tWnmxW3E3+iucd4Nypy1XDxsM9YgaxwdffbechMFyQMQYUEpm/XQUS
         W5GsUarXpSVL9MLmR+BSiMCsoceTcVI9Lsw4h6vpw5wLhc7tv+jjeT5P5LJIwSbhfkCX
         8VXuYIBm5F3tCdzKtcaWk6cG7my9z4ByPKWyXDbPtHQX01LyyNWrvpbhzl+dVsWSU9dy
         Cu42gEWdeuXvYrvXVgguND4Wwsq2abxbKjvTqvjgFUUbo+tXkJrnxItGWaitmXHOpVV5
         gpgGnR+Qqft1TqNWho1g1pdyXJM5Bmf78qPBen6orkaneJeXQfAhHC2VSUeqg5goeqEZ
         MqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDP8l1fya6/pVhDoKdi933aHSEw6hJWm//pk2mLZJa4=;
        b=ez3IsWfqCP+vDPlnNl3kI36dSIT3pkiu9GdicHANQdoLQvPovkYJOEEgyRRryxkFPe
         3yRm2R8jWc+Be1bUZzkinx7vr6DRNhiq9nqhhr9dNWXzlmyxi7WEu7DK7g41q9Rrf2b9
         bILlQt4BkdFKDLwfWsYnYve0VhM4FODmwpKHpXCqy+Aui5SzO2ZSetY79KGtyF1bslqV
         HVTyT63aPU3inIHb2LBKCAq54wumbrdaByXZ/88TGBhcgWRHvGxorHRx2KlXu7CMhBYF
         RceDA+S9i86aUXZZVGvrZKUDk2TgcFjz4i0Jv4La5l7PvkFyWZ+U7WOl7R1M0kk2E6Ii
         zjfQ==
X-Gm-Message-State: AJcUukei1tpt+Uz8mSIOeSu4HHsfG6I3taAiCgQypzsLY7wy7AYeCict
        nHH+UwMUqwzb+UaBGzM0xqRyOXz0hBs=
X-Google-Smtp-Source: ALg8bN4jblqzchoaqyKArvbk7j1qxFJg7AP9/FMsj4bjBB09J1viFvV7ZK+lobvFTq1KToZP8Le5gw==
X-Received: by 2002:a62:ae04:: with SMTP id q4mr16357916pff.126.1547756101137;
        Thu, 17 Jan 2019 12:15:01 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id b202sm5600744pfb.88.2019.01.17.12.14.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 12:15:00 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 0/2]  media: imx: Disable CSI immediately after last EOF
Date:   Thu, 17 Jan 2019 12:13:45 -0800
Message-Id: <20190117201347.27347-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Disable the CSI immediately after receiving the last EOF before stream
off (and thus before disabling the IDMA channel).

This fixes a complete system hard lockup on the SabreAuto when streaming
from the ADV7180, by repeatedly sending a stream off immediately followed
by stream on:

while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done

Eventually this either causes the system lockup or EOF timeouts at all
subsequent stream on, until a system reset.

The lockup occurs when disabling the IDMA channel at stream off. Disabling
the CSI before disabling the IDMA channel appears to be a reliable fix for
the hard lockup.


Steve Longerbeam (2):
  media: imx: csi: Disable CSI immediately after last EOF
  media: imx: prpencvf: Disable CSI immediately after last EOF

 drivers/staging/media/imx/imx-ic-prpencvf.c | 26 ++++++++++++++-------
 drivers/staging/media/imx/imx-media-csi.c   |  7 +++---
 2 files changed, 21 insertions(+), 12 deletions(-)

-- 
2.17.1

