Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22227C282D9
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 02:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2B9B218D9
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 02:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548900291;
	bh=+M5CcjTbF078wkLC9bixiG+JLB6j/zrpnaeshXcrdmU=;
	h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=ppBBFRnVRhaYu1WSZ61sqX7xMMfm7/nI7pb4fGsQDu1LTrVQ0XrCDQaia/i0hcLCT
	 k709S++mfDz28wJFfvIT7odQbX+8DcGO+pgD4dgUuzJBz4mML2QKY4OYCVV0Jlmzxs
	 mGxgDcwGiquNMsHsyItugoHlAYzlmNxjSbpjCyCA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfAaCEu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 21:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfAaCEt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 21:04:49 -0500
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CEFD20989;
        Thu, 31 Jan 2019 02:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548900289;
        bh=+M5CcjTbF078wkLC9bixiG+JLB6j/zrpnaeshXcrdmU=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=2kj3/vVsoTcTE9HtRrDY6WkepwdB+M6hUYOdlQYWw0A2AEOgrYciQngJhpTXpeOvg
         2CbfdUgy97UsCUmZReVG5LVpMF4ikvTGBuc2sCeuaeV9cVDfhNPgazYHMIgDltvPqN
         lIpk/SYYqfwCVh01kc3nLNjlf9hyolWpVRRgrQLI=
Date:   Thu, 31 Jan 2019 02:04:48 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
To:     laurent.pinchart@ideasonboard.com
Cc:     linux-media@vger.kernel.org, chiranjeevi.rapolu@intel.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] uvc: Avoid NULL pointer dereference at the end of streaming
In-Reply-To: <20190130100941.17589-1-sakari.ailus@linux.intel.com>
References: <20190130100941.17589-1-sakari.ailus@linux.intel.com>
Message-Id: <20190131020449.2CEFD20989@mail.kernel.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 9c0863b1cc48 [media] vb2: call buf_finish from __queue_cancel.

The bot has tested the following trees: v4.20.5, v4.19.18, v4.14.96, v4.9.153, v4.4.172, v3.18.133.

v4.20.5: Build OK!
v4.19.18: Build OK!
v4.14.96: Build OK!
v4.9.153: Build OK!
v4.4.172: Build OK!
v3.18.133: Failed to apply! Possible dependencies:
    5d0fd3c806b9 ("[media] uvcvideo: Disable hardware timestamps by default")


How should we proceed with this patch?

--
Thanks,
Sasha
