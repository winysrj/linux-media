Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77CDC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 17:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA4BB218A1
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 17:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfCVRaG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 13:30:06 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56256 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfCVRaG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 13:30:06 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 63937281D1B
Message-ID: <c2164a32b5ea12e1a773fd4aa0b3a03a47189ec8.camel@collabora.com>
Subject: Re: [PATCH v2 02/11] media: Introduce helpers to fill pixel format
 structs
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>
Date:   Fri, 22 Mar 2019 14:29:57 -0300
In-Reply-To: <c1316b02-7df1-5517-f899-7e6f22f8ba31@xs4all.nl>
References: <20190304192529.14200-1-ezequiel@collabora.com>
         <20190304192529.14200-3-ezequiel@collabora.com>
         <c1316b02-7df1-5517-f899-7e6f22f8ba31@xs4all.nl>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-03-12 at 09:29 +0100, Hans Verkuil wrote:
> On 3/4/19 8:25 PM, Ezequiel Garcia wrote:
> > Add two new API helpers, v4l2_fill_pixfmt and v4l2_fill_pixfmt_mp,
> > to be used by drivers to calculate plane sizes and bytes per lines.
> > 
> > Note that driver-specific padding and alignment are not
> > taken into account, and must be done by drivers using this API.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-common.c | 186 ++++++++++++++++++++++++++
> >  include/media/v4l2-common.h           |  32 +++++
> >  2 files changed, 218 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> > index 663730f088cd..11a16bb3efda 100644
> > --- a/drivers/media/v4l2-core/v4l2-common.c
> > +++ b/drivers/media/v4l2-core/v4l2-common.c
> > @@ -44,6 +44,7 @@
> >   * Added Gerd Knorrs v4l1 enhancements (Justin Schoeman)
> >   */
> >  
> > +#include <linux/ctype.h>
> >  #include <linux/module.h>
> >  #include <linux/types.h>
> >  #include <linux/kernel.h>
> > @@ -445,3 +446,188 @@ int v4l2_s_parm_cap(struct video_device *vdev,
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
> > +
> > +static char printable_char(int c)
> > +{
> > +	return isascii(c) && isprint(c) ? c : '?';
> > +}
> > +
> > +const char *v4l2_get_fourcc_name(uint32_t format)
> > +{
> > +	static char buf[8];
> > +
> > +	snprintf(buf, 8,
> > +		 "%c%c%c%c%s",
> > +		 printable_char(format & 0xff),
> > +		 printable_char((format >> 8) & 0xff),
> > +		 printable_char((format >> 16) & 0xff),
> > +		 printable_char((format >> 24) & 0x7f),
> > +		 (format & BIT(31)) ? "-BE" : "");
> > +
> > +	return buf;
> > +}
> > +EXPORT_SYMBOL(v4l2_get_fourcc_name);
> 
> This function isn't re-entrant, but it should be. Multiple threads may be
> calling it at the same time.
> 
> It is probably best to pass the buffer pointer as an argument.
> 

Boy, shame on me, really missed this!

> I would also prefer to split this patch into two: the first adding
> v4l2_format_info, the second adding v4l2_get_fourcc_name. This in case
> that the v4l2_get_fourcc_name() function needs more work.
> 

OK.

Thanks a lot for the feedback,
Eze

