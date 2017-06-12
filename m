Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33935 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbdFLUXo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 16:23:44 -0400
Received: by mail-oi0-f45.google.com with SMTP id b6so7402935oia.1
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 13:23:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU07V9wR+11KJYqWg6JcfK7Wc45-c-Wf6fpTbTVAeKKDHw@mail.gmail.com>
References: <CAJ+vNU07V9wR+11KJYqWg6JcfK7Wc45-c-Wf6fpTbTVAeKKDHw@mail.gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 12 Jun 2017 17:23:43 -0300
Message-ID: <CAOMZO5BSmDo9EyYNmuBS9NRYn9pekcabeHKK_jTkzPbwMOgQhw@mail.gmail.com>
Subject: Re: how to link up audio bus from media controller driver to soc dai bus?
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Mon, Jun 12, 2017 at 4:15 PM, Tim Harvey <tharvey@gateworks.com> wrote:
> Greetings,
>
> I'm working on a media controller driver for the tda1997x HDMI
> receiver which provides an audio bus supporting I2S/SPDIF/OBA/HBR/DST.
> I'm unclear how to bind the audio bus to a SoC's audio bus, for
> example the IMX6 SSI (I2S) bus. I thought perhaps it was via a
> simple-audio-card device-tree binding but that appears to require an
> ALSA codec to bind to?
>
> Can anyone point me to an example of a media controller device driver
> that supports audio and video and how the audio is bound to a I2S bus?

Does the tda998x.txt example help?

Documentation/devicetree/bindings/display/bridge/tda998x.txt

and the dts example:

arch/arm/boot/dts/am335x-boneblack-common.dtsi
