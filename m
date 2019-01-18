Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A7EC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 09:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B170E2087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 09:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfARJHH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 04:07:07 -0500
Received: from mga07.intel.com ([134.134.136.100]:35840 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbfARJHC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 04:07:02 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2019 01:07:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="115640778"
Received: from rfrenzel-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.59.237])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jan 2019 01:07:00 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id E0A4B21E54; Fri, 18 Jan 2019 11:06:57 +0200 (EET)
Date:   Fri, 18 Jan 2019 11:06:57 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH 0/8] Remove obsolete soc_camera drivers
Message-ID: <20190118090656.rdsx7jrfnvmtp3o4@kekkonen.localdomain>
References: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
 <20190118085624.z64orgt62ekyyni6@kekkonen.localdomain>
 <738da2a6-e8a3-c09b-d9b8-4489eeb4f46a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <738da2a6-e8a3-c09b-d9b8-4489eeb4f46a@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 18, 2019 at 09:58:43AM +0100, Hans Verkuil wrote:
> On 1/18/19 9:56 AM, Sakari Ailus wrote:
> > On Thu, Jan 17, 2019 at 05:17:54PM +0100, hverkuil-cisco@xs4all.nl wrote:
> >> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >>
> >> The soc_mt9t112, soc_ov772x and soc_tw9910 drivers now have
> >> non-soc-camera replacements, so those three drivers can be
> >> removed.
> >>
> >> The soc_camera sh_mobile_ceu_camera platform driver also has
> >> a non-soc-camera replacement, so remove this driver as well.
> >>
> >> This driver was also the last driver that used soc_scale_crop,
> >> so remove that too. Finally remove the test soc_camera_platform
> >> driver. There will be no more soc_camera platform drivers, so this
> >> platform template driver serves no purpose anymore.
> > 
> > For the set:
> > 
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Are you planning to move the rest of the drivers to staging and depend on
> > BROKEN, or should I do that?
> > 
> 
> Can you do that?

Certainly. I just want to make sure we don't both do it. :-)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
