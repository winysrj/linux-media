Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:33511 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001Ab0BXNX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 08:23:29 -0500
Subject: Re: [linux-dvb] soft demux device
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <753100.2204.qm@web57007.mail.re3.yahoo.com>
References: <753100.2204.qm@web57007.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Wed, 24 Feb 2010 08:22:32 -0500
Message-Id: <1267017752.3101.0.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-02-24 at 03:57 -0800, ozgur cagdas wrote:
> Hi,
> 
> Thanks very much for the previous information. To give it a go just as
> it is, I've loaded dvb_dummy_fe module manually and many other modules
> including dvb_core as well, but no hope, don't have /dev/dvb folder
> yet. As I've mentioned earlier, I do not have a hardware at the
> moment, so I should trigger loading of proper modules manually. In my
> scenario, which modules should I load? Any simple set of modules
> that'd create necessary /dev/dvb/ and subsequent would do for me. If
> it matters, I am using 2.6.31 kernel and ubuntu 9.10 distribution.

See my dvb_dummy_adapter patch I just posted to the list.

Regards,
Andy

> Cheers,
> 
> Ozgur.
> 
> 
>       
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

