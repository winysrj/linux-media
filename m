Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7A2C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 12:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D94F21852
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 12:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G5+FYVVi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfCNMTG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 08:19:06 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:36085 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbfCNMTG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 08:19:06 -0400
Received: by mail-it1-f194.google.com with SMTP id h9so4484562itl.1;
        Thu, 14 Mar 2019 05:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oTUtf7DHMNapR1bLHHVDG7LJIcXxif1N0TzQwlX+4c4=;
        b=G5+FYVViK7D58YD6RMA5DfXScrAysWzivL/loaA/MJ69IlYFfB2Iz0s6zV2vPnlygH
         jLvgkHQT2Q41xYPnGpSkADxvHEfkS6jfgdoalLYufhnhDTjNXh19onuxBGul1HxW/iwc
         vdppNdxoC/OBC7Xcl4YcZ6X59J1CQ5uWh+D0NjyMMoAzIP4asvg/AcId3RjOvG2ti++G
         5nSe+7xnHtEinWrFyZNtB4o8pjWw8A6HQBhcdH/KyhVRcMiaIu0c4j6FUovGzHkKkIYT
         0E41sB7kuVw4PWRrYrga9ghueXuNLM/GqEIheCvWIqOZtCIqD5QXjVdWPK8LRWUJ0icd
         lSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oTUtf7DHMNapR1bLHHVDG7LJIcXxif1N0TzQwlX+4c4=;
        b=gtVGElPBdI+hyWg9McCKaBEZZRM1lOJ0RNRnHRjnDKcV/f8TOO+//ssW07OOwJv8/6
         nV+KcZHdcEayKwvknCxQ35tUmyj7GG+FYGyckVd13MGjiFGgxmlvbrc8FeU9FnwSga9y
         pJsZayOcs+nTQFtfK4beaCNrCqz1p15TKrIHdzo7b/g/JYlO7oFu5UnwrAfrtWGCI57C
         PvOXMLxgZE9nqpGiilhrDU10sFsaKa15kL+eTt5VPWwnvSAq0nHDKq02xM+K0bTi67C9
         XmB3uHnqeCdwNlKGYLqZXOFcdHy/2oK52akvBDksJnyl/Vn/5MskK8JTQNP/G66uzqAJ
         a8TQ==
X-Gm-Message-State: APjAAAXrL0dvAQvbZdAGSZsUtqIgEJ6JFgmbxEMhj8PhdGcFoapMMlHZ
        WAI02zPKaggYAdYzzaKzXB+sfc8lMMN2VTk0fsU=
X-Google-Smtp-Source: APXvYqzyVnFGZXamqKcgQC6vQ6JnprSS4GG5QO6oXogT/Phak4extsCcyYLL9e+J5zpqhwMrjgO0gxxCDeQF2WTzLWk=
X-Received: by 2002:a02:a903:: with SMTP id n3mr947770jam.3.1552565944487;
 Thu, 14 Mar 2019 05:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20181221011752.25627-1-sre@kernel.org> <4f47f7f2-3abb-856c-4db5-675caf8057c7@xs4all.nl>
In-Reply-To: <4f47f7f2-3abb-856c-4db5-675caf8057c7@xs4all.nl>
From:   Adam Ford <aford173@gmail.com>
Date:   Thu, 14 Mar 2019 07:18:53 -0500
Message-ID: <CAHCN7x+KeHBYH-QxAsRNL2KB_qDud2LTqdtjC4FZ08KvxGtEdA@mail.gmail.com>
Subject: Re: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-media@vger.kernel.org,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 14, 2019 at 3:21 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Sebastian,
>
> On 12/21/18 2:17 AM, Sebastian Reichel wrote:
> > Hi,
> >
> > This moves all remaining users of the legacy TI_ST driver to hcill (patches
> > 1-3). Then patches 4-7 convert wl128x-radio driver to a standard platform
> > device driver with support for multiple instances. Patch 7 will result in
> > (userless) TI_ST driver no longer supporting radio at runtime. Patch 8-11 do
> > some cleanups in the wl128x-radio driver. Finally patch 12 removes the TI_ST
> > specific parts from wl128x-radio and adds the required infrastructure to use it
> > with the serdev hcill driver instead. The remaining patches 13 and 14 remove
> > the old TI_ST code.
> >
> > The new code has been tested on the Motorola Droid 4. For testing the audio
> > should be configured to route Ext to Speaker or Headphone. Then you need to
> > plug headphone, since its cable is used as antenna. For testing there is a
> > 'radio' utility packages in Debian. When you start the utility you need to
> > specify a frequency, since initial get_frequency returns an error:
>
> What is the status of this series?
>
> Based on some of the replies (from Adam Ford in particular) it appears that
> this isn't ready to be merged, so is a v2 planned?

