Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45863 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbdDQM4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 08:56:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Axtens <dja@axtens.net>
Cc: Greg KH <greg@kroah.com>,
        Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: uvcvideo logging kernel warnings on device disconnect
Date: Mon, 17 Apr 2017 15:57:35 +0300
Message-ID: <1742096.L6mokpMOAb@avalon>
In-Reply-To: <87r30rv2ay.fsf@possimpible.ozlabs.ibm.com>
References: <ab3241e7-c525-d855-ecb6-ba04dbdb030f@destevenson.freeserve.co.uk> <8113252.R6OEHK1FMB@avalon> <87r30rv2ay.fsf@possimpible.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Monday 17 Apr 2017 18:57:57 Daniel Axtens wrote:
> Hi,
> 
> >> > I hate to pester, but wondered if you had found anything obvious.
> >> > I really do appreciate you taking the time to look.
> >> 
> >> Sorry, I haven't had the chance and now will not be able to until
> >> January....
> > 
> > Did you mean January 2017 or 2018 ? :-)
> 
> I stumbled across this problem independently, and with the help of some
> of the info on this thread (especially yavta), I have what I think is a
> solution: https://patchwork.kernel.org/patch/9683663/

Thank you for that !

I've reviewed your patch. Greg, there's a question for you in my reply, could 
you have a look when you'll have time ?

-- 
Regards,

Laurent Pinchart
