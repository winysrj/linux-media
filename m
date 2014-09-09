Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:54752 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbaIIKjJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Sep 2014 06:39:09 -0400
Date: Tue, 9 Sep 2014 11:39:04 +0100
From: Sean Young <sean@mess.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: Re: [PATCH] [media] mceusb: fix usbdev leak
Message-ID: <20140909103903.GA623@gofer.mess.org>
References: <1410214243-6319-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410214243-6319-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 09, 2014 at 02:10:43AM +0400, Alexey Khoroshilov wrote:
> mceusb_init_rc_dev() does usb_get_dev(), but there is no any
> usb_put_dev() in the driver.

drivers/media/rc/imon.c suffers from the same problem.

Thanks
Sean
