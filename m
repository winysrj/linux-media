Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:51303 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaEYMks (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 08:40:48 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so6929839wes.27
        for <linux-media@vger.kernel.org>; Sun, 25 May 2014 05:40:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53810CBE.9090504@xs4all.nl>
References: <537F0FCD.207@xs4all.nl> <20140523194545.4793e1a0.m.chehab@samsung.com>
 <53805338.50301@xs4all.nl> <20140524163214.6796f264.m.chehab@samsung.com>
 <20140524165959.4cfe9f0e.m.chehab@samsung.com> <53810CBE.9090504@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 25 May 2014 18:10:17 +0530
Message-ID: <CA+V-a8vTWNjwb6zajJtnx-0J8QdPaOpWaJzh10KsH1cp183G5A@mail.gmail.com>
Subject: Re: [GIT PULL FOR v3.16] davinci updates
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, May 25, 2014 at 2:48 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 05/24/2014 09:59 PM, Mauro Carvalho Chehab wrote:
[snip]
>> reverted patch and resubmit the remaining ones:
>>
>> media: davinci: vpif_capture: drop unneeded module params
>> media: davinci: vpif_capture: fix v4l-complinace issues
>>
>> Ah, please fix the typo there: "complinace".
>
> Prabhakar, do you have time to create a proper description of the "drop unneeded
> module params" patch? I know you are going to relocate, so if you don't, then let
> me know and I will try to make a good description on Monday.
>
> The second patch depends on the first, so rather than trying to fix the second
> patch it is easier to just create a proper description for the first so that
> the can be applied in order.
>
Please go ahead and make the changes and thanks for the help :)

Thanks,
--Prabhakar Lad

> Regards,
>
>         Hans
