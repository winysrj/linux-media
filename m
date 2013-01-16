Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454Ab3APWL5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 17:11:57 -0500
Date: Wed, 16 Jan 2013 20:11:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Simon Farnsworth <simon.farnsworth@onelan.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130116201113.5394cd14@redhat.com>
In-Reply-To: <CAHFNz9K7EJWjmeU8ViW_bnxO-inNuSU4S+=vH_FHnCF9Aq+kBg@mail.gmail.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<CAHFNz9K7EJWjmeU8ViW_bnxO-inNuSU4S+=vH_FHnCF9Aq+kBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Jan 2013 03:07:21 +0530
Manu Abraham <abraham.manu@gmail.com> escreveu:

> With ISDB-T, with the 3 layers, you have BER/UNC for each of the layers, though
> the rate difference could be very little.

Where? There's no way to report per-layer report with DVBv3.

And no, the difference is not very little:

$ dmesg|grep -e mb86a20s_get_main_CNR -e "bit error before" -e "bit count before"

[12785.798746] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer A: 252.
[12785.810743] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer A: 65535.
[12785.856385] i2c i2c-4: mb86a20s_get_main_CNR: CNR is 24.4 dB (1285)
[12786.399684] i2c i2c-4: mb86a20s_get_main_CNR: CNR is 24.4 dB (1285)
[12786.410678] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer A: 248.
[12786.422693] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer A: 65535.
[12786.425547] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer B: 80209.
[12786.437537] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer B: 8257536.
[12786.919289] i2c i2c-4: mb86a20s_get_main_CNR: CNR is 24.4 dB (1285)
[12786.930410] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer A: 213.
[12786.942553] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer A: 65535.
[12786.989127] i2c i2c-4: mb86a20s_get_main_CNR: CNR is 24.4 dB (1285)
[12787.387172] i2c i2c-4: mb86a20s_get_main_CNR: CNR is 24.4 dB (1285)
[12787.398062] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer A: 234.
[12787.409657] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer A: 65535.
[12787.412529] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer B: 83533.
[12787.424293] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer B: 8257536.
[12788.052702] i2c i2c-4: mb86a20s_get_main_CNR: CNR is 24.4 dB (1285)
[12788.063443] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer A: 183.
[12788.075438] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer A: 65535.
[12788.078165] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer B: 91502.
[12788.089946] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer B: 8257536.
[12788.126411] i2c i2c-4: mb86a20s_get_main_CNR: CNR is 24.4 dB (1285)
[12788.388646] i2c i2c-4: mb86a20s_get_main_CNR: CNR is 24.4 dB (1285)
[12788.399268] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer A: 181.
[12788.410887] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer A: 65535.
[12789.189254] i2c i2c-4: mb86a20s_get_main_CNR: CNR is 24.4 dB (1285)
[12789.200099] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer A: 191.
[12789.211719] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer A: 65535.
[12789.214465] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit error before Viterbi for layer B: 83536.
[12789.226348] i2c i2c-4: mb86a20s_get_ber_before_vterbi: bit count before Viterbi for layer B: 8257536.

-- 

Cheers,
Mauro
