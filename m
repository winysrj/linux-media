Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:46644 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbdIRM5J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 08:57:09 -0400
Received: by mail-qk0-f180.google.com with SMTP id z143so394828qkb.3
        for <linux-media@vger.kernel.org>; Mon, 18 Sep 2017 05:57:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59BEEC39.2030609@googlemail.com>
References: <59BEEC39.2030609@googlemail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Mon, 18 Sep 2017 08:57:08 -0400
Message-ID: <CAGoCfizQS3fg2Sqjtg2ypiCqa5cMQ=irMZ1nwEVJ8+TeBuAZCA@mail.gmail.com>
Subject: Re: [PATCH] Support HVR-1200 analog video as a clone of HVR-1500.
 Tested, composite and s-video inputs.
To: Nigel Kettlewell <nigel.kettlewell@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 17, 2017 at 5:42 PM, Nigel Kettlewell
<nigel.kettlewell@googlemail.com> wrote:
> I propose the following patch to support Hauppauge HVR-1200 analog video,
> nothing more than a clone of HVR-1500. Patch based on Linux 4.9 commit
> 69973b830859bc6529a7a0468ba0d80ee5117826
>
> I have tested composite and S-Video inputs.
>
> With the change, HVR-1200 devices have a /dev/video<n> entry which is
> accessible in the normal way.
>
> Let me know if you need anything more.

I'm not confident the tuner config for this board is correct.  The
HVR-1200 is much closer to the HVR-1250 as opposed to the HVR-1500,
and IIRC it didn't have an xc3028.

I don't dispute that with the patch in question the composite/s-video
are probably working ok, but I wouldn't recommend accepting this patch
as-is until the tuner is verified for DVB-T and analog (ideally both).

Can you provide the output of dmesg on device load?  If it's filled
with a bunch of errors showing xc3028 firmware load failures, that
would be a smoking gun that it doesn't have the xc3028.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
