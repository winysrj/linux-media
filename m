Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35758 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751063AbdCZIKC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 04:10:02 -0400
Subject: Re: [PATCH v2 01/12] [media] dvb-frontends/stv0367: add flag to make
 i2c_gatectrl optional
To: Daniel Scheller <d.scheller.oss@gmail.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <20170324182408.25996-1-d.scheller.oss@gmail.com>
 <20170324182408.25996-2-d.scheller.oss@gmail.com>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <c90e92df-16e1-8693-c64d-fcb0fedee931@gentoo.org>
Date: Sun, 26 Mar 2017 10:03:33 +0200
MIME-Version: 1.0
In-Reply-To: <20170324182408.25996-2-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.03.2017 um 19:23 schrieb Daniel Scheller:
> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Some hardware and bridges (namely ddbridge) require that tuner access is
> limited to one concurrent access and wrap i2c gate control with a
> mutex_lock when attaching frontends. According to vendor information, this
> is required as concurrent tuner reconfiguration can interfere each other
> and at worst cause tuning fails or bad reception quality.
> 
> If the demod driver does gate_ctrl before setting up tuner parameters, and
> the tuner does another I2C enable, it will deadlock forever when gate_ctrl
> is wrapped into the mutex_lock. This adds a flag and a conditional before
> triggering gate_ctrl in the demodulator driver.
> 

If I get this right, the complete call to i2c_gate_ctrl should be disabled.
Why not just overwrite the function-pointer i2c_gate_ctrl with NULL in
the relevant attach function (stv0367ddb_attach) or not define it in
stv0367ddb_ops?

That should have exactly the same effect.

Regards
Matthias
