Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B975C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 10:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27BBD222D0
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 10:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbfBPKHA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 05:07:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:50592 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfBPKHA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 05:07:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Feb 2019 02:06:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,376,1544515200"; 
   d="scan'208";a="134040731"
Received: from mmatus1x-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.44.106])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Feb 2019 02:06:58 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 859CD21E8D; Sat, 16 Feb 2019 12:06:55 +0200 (EET)
Date:   Sat, 16 Feb 2019 12:06:55 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: IPU3 smatch/sparse warnings
Message-ID: <20190216100654.fwl4ogt57zfh5oz5@kekkonen.localdomain>
References: <d77618fc-085b-c120-579f-9239a73634fe@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d77618fc-085b-c120-579f-9239a73634fe@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Sat, Feb 16, 2019 at 11:05:18AM +0100, Hans Verkuil wrote:
> Hi Sakari,
> 
> Can you take a look at the IPU3 smatch/sparse warnings?
> 
> See here: https://hverkuil.home.xs4all.nl/logs/Saturday.log
> 
> The two that concern me most are these:
> 
> /home/hans/work/build/media-git/drivers/staging/media/ipu3/include/intel-ipu3.h:2475:35: warning: 'awb_fr' offset 36756 in 'struct
> ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]
> 
> /home/hans/work/build/media-git/drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is
> less than 32 [-Wpacked-not-aligned]
> 
> You can ignore these two sparse warnings:
> 
> /home/hans/work/build/media-git/drivers/staging/media/ipu3/ipu3-css-params.c:1743:15: warning: memset with byte count of 285120
> /home/hans/work/build/media-git/drivers/staging/media/ipu3/ipu3-css-params.c:2284:15: warning: memset with byte count of 240832
> 
> They are bogus and they should disappear since I now added the
> -fmemcpy-max-count=300000 option to sparse.
> 
> The other ipu3 warnings all seem trivial to fix.
> 
> I'm trying to get the build to run without sparse/smatch warnings, so
> getting this fixed will be very useful.

I'll try to get this done early next week.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
