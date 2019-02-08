Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A18CC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A1602147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfBHJGc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 04:06:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:10051 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfBHJGc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 04:06:32 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 01:06:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,347,1544515200"; 
   d="scan'208";a="116199952"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga008.jf.intel.com with ESMTP; 08 Feb 2019 01:06:30 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 82EAE20736; Fri,  8 Feb 2019 11:06:29 +0200 (EET)
Date:   Fri, 8 Feb 2019 11:06:29 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l2-subdev.h: v4l2_subdev_call: use temp __sd variable
Message-ID: <20190208090629.vta7rf2vvpzftgsp@paasikivi.fi.intel.com>
References: <c3a4c93b-e331-b049-fddf-7f7196bc362a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3a4c93b-e331-b049-fddf-7f7196bc362a@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Feb 08, 2019 at 09:49:23AM +0100, Hans Verkuil wrote:
> The sd argument of this macro can be a more complex expression. Since it
> is used 5 times in the macro it can be evaluated that many times as well.
> 
> So assign it to a temp variable in the beginning and use that instead.
> 
> This also avoids any potential side-effects of evaluating sd.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Nice one!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

I wonder if this addresses some of the sparse issues related to using a
macro to come up with sd?

> ---
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 47af609dc8f1..34da094a3f40 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -1093,13 +1093,14 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
>   */
>  #define v4l2_subdev_call(sd, o, f, args...)				\
>  	({								\
> +		struct v4l2_subdev *__sd = (sd);			\
>  		int __result;						\
> -		if (!(sd))						\
> +		if (!__sd)						\
>  			__result = -ENODEV;				\
> -		else if (!((sd)->ops->o && (sd)->ops->o->f))		\
> +		else if (!(__sd->ops->o && __sd->ops->o->f))		\
>  			__result = -ENOIOCTLCMD;			\
>  		else							\
> -			__result = (sd)->ops->o->f((sd), ##args);	\
> +			__result = __sd->ops->o->f(__sd, ##args);	\
>  		__result;						\
>  	})
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
