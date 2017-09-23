Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:52986 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbdIWNKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 09:10:48 -0400
Subject: Re: [git:media_tree/master] media: drivers: delete error messages for
 failed memory allocation
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <E1dvjhO-0000R8-6g@www.linuxtv.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <1ffc2129-192d-84c7-e064-27ebe861d4ec@users.sourceforge.net>
Date: Sat, 23 Sep 2017 15:10:12 +0200
MIME-Version: 1.0
In-Reply-To: <E1dvjhO-0000R8-6g@www.linuxtv.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> This is an automatic generated email to let you know that the following patch were queued:

Thanks for your information about another software evolution
which you would like to integrate also.


> Omit an extra message for a memory allocation failure in this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> [mchehab@s-opensource.com: fold several similar patches into one]

I find the patch granularity interesting that you chose here.


Can it be that the sentence “Omit extra messages for a memory allocation failure
in these functions.” would be more appropriate in the commit description
for such a combination of changes for 23 source files?

Regards,
Markus
