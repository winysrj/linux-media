Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33199 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2EHXhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 19:37:37 -0400
Received: by werb10 with SMTP id b10so2333783wer.19
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 16:37:36 -0700 (PDT)
Message-ID: <1336520246.3125.5.camel@router7789>
Subject: Re: m88rs2000: LNB voltage control implemented
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 09 May 2012 00:37:26 +0100
In-Reply-To: <4246147.n44n5i5ILa@useri>
References: <4246147.n44n5i5ILa@useri>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2012-05-08 at 11:25 +0300, Igor M. Liplianin wrote:
> Trival patch to get it working with my cards stuff.
> 
> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
Acked-by: Malcolm Priestley <tvboxspy@gmail.com>

> differences between files attachment (rs2000volt.patch)
> diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c index 547230d..f6d6e39 100644 --- a/drivers/media/dvb/frontends/m88rs2000.c +++ b/drivers/media/dvb/frontends/m88rs2000.c @@ -416,9 +416,25 @@ static int m88rs2000_tab_set(struct m88rs2000_state *state, static int m88rs2000_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t volt) { -	deb_info("%s: %s\n", __func__, -		volt == SEC_VOLTAGE_13 ? "SEC_VOLTAGE_13" : -		volt == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" : "??"); +	struct m88rs2000_state *state = fe->demodulator_priv; +	u8 data; + +	data = m88rs2000_demod_read(state, 0xb2); +	data |= 0x03; /* bit0 V/H, bit1 off/on */ + +	switch (volt) { +	case SEC_VOLTAGE_18: +		data &= ~0x03; +		break; +	case SEC_VOLTAGE_13: +		data &= ~0x03; +		data |= 0x01; +		break; +	case SEC_VOLTAGE_OFF: +		break; +	} + +	m88rs2000_demod_write(state, 0xb2, data); 	return 0; }
Regards


Malcolm

