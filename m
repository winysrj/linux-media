Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.18]:42844 "HELO
	nm2-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751705Ab1IYT2H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 15:28:07 -0400
Message-ID: <1316978885.75743.YahooMailClassic@web121708.mail.ne1.yahoo.com>
Date: Sun, 25 Sep 2011 12:28:05 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [PATCH v3] EM28xx - fix deadlock when unplugging and replugging a DVB adapter
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4E7F2358.7090906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Sun, 25/9/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Ok, I've applied it, but it doesn't sound a good idea to me
> to do:
> 
> +    mutex_unlock(&dev->lock);
>      em28xx_init_extension(dev);
> +    mutex_lock(&dev->lock);
> 

Yes, I suppose it's the logical equivalent of moving the em28xx_init_extension(dev) call from em28xx_init_dev(), and placing it immediately after the final mutex_unlock(&dev->lock) call in em28xx_usb_probe() instead. Which would be cleaner, quite frankly.

Which stage of the v4l2 initialisation triggers the race with udev? v4l2_device_register()? 

Cheers,
Chris

