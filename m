Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:53648 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZAaQwG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jan 2009 11:52:06 -0500
Message-ID: <498481B5.4030702@gmail.com>
Date: Sat, 31 Jan 2009 17:52:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH] saa7146_i2c: saa7146_i2c_transfer() wrong?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vi drivers/media/common/saa7146_i2c.c +292

in saa7146_i2c_transfer(..., int retries) 
{
	int address_err = 0;
	do {
		...
		if (...)
			address_err++;
		...
	} while (retries--);

	/* if every retry had an address error, exit right away */
        if (address_err == retries) {
                goto out;
        }
	...
}
this is wrong, isn't it?
