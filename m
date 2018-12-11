Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B4EC07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D91B82081B
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D91B82081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbeLKJWU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:22:20 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:35848 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbeLKJWT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 04:22:19 -0500
Received: from [IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a] ([IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id WeF5gFBStQMWUWeF6g6RZy; Tue, 11 Dec 2018 10:22:18 +0100
Subject: Re: [PATCH] drm/tegra: Refactor CEC support
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-tegra@vger.kernel.org
References: <20181210163455.13627-1-thierry.reding@gmail.com>
 <1611ab47-9ba6-83dc-6f6d-8add7b0a9751@xs4all.nl>
 <57066560-7c1b-5702-5269-9bc9deffc53e@xs4all.nl>
Message-ID: <cae0b43a-c206-531b-927e-a5ec5bf89dea@xs4all.nl>
Date:   Tue, 11 Dec 2018 10:22:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <57066560-7c1b-5702-5269-9bc9deffc53e@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfE7NAtTfYtDgWGJcyisKbdTDLTdghh2rbrueDQCA+pJ90aLnakA7LQNS5KyhAzOKuBhm3TPZz9kv/+EOGKirWbPojmxRDmw3MtdBBA8tE9POGlr+poPo
 G885SO02ghiNAOG+uBQyAQTRKMMIoLhn65J6crPxKOMwvULgkmNUQNtV85PAcK9Q50aXzJGDBGZUPbh0suFHupwdK9BdCZlkbmE0+UpJNXhRmWxnyki3Nxcr
 PV7Jmxp31wtkEeuEm+zqLBpS2AsBvAYUGiTIQVAOtJ9aWKmZlXuTdBdS0H49d6Iwe05EkFoBzKrad5GzGVa3i/L9Ib4OvXPvFEQCQJQrSJNRn9efcba/khQl
 9vY/h8t0ZNkG6PTPmUuoIcO3ui0vfr5ba2z0eEvXq01bwYDoPSWH1/O4ze63ac6cPgiGug+yKKWkjGr99oxFkWjVp1ESIg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/10/18 6:07 PM, Hans Verkuil wrote:
> On 12/10/18 5:36 PM, Hans Verkuil wrote:
>> On 12/10/18 5:34 PM, Thierry Reding wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> Most of the CEC support code already lives in the "output" library code.
>>> Move registration and unregistration to the library code as well to make
>>> use of the same code with HDMI on Tegra210 and later via the SOR.
>>>
>>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>>
>> Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> But read my reply to "[PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194".
> You may want to take a different approach here.

Ignore this last comment, this code is fine.

Regards,

	Hans
