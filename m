Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34181 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbdFLTPQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 15:15:16 -0400
Received: by mail-wr0-f173.google.com with SMTP id g76so107197387wrd.1
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 12:15:15 -0700 (PDT)
MIME-Version: 1.0
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 12 Jun 2017 12:15:13 -0700
Message-ID: <CAJ+vNU07V9wR+11KJYqWg6JcfK7Wc45-c-Wf6fpTbTVAeKKDHw@mail.gmail.com>
Subject: how to link up audio bus from media controller driver to soc dai bus?
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

I'm working on a media controller driver for the tda1997x HDMI
receiver which provides an audio bus supporting I2S/SPDIF/OBA/HBR/DST.
I'm unclear how to bind the audio bus to a SoC's audio bus, for
example the IMX6 SSI (I2S) bus. I thought perhaps it was via a
simple-audio-card device-tree binding but that appears to require an
ALSA codec to bind to?

Can anyone point me to an example of a media controller device driver
that supports audio and video and how the audio is bound to a I2S bus?

Regards,

Tim
