Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41354 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753708AbdC1Fhy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 01:37:54 -0400
Subject: Re: [PATCH v2 01/12] [media] dvb-frontends/stv0367: add flag to make
 i2c_gatectrl optional
To: Daniel Scheller <d.scheller.oss@gmail.com>
References: <20170324182408.25996-1-d.scheller.oss@gmail.com>
 <20170324182408.25996-2-d.scheller.oss@gmail.com>
 <c90e92df-16e1-8693-c64d-fcb0fedee931@gentoo.org>
 <20170326123442.60c2752c@macbox>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <e002aa9b-06b0-73b9-5bf4-b836141bde27@gentoo.org>
Date: Tue, 28 Mar 2017 07:37:47 +0200
MIME-Version: 1.0
In-Reply-To: <20170326123442.60c2752c@macbox>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 26.03.2017 um 12:34 schrieb Daniel Scheller:
> Am Sun, 26 Mar 2017 10:03:33 +0200
> schrieb Matthias Schwarzott <zzam@gentoo.org>:
> 
>> Am 24.03.2017 um 19:23 schrieb Daniel Scheller:
>>> From: Daniel Scheller <d.scheller@gmx.net>
>>>
>>> Some hardware and bridges (namely ddbridge) require that tuner
>>> access is limited to one concurrent access and wrap i2c gate
>>> control with a mutex_lock when attaching frontends. According to
>>> vendor information, this is required as concurrent tuner
>>> reconfiguration can interfere each other and at worst cause tuning
>>> fails or bad reception quality.
>>>
>>> If the demod driver does gate_ctrl before setting up tuner
>>> parameters, and the tuner does another I2C enable, it will deadlock
>>> forever when gate_ctrl is wrapped into the mutex_lock. This adds a
>>> flag and a conditional before triggering gate_ctrl in the
>>> demodulator driver. 
>>
>> If I get this right, the complete call to i2c_gate_ctrl should be
>> disabled. Why not just overwrite the function-pointer i2c_gate_ctrl
>> with NULL in the relevant attach function (stv0367ddb_attach) or not
>> define it in stv0367ddb_ops?
> 
> This will make communication with the TDA18212 tuner chip impossible.
> We need to open stv0367's I2C gate, thus need the function. But for the
> overall hardware case, concurrent tuner reconfiguration must be avoided
> due to the mentioned issues, thus after _attach the bridge driver
> remaps the function pointer to wrap i2c_gate_ctrl with a lock to
> accomplish this - see [1] and [2]. As the demod AND the tuner driver
> both open the I2C gate, this will lead to a dead lock. To not change or
> break existing behaviour with other cards and tuner drivers, this
> (flag, conditional) appears to be the best option.

Ok, I understand: The real problem is that both demod driver (around
tuner access) and tuner driver care about the i2c_gate.

Regards
Matthias
