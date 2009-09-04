Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60328 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261AbZIDUIH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2009 16:08:07 -0400
Subject: Re: Fix memory corruption during IR initialization for various
 tuner cards
From: Andy Walls <awalls@radix.net>
To: Brian Rogers <brian@xyzw.org>, SoxSlayer <soxslayer@gmail.com>
Cc: ivtv-users@ivtvdriver.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Barton C Massey <bart@cs.pdx.edu>
In-Reply-To: <4AA148F3.10700@xyzw.org>
References: <4AA148F3.10700@xyzw.org>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 16:09:47 -0400
Message-Id: <1252094987.3143.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-09-04 at 10:05 -0700, Brian Rogers wrote:
> Mauro,
> 
> The attached git-formatted patch fixes a regression I just found that 
> was introduced in 2.6.31-rc1. I hope it can make it into the release.
> 
> Brian

Brian,

Thanks for solving my cx18 problem for me. :)

Dustin,

Could you please try this patch for the IR receiver on the HVR-1600 with
ir-kbd-i2c?

http://linuxtv.org/hg/~awalls/v4l-dvb/rev/30f721b428b9


Regards,
Andy



