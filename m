Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:62777 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751404AbdILPBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 11:01:38 -0400
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
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5b8eb902-d97c-3308-5ba9-64469320e0e2@users.sourceforge.net>
Date: Tue, 12 Sep 2017 17:00:55 +0200
MIME-Version: 1.0
In-Reply-To: <0fa9a180-be67-3a33-682c-bff819c36c6a@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> * Do you care to preserve an information like the author date?
>
> In this case not, but actually the Date line is not an issue.

Thanks for your information.

It seems then that you quoted a line too much.


> Anyway the patch is malformed, …

I have got doubts for this view because the file was automatically generated
by the command “git format-patch” also for the discussed three update steps.

Regards,
Markus
