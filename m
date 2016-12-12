Return-path: <linux-media-owner@vger.kernel.org>
Received: from zed.grinta.net ([109.74.203.128]:60744 "EHLO zed.grinta.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752035AbcLLXT2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 18:19:28 -0500
Subject: Re: Clarification for acceptance statistics?
To: SF Markus Elfring <elfring@users.sourceforge.net>
References: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
 <e20a6835-a404-e894-d0d0-a408bfcd7fb6@users.sourceforge.net>
 <ecf01283-e2eb-ecef-313f-123ba41c0336@grinta.net>
 <d3ab238e-02f0-2511-9be1-a1447e7639bc@users.sourceforge.net>
 <5560ffc2-e17d-5750-24e5-3150aba5d8aa@grinta.net>
 <ce612b15-0dff-ce33-6b22-3a2775bed4cd@users.sourceforge.net>
 <581046dd-0a4a-acea-a6a8-8d2469594881@grinta.net>
 <3d09590c-9a10-f756-1b71-536ea37d8524@users.sourceforge.net>
 <a694926d-eedd-5d51-54d0-7ba88775c42e@grinta.net>
 <dc59427b-5631-b7e7-e9e9-80e786a8c2d6@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Daniele Nicolodi <daniele@grinta.net>
Message-ID: <9708653c-c7ac-dcb0-1b5d-4b74ee5ed79a@grinta.net>
Date: Mon, 12 Dec 2016 16:19:23 -0700
MIME-Version: 1.0
In-Reply-To: <dc59427b-5631-b7e7-e9e9-80e786a8c2d6@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/16 3:11 PM, SF Markus Elfring wrote:
>>> It is really needed to clarify the corresponding software development
>>> history any further?
>>
>> It is relevant because you are submitting a patch and your changelog
>> implies that it makes the code follow some code structure rule that
>> needs to be applied to the kernel.
> 
> I am proposing a change which was described also around various other
> functions in some software already.

What is this supposed to mean?

>> As the above is a recurring pattern in kernel code, it is legitimate
>> to ask if such a rule exist, and has been enforced before, or you are
>> making it up.
> 
> I got the impression that special software development habits can also
> evolve over time.
> 
>> As a proposer of a new pattern, what is the evidence you can bring to
>> the discussion that supports that your solution is better?
> 
> I am trying to increase the software development attention on error
> detection and corresponding exception handling at various places.

Are you doing this submitting random patches to the kernel sources?

>> What is the metric you are using to define "better"?
> 
> Do response times for system failures matter here?

No. And you are again answering a question with a question.

Cheers,
Daniele


