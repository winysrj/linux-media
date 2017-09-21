Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:58787 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751896AbdIULXq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 07:23:46 -0400
Subject: Re: [media] s2255drv: Adjust 13 checks for null pointers
To: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
 <66f0b95e-e717-7a50-39d2-05fcbf7b77bd@users.sourceforge.net>
 <20170920230729.b2jujsdcjtvjrjun@mwanda>
 <f5fde857-e0d2-1189-7764-dd82ca5df84a@users.sourceforge.net>
 <20170921092235.s4w56ohow2qmeyus@mwanda>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ea01c235-f570-a286-b549-d8df9844b526@users.sourceforge.net>
Date: Thu, 21 Sep 2017 13:23:24 +0200
MIME-Version: 1.0
In-Reply-To: <20170921092235.s4w56ohow2qmeyus@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Would you like to clarify corresponding concerns any more?
>>
> 
> Look at the `git log`

I did this also for a moment.


> and it just copies those lines:

The Git software preserves these three message fields
(when special characters were used in the commit message).

Can you accept such software functionality?

Regards,
Markus
