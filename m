Return-path: <mchehab@localhost.localdomain>
Received: from waldorf.cs.uni-dortmund.de ([129.217.4.42]:59898 "EHLO
	waldorf.cs.uni-dortmund.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268Ab0IMJzb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 05:55:31 -0400
From: Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de>
To: linux-media@vger.kernel.org
Subject: Re: Kernel Oops with Kernel 2.6.32
Date: Mon, 13 Sep 2010 11:55:14 +0200
Cc: Andy Walls <awalls@md.metrocast.net>,
	Patrick Boettcher <pboettcher@dibcom.fr>
References: <201009102306.55019.Christoph.Pleger@cs.tu-dortmund.de> <1284213736.2053.65.camel@morgan.silverblock.net>
In-Reply-To: <1284213736.2053.65.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009131155.15268.Christoph.Pleger@cs.tu-dortmund.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Hello,

> The value for "adap" is in register RDI: 0000000000000002, and that is
> not a valid pointer.  There is a bug in dib7000p.c somewhere.
>
> Do a 'hg log -v -p linux/drivers/media/dvb/frontends/dib7000p.c | less'
> to see what might have changed.

I cannot find the reason for the Kernel Oops. I even copied the dib7000p.c 
from an April 2009 version and just added two missing necessary functions 
(dib7000p_pid_filter_ctrl and dib7000p_pid_filter), but the Kernel Oops does 
still occur.

Regards
  Christoph
