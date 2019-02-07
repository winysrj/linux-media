Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5E7C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E11FD2147C
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfBGOXX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:23:23 -0500
Received: from mga17.intel.com ([192.55.52.151]:12465 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727191AbfBGOXU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 09:23:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2019 06:23:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,344,1544515200"; 
   d="scan'208";a="136640006"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga001.jf.intel.com with ESMTP; 07 Feb 2019 06:23:18 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id EA3A420389; Thu,  7 Feb 2019 16:23:16 +0200 (EET)
Date:   Thu, 7 Feb 2019 16:23:16 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 5/6] omap3isp: fix sparse warning
Message-ID: <20190207142316.bc5g2vyizis2x5bh@paasikivi.fi.intel.com>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-6-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207091338.55705-6-hverkuil-cisco@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 07, 2019 at 10:13:37AM +0100, Hans Verkuil wrote:
> drivers/media/platform/omap3isp/ispvideo.c:1013:15: warning: unknown expression (4 0)
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
