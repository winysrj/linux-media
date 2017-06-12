Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:34800 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752386AbdFLUKX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 16:10:23 -0400
Received: by mail-yb0-f195.google.com with SMTP id o185so5104196yba.1
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 13:10:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU07V9wR+11KJYqWg6JcfK7Wc45-c-Wf6fpTbTVAeKKDHw@mail.gmail.com>
References: <CAJ+vNU07V9wR+11KJYqWg6JcfK7Wc45-c-Wf6fpTbTVAeKKDHw@mail.gmail.com>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Mon, 12 Jun 2017 16:10:17 -0400
Message-ID: <CADnq5_NKH1MkG6ghSGjWP0imSybahsVd5x8rPFogCM4ESxavoA@mail.gmail.com>
Subject: Re: how to link up audio bus from media controller driver to soc dai bus?
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 12, 2017 at 3:15 PM, Tim Harvey <tharvey@gateworks.com> wrote:
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

I'm not sure if this is what you are looking for now not, but on some
AMD APUs, we have an i2s bus and codec attached to the GPU rather than
as a standalone device.  The audio DMA engine and interrupts are
controlled via the GPU's mmio aperture, but we expose the audio DMA
engine and i2c interface via alsa.  We use the MFD (Multi-Function
Device) kernel infrastructure to do this.  The GPU driver loads and
probes the audio capabilities and triggers the hotplug of the i2s and
audio dma engine.

For the GPU side see:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
for the audio side:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sound/soc/amd/acp-pcm-dma.c

Alex
