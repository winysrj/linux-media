Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCF6C282D9
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 07:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3476520881
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 07:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfAaHbL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 02:31:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:18826 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbfAaHbK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 02:31:10 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2019 23:31:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,543,1539673200"; 
   d="scan'208";a="316399030"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jan 2019 23:31:08 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id EA0412068E; Thu, 31 Jan 2019 09:31:07 +0200 (EET)
Date:   Thu, 31 Jan 2019 09:31:07 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        chiranjeevi.rapolu@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] uvc: Avoid NULL pointer dereference at the end of
 streaming
Message-ID: <20190131073107.rogoi3rwmjgzq4x3@paasikivi.fi.intel.com>
References: <20190130100941.17589-1-sakari.ailus@linux.intel.com>
 <20190131020449.2CEFD20989@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131020449.2CEFD20989@mail.kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sasha,

On Thu, Jan 31, 2019 at 02:04:48AM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 9c0863b1cc48 [media] vb2: call buf_finish from __queue_cancel.
> 
> The bot has tested the following trees: v4.20.5, v4.19.18, v4.14.96, v4.9.153, v4.4.172, v3.18.133.
> 
> v4.20.5: Build OK!
> v4.19.18: Build OK!
> v4.14.96: Build OK!
> v4.9.153: Build OK!
> v4.4.172: Build OK!
> v3.18.133: Failed to apply! Possible dependencies:
>     5d0fd3c806b9 ("[media] uvcvideo: Disable hardware timestamps by default")
> 
> 
> How should we proceed with this patch?

IMO 5d0fd3c806b9 should be applied as well. It's effectively a bugfix as
well (but which also, for most users, covered the problem fixed by
9c0863b1cc48).

Laurent, could you confirm?

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
