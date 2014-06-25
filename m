Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51142 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbaFYPBd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 11:01:33 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so2233750wes.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 08:01:28 -0700 (PDT)
Received: from [192.168.0.14] (zac83-1-78-232-174-61.fbx.proxad.net. [78.232.174.61])
        by mx.google.com with ESMTPSA id ey16sm54619427wid.14.2014.06.25.08.01.24
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 25 Jun 2014 08:01:26 -0700 (PDT)
Message-ID: <53AAE440.5020909@gmail.com>
Date: Wed, 25 Jun 2014 17:01:20 +0200
From: Corentin FERRY <cocodidouf@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: PCTV 340e: tuning again
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Starting with kernel 3.11 (or a little bit earlier), the PCTV 340e DVB-T 
tuner would no longer tune to any channel.
There's been a patch which introduced a frequency offset in dib7000p, 
based on tuner frequency, here: 
https://github.com/torvalds/linux/commit/6fe10 
99c7aecc54ebf2fcf8e3af2225cd7bfa550 .
Yet, there should be no offset with the PCTV 340e's DIB7000P, as the 
COFDM demodulator is already set at the right frequency, i.e. the one 
the XC4000 tuner passes its data on.
In order to make the PCTV 340e work again, I have done the following:

In drivers/media/dvb-frontends/dib7000p.c :

static void dib7000p_set_dds(struct dib7000p_state *state, s32 offset_khz)
{
	u32 internal = dib7000p_get_internal_freq(state);
	s32 unit_khz_dds_val = 67108864 / (internal);	/* 2**26 / Fsampling is 
the unit 1KHz offset */
	u32 abs_offset_khz = ABS(offset_khz);
	u32 dds = state->cfg.bw->ifreq & 0x1ffffff;
	u8 invert = !!(state->cfg.bw->ifreq & (1 << 25));

	dprintk("setting a frequency offset of %dkHz internal freq = %d invert 
= %d", offset_khz, internal, invert);

	if (offset_khz < 0)
		unit_khz_dds_val *= -1;

	/* IF tuner */
//comment out the lines that involve the offset
//	if (invert)
//		dds -= (abs_offset_khz * unit_khz_dds_val);	/* /100 because of /100 
on the unit_khz_dds_val line calc for better accuracy */
//	else
//		dds += (abs_offset_khz * unit_khz_dds_val);

	if (abs_offset_khz <= (internal / 2)) {	/* Max dds offset is the half 
of the demod freq */
		dib7000p_write_word(state, 21, (u16) (((dds >> 16) & 0x1ff) | (0 << 
10) | (invert << 9)));
		dib7000p_write_word(state, 22, (u16) (dds & 0xffff));
	}
}

Restoring dib7000p_set_dds(state, 0); instead of the if 
(demod->ops.tuner_ops.get_frequency) {...} didn't do the trick (or I did 
something wrong with it...)).

This is a basic workaround to get it working, yet there may be units 
which embed a DIB7000P demodulator, and where this offset is required.
Does anybody out there have such an unit, or a justification for this 
offset setting?

Cheers,
Corentin FERRY
