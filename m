Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:57152 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752546AbdLHVML (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 16:12:11 -0500
Subject: Re: [PATCH] build: Added missing timer_setup_on_stack
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: d.scheller@gmx.net
References: <1512766859-7667-1-git-send-email-jasmin@anw.at>
 <3343c1fd-d0f0-46b1-fd3f-150f36de6fa4@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <21ccbddb-eada-fa44-93ea-f0b80e17d409@xs4all.nl>
Date: Fri, 8 Dec 2017 22:12:05 +0100
MIME-Version: 1.0
In-Reply-To: <3343c1fd-d0f0-46b1-fd3f-150f36de6fa4@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2017 10:06 PM, Jasmin J. wrote:
> Hello Hans!
> 
> With this patch it compiles for Kernel 4.4, but not on 3.13. I will work on
> that soon.
> 
> I am not sure if this patch keeps pvrusb2 working, but it compiles. I tried
> first a solution by reverting 8da0edf2f90b6c74b69ad420fdd230c9bd2bd1ed. If you
> prefer this, I have it on a branch and can submit it.
> 
> BR,
>    Jasmin
> 

I've applied all your patches. Thank you very much for working on this.

Let's see what the result of the nightly build will be.

In general reverting kernel patches to make a driver compile is something of a
last resort. It tends to be painful to maintain in the long run, at least, that's
been my experience.

Regards,

	Hans
