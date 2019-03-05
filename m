Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414B2C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 20:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D9BB20842
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 20:07:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Ie9bwD1v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfCEUHW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 15:07:22 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:41036 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfCEUHW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 15:07:22 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id ACB1924A;
        Tue,  5 Mar 2019 21:07:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551816440;
        bh=bPZ8r93742GEqk+4PEB7XOEw7clrYURHX/LBv26xOso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ie9bwD1vlKTvqLOBaT9Nuq4DJTVuaOJM2cCwtizdQxo2s2TiYugieyEl93qa4adW7
         bhVF0xk0HWiyUpOUlZg0/PZhTby1CsMAkrOVil0ckmDj1S/7nlotdiIYH4QA9LwW6W
         bvsX3keTG8dcb/1Mrbvax/ivLg5B2HuQFC449U6M=
Date:   Tue, 5 Mar 2019 22:07:14 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Shaobo He <shaobo@cs.utah.edu>
Cc:     linux-media@vger.kernel.org
Subject: Re: Question about drivers/media/usb/uvc/uvc_v4l2.c
Message-ID: <20190305200714.GL14928@pendragon.ideasonboard.com>
References: <8479deae-dedb-b7d2-58b7-8ff91f265eab@cs.utah.edu>
 <20190302214308.GI4682@pendragon.ideasonboard.com>
 <3bfdd00d-abff-8683-6e25-1010cc568702@cs.utah.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3bfdd00d-abff-8683-6e25-1010cc568702@cs.utah.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Shoabo,

On Sat, Mar 02, 2019 at 03:29:25PM -0700, Shaobo He wrote:
> Hi Laurent,
> 
> Thank you very much for your reply. This is what I thought, too. It seems that 
> there's an implicit order of execution that is not clearly implied in the code, 
> meaning `uvc_parse_streaming` is called before `uvc_v4l2_try_format`.

It is implied by the logic of the driver that calls
uvc_parse_streaming() at probe time before registering video nodes, and
with uvc_v4l2_try_format() only being called from userspace through the
video nodes.

> That being said, I was wondering maybe a better practice to write the loop in 
> `uvc_v4l2_try_format` would be like the following,
> 
> ```
> format=NULL;
> ...
> for (i = 0; i < stream->nformats; ++i) {
> 		format = &stream->format[i];
> 		if (format->fcc == fmt->fmt.pix.pixelformat)
> 			break;
> }
> // dereferencing format
> ```
> to
> ```
> // just declaration
> format;
> i=0;
> do {
> 		format = &stream->format[i];
> 		if (format->fcc == fmt->fmt.pix.pixelformat)
> 			break;
> 		++i;
> } while (i<stream->nformats)
> // dereferencing format
> ```
> I mean you can save one initialization, provided compiler does it and one branch.

I like for loops better in general, they convey the meaning in a cleaner
way. The compiler should be able to do its job here and optimize the
code correctly, I don't think a change is worth it, especially as we're
not dealing with a hot path.

> On 2019/3/2 14:43, Laurent Pinchart wrote:
> > On Sat, Mar 02, 2019 at 01:22:49PM -0700, Shaobo He wrote:
> >> Hello everyone,
> >>
> >> This is Shaobo from Utah again. I've been bugging the mailing list with my
> >> patches. I have a quick question about a function in
> >> `drivers/media/usb/uvc/uvc_v4l2.c`. In `uvc_v4l2_try_format`, can
> >> `stream->nformats` be 0? I saw that in other files, this field could be zero
> >> which is considered as error cases. I was wondering if it's true for this
> >> function, too.
> > 
> > The uvc_parse_streaming() function should answer this question :-)

-- 
Regards,

Laurent Pinchart
