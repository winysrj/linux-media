Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59214 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935723Ab3DHMmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 08:42:33 -0400
Received: by mail-ie0-f172.google.com with SMTP id c10so6881069ieb.3
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 05:42:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+MoWDpAFOgEN-ruyzVp=C-Dz_16CnOSXU30UowARB3m-eTVMQ@mail.gmail.com>
References: <CAFW1BFxJ-fe8N-=LSKUfRP=-R+XUY_it3miEUKKJ6twkZa1wZA@mail.gmail.com>
	<CA+MoWDpAFOgEN-ruyzVp=C-Dz_16CnOSXU30UowARB3m-eTVMQ@mail.gmail.com>
Date: Mon, 8 Apr 2013 14:42:32 +0200
Message-ID: <CAFW1BFwnsgUqCg5DkN5w=z8-Ph+oMQ-PrYyxg_ENTjNmEBpGHg@mail.gmail.com>
Subject: Re: vivi kernel driver
From: Michal Lazo <michal.lazo@mdragon.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
720x576 RGB 25, 30 fps and it take

25% cpu load on raspberry pi(ARM 700Mhz linux 3.6.11) or 8% on x86(AMD
2GHz linux 3.2.0-39)

it is simply too much




On Mon, Apr 8, 2013 at 9:42 AM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> Dear Michal,
>
> The CPU intensive part of the vivi driver is the image generation.
> This is not an issue for real drivers.
>
> Regards,
>
> Peter
>
> On Sun, Apr 7, 2013 at 9:32 PM, Michal Lazo <michal.lazo@mdragon.org> wrote:
>> Hi
>> V4L2 driver vivi
>> generate 25% cpu load on raspberry pi(linux 3.6.11) or 8% on x86(linux 3.2.0-39)
>>
>> player
>> GST_DEBUG="*:3,v4l2src:3,v4l2:3" gst-launch-0.10 v4l2src
>> device="/dev/video0" norm=255 ! video/x-raw-rgb, width=720,
>> height=576, framerate=30000/1001 ! fakesink sync=false
>>
>> Anybody can answer me why?
>> And how can I do it better ?
>>
>> I use vivi as base example for my driver
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Peter



-- 
Best Regards

Michal Lazo
Senior developer manager
mdragon.org
Slovakia
