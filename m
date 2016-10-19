Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:57009 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938723AbcJSOOW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:14:22 -0400
Subject: Re: [media] winbond-cir: Move a variable assignment in wbcir_tx()
To: =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org
References: <26ee4adb-2637-52c3-ac83-ae121bed5eff@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
 <78ddb54d61d871ad4b81c986dd9a32d4@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <1a68a0e8-6d56-d9c1-058b-cf9cd8122acb@users.sourceforge.net>
Date: Wed, 19 Oct 2016 15:32:20 +0200
MIME-Version: 1.0
In-Reply-To: <78ddb54d61d871ad4b81c986dd9a32d4@hardeman.nu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Move the assignment for the local variable "data" behind the source code
>> for a memory allocation by this function.
> 
> Sorry, I can't see what the point is?

* How do you think about to avoid a variable assignment in case
  that this memory allocation failed anyhow?

* Do you care for data access locality?

Regards,
Markus
