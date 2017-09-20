Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:51558 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751307AbdITRSk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 13:18:40 -0400
Subject: Re: [media] Siano: Use common error handling code in
 smsusb_init_device()
To: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <be0003e5-d8e0-bff6-2205-7e88270ba2b4@users.sourceforge.net>
 <20170920135605.sneukaioeabalkud@mwanda>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5c4e91c6-80fd-e17a-d165-b8d4a5e5ce14@users.sourceforge.net>
Date: Wed, 20 Sep 2017 19:18:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170920135605.sneukaioeabalkud@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> If smscore_register_device() succeeds then mdev is freed when we call
> smsusb_term_device(intf);  The call tree is:

Thanks for your constructive information.


How do you think about another implementation detail in this function then?

May the statement “kfree(mdev);” be executed before “smsusb_term_device(intf);”
in one if branch?

Regards,
Markus
