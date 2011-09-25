Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab1IYMtb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 08:49:31 -0400
Message-ID: <4E7F2358.7090906@redhat.com>
Date: Sun, 25 Sep 2011 09:49:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <4E7E43A2.3020905@yahoo.com>
In-Reply-To: <4E7E43A2.3020905@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-09-2011 17:54, Chris Rankin escreveu:
> This fixes the deadlock that occurs with either multiple PCTV 290e adapters or when a single PCTV 290e adapter is replugged.
> 
> For DVB devices, the device lock must now *not* be held when adding/removing either a device or an extension to the respective lists. (Because em28xx_init_dvb() will want to take the lock instead).
> 
> Conversely, for Audio-Only devices, the device lock *must* be held when adding/removing either a device or an extension to the respective lists.
> 
> Signed-off-by: Chris Rankin <ranki...@yahoo.com>

Ok, I've applied it, but it doesn't sound a good idea to me to do:

+	mutex_unlock(&dev->lock);
 	em28xx_init_extension(dev);
+	mutex_lock(&dev->lock);

I'll later test it with some hardware and see how well this behaves
in practice.

Thanks,
Mauro
