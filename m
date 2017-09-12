Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:20848 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751523AbdILRlh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 13:41:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"; format="flowed"
Subject: Re: [media] s5p-mfc: Adjust a null pointer check in four functions
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <ee8ba7fd-1de4-b1b9-8aa0-130c86c38f30@samsung.com>
Date: Tue, 12 Sep 2017 19:41:28 +0200
In-reply-to: <5b8eb902-d97c-3308-5ba9-64469320e0e2@users.sourceforge.net>
Content-language: en-GB
Content-transfer-encoding: 8bit
References: <482a6c92-a85e-0bcd-edf7-3c2f63ea74c5@users.sourceforge.net>
        <e794361b-8f2a-7457-007f-72ef4fa66d02@users.sourceforge.net>
        <CGME20170911092134epcas2p1a1b11c056b52d68c3b0e4ea2e1e8f758@epcas2p1.samsung.com>
        <6c2d20b3-4437-0473-73d4-73c049ba52a9@samsung.com>
        <a68020cc-2477-5d6c-bc61-d753253b755a@users.sourceforge.net>
        <0fa9a180-be67-3a33-682c-bff819c36c6a@samsung.com>
        <5b8eb902-d97c-3308-5ba9-64469320e0e2@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2017 05:00 PM, SF Markus Elfring wrote:
>>> * Do you care to preserve an information like the author date?
>> In this case not, but actually the Date line is not an issue.
> Thanks for your information.
> 
> It seems then that you quoted a line too much.
>  
>> Anyway the patch is malformed, …
 >
> I have got doubts for this view because the file was automatically generated
> by the command “git format-patch” also for the discussed three update steps.

Generating patch is only part of the story, it seems the patch is not sent
properly and tags which should be in SMTP header end up in the message
body. I think there would not be such issues if you have used git format-patch
+ git send-email.

I normally do amend things like this while applying, I will do that this time 
as well. It's already too much time wasted for such a dubious patch.

-- 
Thanks,
Sylwester
