Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab0BRU3H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 15:29:07 -0500
Message-ID: <4B7DA30A.5030100@redhat.com>
Date: Thu, 18 Feb 2010 18:28:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 07/11] tm6000: add i2c send recv functions
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-4-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-5-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-6-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-7-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266255444-7422-7-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stefan.ringel@arcor.de wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

Why do you need to split it into two functions? It should be noticed that the naming
tm6000_i2c_recv_word is wrong, since the size can be bigger than 2.

Also, this patch broke compilation on -git:

  CC [M]  drivers/staging/tm6000/tm6000-i2c.o
drivers/staging/tm6000/tm6000-i2c.c: In function ‘tm6000_i2c_send_byte’:
drivers/staging/tm6000/tm6000-i2c.c:50: error: ‘REQ_16_SET_GET_I2C_WR1_RND’ undeclared (first use in this function)
drivers/staging/tm6000/tm6000-i2c.c:50: error: (Each undeclared identifier is reported only once
drivers/staging/tm6000/tm6000-i2c.c:50: error: for each function it appears in.)
drivers/staging/tm6000/tm6000-i2c.c: In function ‘tm6000_i2c_recv_byte’:
drivers/staging/tm6000/tm6000-i2c.c:55: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘:’ token
drivers/staging/tm6000/tm6000-i2c.c:55: error: expected expression before ‘:’ token
drivers/staging/tm6000/tm6000-i2c.c:60: error: ‘rc’ undeclared (first use in this function)
drivers/staging/tm6000/tm6000-i2c.c: In function ‘tm6000_i2c_recv_word’:
drivers/staging/tm6000/tm6000-i2c.c:68: error: ‘REQ_14_SET_GET_I2C_WR2_RND’ undeclared (first use in this function)
make[1]: ** [drivers/staging/tm6000/tm6000-i2c.o] Erro 1


Cheers,
Mauro
