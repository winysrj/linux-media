Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:47809 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab0BNWVn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 17:21:43 -0500
Message-ID: <4B78776D.5050007@zerezo.com>
Date: Sun, 14 Feb 2010 23:21:33 +0100
From: Antoine Jacquet <royale@zerezo.com>
MIME-Version: 1.0
To: thomas.schorpp@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: zr364xx: Aiptek DV8800 (neo): 08ca:2062: Fails on subsequent
 zr364xx_open()
References: <4B73C792.3060907@gmail.com> <4B741C47.1090905@zerezo.com> <4B7567CB.20609@gmail.com>
In-Reply-To: <4B7567CB.20609@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>> Someone reported similar behavior recently, and was apparently able to 
>> fix the issue by adding more delay between open/close sequences.
> 
> No search tags to find it on the list, can You remember device model?

Yes, this was an off-list discussion, available here:
	http://royale.zerezo.com/forum/viewtopic.php?t=355

> Didn't work, same -110 errors, sorry, no v4l-dvb git here, vdr 
> production machine on 2.6.32.7.

Just checked and the differences in the zr364xx driver are minor.
Would be better if you could work on LinuxTV hg/git tree so we have the 
same basis for patches.

> 1. Patch with optimized delay below, slow but works, 1st try was 
> delaying subsequent msg at open sequence i=6, worked until the last 2 
> open() before capture start.
>> From the windows snoopy log I sent yesterday I can see only 1-2 URBs 
>> with relevant delay of ~1s but 
> cannot see the sequence point.

Ok this is a bit hardcore but nice if it works.
What do you mean by "until the last 2 open()"?
Also, you may want to try with simpler tools like "dd" to do only one 
clean open/close.
Ekiga/Cheese/Skype tend to do many open/close and this may not be the 
ideal tools for debugging, but great to trigger the bugs ;-)

> What is error -22, can not find it in errno.h?

I think it's -EINVAL.

> 2. Picture with (640->320) lines alignment error with ekiga+cheese 
> *attached*, wether cam is configured internally for 640x480 or 320x240, 
> not affecting.
> setting the driver to mode=2 fails with libv4l jpeg decoding errors. I 
> try to correct this.

Do you know if the Windows driver support this mode?
If so, it would be helpful to have the snoop too.

> 3. Driver oops on modprobe -r or device firmware crash, I need to unplug 
> first or null pointer fault occours (mutex locks), see below

Ok that's bad, let me know if you find the issue.

Regards,

Antoine


-- 
Antoine "Royale" Jacquet
http://royale.zerezo.com
