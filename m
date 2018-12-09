Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9CEC07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 22:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F015A20661
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 22:34:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F015A20661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbeLIWeF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 17:34:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:63434 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbeLIWeF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Dec 2018 17:34:05 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2018 14:34:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,336,1539673200"; 
   d="scan'208";a="116971218"
Received: from sohakulk-mobl.amr.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.40.74])
  by orsmga002.jf.intel.com with ESMTP; 09 Dec 2018 14:34:01 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 3C87E21EFF; Mon, 10 Dec 2018 00:33:57 +0200 (EET)
Date:   Mon, 10 Dec 2018 00:33:57 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Yong Zhi <yong.zhi@intel.com>
Cc:     linux-media@vger.kernel.org, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        jerry.w.hu@intel.com, tian.shu.qiu@intel.com,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        mchehab@kernel.org, bingbu.cao@intel.com, jian.xu.zheng@intel.com
Subject: Re: [PATCH v8 17/17] doc-rst: Add Intel IPU3 documentation
Message-ID: <20181209223353.g535d2puwrdr5zhm@kekkonen.localdomain>
References: <1544144622-29791-1-git-send-email-yong.zhi@intel.com>
 <1544144622-29791-18-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544144622-29791-18-git-send-email-yong.zhi@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Yong,

On Thu, Dec 06, 2018 at 07:03:42PM -0600, Yong Zhi wrote:
> From: Rajmohan Mani <rajmohan.mani@intel.com>
> 
> This patch adds the details about the IPU3 Imaging Unit driver.
> 
> Change-Id: I560cecf673df2dcc3ec72767cf8077708d649656

Please remove the Change-Id tag in the next version.

> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
