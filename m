Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35888 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbbDDNgz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2015 09:36:55 -0400
Date: Sat, 4 Apr 2015 15:36:47 +0200
From: Jonathan Corbet <corbet@lwn.net>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	ldv-project@linuxtesting.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] marvell-ccic: fix memory leak on failure path
 in cafe_smbus_setup()
Message-ID: <20150404153647.01d475a5@lwn.net>
In-Reply-To: <1428106561-12623-1-git-send-email-khoroshilov@ispras.ru>
References: <1428106561-12623-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat,  4 Apr 2015 03:16:01 +0300
Alexey Khoroshilov <khoroshilov@ispras.ru> wrote:

> If i2c_add_adapter() fails, adap is not deallocated.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Actually, the worse thing is that it leaves the IRQ enabled...it's good
you moved that lines down.  Even better, of course, that the failure path
has probably never been run during the life of this driver...:)

Should there be some sort of proper reported-by line for the driver
verification project?

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
