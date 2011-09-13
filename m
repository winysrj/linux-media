Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54974 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab1IMUEK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 16:04:10 -0400
Message-ID: <4E6FB736.4080202@iki.fi>
Date: Tue, 13 Sep 2011 23:04:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <1313851233.95109.YahooMailClassic@web121704.mail.ne1.yahoo.com> <4E4FCC8D.3070305@redhat.com> <4E50FAC7.6080807@yahoo.com>
In-Reply-To: <4E50FAC7.6080807@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2011 03:32 PM, Chris Rankin wrote:
> It occurred to me this morning that since we're no longer supposed to be
> holding the device lock when taking the device list lock, then the
> em28xx_usb_disconnect() function needs changing too.
>
> Signed-off-by: Chris Rankin <rankincj@yahoo.com>

I ran that also when re-plugging both PCTV 290e and 460e as today 
LinuxTV 3.2 tree. Seems like this patch is still missing and maybe some 
more.

git log drivers/media/video/em28xx/ |grep -A3 "Author: Chris Rankin"
Author: Chris Rankin <rankincj@yahoo.com>
Date:   Tue Sep 13 12:23:39 2011 +0300

     em28xx: ERROR: "em28xx_add_into_devlist" 
[drivers/media/video/em28xx/em28xx.ko] undefined!
--
Author: Chris Rankin <rankincj@yahoo.com>
Date:   Sat Aug 20 16:01:26 2011 -0300

     [media] em28xx: don't sleep on disconnect
--
Author: Chris Rankin <rankincj@yahoo.com>
Date:   Sat Aug 20 08:31:05 2011 -0300

     [media] em28xx: move printk lines outside mutex lock
--
Author: Chris Rankin <rankincj@yahoo.com>
Date:   Sat Aug 20 08:28:17 2011 -0300

     [media] em28xx: clean up resources should init fail
--
Author: Chris Rankin <rankincj@yahoo.com>
Date:   Sat Aug 20 08:21:03 2011 -0300

     [media] em28xx: use atomic bit operations for devices-in-use mask
--
Author: Chris Rankin <rankincj@yahoo.com>
Date:   Sat Aug 20 08:08:34 2011 -0300

     [media] em28xx: pass correct buffer size to snprintf


regards
Antti
-- 
http://palosaari.fi/
