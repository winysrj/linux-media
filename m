Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:30191 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KJIUt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 03:20:49 -0500
Date: Thu, 10 Nov 2011 09:20:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	tvboxspy <malcolmpriestley@gmail.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC 2/2] tda18218: use generic dvb_wr_regs()
Message-ID: <20111110092041.25646268@endymion.delvare>
In-Reply-To: <4EBB0665.4070203@iki.fi>
References: <4EB9C272.2010607@iki.fi>
	<4EBAF97F.4000105@test.com>
	<4EBB0665.4070203@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 10 Nov 2011 01:01:57 +0200, Antti Palosaari wrote:
> Hello
> After today discussion I think at least following configuration options 
> could be possible:
> 
> address len, for format msg
> register value len, for format msg
> max write len, for splitting
> max read len, for splitting
> option for repeated start, for splitting
> conditional error logging
> callback for I2C-mux (I2C-gate)
> general functions implemented: wr_regs, rd_regs, wr_reg, rd_reg, 
> wr_reg_mask, wr_reg_bits, rd_reg_bits
> support for register banks?
> 
> That's full list of ideas I have as now. At least in first phase I think 
> only basic register reads and writes are enough.

Yes, I suggest starting simple, and adding things later on as they
become needed.

I also suggest spelling out "read" and "write", and also don't forget
to prefix your public function names to avoid namespace collisions.

> I wonder if Jean could be as main leader of development since he has 
> surely best knowledge about I2C and all possible users. Otherwise, I 
> think I could do it only as linux-media common functionality, because I 
> don't have enough knowledge about other users.

If you want it to happen fast, then I suggest that you drive
development yourself, and indeed implement it as a common linux-media
functionality for now. Later on, once the code has been in place for
some time with success, if other subsystems need something similar then
we can consider moving the code to i2c-core or some generic i2c helper
module.

If you count on me to drive it, I am afraid it will take months, given
my current workload and various tasks with a much higher priority than
this. I will however be happy to help with code review.

-- 
Jean Delvare
