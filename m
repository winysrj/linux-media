Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIMWL_WL_MED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95131C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 16:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 587842083D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 16:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="179+LLar"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 587842083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbeLGQMe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 11:12:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42804 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbeLGQMd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 11:12:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id q18so4298347wrx.9
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 08:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1JOYu76vd56GqKPQtwn4aosZUJauRxXsxAXbhD/kKVQ=;
        b=179+LLarUXxW+fC8xr4TwZV81GaEIw91vR2GTo+d9mwXrxP1jyHVBhOaKyQFLAM466
         YJwZKmLqa0WZcTvH2toGNbO6pEZMsjKLqCm/7vMlArxyRyjSfw7Pm9sOrM8wWIQb16ql
         8a1Kwnt/VCdVIbnvDJsHGDr+xg6EAmU983df5KLcT+JAUno6ClBLavMS2lODap2fHJVT
         RHPFkjtKNZeo/StIp9PbzvzXIUYM5Jazq4E4MCieNB5xcN+itxZoDTCAPzs5BN7GAQxG
         4Q4KB2QkTBodnZBWxz/k/8r4vmZY0C0HNc7BkmAxVU1r9tYQZribjiyavEcJyTPog+uK
         EyFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1JOYu76vd56GqKPQtwn4aosZUJauRxXsxAXbhD/kKVQ=;
        b=drzcU2HrFMVEBto7xIxdTLRy/lvAm/Y09kSD0CLbYmexHSZmtcQ7c/hwDc5tC/kFs9
         N8zqUX+asXgvoyIaomGh3qfKIFzxxr4fFCIzCIBhhF46Da98OJ1cjwNEYhxiZrPp872G
         OZIMgxikvTnxxKlrauOTrepILhMiwQRtra7CYdWY2YMxbEZ7Due4HWbvAroQraeIjF2Z
         px1/PDk0hG7a+ARfugS+bjnBTdleVncc+DLyQoR4vyktVD7htF+0FGIyb90E4Xaq47as
         /jPHjaNdfth/wfQrVJP+Txq3BLlHwurJT4ud3mwQ1wKXtx56+bLxOuVZWlpD42THZV/9
         8iRg==
X-Gm-Message-State: AA+aEWbdt90asdU9QikOyfqjUVxOLFBOO5BeRCuy5uMTqwqH9/CY/AIs
        EIOXOHMJwlAYjjBzOsrXs5kXK5wBXdDgLQL6GJPz/A==
X-Google-Smtp-Source: AFSGD/XaLYXnHJQy80BdENwiM/ProBzyKUYTeQ4P6w0eexQXAwmJAjV+Ugahzx1srxdrBWFU2i9V9mC57m+SdPuuYzk=
X-Received: by 2002:adf:a58a:: with SMTP id g10mr2306288wrc.3.1544199151934;
 Fri, 07 Dec 2018 08:12:31 -0800 (PST)
MIME-Version: 1.0
References: <20181004133739.19086-1-mjourdan@baylibre.com> <491c3f33-b51b-89cb-09f0-b48949d61efb@xs4all.nl>
 <CAAFQd5DqY7zRR9SePWDCL0erB4x0pkBP7x2enuVvdjmyX+ASBw@mail.gmail.com> <b8904bae-ff56-bec5-89dd-aa4139b93324@xs4all.nl>
In-Reply-To: <b8904bae-ff56-bec5-89dd-aa4139b93324@xs4all.nl>
From:   Maxime Jourdan <mjourdan@baylibre.com>
Date:   Fri, 7 Dec 2018 17:12:20 +0100
Message-ID: <CAMO6nawKYdBH8gCN9ZETRRT4-6=xYjLY-3xGctoTxfp+USkfjQ@mail.gmail.com>
Subject: Re: [PATCH] media: videodev2: add V4L2_FMT_FLAG_NO_SOURCE_CHANGE
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans, Tomasz,

Sorry I missed your messages last week..!
On Fri, Nov 30, 2018 at 8:35 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 11/29/2018 08:35 PM, Tomasz Figa wrote:
> > On Thu, Nov 29, 2018 at 1:01 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> On 10/04/2018 03:37 PM, Maxime Jourdan wrote:
> >>> When a v4l2 driver exposes V4L2_EVENT_SOURCE_CHANGE, some (usually
> >>> OUTPUT) formats may not be able to trigger this event.
> >>>
> >>> Add a enum_fmt format flag to tag those specific formats.
> >>
> >> I think I missed (or forgot) some discussion about this since I have no
> >> idea why this flag is needed. What's the use-case?
> >
> > As far as I remember, the hardware/firmware Maxime has been working
> > with can't handle resolution changes for some coded formats. Perhaps
> > we should explain that better in the commit message and documentation
> > of the flag, though. Maxime, could you refresh my memory with the
> > details?
>
> So basically it describes if a compressed format can handle resolution
> changes for the given hardware?
>

Yes, exactly

> If that's the case, then NO_SOURCE_CHANGE is not a good name as it
> describes the symptom, not the real reason.
>
> Perhaps _FIXED_RESOLUTION might be a better name.
>

Fair point, I will update it as such.

Next time, this patch will come in a series that uses the flag.

Cheers,
Maxime

> Regards,
>
>         Hans
>
> >
> > Best regards,
> > Tomasz
> >
> >>
> >> Regards,
> >>
> >>         Hans
> >>
> >>>
> >>> Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
> >>> ---
> >>>  Documentation/media/uapi/v4l/vidioc-enum-fmt.rst | 5 +++++
> >>>  include/uapi/linux/videodev2.h                   | 5 +++--
> >>>  2 files changed, 8 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> >>> index 019c513df217..e0040b36ac43 100644
> >>> --- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> >>> +++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> >>> @@ -116,6 +116,11 @@ one until ``EINVAL`` is returned.
> >>>        - This format is not native to the device but emulated through
> >>>       software (usually libv4l2), where possible try to use a native
> >>>       format instead for better performance.
> >>> +    * - ``V4L2_FMT_FLAG_NO_SOURCE_CHANGE``
> >>> +      - 0x0004
> >>> +      - The event ``V4L2_EVENT_SOURCE_CHANGE`` is not supported
> >>> +     for this format.
> >>> +
> >>>
> >>>
> >>>  Return Value
> >>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> >>> index 3a65951ca51e..a28acee1cb52 100644
> >>> --- a/include/uapi/linux/videodev2.h
> >>> +++ b/include/uapi/linux/videodev2.h
> >>> @@ -723,8 +723,9 @@ struct v4l2_fmtdesc {
> >>>       __u32               reserved[4];
> >>>  };
> >>>
> >>> -#define V4L2_FMT_FLAG_COMPRESSED 0x0001
> >>> -#define V4L2_FMT_FLAG_EMULATED   0x0002
> >>> +#define V4L2_FMT_FLAG_COMPRESSED     0x0001
> >>> +#define V4L2_FMT_FLAG_EMULATED               0x0002
> >>> +#define V4L2_FMT_FLAG_NO_SOURCE_CHANGE       0x0004
> >>>
> >>>       /* Frame Size and frame rate enumeration */
> >>>  /*
> >>>
> >>
>
