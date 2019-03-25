Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118E6C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 00:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3CD420989
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 00:36:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUMz+FjM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfCYAfq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 20:35:46 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:39508 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbfCYAfq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 20:35:46 -0400
Received: by mail-lf1-f44.google.com with SMTP id m13so4750472lfb.6;
        Sun, 24 Mar 2019 17:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DwJZ5Bop6r1egQ8vzySSqZuV+GwSZPn5rseOtqa/qog=;
        b=AUMz+FjM7fwI6o2UEKrsTaPSmQMTyQEpMEMu9DiwcSzEg6SnEC71Ee0CUxXP1h5iOD
         XuHkdE3VovQhzsZY1SE2OD1CKIU04wlI8SgJzPlgRb+FNb1Rz1XSti6sVWvXl+fkBGZT
         E9D2LW2vrc9usVjBLgn+asuPs2DSWVqXgUtE3sz51UTWKyJENAl0TH+NOaKrN808QfNk
         Oo9gccAJZ09QUA5VJhmBE8bh89IJXc9wV76csrRcPVwhMdGlkiwYMAwXY9gxLIlih6lg
         Enz7VY7efr7P2t7GYZBoXSzq9Q6p8bVsibl2W4pg7Y7ihWlsjf+33JQ5jSCzL/PNs1RU
         mSxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DwJZ5Bop6r1egQ8vzySSqZuV+GwSZPn5rseOtqa/qog=;
        b=lOsWUMy2qCBRe1cWlb1XthQDsyxTW+8/68/I0am2N2UsbGTG7CzM4MAmei9kJl3sQa
         /mj0etEGpVt/1FAmyo/Eu9aYBCy9aMLjo9Vw4NhK9Yxuu5baBbxTxm6M/fCXYsXP3Sfr
         FEo/fn5OKXszOswvWFEnUgjU1FSTv+7ty5EoSQZGYirMGsi2wO3R1nUQwH3qBZHtQDnd
         WOgQlSuXiTeShnEqWkxH2KMgfWtWkjxGm9X9mcPPj0kMRkN3/rTQ8y0UqUkJEhY6tf29
         McZuchHIVsWQAf8bJ/86SXVXACK+VKky0QXpfTvbWPKDXGXr+mQcKfa5TiIEFSO7v3U8
         /rqg==
X-Gm-Message-State: APjAAAU0sys6Ta/x2ZbUY1vmpqZccpjUFHYwTT6Ww7rtYYAkBNv1OaDm
        w7Yb8j+oBo+Wt8+nb5N15fSkHoAe
X-Google-Smtp-Source: APXvYqzM3eSXTf3zC+UP4PVwwEosBMPkElD0Vfi/tK2Drhq+Rg7xz3iJe/NppTu+5L6dnc+FpfWSyg==
X-Received: by 2002:ac2:5961:: with SMTP id h1mr6397642lfp.167.1553474144530;
        Sun, 24 Mar 2019 17:35:44 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id y17sm1217993ljd.54.2019.03.24.17.35.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Mar 2019 17:35:43 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [PATCH 0/2] media: ov6650: Add V4L2 asynchronous subdevice support
Date:   Mon, 25 Mar 2019 01:34:59 +0100
Message-Id: <20190325003501.14687-1-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Janusz Krzysztofik (2):
      media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper
      media: ov6650: Register with asynchronous subdevice framework

 ov6650.c |   45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)


