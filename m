Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95151C61CE4
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53FC12084C
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5f1BYpT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfASVqK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 16:46:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37595 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbfASVqK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 16:46:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id g67so7534279wmd.2
        for <linux-media@vger.kernel.org>; Sat, 19 Jan 2019 13:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Lipbb4HgR5CZQnceyjYakIKNxwWLAD+EULwnne+4JyE=;
        b=K5f1BYpTnf1ofiG63urxs+YWwBqGnR5JwuSZxsFkdkMxjEO4csOgJ/G3sqgy9fkP+w
         JRfCCJHDK0jjOiapbEOTrFj80UPg+UkvKX/9bCxA5qvBZgdbI05xamz3GBIJWXmVVvdR
         AxglnuoaKrEtvGX1JzIY/5XEPUZ2vlCLOeiSzAS9SfAQ73UDcb3TJF0fYEk9JsR+vlJv
         p9kSfQh1hJkPDarZ3G+1Hcys84xZLjUjX2lt7H2YyQHEKRPqayjPd7nq6qHFqv7yac66
         OZNJjKLZs2ckzC21iUpbL4bvTZIgDn+KbIeti/zYyELlsNpHsJrVdatfeTH/GxCRG+Cq
         srtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Lipbb4HgR5CZQnceyjYakIKNxwWLAD+EULwnne+4JyE=;
        b=sHK0p0qRvo8VukFnttcgkuI5/+WDcWj4raRRfm38Y318GGiZ/rM9R8TIRvJ4xKN6Vn
         I3lXWT3w69iR+14YpVBBSFO2j2P3EatPXC0K6ILMKQmWR88SUD0RDURac3ZNJvBd3nMF
         wa4sdow8TzpM2/9ytPON2fkZuU6g6cM220PLCL2OSgXlJcC4+FP4jlvelxV6Basu4dVA
         cRngDaOjLr+CkZBwVSaToV+PnyfZpbteZrSFzadA16IVYAtzn2BqCNEh0ms6DpWZ4bkC
         PzvFNzrs6/bUzH6msAxY0qUgTR+4Sa4jNQOedH415kLiAN1JVjfLDU5Xnr17wvMA42Hv
         M1eg==
X-Gm-Message-State: AJcUuke7D8VkKEI+zdKhGenc6ELLpfVSK4KAIipBXEo4yHT18i29WQeR
        RhAgzLIXLouvN/zdEmxsg1T2oWSW
X-Google-Smtp-Source: ALg8bN4GtU0yLJ/ThoZlYFvIJwa1Yu3y9rHvCk8LrTaDu4cRONRnIcBKKhmlyzfvxCP+ugYBa2ZjkQ==
X-Received: by 2002:a1c:f518:: with SMTP id t24mr11014154wmh.26.1547934368102;
        Sat, 19 Jan 2019 13:46:08 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o5sm26432048wrw.46.2019.01.19.13.46.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jan 2019 13:46:07 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 0/4] media: imx: Various fixes for i.MX5 support
Date:   Sat, 19 Jan 2019 13:45:56 -0800
Message-Id: <20190119214600.30897-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some fixes and improvements to support video capture on i.MX5.

Steve Longerbeam (4):
  media: imx: csi: Allow unknown nearest upstream entities
  media: imx: Clear fwnode link struct for each endpoint iteration
  media: imx: Rename functions that add IPU-internal subdevs/links
  media: imx: Don't register IPU subdevs/links if CSI port missing

 drivers/staging/media/imx/imx-ic-common.c     |  2 +-
 drivers/staging/media/imx/imx-media-csi.c     | 18 +++-
 drivers/staging/media/imx/imx-media-dev.c     | 13 +--
 .../staging/media/imx/imx-media-internal-sd.c | 36 +++-----
 drivers/staging/media/imx/imx-media-of.c      | 91 ++++++++++++-------
 drivers/staging/media/imx/imx-media-vdic.c    |  2 +-
 drivers/staging/media/imx/imx-media.h         | 11 ++-
 7 files changed, 92 insertions(+), 81 deletions(-)

-- 
2.17.1

