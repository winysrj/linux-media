Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1IXPPV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 11:15:21 -0400
Message-ID: <4E7DF406.90101@redhat.com>
Date: Sat, 24 Sep 2011 12:15:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] EM28xx patches for 3.2
References: <4E7DEF16.6070209@yahoo.com>
In-Reply-To: <4E7DEF16.6070209@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-09-2011 11:54, Chris Rankin escreveu:
> Mauro,
> 
> I am resending the two patches for the em28xx driver which seem to have been missed for 3.2. The first one simply removes a stray bit
> operation on em28xx_devused, whereas the second tidies up the device/extension list handling.

This one were already applied. Just applied the second one.
> 
> It is possible that the first patch has been applied already. However, I cannot be sure because I cannot find a URL anywhere that will show me the current "HEAD" of the "pending for 3.2" tree.

http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.2

> BTW, did you implement a different solution for the DVB module trying to retake the dev->lock mutex? Because it looks as if both em28xx_dvb_init() and em28xx_usb_probe() are still calling mutex_lock().

No, I didn't find any time to look into it. Too much work here...

Regards,
Mauro

> 
> Cheers,
> Chris

