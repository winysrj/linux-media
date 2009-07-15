Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:33920 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbZGOUhD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 16:37:03 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id CB7212DCCF
	for <linux-media@vger.kernel.org>; Wed, 15 Jul 2009 22:36:57 +0200 (CEST)
Message-ID: <4A5E3D9C.8020604@zerezo.com>
Date: Wed, 15 Jul 2009 22:35:40 +0200
From: Antoine Jacquet <royale@zerezo.com>
MIME-Version: 1.0
To: Lamarque Vieira Souza <lamarque@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH] Implement V4L2_CAP_STREAMING for zr364xx driver
References: <200903252025.11544.lamarque@gmail.com> <200903280711.37892.lamarque@gmail.com> <200907022309.47562.lamarque@gmail.com> <200907111729.51836.lamarque@gmail.com>
In-Reply-To: <200907111729.51836.lamarque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry for the very late answer, I did not have time to work on my driver 
during the past months.
I managed to apply your patch to my current hg tree, but since it is 5 
months out of sync with the main tree, I am having issues to merge your 
work.
Could you send a patch against the current main tree ( 
http://linuxtv.org/hg/v4l-dvb/ ) so I can test your patch?

Thanks a lot and sorry again.

Regards,

Antoine


Lamarque Vieira Souza wrote:
> 	Hi guys. Any news about this patch? I really think is important to make 
> zr364xx driver works with libv4l, mplayer, kopete and skype. Maintaining this 
> patch out of tree is also troublesome for me, I would really appreciate if you 
> could add it to the tree. If there is any problem with the patch let me know 
> that will fix it.
> 
> Em Thursday 02 July 2009, Lamarque Vieira Souza escreveu:
>> 	Hi all,
>>
>> 	I have noticed the patch mentioned in the subject was not included in
>> 2.6.30. Do you plan to add it to 2.6.31?
>>
>> Em Saturday 28 March 2009, Lamarque Vieira Souza escreveu:
>>> This patch implements V4L2_CAP_STREAMING for the zr364xx driver, by
>>> converting the driver to use videobuf.
>>>
>>> Tested with Creative PC-CAM 880.
>>>
>>> It basically:
>>> . implements V4L2_CAP_STREAMING using videobuf;
>>>
>>> . re-implements V4L2_CAP_READWRITE using videobuf;
>>>
>>> . copies cam->udev->product to the card field of the v4l2_capability
>>> struct. That gives more information to the users about the webcam;
>>>
>>> . moves the brightness setting code from before requesting a frame (in
>>> read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is
>>> executed only when the application requests a change in brightness and
>>> not before every frame read;
>>>
>>> . comments part of zr364xx_vidioc_try_fmt_vid_cap that says that Skype +
>>> libv4l do not work.
>>>
>>> This patch fixes zr364xx for applications such as mplayer,
>>> Kopete+libv4l and Skype+libv4l can make use of the webcam that comes
>>> with zr364xx chip.
>>>
>>> Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
>>> ---
>>>
>>> --- v4l-dvb/linux/drivers/media/video/zr364xx.c	2009-03-27
>>> 15:18:54.050413997 -0300
>>> +++ v4l-dvb/linux-lvs/drivers/media/video/zr364xx.c	2009-03-27
>>> 15:22:47.914414277 -0300
>> ... stripped off to not bloat the e-mail.
> 
> 


-- 
Antoine "Royale" Jacquet
http://royale.zerezo.com