If you can leave the Logic PD Torpedo board alone and don't remove the
legacy st driver for now, go ahead and migrate the others.  I know
what you proposed 'should' work on my board, but I don't know why it
doesn't.  In fact other boards I maintain use your method, but it just
doesn't work on the Torpedo and I don't know why.  (it's not for lack
of trying)

adam
>
> Regards,
>
>         Hans
>
> >
> > $ radio -f 100.0
> >
> > Merry Christmas!
> >
> > -- Sebastian
> >
> > Sebastian Reichel (14):
> >   ARM: dts: LogicPD Torpedo: Add WiLink UART node
> >   ARM: dts: IGEP: Add WiLink UART node
> >   ARM: OMAP2+: pdata-quirks: drop TI_ST/KIM support
> >   media: wl128x-radio: remove module version
> >   media: wl128x-radio: remove global radio_disconnected
> >   media: wl128x-radio: remove global radio_dev
> >   media: wl128x-radio: convert to platform device
> >   media: wl128x-radio: use device managed memory allocation
> >   media: wl128x-radio: load firmware from ti-connectivity/
> >   media: wl128x-radio: simplify fmc_prepare/fmc_release
> >   media: wl128x-radio: fix skb debug printing
> >   media: wl128x-radio: move from TI_ST to hci_ll driver
> >   Bluetooth: btwilink: drop superseded driver
> >   misc: ti-st: Drop superseded driver
> >
> >  .../boot/dts/logicpd-torpedo-37xx-devkit.dts  |   8 +
> >  arch/arm/boot/dts/omap3-igep0020-rev-f.dts    |   8 +
> >  arch/arm/boot/dts/omap3-igep0030-rev-g.dts    |   8 +
> >  arch/arm/mach-omap2/pdata-quirks.c            |  52 -
> >  drivers/bluetooth/Kconfig                     |  11 -
> >  drivers/bluetooth/Makefile                    |   1 -
> >  drivers/bluetooth/btwilink.c                  | 350 -------
> >  drivers/bluetooth/hci_ll.c                    | 115 ++-
> >  drivers/media/radio/wl128x/Kconfig            |   2 +-
> >  drivers/media/radio/wl128x/fmdrv.h            |   5 +-
> >  drivers/media/radio/wl128x/fmdrv_common.c     | 211 ++--
> >  drivers/media/radio/wl128x/fmdrv_common.h     |   4 +-
> >  drivers/media/radio/wl128x/fmdrv_v4l2.c       |  55 +-
> >  drivers/media/radio/wl128x/fmdrv_v4l2.h       |   2 +-
> >  drivers/misc/Kconfig                          |   1 -
> >  drivers/misc/Makefile                         |   1 -
> >  drivers/misc/ti-st/Kconfig                    |  18 -
> >  drivers/misc/ti-st/Makefile                   |   6 -
> >  drivers/misc/ti-st/st_core.c                  | 922 ------------------
> >  drivers/misc/ti-st/st_kim.c                   | 868 -----------------
> >  drivers/misc/ti-st/st_ll.c                    | 169 ----
> >  include/linux/ti_wilink_st.h                  | 337 +------
> >  22 files changed, 213 insertions(+), 2941 deletions(-)
> >  delete mode 100644 drivers/bluetooth/btwilink.c
> >  delete mode 100644 drivers/misc/ti-st/Kconfig
> >  delete mode 100644 drivers/misc/ti-st/Makefile
> >  delete mode 100644 drivers/misc/ti-st/st_core.c
> >  delete mode 100644 drivers/misc/ti-st/st_kim.c
> >  delete mode 100644 drivers/misc/ti-st/st_ll.c
> >
>
