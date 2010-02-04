Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f189.google.com ([209.85.210.189]:33134 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab0BDJGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 04:06:22 -0500
Received: by yxe27 with SMTP id 27so1988982yxe.4
        for <linux-media@vger.kernel.org>; Thu, 04 Feb 2010 01:06:22 -0800 (PST)
Message-ID: <4B6A8E02.3090905@gmail.com>
Date: Thu, 04 Feb 2010 17:06:10 +0800
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de
Subject: Re: [PATCH v2 00/10] add linux driver for chip TLG2300
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com> <4B6817E6.4070709@redhat.com> <4B69159D.2040606@gmail.com> <4B6925EB.7000601@redhat.com> <4B693681.2030402@gmail.com> <4B693AD6.3030005@redhat.com>
In-Reply-To: <4B693AD6.3030005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> No, I don't meant that.
>
> The differences of FM radio standards are basically the preemphasis and the
> frequency ranges.
>
> For frequency ranges, V4L2_TUNER_RADIO allows specifying the maximum/minimum values.
>
> For preemphasis, you should implement V4L2_CID_TUNE_PREEMPHASIS ctrl. This
> CTRL has 3 states:
>
>          static const char *tune_preemphasis[] = {
>                  "No preemphasis",
>                  "50 useconds",
>                  "75 useconds",
>                  NULL,
>          };
>
> At v4l2-common.c, there are some functions that helps to implement it
> at the driver, like:
> 	v4l2_ctrl_get_menu, v4l2_ctrl_get_name and v4l2_ctrl_query_fill.
>    
I meet a problem now. :(

Even I add the ctrl to the tlg2300 driver, there is no application to
test it :

[1] The Mplayer do not check the ctrl except the "vulume " or "mute".
[2] I do  not know how to use the VLC to listen the radio with ALSA, I
tried many times, but failed. Does someone know this ?

Btw: I will be on my vacation for the following two weeks, I will come 
back to
work at 20th of this month. I afraid I can not finish the patches to 
remove  the
country code in the two days(today and tomorrow).


> Take a look at si4713-i2c.c for an example on how to use it.
>
> Ah, please submit those changes as another series of patches. This helps me
> to not needing to review the entire changeset again.
>
> Cheers,
> Mauro
>
>    
Best Regards
Huang Shijie

