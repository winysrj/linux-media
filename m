Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49697 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751362AbdBJI6S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 03:58:18 -0500
Subject: Re: Patch status in patchwork
To: Avraham Shukron <avraham.shukron@gmail.com>,
        linux-media@vger.kernel.org
References: <fe15a61f-f0fd-335b-e743-b9dc514380f5@gmail.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <b9d82634-c7dc-d5c9-45d7-794d97e1c40a@ideasonboard.com>
Date: Fri, 10 Feb 2017 08:57:46 +0000
MIME-Version: 1.0
In-Reply-To: <fe15a61f-f0fd-335b-e743-b9dc514380f5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Avraham,

On 08/02/17 12:11, Avraham Shukron wrote:
> Hi!
> 
> I submitted a patch which is now at v3 already.
> In patchwork they appear separated / unrelated.
> 1. Is there a way to tell patchwork that they are all actually iterations
>    of the same patch?

I don't believe this is possible currently.
Though I'd be interested to know if I'm wrong :D

> 2. The current status of v1, v2 is "Change Requested". v3 adds the necessary changes.
>    Should I update the status of v1,v2? If so - to what?

You could mark the old versions as superseded. Much of patchwork is a manual
process, so it can take some time before someone works through the patch list to
update old patches.

--
Regards

Kieran

> Thanks,
> Avi Shukron
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
