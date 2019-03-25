Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4952C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 15:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C3F12083D
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 15:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbfCYPdC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 11:33:02 -0400
Received: from muru.com ([72.249.23.125]:42432 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfCYPdC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 11:33:02 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id ABF4080CC;
        Mon, 25 Mar 2019 15:33:15 +0000 (UTC)
Date:   Mon, 25 Mar 2019 08:32:58 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org
Subject: CEC blocks idle on omap4
Message-ID: <20190325153258.GU5717@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Looks like CONFIG_OMAP4_DSS_HDMI_CEC=y blocks SoC core retention
idle on omap4 if selected.

Should we maybe move hdmi4_cec_init() to hdmi_display_enable()
and hdmi4_cec_uninit() to hdmi_display_disable()?

Or add some enable/disable calls in addtion to the init and
uninit calls that can be called from hdmi_display_enable()
and hdmi_display_disable()?

Cheers,

Tony
