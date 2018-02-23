Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33739 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933596AbeBWTkQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 14:40:16 -0500
Received: by mail-qk0-f182.google.com with SMTP id f25so12142455qkm.0
        for <linux-media@vger.kernel.org>; Fri, 23 Feb 2018 11:40:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwYLHuhTqt0KiXE2A_2oJPgf8ACRqmwGXOrA2mMpRCbjQ@mail.gmail.com>
References: <CAGUPqz7AX0t6M0U6ZKNtqjyW3_5Aj7PsOHVTERTGX1tApVCWbQ@mail.gmail.com>
 <CAGoCfiwYLHuhTqt0KiXE2A_2oJPgf8ACRqmwGXOrA2mMpRCbjQ@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Fri, 23 Feb 2018 14:40:15 -0500
Message-ID: <CAGoCfiwdM3kgBmiz5C7iC-m-S6eU_X29e=pbRNmj+PtZMhrMkA@mail.gmail.com>
Subject: Re: pinnacle 300i driver crashed after first device access
To: Federico Allegretti <allegfede@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 23, 2018 at 2:37 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Fri, Feb 23, 2018 at 2:30 PM, Federico Allegretti
> <allegfede@gmail.com> wrote:
>> i noticed that my pinnacle 300i could accept full resolution settings:
>> v4l2-ctl --set-fmt-video=width=720,height=576
>>
>> only the first time the command is fired.
>>
>> after that, evey time i try to set that resolution with the same
>> command, i get instead only the half vertical resolution:
>> v4l2-ctl --get-fmt-video
>> Format Video Capture:
>>     Width/Height      : 720/288
>>     Pixel Format      : 'YU12'
>>     Field             : Bottom
>>     Bytes per Line    : 720
>>     Size Image        : 311040
>>     Colorspace        : SMPTE 170M
>>     Transfer Function : Default
>>     YCbCr/HSV Encoding: Default
>>     Quantization      : Default
>>     Flags             :

Also, looks like the field format is set to bottom, which would
explain why you're only getting half the lines.  You probably need to
set the field type to interlaced in your --set-fmt-video arguments
(although I don't have the exact syntax right in front of me).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
