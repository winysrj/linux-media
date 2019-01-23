Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4063C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9435E20861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Goc/hFU8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfAWKkR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:40:17 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55548 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfAWKkR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:40:17 -0500
Received: by mail-wm1-f68.google.com with SMTP id y139so1450398wmc.5
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=2WopGAHC3vhDTNXuOGSdAGTac9qZGaqwKjIqjMvQSeU=;
        b=Goc/hFU8+Zu9MH+v7UBE/S5u1Z2Jte0UYY+VTlLvPg64dEwuuPcHZS3HA+32f1KdxN
         BwHHPJ1v4+S750m/kHv27OBl9rKzpFHcIWzOCtDarge5h93g9Ba3FBqPb8LmVHrqymVB
         UwXelunkfwho0lKOcyGUevsi2roFYQ7V7Lvv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2WopGAHC3vhDTNXuOGSdAGTac9qZGaqwKjIqjMvQSeU=;
        b=pBWR+4hyBJnQ/btEI0nDwGsQvMPCeZwOI6YenmkG+nM8xZxK7W+ieRUpF2bcDLU536
         ELWPbocLNS5F4jqonnPpi7wzBaVDwXLvZGe+R+cGTKtg7TGWcawLakd6gI4N9Yr8ISPA
         yLQxscRK0XWHvhb+QsHL26VkMxcbiAkZqVqFeRCdXKdGekc39VKJHlWLjUOugHVZ5CLD
         2s7uwOzP/Bvp8KXgr+8GNo8z+62UrxZT3bIm0LyKe06i24jhR57OTGkvSnqtsP3war9v
         jPGVDBrcm2VNfYPvRPwHymNSE4zO6LWQ00UpKQ7CEtgKDfG5DKIX1Co8hF3KmKwrzCf3
         Y42w==
X-Gm-Message-State: AJcUukcOSE7WxIN9EJtaqx7VOPJXL0gUhG26lMZvyUAZbt8hqmac39tc
        oiRpaH06ZoETXKBVd1Eh5m3bbV5VutU=
X-Google-Smtp-Source: ALg8bN5pgQqWc7dhDG5TLFgMGWYpXN57+xczsOV5sA2pCnNTv/90L1SnwGOirjslxJZgRk5Pq1pnnA==
X-Received: by 2002:a1c:cc19:: with SMTP id h25mr2161893wmb.80.1548240015469;
        Wed, 23 Jan 2019 02:40:15 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id b18sm84525211wrw.83.2019.01.23.02.40.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:40:14 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 0/4] Venus various fixes
Date:   Wed, 23 Jan 2019 12:39:45 +0200
Message-Id: <20190123103949.13496-1-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

Changes in v2:
 * in 1/4 make 'mapped' const - Alex
 * fixed typos in 2/4 and 4/4 - Alex
 * added Reviewed-by and Tested-by tags

regards,
Stan

Stanimir Varbanov (4):
  venus: firmware: check fw size against DT memory region size
  venus: core: correct maximum hardware load for sdm845
  venus: core: correct frequency table for sdm845
  venus: helpers: drop setting of timestamp invalid flag

 drivers/media/platform/qcom/venus/core.c     | 12 +++--
 drivers/media/platform/qcom/venus/core.h     |  1 +
 drivers/media/platform/qcom/venus/firmware.c | 53 +++++++++++---------
 drivers/media/platform/qcom/venus/helpers.c  |  3 --
 4 files changed, 38 insertions(+), 31 deletions(-)

-- 
2.17.1

