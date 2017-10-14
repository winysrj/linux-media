Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:47417 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751109AbdJNI0B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Oct 2017 04:26:01 -0400
Subject: Re: [PATCH] build: Remove IDA from lirc_dev
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: d.scheller@gmx.net, david@hardeman.nu, Sean Young <sean@mess.org>
References: <1507926209-9654-1-git-send-email-jasmin@anw.at>
 <6709a343-26fa-64c7-f7ac-ed3a99ebc6ef@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e3e7b2bd-76c5-8adb-8c4e-ed8ce38bebff@xs4all.nl>
Date: Sat, 14 Oct 2017 10:25:56 +0200
MIME-Version: 1.0
In-Reply-To: <6709a343-26fa-64c7-f7ac-ed3a99ebc6ef@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added Sean.

Hans

On 10/13/2017 10:33 PM, Jasmin J. wrote:
> Hi!
> 
> With this patch, the media-tree can be compiled back to Kernel 2.6.37.
> For 2.6.32 some patches do not apply. I will fix that later.
> 
> @David:
> Please can you review my changes if I reverted the patch correctly.
> "git revert" didn't work, because of the changes in lirc_dev.c.
> 
> BR,
>    Jasmin
> 
