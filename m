Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B21C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4772C20878
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MwSmj0X1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4772C20878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727475AbeLEPsw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 10:48:52 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43588 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbeLEPsw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 10:48:52 -0500
Received: by mail-lf1-f66.google.com with SMTP id u18so15082719lff.10;
        Wed, 05 Dec 2018 07:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lC1bscAw3ERKT7j82pFtPcdCQjQeQywp1wrjwJ+vU4Y=;
        b=MwSmj0X1ylP+T1KxpmQRONZ50lcsNXbkyXNsyfy67dV6N+YGE2JppTIKRJ8CtbfBvU
         fLxrukxLToJ8PieOdc28mcNbRFNW2Et6Om/lPnFaB1zOeXDXPctsuW6LV17UpQrE37uV
         x8cyDBNpP1SvXtZdHYyjro/J0OZbngk9Rw5KTZUjV9vHoW5vGlGaNX20cWWcnO3ZHbpu
         CnHgDr3CnHR3c2jS+fyZ3hUe+33DG+7PJ0XemUW7EGY/jEPbA/dlMxxAaRN34vB2Y6gW
         nf5zeImU56jemOX2W0f4Ebm33R2DNLMLlmQ9/3CMEg0S02bcG3u1JATi4l1vVSsfpV5Y
         3kyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lC1bscAw3ERKT7j82pFtPcdCQjQeQywp1wrjwJ+vU4Y=;
        b=OlHXH2rC75xhtVNthkDXf6ArpbdnA4CTD791A61ovOMZVv/Mgkv7xeAD+UlejZMuBA
         PnHaKAfD8aObdCJ0zPWF/ed8tknQdin1H+CF0rLr819grAeXConvWUjFmTLaL4ZF+4hJ
         m9YcU4OfBDB/AXZHbqecwgvlG2GgO926flOQuOpwyOvrh4cXUbOcRZPUQ82Tel/AOeUU
         y1l3dHYMSK6G4mb0SKVT+CtjORIyzsJxWso8j0330l0sDq6BDVg/awLXHIuxfvs/DRk5
         SiqZucZczKqj6jPuNN5Yn8M6wJgMy4Kopy5IU8kneUHvjKThVPjIjnXl7pW7YcFxk/yW
         6teg==
X-Gm-Message-State: AA+aEWZbqmev97xANNEl0AQJ1RMdtPd/6A8BaUVpGfetZNgRYKbaKIS4
        afW9k4qC7kPpi2Q49+NiF9U=
X-Google-Smtp-Source: AFSGD/X2dwNTcootmdXKiCqkKL6RJlNEo/xdNBiz/fbDSkNl4CYdrTmMWsE6rnV6uXkJ6sS9VI1BQw==
X-Received: by 2002:a19:f115:: with SMTP id p21mr14367015lfh.20.1544024929739;
        Wed, 05 Dec 2018 07:48:49 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:41e8:260c:942a:b736])
        by smtp.googlemail.com with ESMTPSA id t18sm3592517lft.93.2018.12.05.07.48.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 07:48:48 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH 0/5] media: radio-si470x-i2c: Add device tree and reset gpio support
Date:   Wed,  5 Dec 2018 16:47:45 +0100
Message-Id: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com>
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

Paweł Chmiel (5):
  si470x-i2c: Add device tree support
  media: dt-bindings: Add binding for si470x radio
  si470x-i2c: Use managed resource helpers
  si470x-i2c: Add optional reset-gpio support
  media: dt-bindings: si470x: Document new reset-gpios property

 .../devicetree/bindings/media/si470x.txt      | 26 ++++++++++
 drivers/media/radio/si470x/radio-si470x-i2c.c | 52 ++++++++++++-------
 drivers/media/radio/si470x/radio-si470x.h     |  1 +
 3 files changed, 61 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/si470x.txt

-- 
2.17.1

