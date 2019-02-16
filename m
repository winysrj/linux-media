Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8135EC43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 15:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF642192C
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 15:31:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="ypxfzHtH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbfBPPbC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 10:31:02 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51652 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfBPPbC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 10:31:02 -0500
Received: by mail-wm1-f67.google.com with SMTP id n19so746236wmi.1
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2019 07:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a5GCK7k7lHZf5RObM0SEEMWIGLP3RGgQNsgQw+HDfQ0=;
        b=ypxfzHtHaCkrR1fDJwJhiQqTx0Z12dRrt8JcKYMrJtOCzF5dx99iOiqVejbMi3DyhY
         CR2sw9Y4IwA68/hDk57SZLJmy0/6PuX4VGM7xVtctg+4fs08US5FTws3gyDXLGMZ0yBi
         fM6sNTR+U8XfhsQ/cnyKDD4NiTFZKgjchWHqxodaHcs+lsj9eaUtoKT2SKr9nMYreUTF
         /y5RlDimhUpAmBaLtODYdK64NX5tNdBgPrC8dKF+a3IsY/5b3RxxK6xkm6bfn0FLCxpz
         dJknOrvYR655o0uwEZgLbQYsKDrxagJS7Xdl2H+Kd3GqiAt1T9lKeboIuNxyHeINYe+y
         fF9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a5GCK7k7lHZf5RObM0SEEMWIGLP3RGgQNsgQw+HDfQ0=;
        b=Tw7T3cJvB7SQCupv0mnC/cjHGXsnWKOgvKwJfARcjv5sQFKNxh204MDC6yrLBNWLQn
         fIxv7B3wtQBqI19omQC2vlBjqzHQWfTtCdJfAX+lFhY1XJQl6XJj42+FALly7Slp4f+t
         xWAjDTS6yrgDRjQ0CeNaXzObwN3JTM1cFgMvXyH7HYztdQKLBrSC0ZgwYSdYJXcmWGF9
         /LZMdLVTtPDuomW6VtWULIONxMUUItDTleR3ExIknYxHajpdZHCtgogXvlXHsvEY61Lu
         e+53MQmoExjsMhz8nzqcAYWefZgbHWd3gOk4P2wU+VVhQkEl7uLcDVvt2VoQqPrnz1TY
         tJ+w==
X-Gm-Message-State: AHQUAubXBxV6ix2Ah5dP6fnXvd6u3oNJKqLLpLRG6daResR+w0I1wRcG
        LjldrNWPvOg/vlexXE5iWuRFdn/XpsIZzzsYYbN6jA==
X-Google-Smtp-Source: AHgI3Ia0slUcLi84GmxsAfdDuwpMzwncCdUl+0f8vD2XQ6KFX1KZxYwWX1FpjKewBzYCHOPvPdwahfC+4tTqD/ooJLI=
X-Received: by 2002:a1c:80d6:: with SMTP id b205mr10576370wmd.109.1550331060021;
 Sat, 16 Feb 2019 07:31:00 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU2aA-RrQbHrVa7eV4nZjUsbA9z42Dm0iVeOuWbgO=PtfQ@mail.gmail.com>
 <CAKQmDh_XOH7g2pibaSxHWVNxQwVoapzneE6vetZEA8V=ad3iSw@mail.gmail.com>
In-Reply-To: <CAKQmDh_XOH7g2pibaSxHWVNxQwVoapzneE6vetZEA8V=ad3iSw@mail.gmail.com>
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
Date:   Sat, 16 Feb 2019 10:30:48 -0500
Message-ID: <CAKQmDh-EzEqj=7ZS3MWYCt7QAjbDAmjWKUecDjsYfejNzW67+w@mail.gmail.com>
Subject: Re: v4l2 mem2mem compose support?
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     DVB_Linux_Media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Carlos Rafael Giani <dv@pseudoterminal.org>,
        Discussion of the development of and with GStreamer 
        <gstreamer-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sending back in text mode so that people on the kernel mailing list
can read, they have a spam filter that hides anything that may have an
HTML tag in it.

Le ven. 15 f=C3=A9vr. 2019 =C3=A0 21:42, Nicolas Dufresne <nicolas@ndufresn=
e.ca> a =C3=A9crit :
>
>
>
> Le ven. 15 f=C3=A9vr. 2019 19 h 16, Tim Harvey <tharvey@gateworks.com> a =
=C3=A9crit :
>>
>> Greetings,
>>
>> What is needed to be able to take advantage of hardware video
>> composing capabilities and make them available in something like
>> GStreamer?
>
>
> Veolab wrote one already for the IMX.6 hardware (mainline kernel), it wor=
ked for them, but it's missing some polishing prior to go upstream. Would b=
e nice since it  could work with other drivers too, rockchip and Samsung Ex=
ynos have similar IP with partial drivers. And I'm sure a lot of HW exist.
>
> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/issues/308
>
> I worked with them for the design, they added a new helper to make it eas=
y to handle the internal m2m nodes which seems like a good idea, and we cou=
ld simplify some more code with it. The design is to cascade the blitters, =
so you can compose as many layers as you want. It's base on aggregator clas=
s.
>
>>
>> Philipp's mem2mem driver [1] exposes the IMX IC and GStreamer's
>> v4l2convert element uses this nicely for hardware accelerated
>> scaling/csc/flip/rotate but what I'm looking for is something that
>> extends that concept and allows for composing frames from multiple
>> video capture devices into a single memory buffer which could then be
>> encoded as a single stream.
>>
>> This was made possible by Carlo's gstreamer-imx [2] GStreamer plugins
>> paired with the Freescale kernel that had some non-mainlined API's to
>> the IMX IPU and GPU. We have used this to take for example 8x analog
>> capture inputs, compose them into a single frame then H264 encode and
>> stream it. The gstreamer-imx elements used fairly compatible
>> properties as the GstCompositorPad element to provide a destination
>> rect within the compose output buffer as well as rotation/flip, alpha
>> blending and the ability to specify background fill.
>>
>> Is it possible that some of this capability might be available today
>> with the opengl GStreamer elements?
>
>
> You could do it in GLES2, but it's not very fast compared to the 2D blitt=
er. Depending on the variant, the GPU might not be able to reuse its own ou=
tput, which kills the performance with how the GST GL elements are designed=
.
>
>>
>> Best Regards,
>>
>> Tim
>>
>> [1] https://patchwork.kernel.org/patch/10768463/
>> [2] https://github.com/Freescale/gstreamer-imx
