Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:49734 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbcLLHeI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 02:34:08 -0500
Subject: Re: [media] bt8xx: One function call less in bttv_input_init() after
 error detection
To: Daniele Nicolodi <daniele@grinta.net>
References: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
 <e20a6835-a404-e894-d0d0-a408bfcd7fb6@users.sourceforge.net>
 <ecf01283-e2eb-ecef-313f-123ba41c0336@grinta.net>
 <d3ab238e-02f0-2511-9be1-a1447e7639bc@users.sourceforge.net>
 <5560ffc2-e17d-5750-24e5-3150aba5d8aa@grinta.net>
Cc: linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ce612b15-0dff-ce33-6b22-3a2775bed4cd@users.sourceforge.net>
Date: Mon, 12 Dec 2016 08:33:43 +0100
MIME-Version: 1.0
In-Reply-To: <5560ffc2-e17d-5750-24e5-3150aba5d8aa@grinta.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I would prefer a safer coding style for the corresponding
>> exception handling.
> 
> Can you please point out what is wrong in the current code

Is it useful to reconsider the software situation that another memory
allocation is attempted when it could be determined that a previous one
failed already?
Are two successful allocations finally needed to achieve the desired task?


> and how the changes you propose fix the problem?

I suggest to check return values immediately after each function call.
An error situation can be detected earlier then and only the required
clean-up functionality will be executed at the end.


> No one has expressed acceptance for the kind of change you propose with
> this patch, or to previous patches you proposed changing similar constructs.

I got a mixed impression from the acceptance statistics about my
published patches.


> The fact that you propose over and over again a class of changes that
> has been already vocally rejected would suggest otherwise.

I dare to propose another look at results from source code search patterns.


> The major achievement you obtained so far is that one of the maintainers
> of a large fraction of the kernel refuses to look at your patch submissions.

It can happen that some patterns are occasionally "too special"
to grow the popularity for such change possibilities and desired software
improvements quickly.
There are also different views about affected implementation details
by the software development community, aren't there?

Regards,
Markus
