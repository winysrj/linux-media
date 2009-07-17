Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61897 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933726AbZGQAI1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 20:08:27 -0400
Subject: Re: two instances of tvp514x module required for DM6467. Any
 suggestion?
From: Andy Walls <awalls@radix.net>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40144F1E560@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40144F1E560@dlee06.ent.ti.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 20:10:24 -0400
Message-Id: <1247789424.3163.21.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-07-16 at 10:32 -0500, Karicheri, Muralidharan wrote:
> Hi,
> 
> I am working to add support for DM6467 capture driver. This evm has
> two tvp5147 chips with different i2c addresses. So will I be able to
> call v4l2_i2c_new_subdev_board() twice to have two instances of this
> driver running? 

Yes call it once for each device.

Technically there will only be one copy of the driver code in memory,
but two distinct instances of data structures on which that code
operates.



> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
              ^^
Another Marylander! :)

Regards,
Andy

