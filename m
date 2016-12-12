Return-path: <linux-media-owner@vger.kernel.org>
Received: from zed.grinta.net ([109.74.203.128]:53402 "EHLO zed.grinta.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751375AbcLLHjo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 02:39:44 -0500
Subject: Re: [media] bt8xx: One function call less in bttv_input_init() after
 error detection
To: SF Markus Elfring <elfring@users.sourceforge.net>
References: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
 <e20a6835-a404-e894-d0d0-a408bfcd7fb6@users.sourceforge.net>
 <ecf01283-e2eb-ecef-313f-123ba41c0336@grinta.net>
 <d3ab238e-02f0-2511-9be1-a1447e7639bc@users.sourceforge.net>
 <5560ffc2-e17d-5750-24e5-3150aba5d8aa@grinta.net>
 <ce612b15-0dff-ce33-6b22-3a2775bed4cd@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Daniele Nicolodi <daniele@grinta.net>
Message-ID: <581046dd-0a4a-acea-a6a8-8d2469594881@grinta.net>
Date: Mon, 12 Dec 2016 00:39:39 -0700
MIME-Version: 1.0
In-Reply-To: <ce612b15-0dff-ce33-6b22-3a2775bed4cd@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/16 00:33, SF Markus Elfring wrote:
>>> I would prefer a safer coding style for the corresponding
>>> exception handling.
>>
>> Can you please point out what is wrong in the current code
> 
> Is it useful to reconsider the software situation that another memory
> allocation is attempted when it could be determined that a previous one
> failed already?

No.

> Are two successful allocations finally needed to achieve the desired task?

Yes.

>> and how the changes you propose fix the problem?
> 
> I suggest to check return values immediately after each function call.
> An error situation can be detected earlier then and only the required
> clean-up functionality will be executed at the end.

Which improvement does this bring?

>> No one has expressed acceptance for the kind of change you propose with
>> this patch, or to previous patches you proposed changing similar constructs.
> 
> I got a mixed impression from the acceptance statistics about my
> published patches.

Have you proposed a similar patch that was accepted? I don't find record
of it, but I may be wrong.

>> The fact that you propose over and over again a class of changes that
>> has been already vocally rejected would suggest otherwise.
> 
> I dare to propose another look at results from source code search patterns.

Why?

Cheers,
Daniele

