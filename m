Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:57435 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbZGUOaG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 10:30:06 -0400
Message-ID: <4A65D0E2.4060108@zerezo.com>
Date: Tue, 21 Jul 2009 16:29:54 +0200
From: Antoine Jacquet <royale@zerezo.com>
MIME-Version: 1.0
To: Lamarque Vieira Souza <lamarque@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH] Implement changing resolution on the fly for zr364xx
 driver
References: <200907152054.56581.lamarque@gmail.com> <200907202046.43194.lamarque@gmail.com>
In-Reply-To: <200907202046.43194.lamarque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> This patch implements changing resolution in zr364xx_vidioc_s_fmt_vid_cap for 
> zr364xx driver. This version is synced with v4l-dvb as of 20/Jul/2009. Tested 
> with Creative PC-CAM 880.

Nice, I successfully tested your patch with 2 compatible webcams.
 From the users feedbacks I had before, it seems that some devices do 
not support the 640x480 resolution, but I was not able to verify this 
myself.
This is the only concern I have, since some users may think the driver 
is not working if the application automatically switches to the maximum 
resolution with an incompatible device.

> OBS: I had to increase MAX_FRAME_SIZE to prevent a hard crash in my notebook 
> (caps lock blinking) when testing with mplayer, which automatically sets 
> resolution to the maximum (640x480). Maybe we should add code to auto-detect 
> frame size to prevent this kind of crash in the future.

Yes, I also had this issue before. I don't know what is the good 
approach to determine the best size with JPEG compression.

I will push your changes to my tree and send a pull request to Mauro later.

Regards,

Antoine

-- 
Antoine "Royale" Jacquet
http://royale.zerezo.com
