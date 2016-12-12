Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:52018 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933505AbcLLRQM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 12:16:12 -0500
Subject: Re: [media] bt8xx: One function call less in bttv_input_init() after
 error detection
To: Daniele Nicolodi <daniele@grinta.net>
References: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
 <e20a6835-a404-e894-d0d0-a408bfcd7fb6@users.sourceforge.net>
 <ecf01283-e2eb-ecef-313f-123ba41c0336@grinta.net>
 <d3ab238e-02f0-2511-9be1-a1447e7639bc@users.sourceforge.net>
 <5560ffc2-e17d-5750-24e5-3150aba5d8aa@grinta.net>
 <ce612b15-0dff-ce33-6b22-3a2775bed4cd@users.sourceforge.net>
 <581046dd-0a4a-acea-a6a8-8d2469594881@grinta.net>
Cc: linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <baf6a24e-6a4e-f1ea-1b4d-7a3211964e4b@users.sourceforge.net>
Date: Mon, 12 Dec 2016 18:15:45 +0100
MIME-Version: 1.0
In-Reply-To: <581046dd-0a4a-acea-a6a8-8d2469594881@grinta.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I suggest to check return values immediately after each function call.
>> An error situation can be detected earlier then and only the required
>> clean-up functionality will be executed at the end.
> 
> Which improvement does this bring?

* How do you think about to avoid requesting additional system resources
  when it was determined that a previously required memory allocation failed?

* Can the corresponding exception handling become a bit more efficient?


> Why?

Do you care for any results from static source code analysis?

Regards,
Markus
