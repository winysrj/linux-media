Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:24022 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbZBAKzY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2009 05:55:24 -0500
Date: Sun, 1 Feb 2009 11:55:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] saa7146_i2c: saa7146_i2c_transfer() wrong?
Message-ID: <20090201115514.380984b7@hyperion.delvare>
In-Reply-To: <498481B5.4030702@gmail.com>
References: <498481B5.4030702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 31 Jan 2009 17:52:05 +0100, Roel Kluin wrote:
> vi drivers/media/common/saa7146_i2c.c +292
> 
> in saa7146_i2c_transfer(..., int retries) 
> {
> 	int address_err = 0;
> 	do {
> 		...
> 		if (...)
> 			address_err++;
> 		...
> 	} while (retries--);
> 
> 	/* if every retry had an address error, exit right away */
>         if (address_err == retries) {
>                 goto out;
>         }
> 	...
> }
> this is wrong, isn't it?

Yes, it looks pretty wrong, however the linux-i2c list isn't the right
place to discuss this.

-- 
Jean Delvare
