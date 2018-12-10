Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D16C67838
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 08:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA2F32082F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 08:10:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA2F32082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbeLJIKl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 03:10:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:6075 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbeLJIKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 03:10:41 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2018 00:10:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,337,1539673200"; 
   d="scan'208";a="117064778"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga002.jf.intel.com with ESMTP; 10 Dec 2018 00:10:38 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id BCFB4205E8; Mon, 10 Dec 2018 10:10:37 +0200 (EET)
Date:   Mon, 10 Dec 2018 10:10:37 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        nicolas@ndufresne.ca,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Invite for IRC meeting: Re: [PATCHv4 01/10] videodev2.h: add tag
 support
Message-ID: <20181210081037.6gu4gvlunfwhlx3z@paasikivi.fi.intel.com>
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
 <20181205102040.11741-2-hverkuil-cisco@xs4all.nl>
 <dee778ea-89d5-ddaf-c5d9-6423b7dee005@xs4all.nl>
 <CAAFQd5Bshhc+npq8VgFWpOOvoc-ym8xytF4n49ZSe4iTGMnkAg@mail.gmail.com>
 <B8C205F2-A5EA-4502-B2D0-2B5A592C31FD@osg.samsung.com>
 <0426239b-f7d1-0bc1-3ce4-7cef62591bbd@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0426239b-f7d1-0bc1-3ce4-7cef62591bbd@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 10, 2018 at 08:59:36AM +0100, Hans Verkuil wrote:
> Wed works for me.

Same here.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
