Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A684AC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7995D21872
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfBGOvU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:51:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:60397 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfBGOvT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 09:51:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2019 06:51:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,344,1544515200"; 
   d="scan'208";a="114423458"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga006.jf.intel.com with ESMTP; 07 Feb 2019 06:51:15 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 0249820389; Thu,  7 Feb 2019 16:51:14 +0200 (EET)
Date:   Thu, 7 Feb 2019 16:51:14 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 7/6] omap4iss: fix sparse warning
Message-ID: <20190207145114.z4huk7ktda67wy36@paasikivi.fi.intel.com>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-7-hverkuil-cisco@xs4all.nl>
 <546e17e7-310c-faaf-ae13-a1b005f40579@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546e17e7-310c-faaf-ae13-a1b005f40579@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 07, 2019 at 03:38:02PM +0100, Hans Verkuil wrote:
> drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
> drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
> drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
> drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> Same fix as for omap3isp. I discovered that staging drivers weren't built by the
> daily build, so I never noticed these warnings.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
