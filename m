Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44757 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752071AbZG3KeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 06:34:07 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 0/4] radio-si470x: separate usb and i2c interface
Date: Thu, 30 Jul 2009 12:26:10 +0200
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, klimov.linux@gmail.com
References: <4A5C137A.2010104@samsung.com>
In-Reply-To: <4A5C137A.2010104@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301226.10965.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> I send the radio-si470x patches worked on http://linuxtv.org/hg/v4l-dvb.
> The patches is updated to version 2.

The patchset looks good. I'll give my feedback in the following mails.

> Tobias informed me the base code for seperating at 
> http://linuxtv.org/hg/~tlorenz/v4l-dvb of Tobias repository in above
> mail, i based on it, but it cannot find now at Tobias repository.

Before sending a pull request, I usually clean up the archive from any other patches.
But nevertheless, you and me still have the I2C patches. They now reached a quality to finally bring them in the kernel.
Good work.

> The patch 1/4 is for separating common and usb code.
> The patch 2/4 is about using dev_* macro instead of printk.
> The patch 3/4 is about adding disconnect check function for i2c interface.
> The patch 4/4 is for supporting si470x i2c interface.

Bye,
Toby
