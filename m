Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:59933 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986Ab2EBTXP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 15:23:15 -0400
Message-ID: <25369268.1335986594418.JavaMail.root@mswamui-thinleaf.atl.sa.earthlink.net>
Date: Wed, 2 May 2012 15:23:14 -0400 (GMT-04:00)
From: sitten74490@mypacks.net
To: sitten74490@mypacks.net,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: HVR-1800 Analog Driver: MPEG video broken
Cc: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just tried again with a live CD running kernel 3.2 and got clean video with cat /dev/video1 > /tmp/foo.mpg.  So there is a definitely a regression here.  Please let me know what I can do to help track it down.

Regards,

Jonathan
-----Original Message-----
>From: sitten74490@mypacks.net
>Sent: May 2, 2012 11:53 AM
>To: Devin Heitmueller <dheitmueller@kernellabs.com>
>Cc: linux-media@vger.kernel.org
>Subject: Re: HVR-1800 Analog Driver: MPEG video broken
>
>In case it might be helpful, here's the output of v4l2-ctl -d /dev/video1 --log-status:
>
>http://pastebin.com/4iTcXDNP
>
>Thanks,
>
>Jonathan
>-----Original Message-----
>>From: Devin Heitmueller <dheitmueller@kernellabs.com>
>>Sent: May 2, 2012 9:58 AM
>>To: sitten74490@mypacks.net
>>Cc: linux-media@vger.kernel.org
>>Subject: Re: HVR-1800 Analog Driver: MPEG video broken
>>
>>On Wed, May 2, 2012 at 9:32 AM,  <sitten74490@mypacks.net> wrote:
>>> I have been testing the latest cx23885 driver built from http://git.kernellabs.com/?p=stoth/cx23885-hvr1850-fixups.git;a=summary running on kernel 3.3.4 with my HVR-1800 (model 78521).  I am able to watch analog TV with tvtime using the raw device, /dev/video0.  But if I try to use it with the MPEG device, /dev/video1, I briefly get a blue screen and then tvtime segfaults.
>>
>>Tvtime segfaulting if you try to use it on an MPEG device is a known
>>tvtime bug.  Tvtime lacks an MPEG decoder, and only works with devices
>>that support raw video.
>>
>>cat /dev/video1 > /tmp/foo.mpg gives video with moving, distorted,
>>mostly black and white diagonal lines just like @Britney posted here:
>>http://www.kernellabs.com/blog/?p=1636.
>>
>>Yup, I've been going back and forth with bfransen on this.  I received
>>a board last week, and am hoping to debug it this week.
>>
>>Regards,
>>
>>Devin
>>
>>-- 
>>Devin J. Heitmueller - Kernel Labs
>>http://www.kernellabs.com
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

