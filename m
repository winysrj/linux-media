Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33399 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJFVpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 17:45:55 -0400
Received: by mail-vc0-f171.google.com with SMTP id hy10so3827906vcb.16
        for <linux-media@vger.kernel.org>; Mon, 06 Oct 2014 14:45:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2999205.OqlimhFfiu@avalon>
References: <1407358249-19605-1-git-send-email-philipp.zabel@gmail.com>
	<CA+gwMccqt9zP4bOdDKyiZa=S+xPuZgcpg4aWcdUCyqwobAnKfQ@mail.gmail.com>
	<2999205.OqlimhFfiu@avalon>
Date: Mon, 6 Oct 2014 23:45:54 +0200
Message-ID: <CA+gwMccBfXtus7mEbGFXidqrNmrttFm24m=x78GRrtgEBC7zjA@mail.gmail.com>
Subject: Re: [PATCH v2] [media] uvcvideo: Add quirk to force the Oculus DK2 IR
 tracker to grayscale
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Oct 6, 2014 at 4:34 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> > @@ -311,6 +311,7 @@ static int uvc_parse_format(struct uvc_device *dev,
>> >         struct uvc_format_desc *fmtdesc;
>> >         struct uvc_frame *frame;
>> >         const unsigned char *start = buffer;
>> > +       bool force_yuy2_to_y8 = false;
>
> To keep things a bit more generic, how about an unsigned int width_multiplier
> initialized to 1 and set to 2 when the quirk applies ?
[...]
>> > @@ -333,6 +334,22 @@ static int uvc_parse_format(struct uvc_device *dev,
>> >
>> >                 /* Find the format descriptor from its GUID. */
>> >                 fmtdesc = uvc_format_by_guid(&buffer[5]);
>> > +               format->bpp = buffer[21];
>> > +
>> > +               if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
>> > +                       if (fmtdesc && fmtdesc->fcc == V4L2_PIX_FMT_YUYV
>> > &&
>> > +                           format->bpp == 16) {
>
> I wonder if that check is really needed, all YUYV formats should have 16bpp.
>
>> > +                               force_yuy2_to_y8 = true;
>> > +                               fmtdesc = &uvc_fmts[9];
>
> The hardcoded index here is hair-raising :-) How about something like the
> following instead ?
>
>                 }
>
>                 format->bpp = buffer[21];
> +
> +               /* Some devices report a format that doesn't match what they
> +                * really send.
> +                */
> +               if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
> +                       if (format->fcc == V4L2_PIX_FMT_YUYV) {
> +                               strlcpy(format->name, "Greyscale 8-bit (Y8  )",
> +                                       sizeof(format->name));
> +                               format->fcc = V4L2_PIX_FMT_GREY;
> +                               format->bpp = 8;
> +                               width_multiplier = 2;
> +                       }
> +               }
> +
>                 if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
>                         ftype = UVC_VS_FRAME_UNCOMPRESSED;
>                 } else {
>
> I know it duplicates the format string, but as we're trying to move them to
> the V4L2 core anyway, I don't see that as being a big problem.
[...]
>> > @@ -455,6 +471,8 @@ static int uvc_parse_format(struct uvc_device *dev,
>> >                 frame->bFrameIndex = buffer[3];
>> >                 frame->bmCapabilities = buffer[4];
>> >                 frame->wWidth = get_unaligned_le16(&buffer[5]);
>> > +               if (force_yuy2_to_y8)
>> > +                       frame->wWidth *= 2;
>
> This would become
>
> +               frame->wWidth = get_unaligned_le16(&buffer[5])
> +                             * width_multiplier;
>
> If you're fine with that there's no need to resubmit, I'll modify the patch
> when applying it to my tree.

Thank you, I'm fine with your suggested changes.
Especially the format setting part looks a lot more civilized now.

regards
Philipp
