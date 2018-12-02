Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41303 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbeLBUoO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2018 15:44:14 -0500
MIME-Version: 1.0
References: <20181202134538.GA18886@gfm-note>
In-Reply-To: <20181202134538.GA18886@gfm-note>
From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 2 Dec 2018 21:43:53 +0100
Message-ID: <CAK8P3a2of9sZ5BGCKshCjFkpt8q6s-KD-9XC4SGYP2Ppj7fjEw@mail.gmail.com>
Subject: Re: [PATCH v4] media: vivid: Improve timestamping
To: gfmandaji@gmail.com
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lkcamp@lists.libreplanetbr.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 2, 2018 at 2:47 PM Gabriel Francisco Mandaji
<gfmandaji@gmail.com> wrote:

> @@ -667,10 +653,28 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
>         }
>  }
>
> +static void vivid_cap_update_frame_period(struct vivid_dev *dev)
> +{
> +       u64 f_period;
> +
> +       f_period = (u64)dev->timeperframe_vid_cap.numerator * 1000000000;
> +       do_div(f_period, dev->timeperframe_vid_cap.denominator);
> +       if (dev->field_cap == V4L2_FIELD_ALTERNATE)
> +               do_div(f_period, 2);
> +       /*
> +        * If "End of Frame", then offset the exposure time by 0.9
> +        * of the frame period.
> +        */
> +       dev->cap_frame_eof_offset = f_period * 9;
> +       do_div(dev->cap_frame_eof_offset, 10);
> +       dev->cap_frame_period = f_period;
> +}

Doing two or three do_div() operations is going to make this rather
expensive on 32-bit architectures, and it looks like this happens for
each frame?

Since each one is a multiplication followed by a division, could this
be changed to using a different factor followed by a bit shift?

      Arnd
