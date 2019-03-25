Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EACEC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 10:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4812A20811
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 10:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbfCYKIX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 06:08:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:14381 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730250AbfCYKIW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 06:08:22 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Mar 2019 03:08:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="137196332"
Received: from ikahlonx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.61.250])
  by fmsmga007.fm.intel.com with ESMTP; 25 Mar 2019 03:08:19 -0700
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 1C8F921D09; Mon, 25 Mar 2019 12:08:13 +0200 (EET)
Date:   Mon, 25 Mar 2019 12:08:12 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Smitha T Murthy <smitha.t@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] media: v4l2-ctrl: potential shift wrapping bugs
Message-ID: <20190325100812.y64uflgitooe7pqm@kekkonen.localdomain>
References: <20190325090626.GC16023@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325090626.GC16023@kadam>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Dan,

Thanks for the patch.

On Mon, Mar 25, 2019 at 12:06:26PM +0300, Dan Carpenter wrote:
> This code generates a static checker warning:
> 
>     drivers/media/v4l2-core/v4l2-ctrls.c:2921 v4l2_querymenu()
>     warn: should '(1 << i)' be a 64 bit type?
> 
> The problem is that "ctrl->menu_skip_mask" is a u64 and we're only
> testing the lower 32 bits.

This seems to be caused by patch 0ba2aeb6dab8 ("[media] v4l2-ctrls:
increase internal min/max/step/def to 64 bit"). Backporting the fix isn't
likely really important --- the reason being no-one has figured this out
previously, very probably so because there are no menus that long.

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b79d3bbd8350..cee78485df02 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1599,7 +1599,7 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  	case V4L2_CTRL_TYPE_INTEGER_MENU:
>  		if (ptr.p_s32[idx] < ctrl->minimum || ptr.p_s32[idx] > ctrl->maximum)
>  			return -ERANGE;
> -		if (ctrl->menu_skip_mask & (1 << ptr.p_s32[idx]))
> +		if (ctrl->menu_skip_mask & (1ULL << ptr.p_s32[idx]))
>  			return -EINVAL;
>  		if (ctrl->type == V4L2_CTRL_TYPE_MENU &&
>  		    ctrl->qmenu[ptr.p_s32[idx]][0] == '\0')
> @@ -2918,7 +2918,7 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
>  		return -EINVAL;
>  
>  	/* Use mask to see if this menu item should be skipped */
> -	if (ctrl->menu_skip_mask & (1 << i))
> +	if (ctrl->menu_skip_mask & (1ULL << i))
>  		return -EINVAL;
>  	/* Empty menu items should also be skipped */
>  	if (ctrl->type == V4L2_CTRL_TYPE_MENU) {

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
