Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145EAC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1BCA20851
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8+FskV9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfAQUtb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:49:31 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39308 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfAQUtb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:49:31 -0500
Received: by mail-pl1-f193.google.com with SMTP id 101so5270670pld.6
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 12:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HJm1HIsSdeddz5IW7kMUHQ98tIWohRQeiz5j3u7Hm/4=;
        b=g8+FskV9F07xWhZDCej52Jmisf2QvOcD0ErWGXpMe7ThCALdh9I+M1/YOqFxn+zkoY
         QUEclwwGNrpdCeGBNn+TELYRYcoYSPRzHiT7ne7257JcBo9JHkpVV6cyw3H5zNNPh65t
         /Hi/5uWkuDs8HHpSYOX256BGwegAkvmhGcWDan9IyE7B36TIVSIMmJT3aSqijZnkadc5
         iYpkIkgV0hjWwvuJxExse7WUnpQ1RXrH9RvK4MOXOQ67FhsxHHKGfqWwe/GZOvGtJXmX
         IG4UKgD7Eex+cUSui+xGjJNtLALO10S0vYmSIemDqwe+D7hl3rkXdAOn1votRied4cxq
         KGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HJm1HIsSdeddz5IW7kMUHQ98tIWohRQeiz5j3u7Hm/4=;
        b=EyLISeSXSA/UjlphYieq/jBG776paLQdqQEszaIYX+ZdJdGRxQTotZOZka1EBSBALy
         mjNpx4fDISZxilYvSJq9cfhC4mfmItFW5YvnspGgbq+JydrqgjZevEkKOjmNnVLX+eIu
         vjxdNx++1ePXc4ivRccr2jADyqEoHKq4FtYoaiAL57L/3p6DLSji/+VTTBnOilQXCV/T
         Mtn0TSEV7maXBc+x5C+NKXZDak6TFT0ryK0nleEclAqv+ri1rQpueJFwSTXCGzZr0QTA
         uoVmAv0MMOTO+6aUL2TIxyHG3OVm9n2S4X5UZaYHlMnKyH4t2QJhJz27JjWklw8WJHqM
         V67Q==
X-Gm-Message-State: AJcUukcAm0NP5QRVwH6FQrHWaGNOMQX1Y/n2r9goMsQEfLDMSJnr16ZJ
        BEhOWk1BWRFCsXAVJ2D+eCtX2UQ+0AI=
X-Google-Smtp-Source: ALg8bN7f80Q4ANgokixefHjA18Ac4cAO+49c1KGzEAbCTPRIEb0H+FtENYPmP3eHrt7gqVdwY9MtHw==
X-Received: by 2002:a17:902:6948:: with SMTP id k8mr16280813plt.2.1547758169756;
        Thu, 17 Jan 2019 12:49:29 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id b68sm4007481pfg.160.2019.01.17.12.49.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 12:49:28 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v2 0/2] media: imx: Disable CSI immediately after last EOF
Date:   Thu, 17 Jan 2019 12:49:10 -0800
Message-Id: <20190117204912.28456-1-slongerbeam@gmail.com>
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

History:
v2:
- Whitespace fixes
- Add Fixes: and Cc: stable@vger.kernel.org
- No functional changes.

Steve Longerbeam (2):
  media: imx: csi: Disable CSI immediately after last EOF
  media: imx: prpencvf: Disable CSI immediately after last EOF

 drivers/staging/media/imx/imx-ic-prpencvf.c | 26 ++++++++++++++-------
 drivers/staging/media/imx/imx-media-csi.c   |  6 +++--
 2 files changed, 21 insertions(+), 11 deletions(-)

-- 
2.17.1

