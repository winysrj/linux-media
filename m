Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77C5C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CD6221908
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfBGOeB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:34:01 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:42996 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726809AbfBGOeA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 09:34:00 -0500
Received: from [IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5] ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rkkXgMY4oRO5ZrkkZgsnc4; Thu, 07 Feb 2019 15:33:59 +0100
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: imx: smatch errors
Message-ID: <4015d912-2368-6c59-9ab9-5ad5117ff605@xs4all.nl>
Date:   Thu, 7 Feb 2019 15:33:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfF+hObZz4pohJ1LOarKdRnqeJGrDBxxh/3pV9fqdbIKjf8CqF9MB6hVUT6OdzZh3VqJ8hd0zcIK+WuT5tvcWzL/fWf/kpPqcMwrdnEfC9gvYXS+JvmCY
 RTVlfICem8YERrXy/6xDjV9nmaYyvFvltXeq8tjeS/tdQq87K95Ht5OmdpfLeGeGJZBMLte2QtOuC9nkUzASnNy1fTe0Ip7Qjc+x4MO/9pGQa+tcyQxjGj3t
 Fwsa3mcgpLPrGmVNe8ta9RAkUPCr6Fw+D2fWD0WBwGx7+mve6igkjn9WdcuzKZ8rEsQvXfLaH2jbcKBM92ukWw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

It turns out that the daily build never compiled the staging media drivers,
which included imx. Now that I enabled it I get these three errors:

drivers/staging/media/imx/imx-media-vdic.c:236 prepare_vdi_in_buffers() error: uninitialized symbol 'prev_phys'.
drivers/staging/media/imx/imx-media-vdic.c:237 prepare_vdi_in_buffers() error: uninitialized symbol 'curr_phys'.
drivers/staging/media/imx/imx-media-vdic.c:238 prepare_vdi_in_buffers() error: uninitialized symbol 'next_phys'.

Can you take a look? The root cause is that the switch doesn't have
a default case.

I expect that this is easy to fix, but I'm not sure what the fix should be,
otherwise I would have made a patch for you.

Regards,

	Hans
