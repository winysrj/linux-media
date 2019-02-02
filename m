Return-Path: <SRS0=sYKt=QJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1D9C282D7
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 13:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 337792086C
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 13:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfBBN6K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 08:58:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:39746 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbfBBN6K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Feb 2019 08:58:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Feb 2019 05:58:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,552,1539673200"; 
   d="scan'208";a="123418118"
Received: from rdomark-mobl.ccr.corp.intel.com (HELO mara.localdomain) ([10.252.10.239])
  by orsmga003.jf.intel.com with ESMTP; 02 Feb 2019 05:58:07 -0800
Received: from sailus by mara.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gpvo4-00057Y-6m; Sat, 02 Feb 2019 15:58:04 +0200
Date:   Sat, 2 Feb 2019 15:58:03 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, rajmohan.mani@intel.com,
        yong.zhi@intel.com
Subject: Re: [v4l-utils PATCH v3 1/1] v4l2-ctl: Add support for META_OUTPUT
 buffer type
Message-ID: <20190202135802.f2vhi4ae32xfe7rr@mara.localdomain>
References: <20190201135152.27782-1-sakari.ailus@linux.intel.com>
 <5c11be8d-e841-3a4a-bf3f-14936cb22ddd@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c11be8d-e841-3a4a-bf3f-14936cb22ddd@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Feb 02, 2019 at 10:38:58AM +0100, Hans Verkuil wrote:
> On 02/01/2019 02:51 PM, Sakari Ailus wrote:
> > Add support for META_OUTPUT buffer type to v4l2-ctl.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Hi Hans, others,
> > 
> > I've reworked the patch to match with the way SDR is implemented: the
> > options for setting the format work independently of the node type.
> > 
> > I like this better than the previous one; there is much less redundant
> > code now.
> > 
> >  utils/v4l2-ctl/v4l2-ctl-meta.cpp | 97 ++++++++++++++++++++++++++--------------
> >  utils/v4l2-ctl/v4l2-ctl.cpp      |  7 +++
> >  utils/v4l2-ctl/v4l2-ctl.h        |  5 +++
> >  3 files changed, 76 insertions(+), 33 deletions(-)
> > 
> > diff --git a/utils/v4l2-ctl/v4l2-ctl-meta.cpp b/utils/v4l2-ctl/v4l2-ctl-meta.cpp
> 
> <snip>
> 
> > +void __meta_get(cv4l_fd &fd, __32 type)
> 
> __32???
> 
> This clearly hasn't even been compile tested.
> 
> I also saw a pile of compiler warnings elsewhere after applying this patch.
> 
> I'm not sure what happened, perhaps an old version of the patch was accidentally
> posted, but I'll wait for a v4.

Oops. I fixed the problems you've seen but I ended up sending an older
version. I'll send v4...

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
