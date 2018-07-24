Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37030 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388256AbeGXNlf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 09:41:35 -0400
Received: by mail-it0-f43.google.com with SMTP id h20-v6so2254017itf.2
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2018 05:35:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1762892.v9kic1zYKq@avalon>
References: <8804dcb3-1aca-3679-6a96-bbe554f188d0@redhat.com>
 <2208320.5nHJhHVTzE@avalon> <1a5ac0f3-9acd-1b8f-7354-b2147aa5636f@redhat.com> <1762892.v9kic1zYKq@avalon>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Tue, 24 Jul 2018 14:35:17 +0200
Message-ID: <CABxcv=kTDtmFy=FDmJGLvu6NZk9iHuQBGZR7T9tvSs03Q8dYcA@mail.gmail.com>
Subject: Re: Devices with a front and back webcam represented as a single UVC device
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Carlos Garnacho <carlosg@gnome.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Jul 12, 2018 at 3:01 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

[snip]

>>
>> Laurent, thank you for your input on this. I thought it was a bit weird that
>> the cam on my HP X2 only had what appears to be the debug controls, so I
>> opened it up and as I suspect (after your analysis) it is using a USB
>> module for the front camera, but the back camera is a sensor directly
>> hooked with its CSI/MIPI bus to the PCB, so very likely it is using the
>> ATOMISP stuff.
>>
>> So I think that we can consider this "solved" for my 2-in-1.
>
> Great, I'll add you to the list of potential testers for an ATOMISP solution
> :-)
>

The ATOMISP driver was removed from staging by commit 51b8dc5163d
("media: staging: atomisp: Remove driver"). Do you mean that there's a
plan to bring that driver back?

Best regards,
Javier
