Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33541 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752092AbcJWKOb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 06:14:31 -0400
Received: by mail-qk0-f195.google.com with SMTP id f128so10703323qkb.0
        for <linux-media@vger.kernel.org>; Sun, 23 Oct 2016 03:14:31 -0700 (PDT)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com. [209.85.220.178])
        by smtp.gmail.com with ESMTPSA id b12sm7220632qta.4.2016.10.23.03.14.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Oct 2016 03:14:30 -0700 (PDT)
Received: by mail-qk0-f178.google.com with SMTP id f128so196745960qkb.1
        for <linux-media@vger.kernel.org>; Sun, 23 Oct 2016 03:14:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161023100312.GA6792@dell-m4800.home>
References: <000901d22a39$9de21e70$d9a65b50$@yahoo.de> <20161019171419.3343cdd5@vento.lan>
 <009201d22c8a$c93b9580$5bb2c080$@yahoo.de> <20161023100312.GA6792@dell-m4800.home>
From: Olli Salonen <olli.salonen@iki.fi>
Date: Sun, 23 Oct 2016 13:14:29 +0300
Message-ID: <CAAZRmGzT_8LUB8-gJPfwMS0m2VME5Frp-FBugbnr-YCsQ+VE=A@mail.gmail.com>
Subject: Re: em28xx WinTV dualHD in Raspbian
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: ps00de@yahoo.de, Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

When I submitted the original patch to add support for this device I
stated that it only supports the first tuner. The em28xx driver is not
built with dual-tuner support in mind and I had not enough interest to
start changing it (the driver supports like 100 devices and is quite
massive). There should not be many issues in using the second tuner
itself on this device, it's just another I2C bus...

Cheers,
-olli


On 23 October 2016 at 13:03, Andrey Utkin <andrey_utkin@fastmail.com> wrote:
> On Sat, Oct 22, 2016 at 07:36:13PM +0200, ps00de@yahoo.de wrote:
>> Hopefully some driver expert can get the second tuner working, that would be
>> awesome
>
> What's the problem? I don't see it described in this discussion thread.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
