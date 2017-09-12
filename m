Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:57251 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750742AbdILUeP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 16:34:15 -0400
Subject: Re: [media] s5p-mfc: Adjust a null pointer check in four functions
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <482a6c92-a85e-0bcd-edf7-3c2f63ea74c5@users.sourceforge.net>
 <e794361b-8f2a-7457-007f-72ef4fa66d02@users.sourceforge.net>
 <CGME20170911092134epcas2p1a1b11c056b52d68c3b0e4ea2e1e8f758@epcas2p1.samsung.com>
 <6c2d20b3-4437-0473-73d4-73c049ba52a9@samsung.com>
 <a68020cc-2477-5d6c-bc61-d753253b755a@users.sourceforge.net>
 <0fa9a180-be67-3a33-682c-bff819c36c6a@samsung.com>
 <5b8eb902-d97c-3308-5ba9-64469320e0e2@users.sourceforge.net>
 <ee8ba7fd-1de4-b1b9-8aa0-130c86c38f30@samsung.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ecb9823b-007c-f2c2-29bb-fbd08429385c@users.sourceforge.net>
Date: Tue, 12 Sep 2017 22:33:16 +0200
MIME-Version: 1.0
In-Reply-To: <ee8ba7fd-1de4-b1b9-8aa0-130c86c38f30@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Generating patch is only part of the story,

I can follow this view in principle.


> it seems the patch is not sent properly

I got an other impression.


> and tags which should be in SMTP header end up in the message body.

I agree that extra message fields were presented by the git software for
a reason.
You might have got other opinions about the original reason (than me).


> I think there would not be such issues if you have used git
> format-patch + git send-email.

I have got also doubts about your corresponding expectations when you
would find
the proposed commit message itself acceptable (besides the small source
code changes).


> I normally do amend things like this while applying,

That is interesting.


> I will do that this time as well.

Such an action can also be nice.


> It's already too much time wasted for such a dubious patch.

A bit of time is needed to resolve a temporary disagreement.

Regards,
Markus
