Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55754 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab1KIXCA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Nov 2011 18:02:00 -0500
Message-ID: <4EBB0665.4070203@iki.fi>
Date: Thu, 10 Nov 2011 01:01:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: tvboxspy <malcolmpriestley@gmail.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: [RFC 2/2] tda18218: use generic dvb_wr_regs()
References: <4EB9C272.2010607@iki.fi> <4EBAF97F.4000105@test.com>
In-Reply-To: <4EBAF97F.4000105@test.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
After today discussion I think at least following configuration options 
could be possible:

address len, for format msg
register value len, for format msg
max write len, for splitting
max read len, for splitting
option for repeated start, for splitting
conditional error logging
callback for I2C-mux (I2C-gate)
general functions implemented: wr_regs, rd_regs, wr_reg, rd_reg, 
wr_reg_mask, wr_reg_bits, rd_reg_bits
support for register banks?

That's full list of ideas I have as now. At least in first phase I think 
only basic register reads and writes are enough.

I wonder if Jean could be as main leader of development since he has 
surely best knowledge about I2C and all possible users. Otherwise, I 
think I could do it only as linux-media common functionality, because I 
don't have enough knowledge about other users.

regards
Antti
-- 
http://palosaari.fi/
