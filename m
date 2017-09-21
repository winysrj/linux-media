Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:55719 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751530AbdIUINZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 04:13:25 -0400
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
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <f5fde857-e0d2-1189-7764-dd82ca5df84a@users.sourceforge.net>
Date: Thu, 21 Sep 2017 10:12:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170920230729.b2jujsdcjtvjrjun@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>>
> 
> You've been told several times that this stuff doesn't work.

This functionality might not exactly work in the way that you expect so far.


> Try applying this patch with `git am` and you'll see why.

I find that these extra message fields work in the way that was designed
by the Git software developers.

elfring@Sonne:~/Projekte/Linux/next-patched> LANG=C git checkout -b next_deletion_of_oom_messages_in_s2255drv_test_20170921 next_deletion_of_oom_messages-20170905 && LANG=C git am '../[PATCH 2_5] [media] s2255drv: Adjust 13 checks for null pointers.eml'
Switched to a new branch 'next_deletion_of_oom_messages_in_s2255drv_test_20170921'
Applying: s2255drv: Adjust 13 checks for null pointers


Would you like to clarify corresponding concerns any more?

Regards,
Markus
