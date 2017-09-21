Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23881 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdIUJXI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 05:23:08 -0400
Date: Thu, 21 Sep 2017 12:22:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [media] s2255drv: Adjust 13 checks for null pointers
Message-ID: <20170921092235.s4w56ohow2qmeyus@mwanda>
References: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
 <66f0b95e-e717-7a50-39d2-05fcbf7b77bd@users.sourceforge.net>
 <20170920230729.b2jujsdcjtvjrjun@mwanda>
 <f5fde857-e0d2-1189-7764-dd82ca5df84a@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f5fde857-e0d2-1189-7764-dd82ca5df84a@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 21, 2017 at 10:12:56AM +0200, SF Markus Elfring wrote:
> >> MIME-Version: 1.0
> >> Content-Type: text/plain; charset=UTF-8
> >> Content-Transfer-Encoding: 8bit
> >>
> > 
> > You've been told several times that this stuff doesn't work.
> 
> This functionality might not exactly work in the way that you expect so far.
> 
> 
> > Try applying this patch with `git am` and you'll see why.
> 
> I find that these extra message fields work in the way that was designed
> by the Git software developers.
> 
> elfring@Sonne:~/Projekte/Linux/next-patched> LANG=C git checkout -b next_deletion_of_oom_messages_in_s2255drv_test_20170921 next_deletion_of_oom_messages-20170905 && LANG=C git am '../[PATCH 2_5] [media] s2255drv: Adjust 13 checks for null pointers.eml'
> Switched to a new branch 'next_deletion_of_oom_messages_in_s2255drv_test_20170921'
> Applying: s2255drv: Adjust 13 checks for null pointers
> 
> 
> Would you like to clarify corresponding concerns any more?
> 

Look at the `git log` and it just copies those lines:

commit 2a47170a824697783d8c2d28355a806f075c76e4 (HEAD)
Author: Markus Elfring <elfring@users.sourceforge.net>
Date:   Wed Sep 20 16:46:19 2017 +0200

    s2255drv: Adjust 13 checks for null pointers

    MIME-Version: 1.0
    Content-Type: text/plain; charset=UTF-8
    Content-Transfer-Encoding: 8bit

    The script “checkpatch.pl” pointed information out like the following.

    Comparison to NULL could be written !…

    Thus fix the affected source code places.


regards,
dan carpenter
