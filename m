Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A70C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 12:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24180218AC
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 12:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfBAMLt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:11:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:51326 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfBAMLt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 07:11:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2019 04:11:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,548,1539673200"; 
   d="scan'208";a="316803213"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2019 04:11:47 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 1A43E203D9; Fri,  1 Feb 2019 14:11:46 +0200 (EET)
Date:   Fri, 1 Feb 2019 14:11:45 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [GIT FIXES FOR v5.0] v4l2-ioctl: Clear only per-plane reserved
 fields
Message-ID: <20190201121145.fjznkpuwxuqme2yk@paasikivi.fi.intel.com>
References: <7b7507b5-f4d1-d95b-b77b-bd7a8044a5ef@xs4all.nl>
 <20190111211010.volneg4ew4omg6ff@mara.localdomain>
 <f2686e34-0bee-127d-cfc5-01fb31eaf257@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2686e34-0bee-127d-cfc5-01fb31eaf257@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Jan 12, 2019 at 10:17:47AM +0100, Hans Verkuil wrote:
> On 1/11/19 10:10 PM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Fri, Jan 11, 2019 at 09:31:25AM +0100, Hans Verkuil wrote:
> >> Three fixes for a bug introduced in 5.0.
> >>
> >> The last patch (Validate num_planes for debug messages) is also backported
> >> to kernels >= 4.12 (the oldest kernel for which it applies cleanly).
> > 
> > The surrounding lines of code have changed slightly over the years. The
> > older kernels still suffer from the same problem as far as I see, so the
> > backport is relevant down to 3.16 at least (but older kernels aren't
> > supported anyway so I didn't check further). The problem was likely
> > introduced by the big IOCTL handling patches long, long time ago. Huh.
> > 
> 
> I didn't plan on backporting this to older kernels. You have to be root
> to enable this debugging, so it is not security bug.

It is a security problem, even if root would have to enable the feature.

In practice it is not that severe as few would end up doing that. But we
don't know. I think it'd be easier to fix it than informing potential users
about its dangers.

I can submit a patch for the older kernels, too.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
