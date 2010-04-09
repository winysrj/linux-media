Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:65337 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761Ab0DIVgp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 17:36:45 -0400
Subject: Re: [PATCH] Teach drivers/media/IR/ir-raw-event.c to use durations
From: Andy Walls <awalls@radix.net>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <20100408161000.GA23119@hardeman.nu>
References: <20100408161000.GA23119@hardeman.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 17:36:38 -0400
Message-Id: <1270848998.3038.47.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-04-08 at 18:10 +0200, David Härdeman wrote:

> With this patch:
> 
> s64 int's are used to represent pulse/space durations in ns

If performing divides on 64 bit numbers, please check to make sure your
code compiles, links, and loads on a 32-bit system.

We've had problems in the past in where gcc will build the module to
reference __udivdi3 under 32-bit kernels; but that symbol is not in the
kernel.

Search for 'do_div' in:

	linux/drivers/media/video/cx18/cx18-av-core.c

for a simple example divide that works on both 64 and 32 bit machines.

Regards,
Andy

