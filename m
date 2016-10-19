Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:49718 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941581AbcJSOU0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:20:26 -0400
Subject: Re: [media] winbond-cir: Move assignments for three variables in
 wbcir_shutdown()
To: =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org
References: <285954ec-280f-8a5a-5189-eb2471b4339c@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
 <327f6034db9ce0c0a72947e47daf344a@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <3c96d0bf-62fa-6b02-2a2d-2a097709271a@users.sourceforge.net>
Date: Wed, 19 Oct 2016 15:38:44 +0200
MIME-Version: 1.0
In-Reply-To: <327f6034db9ce0c0a72947e47daf344a@hardeman.nu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Move the setting for the local variables "mask", "match" and "rc6_csl"
>> behind the source code for a condition check by this function
>> at the beginning.
>  
> Again, I can't see what the point is?

* How do you think about to set these variables only after the initial
  check succeded?

* Do you care for data access locality?

Regards,
Markus
