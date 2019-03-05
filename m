Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E398C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 14:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78EF4206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 14:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfCEORW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 09:17:22 -0500
Received: from mga05.intel.com ([192.55.52.43]:2902 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbfCEORW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 09:17:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2019 06:17:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,444,1544515200"; 
   d="scan'208";a="131412466"
Received: from schmiger-mobl3.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.45.12])
  by orsmga003.jf.intel.com with ESMTP; 05 Mar 2019 06:17:18 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id C12C621E54; Tue,  5 Mar 2019 16:17:15 +0200 (EET)
Date:   Tue, 5 Mar 2019 16:17:15 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] media: staging/intel-ipu3: reduce kernel stack usage
Message-ID: <20190305141714.u7tj46cvacnmmg4d@kekkonen.localdomain>
References: <20190305132924.3889416-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305132924.3889416-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 05, 2019 at 02:26:29PM +0100, Arnd Bergmann wrote:
> The imgu_css_queue structure is too large to be put on the kernel
> stack, as we can see in 32-bit builds:
> 
> drivers/staging/media/ipu3/ipu3-css.c: In function 'imgu_css_fmt_try':
> drivers/staging/media/ipu3/ipu3-css.c:1863:1: error: the frame size of 1172 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> By dynamically allocating this array, the stack usage goes down to an
> acceptable 140 bytes for the same x86-32 configuration.
> 
> Fixes: f5f2e4273518 ("media: staging/intel-ipu3: Add css pipeline programming")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: restructure to use 'return -ENOMEM' instead of goto for failed
>     allocation.

Thanks, Arnd! All three applied.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
