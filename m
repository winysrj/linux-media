Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CA2C43612
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 542472087F
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfAFPyU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 10:54:20 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38179 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfAFPyU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 10:54:20 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 4B83A60002;
        Sun,  6 Jan 2019 15:54:17 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 0/6] media: adv748x: Implement dynamic routing support
Date:   Sun,  6 Jan 2019 16:54:07 +0100
Message-Id: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,
   second iteration for adv748x dynamic selection of video source.

Please refer to v1 cover letter for more details:
https://patchwork.kernel.org/cover/10723971/

This v2 addresses comments received from Kieran and Laurent, with the most
notable changes in patches 3/6 and 6/6.

Tested on R-Car E3 Ebisu board, where both AFE and HDMI backends share a
single CSI-2 output.

A noted on v1 cover letter, for the series to work on other R-Car SoC the
number of CSI-2 data lanes has to be negotiated, as the AFE->TXA link works
only when up to 2 data lanes are used, while most of Gen 3 SoCs (E3 excluded)
are configured to use 4 data lanes.


The series is based on media tree master with the following series from
Niklas applied on top:
[PATCH v4 0/4] i2c: adv748x: add support for CSI-2 TXA to work in 1-, 2- and 4-lane mode

Branch available for testing at:
git://jmondi.org/linux adv748x_dynamic-routing_v2

Thanks
  j

Jacopo Mondi (6):
  media: adv748x: Add is_txb()
  media: adv748x: Rename reset procedures
  media: adv748x: csi2: Link AFE with TXA and TXB
  media: adv748x: Store the source subdevice in TX
  media: adv748x: Store the TX sink in HDMI/AFE
  media: adv748x: Implement TX link_setup callback

 drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
 drivers/media/i2c/adv748x/adv748x-core.c | 83 +++++++++++++++++++-----
 drivers/media/i2c/adv748x/adv748x-csi2.c | 65 ++++++++++++-------
 drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
 drivers/media/i2c/adv748x/adv748x.h      | 13 +++-
 5 files changed, 124 insertions(+), 41 deletions(-)

--
2.20.1

