Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60793 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0LWQoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 11:44:04 -0500
Received: by fxm20 with SMTP id 20so7262554fxm.19
        for <linux-media@vger.kernel.org>; Thu, 23 Dec 2010 08:44:02 -0800 (PST)
Date: Thu, 23 Dec 2010 19:43:47 +0300
From: Dan Carpenter <error27@gmail.com>
To: Srinivasa.Deevi@conexant.com
Cc: linux-media@vger.kernel.org
Subject: smatch report: cx231xx: incorrect check in cx231xx_write_i2c_data()
Message-ID: <20101223164347.GA16612@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

I was doing an audit and I came across this.

drivers/media/video/cx231xx/cx231xx-core.c +1644 cx231xx_write_i2c_data(14)
	warn: 'saddr_len' is non-zero. Did you mean 'saddr'

  1642          if (saddr_len == 0)
  1643                  saddr = 0;
  1644          else if (saddr_len == 0)
  1645                  saddr &= 0xff;

We check "saddr_len == 0" twice which doesn't make sense.  I'm not sure
what the correct fix is though.  It's been this way since the driver was
merged.

regards,
dan carpenter
