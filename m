Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35436 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbdLKJCm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 04:02:42 -0500
Received: by mail-wm0-f42.google.com with SMTP id f9so12683932wmh.0
        for <linux-media@vger.kernel.org>; Mon, 11 Dec 2017 01:02:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171211013146.2497-1-wenyou.yang@microchip.com>
References: <20171211013146.2497-1-wenyou.yang@microchip.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Mon, 11 Dec 2017 10:02:00 +0100
Message-ID: <CAOFm3uGGjN1_tM5bi0HPUsXRGPKqdR9S+4kP9r1vUqYkHDsVdA@mail.gmail.com>
Subject: Re: [PATCH v9 0/2] media: ov7740: Add a V4L2 sensor-level driver
To: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 11, 2017 at 2:31 AM, Wenyou Yang <wenyou.yang@microchip.com> wrote:
> Add a Video4Linux2 sensor-level driver for the OmniVision OV7740
> VGA camera image sensor.
>
> Changes in v9:
>  - Use the new SPDX ids.

Thank you for this

Acked-by: Philippe Ombredanne <pombredanne@nexb.com>

-- 
Cordially
Philippe Ombredanne
