Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:43819 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0BCJPB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 04:15:01 -0500
Received: by ywh36 with SMTP id 36so1064563ywh.15
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 01:15:00 -0800 (PST)
Message-ID: <4B693E8F.707@gmail.com>
Date: Wed, 03 Feb 2010 17:14:55 +0800
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
> Take a look at si4713-i2c.c for an example on how to use it.
>
>    
Thanks you very much for the explanation.
> Ah, please submit those changes as another series of patches. This helps me
> to not needing to review the entire changeset again.
>
>    
Ok.  no problem.
> Cheers,
> Mauro
>
>    
Best Regards
Huang Shijie

