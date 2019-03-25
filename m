Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F23C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 17:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 487772087E
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 17:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="QTlSeDd6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbfCYRfG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 13:35:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35785 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfCYRfG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 13:35:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id w1so11219877wrp.2
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 10:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lnQ9Y1fYzcSZfxA2CD5Z1Q398yaxdzQe2+YWsYEaBVo=;
        b=QTlSeDd67uLHBe+FyH15m2BDagLrsgMib+10miZWoY2yIkcUK05Ihr60F7Dl2shnsH
         N370gM83t4G/TwCC7+lQMTl3OzIHDog3SnKahLSFFl/899oh5qJqNbDgluzxGSuwp8It
         Dj46USmAqe2w6fs4PLc2OVzR+Ce765D2XmFP5qdB9TLQOjd/FVRJ9dEfjhmKh2N4nDKj
         XSkQyWuAbO15Ns/Fe/BHjHT8dbo1UYDox3afIDjZEw/hwHJl8OgFyN6v6btlpj5MsmzZ
         lABMYdFbYU47x/be11XzM3zPQXchWHEmTQ1c0pDAW7QySPfZDINtSGuM++uhp43VM8Dk
         oEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lnQ9Y1fYzcSZfxA2CD5Z1Q398yaxdzQe2+YWsYEaBVo=;
        b=JIR8GdqJ7rHyLfOrSpwXOR0/N+Wkeqdd2UQe/UpyKPKLLzpk4VWlCqLpG9guWOOUtu
         HgFk/n6fQ/UnzSCrh9C6vL1gsUKVWX5OwOGlqengss/0Igxy7Db2KNW1bM0QA4H6QPuo
         O4Ckb+VQanawASYXAtynRkTGunI+DXntop1nCd9uI9FP1b6estWEUzpkhUXmsrxX4yzV
         cthRAlK+EYFCVqVdqoblkR0n1zL7TScBgsQCZhPUntVnvzgWUWkZuLP9vmFaheEna0GT
         cONEy6fj7cbJNFvkT3qGZwA3NxE1PjrjZ88KfcyPFkaOnbARiCQJvlGBVVRH2ecnzp3W
         QksQ==
X-Gm-Message-State: APjAAAU7HFWQHhDAIdPTV3TDsLi6oYUOlUay8lNdpk7GUGhsV5lVJUYb
        JO9GxkMapvRNNf7O3SJLu4+hMg==
X-Google-Smtp-Source: APXvYqwVTL/cSQffrQXPHLK0MEqsQrIXElwzTpgSM7hG2Dumj7gxFlTg1v5MUFq1zot14ZXI1oR85A==
X-Received: by 2002:adf:fcc5:: with SMTP id f5mr16672219wrs.166.1553535304504;
        Mon, 25 Mar 2019 10:35:04 -0700 (PDT)
Received: from localhost.localdomain (176-150-251-154.abo.bbox.fr. [176.150.251.154])
        by smtp.gmail.com with ESMTPSA id o15sm16003227wrj.59.2019.03.25.10.35.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 25 Mar 2019 10:35:03 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     hverkuil@xs4all.nl, mchehab@kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] media: platform: Add support for the Amlogic Meson G12A AO CEC Controller
Date:   Mon, 25 Mar 2019 18:34:58 +0100
Message-Id: <20190325173501.22863-1-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The Amlogic G12A SoC embeds a second CEC controller with a totally
different design.

The two controller can work in the same time since the CEC line can
be set to two different pins on the two controllers.

This second CEC controller is documented as "AO-CEC-B", thus the
registers will be named "CECB_" to differenciate with the other
AO-CEC driver.

Unlike the other AO-CEC controller, this one takes the Oscillator
clock as input and embeds a dual-divider to provide a precise
32768Hz clock for communication. This is handled by registering
a clock in the driver.

Unlike the other AO-CEC controller, this controller supports setting
up to 15 logical adresses and supports the signal_free_time settings
in the transmit function.

Unfortunately, this controller does not support "monitor" mode.

This patchset :
- Update the bindings for this controller
- Add the controller driver
- Update the MAINTAINERS entry

Neil Armstrong (3):
  media: dt-bindings: media: meson-ao-cec: Add G12A AO-CEC-B Compatible
  media: platform: meson: Add Amlogic Meson G12A AO CEC Controller
    driver
  MAINTAINERS: Update AO CEC with ao-cec-g12a driver

 .../bindings/media/meson-ao-cec.txt           |  15 +-
 MAINTAINERS                                   |   1 +
 drivers/media/platform/Kconfig                |  13 +
 drivers/media/platform/meson/Makefile         |   1 +
 drivers/media/platform/meson/ao-cec-g12a.c    | 783 ++++++++++++++++++
 5 files changed, 809 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/platform/meson/ao-cec-g12a.c

-- 
2.21.0

