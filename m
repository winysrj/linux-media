Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:33859 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdCZKfP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 06:35:15 -0400
Received: by mail-wr0-f182.google.com with SMTP id l43so17750460wre.1
        for <linux-media@vger.kernel.org>; Sun, 26 Mar 2017 03:34:45 -0700 (PDT)
Date: Sun, 26 Mar 2017 12:34:42 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 01/12] [media] dvb-frontends/stv0367: add flag to
 make i2c_gatectrl optional
Message-ID: <20170326123442.60c2752c@macbox>
In-Reply-To: <c90e92df-16e1-8693-c64d-fcb0fedee931@gentoo.org>
References: <20170324182408.25996-1-d.scheller.oss@gmail.com>
        <20170324182408.25996-2-d.scheller.oss@gmail.com>
        <c90e92df-16e1-8693-c64d-fcb0fedee931@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun, 26 Mar 2017 10:03:33 +0200
schrieb Matthias Schwarzott <zzam@gentoo.org>:

> Am 24.03.2017 um 19:23 schrieb Daniel Scheller:
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > Some hardware and bridges (namely ddbridge) require that tuner
> > access is limited to one concurrent access and wrap i2c gate
> > control with a mutex_lock when attaching frontends. According to
> > vendor information, this is required as concurrent tuner
> > reconfiguration can interfere each other and at worst cause tuning
> > fails or bad reception quality.
> > 
> > If the demod driver does gate_ctrl before setting up tuner
> > parameters, and the tuner does another I2C enable, it will deadlock
> > forever when gate_ctrl is wrapped into the mutex_lock. This adds a
> > flag and a conditional before triggering gate_ctrl in the
> > demodulator driver. 
> 
> If I get this right, the complete call to i2c_gate_ctrl should be
> disabled. Why not just overwrite the function-pointer i2c_gate_ctrl
> with NULL in the relevant attach function (stv0367ddb_attach) or not
> define it in stv0367ddb_ops?

This will make communication with the TDA18212 tuner chip impossible.
We need to open stv0367's I2C gate, thus need the function. But for the
overall hardware case, concurrent tuner reconfiguration must be avoided
due to the mentioned issues, thus after _attach the bridge driver
remaps the function pointer to wrap i2c_gate_ctrl with a lock to
accomplish this - see [1] and [2]. As the demod AND the tuner driver
both open the I2C gate, this will lead to a dead lock. To not change or
break existing behaviour with other cards and tuner drivers, this
(flag, conditional) appears to be the best option.

Thanks,
Daniel

[1]
https://github.com/herrnst/dddvb-linux-kernel/blob/cfefdc71b25d8c135889971dc5735414d22003cf/drivers/media/pci/ddbridge/ddbridge-core.c#L646
[2]
https://github.com/herrnst/dddvb-linux-kernel/blob/cfefdc71b25d8c135889971dc5735414d22003cf/drivers/media/pci/ddbridge/ddbridge-core.c#L556
