Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6D7C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E7AE2070D
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfCMVFo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 17:05:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:25402 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbfCMVFo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 17:05:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Mar 2019 14:05:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,475,1544515200"; 
   d="scan'208";a="131419427"
Received: from vinayvna-mobl2.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.45.136])
  by fmsmga008.fm.intel.com with ESMTP; 13 Mar 2019 14:05:42 -0700
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id EAB0721F57; Wed, 13 Mar 2019 23:05:35 +0200 (EET)
Date:   Wed, 13 Mar 2019 23:05:35 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 0/2] media: ov7670: fix regressions caused by "hook
 s_power onto v4l2 core"
Message-ID: <20190313210535.fl54xfjhui7dl7bb@kekkonen.localdomain>
References: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
 <559a9073a3d42de6737f75a1fb6a6e53451a6a28.camel@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <559a9073a3d42de6737f75a1fb6a6e53451a6a28.camel@v3.sk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 12, 2019 at 06:16:08PM +0100, Lubomir Rintel wrote:
> On Tue, 2019-03-12 at 00:36 +0900, Akinobu Mita wrote:
> > This patchset fixes the problems introduced by recent change to ov7670.
> > 
> > Akinobu Mita (2):
> >   media: ov7670: restore default settings after power-up
> >   media: ov7670: don't access registers when the device is powered off
> > 
> >  drivers/media/i2c/ov7670.c | 32 +++++++++++++++++++++++++++-----
> >  1 file changed, 27 insertions(+), 5 deletions(-)
> > 
> > Cc: Lubomir Rintel <lkundrak@v3.sk>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> 
> For the both patches in the set:
> 
> Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>
> Tested-by: Lubomir Rintel <lkundrak@v3.sk>

Thanks, guys!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
