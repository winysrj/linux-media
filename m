Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25851C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1F2D2147C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfAGLAH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:00:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:9983 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbfAGLAH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:00:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 03:00:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,450,1539673200"; 
   d="scan'208";a="106179891"
Received: from bachmicx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.57.24])
  by orsmga006.jf.intel.com with ESMTP; 07 Jan 2019 03:00:05 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 63FCE21D0B; Mon,  7 Jan 2019 13:00:00 +0200 (EET)
Date:   Mon, 7 Jan 2019 13:00:00 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Bingbu Cao <bingbu.cao@linux.intel.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH -next] media: staging/intel-ipu3: Fix err handle of
 ipu3_css_find_binary
Message-ID: <20190107105959.n3pkvo5nbzsikt4m@kekkonen.localdomain>
References: <20181229024528.6016-1-yuehaibing@huawei.com>
 <83af4b2d-a638-70a4-fd61-9720116c3e8f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83af4b2d-a638-70a4-fd61-9720116c3e8f@linux.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Bingbu,

On Mon, Jan 07, 2019 at 10:38:19AM +0800, Bingbu Cao wrote:
> Hi, Haibing
> 
> Thanks for your patch, it looks fine for me.
> Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
> 
> On 12/29/2018 10:45 AM, YueHaibing wrote:
> > css->pipes[pipe].bindex = binary;

I'm taking Colin's patch with equivalent content; it was there first.

Thanks!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
