Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA87C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36A452086D
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QCVHobpm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36A452086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbeLMPjA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:39:00 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39429 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbeLMPjA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 10:39:00 -0500
Received: by mail-lj1-f195.google.com with SMTP id t9-v6so2160061ljh.6
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 07:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I/yNImDiLblblJ13XRnDQucQ3yK337j5ChF/Py07e9A=;
        b=QCVHobpm2N6t8LsSzGu+LOZTgh1gfLRYI/ntgbNvInx2MSAg6qeb9X8M+GHuWNZF52
         a9Vok43GG6Oa4AvnYPfbt6z5hZd01pKgn+gm+7y3ayoQHNbGpMwmglLx+GHiWTAoTY5S
         M107IezQcDeGLTNiB7Wsbos05sjkpFmMdGSdjWE+6CX8bO8wjqgO1fuArHe0EbHi1ZB0
         YtXBmL2Q34Nqu1f43js7XHFpxxiraCUj/fxdHje391/QEuJOhNKhmTHGwFcqKLp1ro3P
         EFabOD9iip+F8Sk5VQzrn3LrxUchSM8F2KPwOmRZ0pgTEAL245MgIqfhRSTNMWDZFDqC
         8gxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I/yNImDiLblblJ13XRnDQucQ3yK337j5ChF/Py07e9A=;
        b=kV9xXvkYZzn7MhSfmBgX+530HSP6AoqdZ/HBmhTZ8LVTAFHHW66BziwD2ETXWiDh4p
         dcdowBIKYK615sSiKxN8MLG7KbIDwJn8Gc3YHwf7/pfJW5EHBH5Dqws0zqD4BeMJ3KKe
         Z1y4AQEgQo4AMw7BG1NEVC6pqYB1LnJV2v1+7+rWy8WdXkDOtiXJwjWglKof8gouYxTj
         0GlJq5ejQYi8KRwRpU6KLD9CwoC6uMKXA9mWoDAJ+lvYecgQF8Rp5VXzIcCOVAnIDCSV
         Ttnp+OCKLBMJPaApPUCeEzWLSZrDtTzxv80laee52g0jLzxF+PFG9fv4RZl92SAr6RU0
         qyBQ==
X-Gm-Message-State: AA+aEWb5Nr7XWBWlWw3Mb0937Vl3b8s38ohc27QZ1+/MAIJ/3FjM8dKm
        Czd01iAwjQCCsmVUphmygf4=
X-Google-Smtp-Source: AFSGD/XekQiMMgSStwaR6CCmRHpG262FcOJ+NYsr3/5BQWjRUDCMlTTEYl3V3tcW/dYk0349Q7Ixuw==
X-Received: by 2002:a2e:6109:: with SMTP id v9-v6mr14802310ljb.126.1544715538161;
        Thu, 13 Dec 2018 07:38:58 -0800 (PST)
Received: from kontron.lan (2001-1ae9-0ff1-f191-41f2-812a-df1c-0485.ip6.tmcz.cz. [2001:1ae9:ff1:f191:41f2:812a:df1c:485])
        by smtp.gmail.com with ESMTPSA id q67sm412869lfe.19.2018.12.13.07.38.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 07:38:57 -0800 (PST)
From:   petrcvekcz@gmail.com
X-Google-Original-From: petrcvekcz.gmail.com
To:     hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc:     Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org,
        philipp.zabel@gmail.com, sakari.ailus@iki.fi
Subject: [PATCH v3 0/8] media: soc_camera: ov9640: switch driver to v4l2_async
Date:   Thu, 13 Dec 2018 16:39:11 +0100
Message-Id: <cover.1544713575.git.petrcvekcz@gmail.com>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Petr Cvek <petrcvekcz@gmail.com>

This patch series transfer the ov9640 driver from the soc_camera subsystem
into a standalone v4l2 driver. There is no changes except the required
v4l2_async calls, GPIO allocation, deletion of now unused variables,
a change from mdelay() to msleep() and an addition of SPDX identifiers
(as suggested in the v1 version RFC).

The config symbol has been changed from CONFIG_SOC_CAMERA_OV9640 to
CONFIG_VIDEO_OV9640.

Also as the drivers of the soc_camera seems to be orphaned I'm volunteering
as a maintainer of the driver (I own the hardware).

I've found the ov9640 seems to be used at least in (the future) HTC
Magician and Palm Zire72. These will need to define power and reset GPIOs
and remove the soc_camera definitions. I'm debugging it on magician now
(ov9640 was unusable on them since the pxa_camera switched from
the soc_camera).

Additional fixes (from v2) are: a fix of the probe error path, variables
change to an unsigned type (indexes, lengths), a redefinition of formats
array to const and better clarity of code near returns.

Petr Cvek (8):
  media: soc_camera: ov9640: move ov9640 out of soc_camera
  media: i2c: ov9640: drop soc_camera code and switch to v4l2_async
  MAINTAINERS: add Petr Cvek as a maintainer for the ov9640 driver
  media: i2c: ov9640: add missing SPDX identifiers
  media: i2c: ov9640: change array index or length variables to unsigned
  media: i2c: ov9640: add space before return for better clarity
  media: i2c: ov9640: make array of supported formats constant
  media: i2c: ov9640: fix missing error handling in probe

 MAINTAINERS                          |   6 +
 drivers/media/i2c/Kconfig            |   7 +
 drivers/media/i2c/Makefile           |   1 +
 drivers/media/i2c/ov9640.c           | 776 +++++++++++++++++++++++++++
 drivers/media/i2c/ov9640.h           | 207 +++++++
 drivers/media/i2c/soc_camera/Kconfig |   6 +-
 6 files changed, 1001 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/i2c/ov9640.c
 create mode 100644 drivers/media/i2c/ov9640.h

-- 
2.20.0

