Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:38087 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752552AbeDPBj1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 21:39:27 -0400
Received: by mail-io0-f176.google.com with SMTP id h9so2630208iob.5
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 18:39:27 -0700 (PDT)
MIME-Version: 1.0
From: Samuel Bobrowicz <sam@elite-embedded.com>
Date: Sun, 15 Apr 2018 18:39:26 -0700
Message-ID: <CAFwsNOEF0rK+SeHQ618Rnuj2ZWaGZG2WY4keWmavqG_agSi+dw@mail.gmail.com>
Subject: OV5640 with 12MHz xclk
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can anyone verify if the OV5640 driver works with input clocks other
than the typical 24MHz? The driver suggests anything from 6MHz-24MHz
is acceptable, but I am running into issues while bringing up a module
that uses a 12MHz oscillator. I'd expect that different xclk's would
necessitate different register settings for the various resolutions
(PLL settings, PCLK width, etc.), however the driver does not seem to
modify nearly enough based on the frequency of xclk.

Sam
