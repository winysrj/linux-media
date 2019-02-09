Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D34C169C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66846217D8
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZCJybdp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfBIBr5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 20:47:57 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37039 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfBIBr5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 20:47:57 -0500
Received: by mail-pf1-f194.google.com with SMTP id y126so2505519pfb.4
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 17:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hCqmTl7s8xIGTYE/bVQr48tzvAGVvrIsZqf35c27P/w=;
        b=dZCJybdpzaPk9JocdRW1c1//4MggaFaY5PRPQtubN3TtFHYtresjK0DrGU4VLw/HAr
         5lF+rc6Ev9yOtLIty60QNzq64f4mEUhssiTAzdbvzd71O+Q5veaJN2Zu4xg2v4LJofhw
         5pe6S8rSlQfDe/gi+1fzTkI2qkp1EH7hETu/8T8lpnvj5oIY8mttoPfjTNEhxfBq/YWy
         mQkPpV6MJg/JEmj2plgZDVjOa9+/jAXEpeIwhRWPwIWjZ/I8U4TXHL6yGOvAVp9fcau5
         LeR8FJNTqqp3i+ICCZAH4l0jaNT6OzETWx3YJVUsYYPuSxXiL/ZAeTHN8i6ckaG1GJ+Q
         ZI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hCqmTl7s8xIGTYE/bVQr48tzvAGVvrIsZqf35c27P/w=;
        b=eD1ZZg3/nlIKEkx+LtAUW2xTCxV3M3P1tqFiOkhwjF06zCos1cG/WpPsbbpF+oqIm9
         VWgrbS3K4ZmteCyPg6tUsw7Dm1+x5Y224MWiNJ8VuJGRpwzBiFZYQ3oOAEq2gxBQo0UM
         M6pkYKtKxrE9Bwgx2QJIpxIAtLHEDgXsOJsxr+upWvzMLKkYBBYGTYxcUQuFI6B5B+Q6
         hyI+6NM5z2J8nIgoKNeFsevFgl9f6T+/gCwClcW9OqtbJust5SNkWsBj9pBSBYvcNgOr
         n0zwApMgaqChv0o7QvzOR4oZkpREQi3XMoMiS6Rf2ulh+FKyVUWHlc+wwCB+3bdZAC5j
         gWdw==
X-Gm-Message-State: AHQUAuYvIDVQCTxnyURuMvpS9S0O4AgWTY7jGrUNEaDKzk2Vo5QWySWE
        /xtV5dEOEil6RdSiN2CjuyEHiXvY
X-Google-Smtp-Source: AHgI3IZAinNvZpLsXzfEQVlPzkPuIkSm0CMm9uwVcmannQhMsjCAmsF5fjsHYSpzshzH5IOjvnathg==
X-Received: by 2002:a63:1b58:: with SMTP id b24mr18221261pgm.247.1549676876270;
        Fri, 08 Feb 2019 17:47:56 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id p67sm4305393pfg.44.2019.02.08.17.47.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 17:47:55 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v4 0/4] media: imx: Add support for BT.709 encoding
Date:   Fri,  8 Feb 2019 17:47:44 -0800
Message-Id: <20190209014748.10427-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset adds support for the BT.709 encoding and inverse encoding
matrices to the ipu_ic task init functions. The imx-media driver can
now support both BT.601 and BT.709 encoding.

History:
v4:
- fix a compile error in init_csc(), reported by Tim Harvey.
v3:
- fix some inconsistent From: and Signed-off-by:'s.
  No functional changes.
v2:
- rename ic_csc_rgb2rgb matrix to ic_csc_identity.
- only return "Unsupported YCbCr encoding" error if inf != outf,
  since if inf == outf, the identity matrix can be used. Reported
  by Tim Harvey.
- move ic_route check above default colorimetry checks, and fill default
  colorspace for ic_route, otherwise it's not possible to set BT.709
  encoding for ic routes.

Steve Longerbeam (4):
  gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding matrices
  gpu: ipu-v3: ipu-ic: Simplify selection of encoding matrix
  gpu: ipu-v3: ipu-ic: Add support for BT.709 encoding
  media: imx: Allow BT.709 encoding for IC routes

 drivers/gpu/ipu-v3/ipu-ic.c                 | 96 +++++++++++++++++----
 drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
 drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
 drivers/staging/media/imx/imx-media-utils.c | 20 +++--
 include/video/imx-ipu-v3.h                  |  5 +-
 5 files changed, 98 insertions(+), 28 deletions(-)

-- 
2.17.1

