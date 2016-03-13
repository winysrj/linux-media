Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53481 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474AbcCML2u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 07:28:50 -0400
Date: Sun, 13 Mar 2016 08:28:43 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Can you look at this daily build warning?
Message-ID: <20160313082843.50133347@recife.lan>
In-Reply-To: <56E51DEA.7010309@xs4all.nl>
References: <56E51DEA.7010309@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 13 Mar 2016 08:59:38 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Shuah,
> 
> I am getting this warning since commit 840f5b0572ea9ddaca2bf5540a171013e92c97bd
> (media: au0828 disable tuner to demod link in au0828_media_device_register()).
> 
> Can you take a look?
> 
> I'm not sure whether the dtv_demod should just be removed or if some other action
> has to be taken.

The code was removed. I wrote a patch fixing it on Friday and sent to the ML.

I'll be applying it, together with a regression fix, in a few.

Regards,
Mauro
> 
> Regards,
> 
> 	Hans
> 
> linux-git-i686: WARNINGS
> 
> /home/hans/work/build/media-git/drivers/media/v4l2-core/v4l2-mc.c: In function 'v4l2_mc_create_media_graph':
> /home/hans/work/build/media-git/drivers/media/v4l2-core/v4l2-mc.c:37:69: warning: unused variable 'dtv_demod' [-Wunused-variable]
>   struct media_entity *tuner = NULL, *decoder = NULL, *dtv_demod = NULL;
>                                                                      ^
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
