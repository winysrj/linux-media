Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8FA5C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E0B821924
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:37:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="SQhNVj4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfBHKhJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:37:09 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43090 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfBHKhJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 05:37:09 -0500
Received: from pendragon.ideasonboard.com (d51A4137F.access.telenet.be [81.164.19.127])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 82FA2F9;
        Fri,  8 Feb 2019 11:37:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549622227;
        bh=BPf4lPRX+XUPjh+hPJHapJA8ROTkXSxEwQyJ61LDVfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SQhNVj4dHWZk9zW+YIVjX4gejZTKCmu/OMn3EV+76y/8kMxeGAfnC0Fzo7o5tF9jZ
         ehPsY++Er87uHtGkZRjWPhAtexYhLc/geyB166uyJ8EjQmIExgAYe7GWMpXCULwkIq
         G+H2sGk2bCIt/eNdODjbTFYOo2owO3dT6KtmuG1s=
Date:   Fri, 8 Feb 2019 12:37:06 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-subdev.h: v4l2_subdev_call: use temp __sd variable
Message-ID: <20190208103706.GA4562@pendragon.ideasonboard.com>
References: <c3a4c93b-e331-b049-fddf-7f7196bc362a@xs4all.nl>
 <20190208090629.vta7rf2vvpzftgsp@paasikivi.fi.intel.com>
 <e958128c-cc9a-5c99-9871-91c192fb55fd@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e958128c-cc9a-5c99-9871-91c192fb55fd@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Fri, Feb 08, 2019 at 10:08:22AM +0100, Hans Verkuil wrote:
> On 2/8/19 10:06 AM, Sakari Ailus wrote:
> > On Fri, Feb 08, 2019 at 09:49:23AM +0100, Hans Verkuil wrote:
> >> The sd argument of this macro can be a more complex expression. Since it
> >> is used 5 times in the macro it can be evaluated that many times as well.
> >>
> >> So assign it to a temp variable in the beginning and use that instead.
> >>
> >> This also avoids any potential side-effects of evaluating sd.
> >>
> >> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > 
> > Nice one!
> > 
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > I wonder if this addresses some of the sparse issues related to using a
> > macro to come up with sd?
> 
> It does solve those as well, in fact :-)
> 
> I rejected the omap3/4 patches in favor of this one, which is a much, much
> cleaner solution.

Thank you for looking into this. Great work :-)

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> >> ---
> >> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> >> index 47af609dc8f1..34da094a3f40 100644
> >> --- a/include/media/v4l2-subdev.h
> >> +++ b/include/media/v4l2-subdev.h
> >> @@ -1093,13 +1093,14 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
> >>   */
> >>  #define v4l2_subdev_call(sd, o, f, args...)				\
> >>  	({								\
> >> +		struct v4l2_subdev *__sd = (sd);			\
> >>  		int __result;						\
> >> -		if (!(sd))						\
> >> +		if (!__sd)						\
> >>  			__result = -ENODEV;				\
> >> -		else if (!((sd)->ops->o && (sd)->ops->o->f))		\
> >> +		else if (!(__sd->ops->o && __sd->ops->o->f))		\
> >>  			__result = -ENOIOCTLCMD;			\
> >>  		else							\
> >> -			__result = (sd)->ops->o->f((sd), ##args);	\
> >> +			__result = __sd->ops->o->f(__sd, ##args);	\
> >>  		__result;						\
> >>  	})
> >>

-- 
Regards,

Laurent Pinchart
