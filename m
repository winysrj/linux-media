Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697F0C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41A7221872
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfBAKn1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:43:27 -0500
Received: from mga17.intel.com ([192.55.52.151]:47270 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfBAKn1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 05:43:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2019 02:43:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,548,1539673200"; 
   d="scan'208";a="121224813"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga008.fm.intel.com with ESMTP; 01 Feb 2019 02:43:24 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 91D8720740; Fri,  1 Feb 2019 12:43:23 +0200 (EET)
Date:   Fri, 1 Feb 2019 12:43:23 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Yong Zhi <yong.zhi@intel.com>
Cc:     linux-media@vger.kernel.org, rajmohan.mani@intel.com,
        tfiga@chromium.org, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        dan.carpenter@oracle.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
Subject: Re: [PATCH v2 2/2] media: ipu3-imgu: Remove dead code for NULL check
Message-ID: <20190201104322.r2lgas55wc5pgq6s@paasikivi.fi.intel.com>
References: <1547659127-13055-1-git-send-email-yong.zhi@intel.com>
 <1547659127-13055-2-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547659127-13055-2-git-send-email-yong.zhi@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Yong,

On Wed, Jan 16, 2019 at 09:18:47AM -0800, Yong Zhi wrote:
> Since ipu3_css_buf_dequeue() never returns NULL, remove the
> dead code to fix static checker warning:
> 
> drivers/staging/media/ipu3/ipu3.c:493 imgu_isr_threaded()
> warn: 'b' is an error pointer or valid
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> [Bug report: https://lore.kernel.org/linux-media/20190104122856.GA1169@kadam/]
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I don't see Laurent's Reviewed-by: tag on the list. Did you get that from
him off-list? If he hasn't given one, please send v3 without that tag.

Thanks.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
