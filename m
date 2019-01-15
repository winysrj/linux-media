Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3C2C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 07:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27AD020656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 07:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfAOH7e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 02:59:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:25813 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbfAOH7d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 02:59:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2019 23:59:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,481,1539673200"; 
   d="scan'208";a="291634420"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005.jf.intel.com with ESMTP; 14 Jan 2019 23:59:30 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 957792050A; Tue, 15 Jan 2019 09:59:29 +0200 (EET)
Date:   Tue, 15 Jan 2019 09:59:29 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Yong Zhi <yong.zhi@intel.com>
Cc:     linux-media@vger.kernel.org, tfiga@chromium.org,
        rajmohan.mani@intel.com, tian.shu.qiu@intel.com,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        mchehab@kernel.org, bingbu.cao@intel.com, dan.carpenter@oracle.com
Subject: Re: [PATCH 1/2] media: ipu3-imgu: Use MENU type for mode control
Message-ID: <20190115075929.vzzb2ppx6hzw6kqc@paasikivi.fi.intel.com>
References: <1547523465-27807-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547523465-27807-1-git-send-email-yong.zhi@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Yong,

On Mon, Jan 14, 2019 at 09:37:44PM -0600, Yong Zhi wrote:
> This addresses the below TODO item.
> - Use V4L2_CTRL_TYPE_MENU for dual-pipe mode control. (Sakari)
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/staging/media/ipu3/TODO                 |  2 --
>  drivers/staging/media/ipu3/include/intel-ipu3.h |  6 ------
>  drivers/staging/media/ipu3/ipu3-v4l2.c          | 18 +++++++++++++-----
>  3 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/media/ipu3/TODO b/drivers/staging/media/ipu3/TODO
> index 905bbb190217..0dc9a2e79978 100644
> --- a/drivers/staging/media/ipu3/TODO
> +++ b/drivers/staging/media/ipu3/TODO
> @@ -11,8 +11,6 @@ staging directory.
>  - Prefix imgu for all public APIs, i.e. change ipu3_v4l2_register() to
>    imgu_v4l2_register(). (Sakari)
>  
> -- Use V4L2_CTRL_TYPE_MENU for dual-pipe mode control. (Sakari)
> -

It's good to see TODO entries being addressed. :-)

With Tomasz's comments addressed, this is good to go in IMO.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
