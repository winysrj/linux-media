Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57020 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752011AbZHITwV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Aug 2009 15:52:21 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 0/4] radio-si470x: separate usb and i2c interface
Date: Sun, 9 Aug 2009 21:52:14 +0200
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, klimov.linux@gmail.com
References: <4A5C137A.2010104@samsung.com> <200907301226.10965.tobias.lorenz@gmx.net> <4A719280.3030306@samsung.com>
In-Reply-To: <4A719280.3030306@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908092152.15803.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> I am concerned about one thing. I cannot test the si470x usb radio 
> driver because i don't have the si470x usb radio device, so i believe
> you would have probably tested it.

It is working. I tested it with the most common radio applications and with some RDS decoders.

As the I2C part is working, I will send Mauro a pull request.

> >> The patch 1/4 is for separating common and usb code.
> >> The patch 2/4 is about using dev_* macro instead of printk.
> >> The patch 3/4 is about adding disconnect check function for i2c interface.
> >> The patch 4/4 is for supporting si470x i2c interface.

Bye,
Toby
