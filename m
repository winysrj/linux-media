Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6814C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CF7320837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kVvEK6Q3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CF7320837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbeLGN6Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:58:24 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34000 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeLGN6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:58:24 -0500
Received: by mail-lj1-f196.google.com with SMTP id u6-v6so3652496ljd.1;
        Fri, 07 Dec 2018 05:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z9kRwe4zFtVd/1/tLzVtsToPMheCZp7KDh+roCD85ZA=;
        b=kVvEK6Q3zZAEAQXF9BWVVyXGmYem9UZfW+lasImps5Zwib9HIDIPPyR/WJD+yioEBm
         AjVEF675iH7hEpi04t2bL0B30de1eIfVzsqf4w/rO6BgA5vYGbLekc0xd3pk/oQM1nMJ
         2ttB2rH6gAllGdUYUcgkucQTLMlm5V9w4DNSXq48+Gp/phVH6N8sghYWR9QX4V1yUWmV
         /wJJKZp8WCTYxeyoxQC6iWwOhHgiA5uDvnqvwF3ctrJBAXVl6Hwa8BTzpfioml2q99eE
         X29etMbC5buDIgbOeI9t9dyayY1i5rpITweXQFlPMWUyELeuQOWAUZlxOG0saeP2TEAX
         bZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z9kRwe4zFtVd/1/tLzVtsToPMheCZp7KDh+roCD85ZA=;
        b=cU7pKGhuUwzUfESbAZP/CZxvGrmHE48Wk3JKB86Ld+ln4kt7WOgX47uhgolwTai5vL
         JyXE/ZXik9nLffEcmtwIGVGMlSaF/kDImDjZsmyXYmwyJq0/TXixfhMF8acnqkD5b/lZ
         sbuMUsLOaPkbTj+hwP9XqpCxwaWHRQsx/Z4YW/5RLGhjUzG6y2Z4e0uOMd1ku+id/WsW
         altKSiWSTuTYCBYVxlHzcFquidzLQ5KG7t1aErf5r+sE/7bh2w30CY5CSTUEnLjT9Ind
         w3QmHjHXAuJAwp8BDQTIiYOw49BHCvdWDKtYFGABsgo+kklNwIBGGgCQrd9zbXN7NJjB
         vQ0Q==
X-Gm-Message-State: AA+aEWbxHOG70qEnuyEP+z9KIHuAPnj6+MPwjlgkOwBssp47VA7YjP0W
        aXunf5mKvLnP20kq9XTYRSs=
X-Google-Smtp-Source: AFSGD/VVWgUNlNRDqsNeio45JnAD4o5pISDK/hkZObPVFgfxFv7fkjMc6zJpwXfiqKuMe8oGKDU4pQ==
X-Received: by 2002:a2e:96c6:: with SMTP id d6-v6mr1557462ljj.35.1544191102043;
        Fri, 07 Dec 2018 05:58:22 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:74d5:51ba:2673:f3f4])
        by smtp.googlemail.com with ESMTPSA id i143sm624609lfg.74.2018.12.07.05.58.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 05:58:20 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH v2 0/4] media: radio-si470x-i2c: Add device tree and reset gpio support
Date:   Fri,  7 Dec 2018 14:58:08 +0100
Message-Id: <20181207135812.12842-1-pawel.mikolaj.chmiel@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset adds support for device tree and reset-gpios
to si470x i2c radio driver.

First two patches adds and documents device tree support.
Third patch simplifies code by using managed resource helpers.
Last two patches adds and documents new optional reset gpios support.

It was tested on Samsung Galaxy S (i9000) phone.

Changes from v1:
  - squashed patches adding/modifying dt-bindings into one patch

Paweł Chmiel (4):
  si470x-i2c: Add device tree support
  si470x-i2c: Use managed resource helpers
  si470x-i2c: Add optional reset-gpio support
  media: dt-bindings: Add binding for si470x radio

 .../devicetree/bindings/media/si470x.txt      | 26 ++++++++++
 drivers/media/radio/si470x/radio-si470x-i2c.c | 52 ++++++++++++-------
 drivers/media/radio/si470x/radio-si470x.h     |  1 +
 3 files changed, 61 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/si470x.txt

-- 
2.17.1

