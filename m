Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33316 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbLRRhw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 12:37:52 -0500
MIME-Version: 1.0
In-Reply-To: <3030478.j1ZKoooRrc@avalon>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1450341626-6695-27-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<5673EB82.2060903@xs4all.nl>
	<3030478.j1ZKoooRrc@avalon>
Date: Fri, 18 Dec 2015 18:37:51 +0100
Message-ID: <CAMuHMdU5ZRZyNwkKissXckvAWaD4osDYhCM7STw3L0wL_xgQnQ@mail.gmail.com>
Subject: Re: [PATCH/RFC 26/48] videodev2.h: Add request field to v4l2_pix_format_mplane
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Dec 18, 2015 at 6:16 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> > @@ -1987,7 +1988,8 @@ struct v4l2_pix_format_mplane {
>> >
>> >     __u8                            ycbcr_enc;
>> >     __u8                            quantization;
>> >     __u8                            xfer_func;
>> >
>> > -   __u8                            reserved[7];
>> > +   __u8                            reserved[3];
>> > +   __u32                           request;
>>
>> I think I mentioned this before: I feel uncomfortable using 4 bytes of the
>> reserved fields when the request ID is limited to 16 bits anyway.
>
> I'm still unsure whether request IDs should be 16 or 32 bits long. If we go
> for 16 bits then I'll of course make this field a __u16.
>
>> I would prefer a __u16 here. Also put the request field *before* the
>> reserved array, not after.
>
> The reserved array isn't aligned to a 32 bit (or even 16 bit) boundary. I can
> put the request field before it, with a 8 bit hole before the field.

There's no alignment at all due to:

>> >  } __attribute__ ((packed));

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
