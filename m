Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27684C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE60420700
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfBSOEE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:04:04 -0500
Received: from mga14.intel.com ([192.55.52.115]:32720 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbfBSOEE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 09:04:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2019 06:03:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,388,1544515200"; 
   d="scan'208";a="119091311"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.44.116])
  by orsmga008.jf.intel.com with ESMTP; 19 Feb 2019 06:03:49 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 1CF2321E8D; Tue, 19 Feb 2019 16:03:47 +0200 (EET)
Date:   Tue, 19 Feb 2019 16:03:46 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] ipu3-mmu: fix some kernel-doc macros
Message-ID: <20190219140346.j5gqakudj7c2hbm5@kekkonen.localdomain>
References: <0bdfc56c13c0ffe003f28395fcde2cd9b5ea0622.1550584828.git.mchehab+samsung@kernel.org>
 <e5e51aa53cf377df643845c88170a75f92f230d9.1550584828.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5e51aa53cf377df643845c88170a75f92f230d9.1550584828.git.mchehab+samsung@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 19, 2019 at 09:00:30AM -0500, Mauro Carvalho Chehab wrote:
> Some kernel-doc markups are wrong. fix them.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
