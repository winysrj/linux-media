Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10890 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239Ab2AGBzI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 20:55:08 -0500
Message-ID: <0a833d4c5de7f07094de25c5769121e3.squirrel@www.codeaurora.org>
In-Reply-To: <201201061144.49354.hverkuil@xs4all.nl>
References: <4e9191cad2837e2710d3ccb8be4aa735.squirrel@www.codeaurora.org>
    <201201061144.49354.hverkuil@xs4all.nl>
Date: Fri, 6 Jan 2012 17:55:08 -0800 (PST)
Subject: Re: Pause/Resume and flush for V4L2 codec drivers.
From: vkalia@codeaurora.org
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: vkalia@codeaurora.org, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Hans.

Yes it does solve a part of my problem - Pause/Resume. But I dont see any
command defined for Flush yet. Do you think we should add one more command
to Flush. Also, I see two more commands

#define V4L2_DEC_CMD_START       (0)
#define V4L2_DEC_CMD_STOP        (1)

How should I use the above two commands for an encoding/decoding session?
I was calling start/stop to hardware in streamon/streamoff earlier.

Thanks
Vinay

> On Friday, January 06, 2012 03:31:37 vkalia@codeaurora.org wrote:
>> Hi
>>
>> I am trying to implement v4l2 driver for video decoders. The problem I
>> am
>> facing is how to send pause/resume and flush commands from user-space to
>> v4l2 driver. I am thinking of using controls for this. Has anyone done
>> this before or if anyone has any ideas please let me know. Appreciate
>> your
>> help.
>
> See this patch series:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg40516.html
>
> Does this give you what you need?
>
> Regards,
>
> 	Hans
>
>>
>> Thanks
>> Vinay
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


