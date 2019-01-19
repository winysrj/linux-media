Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03BDC5AE5E
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 01:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD26120850
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 01:05:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RNy/tSrs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfASBFG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 20:05:06 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41645 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfASBFG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 20:05:06 -0500
Received: by mail-pf1-f194.google.com with SMTP id b7so7392740pfi.8
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2019 17:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+IRip7+pT7f4g75EQffICFN/8uBf6ueB+BLmHqHOWH8=;
        b=RNy/tSrsGYJl+Ul0QK742qe5fPt/bumgdwmCHZOImLAVRWmhvJTsQrKzecYDof+d46
         H+tkEAWQxBc3M2hDs9VCbGflObevjwS9PWdWZ58jzQvd1g17lDWc7WbQEqWmH2+V47Ut
         vvXmDV5BUF2cpd8CxdoBzIo5JNFKMyfh5dMWSCU3SUDl4GaZFuIq54LWlLK1rhAtYawY
         RnGJmix1WNXJ8HuI5JjQi7RZrhSTSBxVijSNA44tV9DCwjY+bincBsEl7p7J+O3XzPSS
         lah8gWInTW0y59y7F2Y6jlTmRYmtxBrR4RblUqRTd5rF4Ji7uQh/Oj6ykOV7x+rMJsFs
         1XZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+IRip7+pT7f4g75EQffICFN/8uBf6ueB+BLmHqHOWH8=;
        b=Q1aqBjbwHso+v4xX/hyk1Rdc94vQZ1+OHI2bzw3Sc+eI254BotI2hMKW6UaooetNP6
         9bVdt/Z3jUycdQi+dT12V1Qdp+ahk/fZFEs89KluyS+hW93n+lbMgI5GXjH1EYMJN3B/
         0FE3xbygVoU++jTTfhgb+jzcJ+NBDBAjc+Au+EHxewolL8SwUE0aG+LjdI5XWWfYxwda
         vusvt2ADez2uM1YCCpCBn0v5jFZP/osIBw8v5eFgBfWdCidbZUmaqA7Ux1y4ZXZLnQn+
         EfcoVhJu8QaWbPEeeMRPYU7PnYx8R8q8WxWUqHj7356BsM7cvVJVu+5Z0UmRU2fXcllD
         EIDg==
X-Gm-Message-State: AJcUukdi8tJq/NUpIajWhS5LrEcbBmRcS2/dqajajut6TCsYKyMw4D5W
        HuLk74WRQqqLPc2fzeMSrjKohLQeyyE=
X-Google-Smtp-Source: ALg8bN5xzUGhVZYKgqqm0TX/BErdLkwDLRx7sT7K7Pa/zADmctIqo7BTAO4FWJTv19XNgecyVXWwvA==
X-Received: by 2002:a62:d448:: with SMTP id u8mr21432170pfl.105.1547859904208;
        Fri, 18 Jan 2019 17:05:04 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id w128sm7955307pfw.79.2019.01.18.17.05.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 17:05:03 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v3 0/2] media: imx: Stop stream before disabling IDMA channels
Date:   Fri, 18 Jan 2019 17:04:55 -0800
Message-Id: <20190119010457.2623-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Repeatedly sending a stream off immediately followed by stream on can
eventually cause a complete system hard lockup on the SabreAuto when
streaming from the ADV7180:

while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done

Eventually this either causes the system lockup or EOF timeouts at all
subsequent stream on, until a system reset.

The lockup occurs when disabling the IDMA channels at stream off. Stopping
the video data stream entering the IDMA channel before disabling the
channel itself appears to be a reliable fix for the hard lockup.

In the CSI subdevice, this can be done by disabling the SMFC before
disabling the CSI IDMA channel, instead of after. In the IC-PRPENVVF
subdevice, this can be done by stopping upstream before disabling the
PRPENC/VF IDMA channel.

History:
v3:
- Switch to disabling the SMFC before the channel, instead of the CSI
  before the channel.

v2:
- Whitespace fixes
- Add Fixes: and Cc: stable@vger.kernel.org
- No functional changes.


Steve Longerbeam (2):
  media: imx: csi: Disable SMFC before disabling IDMA channel
  media: imx: prpencvf: Stop upstream before disabling IDMA channel

 drivers/staging/media/imx/imx-ic-prpencvf.c | 26 ++++++++++++++-------
 drivers/staging/media/imx/imx-media-csi.c   |  2 +-
 2 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.17.1

