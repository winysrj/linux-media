Return-path: <linux-media-owner@vger.kernel.org>
Received: from ptmx.org ([178.63.28.110]:40227 "EHLO ptmx.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752616AbdKGWmR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Nov 2017 17:42:17 -0500
Received: from [172.16.1.14] (62-178-118-86.cable.dynamic.surfer.at [62.178.118.86])
        by ptmx.org (Postfix) with ESMTPSA id 3B74355B46
        for <linux-media@vger.kernel.org>; Tue,  7 Nov 2017 23:35:44 +0100 (CET)
Subject: Re: HDMI field order
To: linux-media <linux-media@vger.kernel.org>
References: <CAJ+vNU3=GCFUgo0DYufyeisHYFuRwsY1qUeuQ29Y9J+mdjR57g@mail.gmail.com>
From: Carlos Rafael Giani <dv@pseudoterminal.org>
Message-ID: <d865b201-c4d8-5907-832a-5b098891c994@pseudoterminal.org>
Date: Tue, 7 Nov 2017 23:35:43 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU3=GCFUgo0DYufyeisHYFuRwsY1qUeuQ29Y9J+mdjR57g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was discussing this with Tim earlier, and there was a little 
confusion. He meant V4L2_FIELD_SEQ_TB/BT, not V4L2_FIELD_INTERLACED.

When I tried out 1080i50 with HDMI in and the i.MX6, I got something 
that looks like V4L2_FIELD_SEQ_TB. The question though is: are the field 
rows always arranged like this with interlaced HDMI? Or does this depend 
on the source? Could it for example be possible that 2 HDMI cameras 
deliver both interlaced video, but the first one delivers 
V4L2_FIELD_INTERLACED, and the second delivers V4L2_FIELD_SEQ_TB? Could 
this happen?


On 2017-11-07 19:40, Tim Harvey wrote:
> Greetings,
>
> I'm trying to understand the various field orders supported by v4l2
> [1]. Do HDMI sources always use V4L2_FIELD_INTERLACED or can they
> support alternate modes as well?
>
> Regards,
>
> Tim
>
> [1] - https://www.linuxtv.org/downloads/legacy/video4linux/API/V4L2_API/spec/ch03s06.html
