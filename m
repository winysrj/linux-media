Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35277 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbZHUQfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 12:35:15 -0400
Received: by fxm17 with SMTP id 17so559594fxm.37
        for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 09:35:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250872459.3139.16.camel@palomino.walls.org>
References: <4A8EC51B.20902@nildram.co.uk>
	 <1250872459.3139.16.camel@palomino.walls.org>
Date: Fri, 21 Aug 2009 12:35:15 -0400
Message-ID: <829197380908210935g4b8403efp907685cbb4a7a83b@mail.gmail.com>
Subject: Re: compat.h required to build
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: lotway@nildram.co.uk, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 21, 2009 at 12:34 PM, Andy Walls<awalls@radix.net> wrote:
> DIV_ROUND_CLOSEST is probably available only in more recent kernels.
> When its use was added to those files, backward compatability was likely
> not tested.  Including compat.h is the proper thing to do.
>
> Regards,
> Andy

I'm pretty sure Mauro just added the macro to compat.h yesterday (and
I can only assume he missed a couple of includes).  Lou, feel free to
submit a patch with the extra includes, including an SOB.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
