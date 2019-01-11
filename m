Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DB9C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 21:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51C092183F
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 21:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfAKVKP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 16:10:15 -0500
Received: from mga04.intel.com ([192.55.52.120]:12913 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbfAKVKP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 16:10:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jan 2019 13:10:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,466,1539673200"; 
   d="scan'208";a="105948320"
Received: from tsadowsk-mobl1.ger.corp.intel.com (HELO mara.localdomain) ([10.252.7.185])
  by orsmga007.jf.intel.com with ESMTP; 11 Jan 2019 13:10:12 -0800
Received: from sailus by mara.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gi44B-0000KE-Oo; Fri, 11 Jan 2019 23:10:12 +0200
Date:   Fri, 11 Jan 2019 23:10:11 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [GIT FIXES FOR v5.0] v4l2-ioctl: Clear only per-plane reserved
 fields
Message-ID: <20190111211010.volneg4ew4omg6ff@mara.localdomain>
References: <7b7507b5-f4d1-d95b-b77b-bd7a8044a5ef@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b7507b5-f4d1-d95b-b77b-bd7a8044a5ef@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Fri, Jan 11, 2019 at 09:31:25AM +0100, Hans Verkuil wrote:
> Three fixes for a bug introduced in 5.0.
> 
> The last patch (Validate num_planes for debug messages) is also backported
> to kernels >= 4.12 (the oldest kernel for which it applies cleanly).

The surrounding lines of code have changed slightly over the years. The
older kernels still suffer from the same problem as far as I see, so the
backport is relevant down to 3.16 at least (but older kernels aren't
supported anyway so I didn't check further). The problem was likely
introduced by the big IOCTL handling patches long, long time ago. Huh.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
