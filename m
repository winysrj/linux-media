Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52077C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 18:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20D9B2083B
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 18:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfBUSUx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 13:20:53 -0500
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:45504 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbfBUSUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 13:20:53 -0500
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2019 13:20:53 EST
Received: from mail-svr1.cs.utah.edu (localhost [127.0.0.1])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP id 5316C6500B5;
        Thu, 21 Feb 2019 11:11:32 -0700 (MST)
Received: from webmail.cs.utah.edu (uster.cs.utah.edu [155.98.65.63])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP;
        Thu, 21 Feb 2019 11:11:32 -0700 (MST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 21 Feb 2019 11:11:32 -0700
From:   Shaobo <shaobo@cs.utah.edu>
To:     linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Problematic code in media/v4l2-core/v4l2-mem2mem.c
Message-ID: <4c01f7987951d7a66350a069f471c129@cs.utah.edu>
X-Sender: shaobo@cs.utah.edu
User-Agent: Roundcube Webmail/1.3.8
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello everyone,

I think I brought up this issue before but didn't resolve it completely. 
Now I'd like to double check this and if we can agree on it, I'd also 
like to submit a patch to fix it. The problem is that function 
`get_queue_ctx` can never return a NULL pointer unless pointer overflow 
occurs, which is very unlikely. To be more specific,

```
static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx 
*m2m_ctx,
						enum v4l2_buf_type type)
{
	if (V4L2_TYPE_IS_OUTPUT(type))
		return &m2m_ctx->out_q_ctx;
	else
		return &m2m_ctx->cap_q_ctx;
}
```

The address returned by this function is either `(char*)m2m_ctx+968` or 
`(char*)m2m_ctx+16`, so for it to be NULL, `m2m_ctx` must be a large 
unsigned value. Yet the return value of this function is NULL-checked, 
for example in v4l2_m2m_get_vq.

Please let me know if it makes sense.

Best,
Shaobo
