Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC535C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 17:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B53252082F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 17:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B53252082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbeLJROd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 12:14:33 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:53698 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728558AbeLJRNp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 12:13:45 -0500
Received: from [IPv6:2001:983:e9a7:1:153f:c992:21d9:6742] ([IPv6:2001:983:e9a7:1:153f:c992:21d9:6742])
        by smtp-cloud8.xs4all.net with ESMTPA
        id WP7lg6aCVCZKKWP7mgF4Gv; Mon, 10 Dec 2018 18:13:43 +0100
Subject: Re: [PATCH] media: vimc: add configfs API to configure the topology
To:     Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, lkcamp@lists.libreplanetbr.org,
        kernel@collabora.com, linux-kernel@vger.kernel.org
References: <20181207182200.25283-1-helen.koike@collabora.com>
 <126c3faf-18e0-6fe5-e2f5-8ef0878fb767@xs4all.nl>
 <1cf814ac-60e1-bff7-4e9b-72b2c393d49a@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <159b0f0c-8e75-385d-08de-117d50ab70e3@xs4all.nl>
Date:   Mon, 10 Dec 2018 18:13:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <1cf814ac-60e1-bff7-4e9b-72b2c393d49a@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKo9lcqtGuOFKiv+NchOElUxtHaDvs2CzEcZlT0ziIMRSjMy47a5WVAxlN2ZLJRFOHCzpz8taHDamKmBRp9xmViw953FfFj9IwdTXtaiZ2RAEsM8OPIw
 SQO0D7Nm9E7Cwd2GIocVNilB3kq5J4QF6AP2FWDVL2JGtmUWd82rdjdpDbq+WBzbNi03fIQQiJ1CQJmE/4hjuUhRHJnmfvsSjTpwYjrgLVmjljEgSRlrcXFq
 xCMqmUHcfcSGNr+JyxtjXK6j318fJ3Rp/i/gwA3yuaVGcFpgh82qgC081YoM6HndcGCCCrkmYiTuG+OiK3RdgtqrVxWR31P9hBKTJ2Nv77HIYKbRZWEILvCX
 roy37HmbOXwduIF7wpcT6stFoYs2sIKwyfCLdy1h/dTGSaC6twLh5ReqymjV/SEWP4qDXG3W5fZUAeT+XM/CCYN1Ijp39vJMNfG6eKJCEiQruetBmRw=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/10/18 5:14 PM, Helen Koike wrote:
> Hi Hans,
> 
> On 12/10/18 9:31 AM, Hans Verkuil wrote:
>> On 12/7/18 7:22 PM, Helen Koike wrote:

<snip>

> 
>>
>> The previewer is effectively similar to a debayer block.
> 
> You mean the image it outputs?

Yes. It takes a bayer image and outputs a non-bayer format on the omap3.

> 
>>
>> AEWB, AF and histogram are for auto-whitebalance, autofocus and histogram statistics.
>> This isn't supported by vimc, and is a 'nice-to-have' for the future.
> 
> Right, I need to check how to include those. I am a bit confused as in
> the omap3 topology they are seems to be just configuration points (I
> mean, they are not really part of the image pipeline).

Typically the SoC analyzes the image and produces statistics of various kinds that
are given to userspace via devices like this. It is used as input to auto-whitebalance,
auto-focus and auto-gain algorithms running in userspace that feedback the results to
sensor config changes.

The format is usually very SoC-specific.

> 
> I was reading this
> https://linuxtv.org/downloads/v4l-dvb-apis-new/v4l-drivers/omap3isp.html?highlight=histogram#statistic-blocks-ioctls
> It says:
> "The statistics are dequeueable by the user from the statistics subdev
> nodes using private IOCTLs"
> 
> I suppose we should emulate those private IOCTLs in vimc? If you could
> provide me some pointers in where I can find docs on these private
> IOCTLs it would be great.

No, just ignore these statistics devices for now. And if we make them, we
can design a vimc-specific format.

> 
>>
>> The main missing bits in vimc are a CSI block and a splitter block. It should be simple
>> to add the CSI block since it really doesn't do anything in an emulated environment.
> 
> CSI would be just a dummy entity with one sink pad and one source pad right?

Right.

> 
>>
>> A splitter might be more complicated, I'm not sure.
> 
> splitter shouldn't that complicated in the current state of vimc, but
> when we start optimizing the pipeline then it is going to be more
> complicated.

Right.

Regards,

	Hans
