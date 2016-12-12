Return-path: <linux-media-owner@vger.kernel.org>
Received: from zed.grinta.net ([109.74.203.128]:57296 "EHLO zed.grinta.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753247AbcLLR4W (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 12:56:22 -0500
Subject: Re: [media] bt8xx: One function call less in bttv_input_init() after
 error detection
To: SF Markus Elfring <elfring@users.sourceforge.net>
References: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
 <e20a6835-a404-e894-d0d0-a408bfcd7fb6@users.sourceforge.net>
 <ecf01283-e2eb-ecef-313f-123ba41c0336@grinta.net>
 <d3ab238e-02f0-2511-9be1-a1447e7639bc@users.sourceforge.net>
 <5560ffc2-e17d-5750-24e5-3150aba5d8aa@grinta.net>
 <ce612b15-0dff-ce33-6b22-3a2775bed4cd@users.sourceforge.net>
 <581046dd-0a4a-acea-a6a8-8d2469594881@grinta.net>
 <baf6a24e-6a4e-f1ea-1b4d-7a3211964e4b@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Daniele Nicolodi <daniele@grinta.net>
Message-ID: <480128e5-f309-d787-0c37-d6475aeabbdd@grinta.net>
Date: Mon, 12 Dec 2016 10:56:16 -0700
MIME-Version: 1.0
In-Reply-To: <baf6a24e-6a4e-f1ea-1b4d-7a3211964e4b@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/16 10:15 AM, SF Markus Elfring wrote:
>>> I suggest to check return values immediately after each function call.
>>> An error situation can be detected earlier then and only the required
>>> clean-up functionality will be executed at the end.
>>
>> Which improvement does this bring?
> 
> * How do you think about to avoid requesting additional system resources
>   when it was determined that a previously required memory allocation failed?

I think it is an irrelevant problem in the case at hand.

> * Can the corresponding exception handling become a bit more efficient?

Where more efficient merely means sparing one function call? I think it
is completely irrelevant in the case at hand and code clarity must be
preferred to pointless optimization.

>> Why?
> 
> Do you care for any results from static source code analysis?

Static source code analysis, in the form you are doing with Coccinelle,
may help in identifying problems in a code base when a specific pattern
has been identified to be problematic. In the static code analysis
results you present, it is not clear what the problematic pattern is.
Independently of how you identified the code section you propose to
change, there is no problem to fix.

As a general advise, Markus, replying to questions with other questions
is a a bad debate form. Questions, as opposed to statements, cannot be
confuted. Also, every time you receive an answer to one of your
questions, you reply with another question broadening the span of the
discussion. However, you do not present evidence supporting your initial
statement that some changes in the code are beneficial.

Cheers,
Daniele

