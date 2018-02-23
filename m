Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:44775 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754222AbeBWThG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 14:37:06 -0500
Received: by mail-qk0-f171.google.com with SMTP id v124so12091098qkh.11
        for <linux-media@vger.kernel.org>; Fri, 23 Feb 2018 11:37:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGUPqz7AX0t6M0U6ZKNtqjyW3_5Aj7PsOHVTERTGX1tApVCWbQ@mail.gmail.com>
References: <CAGUPqz7AX0t6M0U6ZKNtqjyW3_5Aj7PsOHVTERTGX1tApVCWbQ@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Fri, 23 Feb 2018 14:37:05 -0500
Message-ID: <CAGoCfiwYLHuhTqt0KiXE2A_2oJPgf8ACRqmwGXOrA2mMpRCbjQ@mail.gmail.com>
Subject: Re: pinnacle 300i driver crashed after first device access
To: Federico Allegretti <allegfede@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 23, 2018 at 2:30 PM, Federico Allegretti
<allegfede@gmail.com> wrote:
> i noticed that my pinnacle 300i could accept full resolution settings:
> v4l2-ctl --set-fmt-video=width=720,height=576
>
> only the first time the command is fired.
>
> after that, evey time i try to set that resolution with the same
> command, i get instead only the half vertical resolution:
> v4l2-ctl --get-fmt-video
> Format Video Capture:
>     Width/Height      : 720/288
>     Pixel Format      : 'YU12'
>     Field             : Bottom
>     Bytes per Line    : 720
>     Size Image        : 311040
>     Colorspace        : SMPTE 170M
>     Transfer Function : Default
>     YCbCr/HSV Encoding: Default
>     Quantization      : Default
>     Flags             :

Did you set the video standard?  All sorts of bad things could happen
if you set the format to 720x576 but the standard is still set to
NTSC.

To get the standards supported, you can run:

v4l2-ctl --list-standards

And then set the standard with "v4l2-ctl -s".  Do this before setting
the format.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
