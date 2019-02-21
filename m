Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E45C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 21:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B79302080F
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 21:50:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="TADZ3iQj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfBUVuz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 16:50:55 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:48286 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfBUVuz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 16:50:55 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 18B05255;
        Thu, 21 Feb 2019 22:50:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550785853;
        bh=XD5/nNTQSaqAJD6zRs7ajHg14qMkoRLFBAONOtJNRGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TADZ3iQj2Ex1mdTClwoptm77DkG05PG9vTwPqhSAsQi7cYWNsZAYtad4T1u8Ds//W
         V4BPFYlf08kDU9BX0xCFRIfMNpHH2yP7ztWunJ/2D5ZUAZklM7DYaDBt+FOneOR4td
         Ezz2vHIstyovD5d8uPfiAheAyiTJa2ed3O/698Bg=
Date:   Thu, 21 Feb 2019 23:50:48 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Shaobo <shaobo@cs.utah.edu>
Cc:     linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com
Subject: Re: Problematic code in media/v4l2-core/v4l2-mem2mem.c
Message-ID: <20190221215048.GA3485@pendragon.ideasonboard.com>
References: <4c01f7987951d7a66350a069f471c129@cs.utah.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4c01f7987951d7a66350a069f471c129@cs.utah.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Shaobo,

On Thu, Feb 21, 2019 at 11:11:32AM -0700, Shaobo wrote:
> Hello everyone,
> 
> I think I brought up this issue before but didn't resolve it completely. 
> Now I'd like to double check this and if we can agree on it, I'd also 
> like to submit a patch to fix it. The problem is that function 
> `get_queue_ctx` can never return a NULL pointer unless pointer overflow 
> occurs, which is very unlikely. To be more specific,
> 
> ```
> static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx 
> *m2m_ctx,
> 						enum v4l2_buf_type type)
> {
> 	if (V4L2_TYPE_IS_OUTPUT(type))
> 		return &m2m_ctx->out_q_ctx;
> 	else
> 		return &m2m_ctx->cap_q_ctx;
> }
> ```
> 
> The address returned by this function is either `(char*)m2m_ctx+968` or 
> `(char*)m2m_ctx+16`, so for it to be NULL, `m2m_ctx` must be a large 
> unsigned value. Yet the return value of this function is NULL-checked, 
> for example in v4l2_m2m_get_vq.
> 
> Please let me know if it makes sense.

It makes complete sense.

There are only two callers of get_queue_ctx() that check the return
value of the function. It may be argued that the intent was to check for
a NULL m2m_ctx, so you could replace those two checks with a NULL check
for m2m_ctx before calling get_queue_ctx(). However, given that nothing
is crashing, it may also be argued that the checks are unnecessary and
can be dropped completely. The best would be to review the call paths to
ensure the functions can indeed never be called with NULL, but a quick
look at the code shows no other NULL check in functions taking a m2m_ctx
pointer as argument, so I'd vote for just dropping the two offending
checks.

Care to submit a patch ? :-)

-- 
Regards,

Laurent Pinchart
