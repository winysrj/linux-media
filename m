Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2967AC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 13:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0166D20657
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 13:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfAQNAb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:00:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:18878 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726932AbfAQNAb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 08:00:31 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2019 05:00:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,488,1539673200"; 
   d="scan'208";a="135445894"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002.fm.intel.com with ESMTP; 17 Jan 2019 05:00:28 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 23654206EA; Thu, 17 Jan 2019 15:00:27 +0200 (EET)
Date:   Thu, 17 Jan 2019 15:00:27 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Petr Cvek <petrcvekcz@gmail.com>
Subject: Re: [PATCH] media: remove soc_camera ov9640
Message-ID: <20190117130026.2jn6mkcp2l67kd2i@paasikivi.fi.intel.com>
References: <cbb14a0b0a22202c17279155b17eca77aae05904.1547729848.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbb14a0b0a22202c17279155b17eca77aae05904.1547729848.git.mchehab+samsung@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 17, 2019 at 07:57:47AM -0500, Mauro Carvalho Chehab wrote:
> This driver got converted to not depend on soc_camera on commit
> 57b0ad9ebe60 ("media: soc_camera: ov9640: move ov9640 out of soc_camera").
> 
> There's no sense on keeping the old version there.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
