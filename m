Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35528 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdE1Vrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 17:47:42 -0400
Received: by mail-wm0-f68.google.com with SMTP id g15so13505686wmc.2
        for <linux-media@vger.kernel.org>; Sun, 28 May 2017 14:47:41 -0700 (PDT)
Date: Sun, 28 May 2017 23:47:38 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: Re: [PATCH 00/19] cxd2841er/ddbridge: support Sony CXD28xx hardware
Message-ID: <20170528234738.6726df65@macbox>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun,  9 Apr 2017 21:38:09 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:


> Important note: This series depends on the stv0367/ddbridge series
> posted earlier (patches 12 [1] and 13 [2], depending on the I2C
> functions and the TDA18212 attach function).
> 
> This series improves the cxd2841er demodulator driver and adds some
> bits to make it more versatile to be used in more scenarios. Also,
> the ddbridge code is updated to recognize all hardware (PCIe
> cards/bridges and DuoFlex modules) with Sony CXD28xx tuners,
> including the newly introduced MaxA8 eight-tuner C2T2 cards.
> 
> The series has been tested (together with the STV0367 series) on a
> wide variety of cards, including CineCTv7, DuoFlex C(2)T2 modules and
> MaxA8 cards without any issues. Testing was done with TVHeadend, VDR
> and MythTV.
> 
> Note that the i2c_gate_ctrl() flag is needed in this series aswell
> since the i2c_gate_ctrl function needs to be remapped and mutex_lock
> protected for the same reasons as in the STV0367 series.
> 
> Besides printk() warnings, checkpatch.pl doesn't complain.

Ping on this series aswell.

Abylay, would you please mind taking a look at the cxd2841er changes
and check if you're fine with them?

Regards,
Daniel
