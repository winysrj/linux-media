Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab1LKK7m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 05:59:42 -0500
Message-ID: <4EE48D13.7030702@redhat.com>
Date: Sun, 11 Dec 2011 08:59:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL] af9013
References: <4ED666E9.2020405@iki.fi>
In-Reply-To: <4ED666E9.2020405@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30-11-2011 15:24, Antti Palosaari wrote:
> Morjens Mauro,
>
> I rewrote whole af9013 demodulator driver in order to decrease I2C load. Please pull that to the next Kernel merge window.
>
> Antti
>
> The following changes since commit a235af24a74a0fa03ece0a9f5e28a72e4d1e2cad:
>
> ce168: remove experimental from Kconfig (2011-11-19 23:07:54 +0200)
>
> are available in the git repository at:
> git://linuxtv.org/anttip/media_tree.git misc
>
> Antti Palosaari (1):
> af9013: rewrite whole driver
>
> drivers/media/dvb/dvb-usb/af9015.c | 82 +-
> drivers/media/dvb/frontends/af9013.c | 1756 ++++++++++++++---------------
> drivers/media/dvb/frontends/af9013.h | 113 +-
> drivers/media/dvb/frontends/af9013_priv.h | 93 +-
> 4 files changed, 1017 insertions(+), 1027 deletions(-)
>

There was a minor context change here:

@@ -1156,7 +1158,7 @@ static int af9015_af9013_sleep(struct dvb_frontend *fe)
  	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
  		return -EAGAIN;
  
-	ret = priv->init[adap->id](fe);
+	ret = priv->sleep[adap->id](fe);

Basically, the current code doesn't have that mutex_lock_interruptible logic. It
may be into the fixes we'll send for 3.2.

However, after this patch, compilation broke:

drivers/media/dvb/dvb-usb/af9015.c: In function ‘af9015_rc_query’:
drivers/media/dvb/dvb-usb/af9015.c:1089:12: error: ‘struct af9015_state’ has no member named ‘sleep’
drivers/media/dvb/dvb-usb/af9015.c:1089:20: error: ‘adap’ undeclared (first use in this function)
drivers/media/dvb/dvb-usb/af9015.c:1089:20: note: each undeclared identifier is reported only once for each function it appears in
drivers/media/dvb/dvb-usb/af9015.c:1089:30: error: ‘fe’ undeclared (first use in this function)

Regards,
Mauro
