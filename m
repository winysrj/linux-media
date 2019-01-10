Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E1EC43612
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F215D20660
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbfAJOCT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 09:02:19 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33095 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbfAJOCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 09:02:18 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id A961A60011;
        Thu, 10 Jan 2019 14:02:15 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 0/6] media: adv748x: Implement dynamic routing support
Date:   Thu, 10 Jan 2019 15:02:07 +0100
Message-Id: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,
   third iteration for adv748x dynamic selection of video source.

Please refer to v1 and v2 cover letter for more details:
https://patchwork.kernel.org/cover/10723971/
https://patchwork.kernel.org/cover/10749535/

This version includes comments from Laurent and Kieran, on patches 1/6 and
mostly on 6/6, which resulted in a better implementation. Thanks.

I have tested this on Ebisu E3 where I can capture HDMI and CVBS inputs from
TXA, and on Salvator-x M3-W where I can capture HDMI from TXA, and CVBS from
both TXA and TXB, but only when setting the number of CSI-2 data lanes to 2 in
DTS.

It remains unresolved how to dynamically negotiate the number of CSI-2 data
lanes to use between the video source and the CSI-2 receiver, which prevents
using AFE->TXA routing on all Gen3 SoC which use 4 CSI-2 data lanes.

The series is based on media tree master with the following series from
Niklas applied on top:
[PATCH v4 0/4] i2c: adv748x: add support for CSI-2 TXA to work in 1-, 2- and 4-lane mode

Branch available for testing at:
git://jmondi.org/linux adv748x_dynamic-routing_v3

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
 drivers/media/i2c/adv748x/adv748x-core.c | 74 +++++++++++++++++++-----
 drivers/media/i2c/adv748x/adv748x-csi2.c | 64 +++++++++++++-------
 drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
 drivers/media/i2c/adv748x/adv748x.h      | 10 ++++
 5 files changed, 112 insertions(+), 40 deletions(-)

--
2.20.1

