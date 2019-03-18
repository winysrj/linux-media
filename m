Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E603FC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE542213F2
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfCRTSH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:18:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:38980 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbfCRTSH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 15:18:07 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Mar 2019 12:18:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,494,1544515200"; 
   d="scan'208";a="283739640"
Received: from rpeteran-mobl1.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.45.36])
  by orsmga004.jf.intel.com with ESMTP; 18 Mar 2019 12:18:03 -0700
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id C6F5021F57; Mon, 18 Mar 2019 21:17:59 +0200 (EET)
Date:   Mon, 18 Mar 2019 21:17:59 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Koen Vandeputte <koen.vandeputte@ncentric.com>
Cc:     linux-media@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robin Leblon <robin.leblon@ncentric.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Tim Harvey <tharvey@gateworks.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: i2c: tda1997x: select V4L2_FWNODE
Message-ID: <20190318191758.hhxnwpkqqib5ne7w@kekkonen.localdomain>
References: <20190318164005.4070-1-koen.vandeputte@ncentric.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318164005.4070-1-koen.vandeputte@ncentric.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Mar 18, 2019 at 05:40:05PM +0100, Koen Vandeputte wrote:
> Building tda1997x fails now unless V4L2_FWNODE is selected:
> 
> drivers/media/i2c/tda1997x.o: in function `tda1997x_parse_dt'
> undefined reference to `v4l2_fwnode_endpoint_parse'
> 
> While at it, also sort the selections alphabetically
> 
> Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")
> Signed-off-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
> Cc: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Bingbu Cao <bingbu.cao@intel.com>
> Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Robin Leblon <robin.leblon@ncentric.com>
> Cc: Rui Miguel Silva <rui.silva@linaro.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Tim Harvey <tharvey@gateworks.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org # v4.17+

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
