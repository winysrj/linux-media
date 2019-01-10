Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E4DC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE66C214DA
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfAJMev (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 07:34:51 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39309 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727534AbfAJMev (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 07:34:51 -0500
Received: from [IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f] ([IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f])
        by smtp-cloud9.xs4all.net with ESMTPA
        id hZXpgbBOvMWvEhZXtgXEFg; Thu, 10 Jan 2019 13:34:49 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes
Message-ID: <83553828-f3cd-1f99-5ddb-ac1b71f0f78c@xs4all.nl>
Date:   Thu, 10 Jan 2019 13:34:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfD8RDsVb5kfZ2alss5YE7nzMNJwE6okxesZuBr3RNbPwz+j8+kArQexzk4p/yxwJixt4oVTzHBj3FafG+iPv3c8HY/xbxU5R91Psp8zYchwOkQs+bU75
 Q0tvNfnTB0Us9xlnsTMvvNB4HaHPr2IAbdJDEm2n50POVbq5IsXFlEiFbSIp+IYvj1xUwvI2ogudOo3r9/jfDVCl5PeeHb2nvdCWqOBA40cwX4DDplFQsPqX
 mcgE08gR1jz3JWYN0RXtIpbYSpcaSSekRwvvSNkNVAsyrE3Xu5gKO22mHBzIhIAJ
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1c

for you to fetch changes up to a9561384ce6d9f01e919793b0b6e8c5551df4eb8:

  media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTART_INTERVAL (2019-01-10 12:36:18 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Fabrizio Castro (4):
      media: dt-bindings: rcar-csi2: Add r8a774c0
      media: dt-bindings: rcar-vin: Add R8A774C0 support
      media: rcar-vin: Add support for RZ/G2E
      media: rcar-csi2: Add support for RZ/G2E

Niklas Söderlund (4):
      dt-bindings: adv748x: make data-lanes property mandatory for CSI-2 endpoints
      i2c: adv748x: reuse power up sequence when initializing CSI-2
      i2c: adv748x: store number of CSI-2 lanes described in device tree
      i2c: adv748x: configure number of lanes used for TXA CSI-2 transmitter

Pawe? Chmiel (1):
      media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTART_INTERVAL

Peter Rosin (1):
      media: saa7146: make use of i2c_8bit_addr_from_msg

 Documentation/devicetree/bindings/media/i2c/adv748x.txt       |  11 ++-
 Documentation/devicetree/bindings/media/rcar_vin.txt          |   9 +-
 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt |   3 +-
 drivers/media/common/saa7146/saa7146_i2c.c                    |   5 +-
 drivers/media/i2c/adv748x/adv748x-core.c                      | 209 ++++++++++++++++++++++++++--------------------
 drivers/media/i2c/adv748x/adv748x.h                           |   1 +
 drivers/media/platform/rcar-vin/rcar-core.c                   |   4 +
 drivers/media/platform/rcar-vin/rcar-csi2.c                   |   4 +
 drivers/media/platform/s5p-jpeg/jpeg-core.c                   |   2 +-
 9 files changed, 146 insertions(+), 102 deletions(-)
