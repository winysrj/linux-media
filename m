Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:50218 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938725AbcJSOOW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:14:22 -0400
Subject: Re: [media] winbond-cir: Move assignments for three variables in
 wbcir_shutdown()
To: =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org
References: <3c96d0bf-62fa-6b02-2a2d-2a097709271a@users.sourceforge.net>
 <285954ec-280f-8a5a-5189-eb2471b4339c@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
 <327f6034db9ce0c0a72947e47daf344a@hardeman.nu>
 <10715e71c46bda76f6c8654675062f61@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <213df5d7-1c5a-496d-9928-bdafefce8781@users.sourceforge.net>
Date: Wed, 19 Oct 2016 16:14:12 +0200
MIME-Version: 1.0
In-Reply-To: <10715e71c46bda76f6c8654675062f61@hardeman.nu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>> Move the setting for the local variables "mask", "match" and "rc6_csl"
>>>> behind the source code for a condition check by this function
>>>> at the beginning.
>>>
>>> Again, I can't see what the point is?
>>
>> * How do you think about to set these variables only after the initial
>> check succeded?
> 
> I prefer setting variables early so that no thinking about
> whether they're initialized or not is necessary later.

* How do you think about to reduce the scope for these variables then?

* Would you dare to move the corresponding source code into a separate function?

Regards,
Markus
