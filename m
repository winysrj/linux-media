Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:61402 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934923AbcJSOR4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:17:56 -0400
Subject: Re: [media] winbond-cir: Move a variable assignment in two functions
To: =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org
References: <0b6de919-35a0-8ee3-9ea7-907c9b9a36f2@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
 <ecd1ac487c0cfe2080c9477408258e25@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <75f2acf2-bc93-04be-1331-242c5a85beaf@users.sourceforge.net>
Date: Wed, 19 Oct 2016 15:53:39 +0200
MIME-Version: 1.0
In-Reply-To: <ecd1ac487c0cfe2080c9477408258e25@hardeman.nu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Move the assignment for the local variable "data" behind the source code
>> for condition checks by these functions.
> 
> Why?

* Would you like to set these variables only after the initial
  check succeeded?

* Do you care for data access locality also in these cases?

Regards,
Markus

