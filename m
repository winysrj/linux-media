Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52798
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbcI0JF3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 05:05:29 -0400
Date: Tue, 27 Sep 2016 06:05:19 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [ANN] No daily build this week
Message-ID: <20160927060519.4e76aaea@vento.lan>
In-Reply-To: <573484a3-cc5c-614a-e0de-772d9d164ee1@xs4all.nl>
References: <573484a3-cc5c-614a-e0de-772d9d164ee1@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Sep 2016 10:03:46 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi all,
> 
> Due to a server crash there is no daily build for a while. I was
> planning to move the daily build to another server. so this is as
> good a time as any to do this, but it's unlikely to happen this
> week. I hope to have it up and running again early next week.

No problems. I don't plan to apply any patch to the tree, up to the
end of the merge window, except if some urgent patch is required.

Btw, it would be good if you could take the opportunity and modify
your daily build process to only generate e-mails if a patch is
added to one of the trees used on the build.

Regards,
Mauro

> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Thanks,
Mauro
