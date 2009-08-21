Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54227 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbZHUQcu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 12:32:50 -0400
Subject: Re: compat.h required to build
From: Andy Walls <awalls@radix.net>
To: lotway@nildram.co.uk
Cc: linux-media@vger.kernel.org
In-Reply-To: <4A8EC51B.20902@nildram.co.uk>
References: <4A8EC51B.20902@nildram.co.uk>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 12:34:19 -0400
Message-Id: <1250872459.3139.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-08-21 at 17:02 +0100, Lou Otway wrote:
> Hi,
> 
> The following files:
> 
> /linux/drivers/media/dvb/frontends/stb6100.c
> /linux/drivers/media/dvb/frontends/tda10021.c
> /linux/drivers/media/dvb/frontends/ves1820.c
> 
> Fail to build with:
> 
> error: implicit declaration of function 'DIV_ROUND_CLOSEST'
> 
> and need the addition of:
> 
> #include "compat.h"
> 
> when building on my system. Is this related to my kernel version 
> (2.6.28) or is it something else?

DIV_ROUND_CLOSEST is probably available only in more recent kernels.
When its use was added to those files, backward compatability was likely
not tested.  Including compat.h is the proper thing to do.

Regards,
Andy


> Thanks,
> 
> Lou
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

