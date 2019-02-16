Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DB0C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 09:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A93F222D7
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 09:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730824AbfBPJ1X (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 04:27:23 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:42122 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728307AbfBPJ1X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 04:27:23 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id uwFigeV6fLMwIuwFlgaDNG; Sat, 16 Feb 2019 10:27:22 +0100
Subject: Re: imx: smatch errors
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <4015d912-2368-6c59-9ab9-5ad5117ff605@xs4all.nl>
Message-ID: <bcde0f8e-1e0d-38cf-6c57-06c3a324145c@xs4all.nl>
Date:   Sat, 16 Feb 2019 10:27:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <4015d912-2368-6c59-9ab9-5ad5117ff605@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIKsaE3jslpldToeWwBKx5Ux2fC1BVCkNa2LrFz2diVWXbZH3QWi3Ro2Vt4Kgo+9JNKnuZ2Ovf9xa/W1aZ9LFQTnvTXp9Rjd+dJttLF8rVuMa+J13f4U
 BykktHEfW/tyer2TGtbjZVJQhdhdomIN/k7KT+Y3uBt/+5uqutCRpXwbfFKp7wxO64flHyG0cgrg0PTC1rOHDBIys9xaFSDu0hNkCU9/kI88ovNthD7vC3Uj
 Wn6EDDXGqkPwKy+P/9RWWA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/7/19 3:33 PM, Hans Verkuil wrote:
> Hi Steve,
> 
> It turns out that the daily build never compiled the staging media drivers,
> which included imx. Now that I enabled it I get these three errors:
> 
> drivers/staging/media/imx/imx-media-vdic.c:236 prepare_vdi_in_buffers() error: uninitialized symbol 'prev_phys'.
> drivers/staging/media/imx/imx-media-vdic.c:237 prepare_vdi_in_buffers() error: uninitialized symbol 'curr_phys'.
> drivers/staging/media/imx/imx-media-vdic.c:238 prepare_vdi_in_buffers() error: uninitialized symbol 'next_phys'.
> 
> Can you take a look? The root cause is that the switch doesn't have
> a default case.
> 
> I expect that this is easy to fix, but I'm not sure what the fix should be,
> otherwise I would have made a patch for you.

Ping!

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 

