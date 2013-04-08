Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41173 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3DHHmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 03:42:37 -0400
Received: by mail-ie0-f179.google.com with SMTP id k11so6492093iea.38
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 00:42:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFW1BFxJ-fe8N-=LSKUfRP=-R+XUY_it3miEUKKJ6twkZa1wZA@mail.gmail.com>
References: <CAFW1BFxJ-fe8N-=LSKUfRP=-R+XUY_it3miEUKKJ6twkZa1wZA@mail.gmail.com>
Date: Mon, 8 Apr 2013 09:42:36 +0200
Message-ID: <CA+MoWDpAFOgEN-ruyzVp=C-Dz_16CnOSXU30UowARB3m-eTVMQ@mail.gmail.com>
Subject: Re: vivi kernel driver
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Michal Lazo <michal.lazo@mdragon.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Michal,

The CPU intensive part of the vivi driver is the image generation.
This is not an issue for real drivers.

Regards,

Peter

On Sun, Apr 7, 2013 at 9:32 PM, Michal Lazo <michal.lazo@mdragon.org> wrote:
> Hi
> V4L2 driver vivi
> generate 25% cpu load on raspberry pi(linux 3.6.11) or 8% on x86(linux 3.2.0-39)
>
> player
> GST_DEBUG="*:3,v4l2src:3,v4l2:3" gst-launch-0.10 v4l2src
> device="/dev/video0" norm=255 ! video/x-raw-rgb, width=720,
> height=576, framerate=30000/1001 ! fakesink sync=false
>
> Anybody can answer me why?
> And how can I do it better ?
>
> I use vivi as base example for my driver
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Peter
