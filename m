Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE38FC37122
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 23:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9019D2089F
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 23:36:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Chtl04jD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfAUXgD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 18:36:03 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41708 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfAUXgC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 18:36:02 -0500
Received: by mail-pf1-f193.google.com with SMTP id b7so10797291pfi.8
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 15:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+nbs4JKCg+Prw9LjsZaMA7Zq/1NcToXTSk8h2iXZRXo=;
        b=Chtl04jDvnS9gUSRg7ayus1A2PxQY/ofD/nB9koOJ+Px9wqDi0Y3STHIPWBPR5aWHQ
         fKn59WFOD702Q0bJLfS1MyzUCl9t2vVeTAe22Oe4ZuZcrFjYAQ2guvDordW8mnADwgqj
         ktEcxgP3AlB3828hqSZVyZ87BMhwWFUwpa+6HEwk0pV3Xs2jmPLM2BwWrijkCHgSTlvB
         JjjlrQv/uBEVv1fVdYoSKTt+n4xfwiYvcwsBoQC/quDuwsJ8IFQCeDAdVOgVujrsAf7W
         QHSlZIOMqNOnKSJ11LfOYGS1WiWDsVzqb4apU4tV0MPJ1W9fI6El4x/EwCXc7GbEQT7W
         onZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+nbs4JKCg+Prw9LjsZaMA7Zq/1NcToXTSk8h2iXZRXo=;
        b=fSW7XH16PDfKhfhMXFXjrprIKYDxcMt6K2Q1CpvgIDINcixiY4zx+tseNzxNNmJXgx
         JjzBTs/oFWayIflENS08v8PKOPhBp50EMCd0eUM1WL8x34VqWF8ySaQNjuLKKegz3OjJ
         GxRIbZRSXWmftmKKVH4ZH2NO15PdapTO4wj2mqvsdE2f/Yz0h3dWV0IYPQGqAdGORybM
         O4AZju5TfEosuRen551AhWu4pOhiKPUOB8cuPHfq1LSEwor925+mP60EEBDF27A8Ifyi
         unX3SJTbrTvzvg9Og6t8TTSs0is2jBc22HuZZQtIPdE6uS19c1KDyYOaYbn+eELLC7oM
         mwJA==
X-Gm-Message-State: AJcUukcvU7cyyKcb6XP10nsHAaxPcbrjrUIgj3c4Xgrqe+bGl4GTbyyT
        gGu9NFIt9Mll1VlF1MKSNklp3MDAxpI=
X-Google-Smtp-Source: ALg8bN6dp+uiAV4YowU1OGWWreYGk1MepYUPjRjQVlOf4sRtoIh2+FdQQ0i0mBscHz9ijN/9gApqRg==
X-Received: by 2002:a62:2547:: with SMTP id l68mr31077481pfl.131.1548113761507;
        Mon, 21 Jan 2019 15:36:01 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id y9sm14016345pfi.74.2019.01.21.15.36.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 15:36:00 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v4 0/3] media: imx: Stop stream before disabling IDMA channels
Date:   Mon, 21 Jan 2019 15:35:49 -0800
Message-Id: <20190121233552.20001-1-slongerbeam@gmail.com>
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

In the CSI subdevice, this can be done by disabling the CSI before
disabling the CSI IDMA channel, instead of after. In the IC-PRPENVVF
subdevice, this can be done by stopping upstream before disabling the
PRPENC/VF IDMA channel.

History:
v4:
- Disabling SMFC will have no effect if both CSI's are streaming. So
  go back to disabling CSI before channel as in v2, but split up
  csi_idmac_stop such that ipu_csi_disable can still be called within
  csi_stop.

v3:
- Switch to disabling the SMFC before the channel, instead of the CSI
  before the channel.

v2:
- Whitespace fixes
- Add Fixes: and Cc: stable@vger.kernel.org
- No functional changes.


Steve Longerbeam (3):
  media: imx: csi: Disable CSI immediately after last EOF
  media: imx: csi: Stop upstream before disabling IDMA channel
  media: imx: prpencvf: Stop upstream before disabling IDMA channel

 drivers/staging/media/imx/imx-ic-prpencvf.c | 26 ++++++++-----
 drivers/staging/media/imx/imx-media-csi.c   | 42 +++++++++++++--------
 2 files changed, 44 insertions(+), 24 deletions(-)

-- 
2.17.1

