Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38523 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934122AbeE2NIe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 09:08:34 -0400
Subject: Re: [PATCH v2] media: staging: tegra-vde: Reset memory client
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <20180526142755.22966-1-digetx@gmail.com>
 <87260ffb-545f-4b2c-450f-25091d028187@xs4all.nl>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <591c5840-d2ad-1ccf-0797-ab91fbd33006@gmail.com>
Date: Tue, 29 May 2018 16:08:30 +0300
MIME-Version: 1.0
In-Reply-To: <87260ffb-545f-4b2c-450f-25091d028187@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29.05.2018 09:18, Hans Verkuil wrote:
> Hi Dmitry,
> 
> On 05/26/2018 04:27 PM, Dmitry Osipenko wrote:
>> DMA requests must be blocked before resetting VDE HW, otherwise it is
>> possible to get a memory corruption or a machine hang. Use the reset
>> control provided by the Memory Controller to block DMA before resetting
>> the VDE HW.
>>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> ---
>>
>> Changelog:
>>
>> v2:
>> 	- Reset HW even if Memory Client resetting fails.
> 
> Please note that v1 has already been merged, so if you can make a v3 rebased
> on top of the latest media_tree master branch, then I'll queue that up for
> 4.18.
> 

Thank you very much for letting me know, I'll make v3.

Thierry, wouldn't you mind to queue the relevant devicetree patches for 4.18, or
it's too late now? We'll have a full set in 4.18 then.
