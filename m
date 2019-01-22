Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A88DC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 12:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2089320870
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 12:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfAVMbn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:31:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:64420 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbfAVMbn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 07:31:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 04:31:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,506,1539673200"; 
   d="scan'208";a="129739151"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2019 04:31:41 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id C17A1205C8; Tue, 22 Jan 2019 14:31:40 +0200 (EET)
Date:   Tue, 22 Jan 2019 14:31:40 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, rajmohan.mani@intel.com,
        yong.zhi@intel.com
Subject: Re: [v4l-utils PATCH 4/4] v4l2-ctl: Add support for META_OUTPUT
 buffer type
Message-ID: <20190122123140.6w2242yetwd7etdm@paasikivi.fi.intel.com>
References: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
 <20190114141308.29329-5-sakari.ailus@linux.intel.com>
 <4bb84871-1871-74a0-1093-8e460db46634@xs4all.nl>
 <20190122094750.aak6fl2xskxsio2r@paasikivi.fi.intel.com>
 <dd6b3447-80a5-43f1-7718-cbe61607e965@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd6b3447-80a5-43f1-7718-cbe61607e965@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 22, 2019 at 11:21:27AM +0100, Hans Verkuil wrote:
> On 01/22/19 10:47, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Tue, Jan 22, 2019 at 09:19:42AM +0100, Hans Verkuil wrote:
> >> Hi Sakari,
> >>
> >> Can you check if this patch is needed at all? The latest v4l2-ctl should work
> >> for both meta capture and output, i.e. all meta options (v4l2-ctl --help-meta)
> >> just look up the buffer type of the video device and use that to list/set/get/try
> >> the formats.
> > 
> > That'd be one option. I guess we don't have that elsewhere, do we? In
> > practice it could work, but it'd prevent having the two queue types in the
> > same video node. It seems an improbable combination though.
> > 
> > I'd prefer keeping the options separate to maintain v4l2-ctl's ability to
> > access all aspects of the API, even if unlikely.
> 
> Well, you can add -out options for consistency, but the code remains the
> same :-)

Not quite: the option still determines which formats are being accessed
--- just like for SDR.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
