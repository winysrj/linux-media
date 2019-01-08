Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDAAC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 00:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B71812173C
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 00:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfAHAH2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 19:07:28 -0500
Received: from mga05.intel.com ([192.55.52.43]:33392 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbfAHAH2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 19:07:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 16:07:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,451,1539673200"; 
   d="scan'208";a="108051261"
Received: from bachmicx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.57.24])
  by orsmga008.jf.intel.com with ESMTP; 07 Jan 2019 16:07:25 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 6D43321D0B; Tue,  8 Jan 2019 02:07:20 +0200 (EET)
Date:   Tue, 8 Jan 2019 02:07:20 +0200
From:   "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
To:     David Binderman <dcb314@hotmail.com>
Cc:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: drivers/staging/media/ipu3/ipu3-css.c:1831: bad compare ?
Message-ID: <20190108000719.2rvfpdnvaszl3r7x@kekkonen.localdomain>
References: <DB7PR08MB380173BC25D42FD8E5C9ED8C9C890@DB7PR08MB3801.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR08MB380173BC25D42FD8E5C9ED8C9C890@DB7PR08MB3801.eurprd08.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi David,

On Mon, Jan 07, 2019 at 10:30:55PM +0000, David Binderman wrote:
> Hello there,
> 
> drivers/staging/media/ipu3/ipu3-css.c:1831:30: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
> 
> Source code is
>         css->pipes[pipe].bindex =
>                 ipu3_css_find_binary(css, pipe, q, r);
>         if (css->pipes[pipe].bindex < 0) {
>                 dev_err(css->dev, "failed to find suitable binary\n");
>                 return -EINVAL;
>         }
> 
> Suggest sanity check return value from function first, then if it is ok,
> assign it to an unsigned variable.

Thanks for reporting this. There have been a few patches to address it so
far, the one going in is here:

<URL:https://patchwork.linuxtv.org/patch/53633/>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
