Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35994C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06F9720870
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:45:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06F9720870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbeLKQpH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:45:07 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51253 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727280AbeLKQpG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 11:45:06 -0500
Received: from [IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a] ([IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a])
        by smtp-cloud9.xs4all.net with ESMTPA
        id Wl9agLc3sMlDTWl9bgEHms; Tue, 11 Dec 2018 17:45:04 +0100
Subject: Re: [PATCH v7 2/2] media: platform: Add Aspeed Video Engine driver
To:     Eddie James <eajames@linux.vnet.ibm.com>,
        Eddie James <eajames@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org
References: <1544480791-92746-1-git-send-email-eajames@linux.ibm.com>
 <1544480791-92746-3-git-send-email-eajames@linux.ibm.com>
 <6567e0a4-ad58-1340-199e-e5d5b267f3ac@xs4all.nl>
 <08ffe734-7c08-370e-0a10-09f3924f24c0@linux.vnet.ibm.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <828d274c-8a0f-d90f-d383-178360f9ac30@xs4all.nl>
Date:   Tue, 11 Dec 2018 17:45:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <08ffe734-7c08-370e-0a10-09f3924f24c0@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBGaCf4NQ2lridnU07Ka37g2f+fF0vusnVsy1kOjzdf8LBMgFMuEcpQzFFZavSwg9juuIBk1a4BxmJPwiufS1WjQ2A1wLMfTRfuFFJhPzhN94uiHNWFN
 tBIel5LYnrlunqfbHusC8QQnRTkSNSZAvADMayO+uxojs/C+sUN7bfwMWpY4s6+kqFleRs0jp2Xk0cArKhuqctNMOWTH5WqiYYfgYXlsp008tKjY5VAtttkO
 LStrCqepMRZ0+70MqFfKXIy2ds+VPjvvKgWJkIcxNZ78YhJrHZGXpNIGP3nyK8yq/NGnBFbU3+heAb+oYMi9d9tKC9sttuEpXhir5b2CUZ1Ah1I3PRWcZBK8
 1/GOPOJdTwjazLAllnVb5a9trVDHL0AP360NVEcI6uVbG+clmEv/+DiOBVdty56LYsk2Bzeglo12VJwpFqubfXn4K/CbASZMXO72+PcjPalSLYeLEGmyw/oa
 3FblK9Vzt//3XgSrjtgr2N0AOD0f/yWD7Mv9N5BDYmBza4eXocjKCxgrwxo6Mm4VB06Jk/ZZz6kv8OPZAqUu4ht4MI/t+mGUw8xtfg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/11/18 5:41 PM, Eddie James wrote:

<snip>

>> Running checkpatch.pl --strict over the patch gives me three 'CHECK' items
>> they you should also address:
>>
>> CHECK: struct mutex definition without comment
>> #312: FILE: drivers/media/platform/aspeed-video.c:222:
>> +       struct mutex video_lock;
>>
>> CHECK: spinlock_t definition without comment
>> #315: FILE: drivers/media/platform/aspeed-video.c:225:
>> +       spinlock_t lock;
>>
>> CHECK: usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt
>> #580: FILE: drivers/media/platform/aspeed-video.c:490:
>> +       udelay(100);
> 
> This one has to be udelay due to possibly being called in the interrupt handler...

Please add a comment for that.

> 
>>
>> I think v8 can be the final version. It probably won't make 4.21, though.
>> If I'll get a v8 today, then there is a small chance it might still make it.
>> If not, then it'll be merged early in the 4.22 cycle.
> 
> OK, no worries either way. Will send v8 in a few.

Looking forward to that.

Regards,

	Hans

> 
> Thanks for all the review!
> Eddie
> 
>>
>> Regards,
>>
>>     Hans
>>
> 

