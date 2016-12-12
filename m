Return-path: <linux-media-owner@vger.kernel.org>
Received: from zed.grinta.net ([109.74.203.128]:59602 "EHLO zed.grinta.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753064AbcLLVC3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 16:02:29 -0500
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
Cc: linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Daniele Nicolodi <daniele@grinta.net>
Message-ID: <a694926d-eedd-5d51-54d0-7ba88775c42e@grinta.net>
Date: Mon, 12 Dec 2016 14:02:24 -0700
MIME-Version: 1.0
In-Reply-To: <3d09590c-9a10-f756-1b71-536ea37d8524@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/16 11:03 AM, SF Markus Elfring wrote:
>> Have you proposed a similar patch that was accepted?
> 
> Yes. - It happened a few times.

The question was: have you ever had a patch changing code in the form

{
	a = kmalloc(...);
	b = kmalloc(...);

	if (!a || !b)
		goto out;

	...

out:
	kfree(a);
	kfree(b);
}

to something else, accepted?

I went checking and I haven't found such a patch.

Did you understand my question?

> It is really needed to clarify the corresponding software development
> history any further?

It is relevant because you are submitting a patch and your changelog
implies that it makes the code follow some code structure rule that
needs to be applied to the kernel. As the above is a recurring pattern
in kernel code, it is legitimate to ask if such a rule exist, and has
been enforced before, or you are making it up.

My conclusion is that you are making it up.

As a proposer of a new pattern, what is the evidence you can bring to
the discussion that supports that your solution is better? What is the
metric you are using to define "better"?

Cheers,
Daniele

