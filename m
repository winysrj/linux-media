Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49031 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab2FPNff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jun 2012 09:35:35 -0400
Date: Sat, 16 Jun 2012 16:35:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
	mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: Re: V4L/DVB (12730): Add conexant cx25821 driver
Message-ID: <20120616133512.GB13539@mwanda>
References: <20120616131611.GA17802@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616131611.GA17802@elgon.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hm...  There are several more places which have this same problem.
I'm not sure what's going on here.

drivers/media/video/saa7164/saa7164-i2c.c:112 saa7164_i2c_register() error: memcpy() '&saa7164_i2c_algo_template' too small (24 vs 64)
drivers/media/video/cx23885/cx23885-i2c.c:321 cx23885_i2c_register() error: memcpy() '&cx23885_i2c_algo_template' too small (24 vs 64)
drivers/media/video/cx231xx/cx231xx-i2c.c:503 cx231xx_i2c_register() error: memcpy() '&cx231xx_algo' too small (24 vs 64)

regards,
dan carpenter
