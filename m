Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B91EC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 17:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F1042087C
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 17:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfCZRR4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 13:17:56 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:34112 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726175AbfCZRRz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 13:17:55 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 8phth6R0HUjKf8phxhmTwg; Tue, 26 Mar 2019 18:17:54 +0100
Subject: Re: [PATCH v4 0/3] Add ZynqMP VCU/Allegro DVT H.264 encoder driver
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dshah@xilinx.com, mchehab@kernel.org, robh+dt@kernel.org,
        kernel@pengutronix.de, tfiga@chromium.org
References: <20190301152718.23134-1-m.tretter@pengutronix.de>
 <20190326084613.405e7ed4@litschi.hi.pengutronix.de>
 <484d66c6-a2c0-6c18-6cdf-81ef647295e3@xs4all.nl>
 <20190326171403.aj7wp5yn6gugkdky@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2b2650f3-7ecf-0277-ecc8-e1c222281665@xs4all.nl>
Date:   Tue, 26 Mar 2019 18:17:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190326171403.aj7wp5yn6gugkdky@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDZHt7l1paAKsAeEuno4AwGJcJ4bekYrnFC+4jtQ9kNMbB9UNdrN7gG3hKlE0X+nr+Kbxqo/1Uxym6V5egw7cq2Zu1D2A4Sm0CuwSwe8UHUkJTiWiUWg
 aypqBf6sBSFJJleKbKz09s1wjVBhtOylLnMDK0E7+wHh+bMJrf1SeR+Ap9zc0XAD9PkUF+u7XC+33g058MkNcsotPX9uhlxyto1NruZjpc4BehWCEhGQPwlG
 Tavw8FxEm6iXdARIYWlHjLvk5OKAFbykhwSEoyfDTP5yWHXNGPO/c5tC1E0EyoRBQUpSWpGTta5gw+ObzMeDm4PxXuPs1mhx1YN96A1mjXfTPx8lc8Qa7jr7
 NTMqCfz6KIpiztvJWC5HLBTL7Ctw7a0VrD8Hg8kEOuaKu6TimdYfGPfQa5y/rOjcXFFXURpJySO/0opOB5/KJpE+1fKm4A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/26/19 6:14 PM, Uwe Kleine-König wrote:
> Hello,
> 
> On Tue, Mar 26, 2019 at 12:47:38PM +0100, Hans Verkuil wrote:
>> On 3/26/19 8:46 AM, Michael Tretter wrote:
>>> On Fri, 01 Mar 2019 16:27:15 +0100, Michael Tretter wrote:
>>>> This is v4 of the series to add support for the Allegro DVT H.264 encoder
>>>> found in the EV family of the Xilinx ZynqMP platform.
>>>
>>> Ping.
>>
>> It's delegated to me in patchwork, so I'll get to it in a few days.
>>
>> We were waiting for the 5.1-rc1 release.
> 
> There is a misunderstanding somewhere here. We have 5.1-rc2 since
> Sunday and 5.1-rc1 since Sunday the week before. What am I missing?

I was waiting for 5.1-rc1 to be merged into our media master repo, so I
can apply this series on top of that. That happened at last week, so now
I can pick up these patches this week/next week.

Regards,

	Hans
