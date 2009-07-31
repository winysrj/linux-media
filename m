Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53300 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZGaSpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 14:45:07 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate01.web.de (Postfix) with ESMTP id 3073A10F2220A
	for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 20:45:07 +0200 (CEST)
Received: from [217.228.167.87] (helo=[172.16.99.2])
	by smtp06.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MWx6H-00025q-00
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 20:45:05 +0200
Message-ID: <4A733BAB.6080305@magic.ms>
Date: Fri, 31 Jul 2009 20:44:59 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Cinergy T2 stopped working with kernel 2.6.30
References: <4A61FD76.8010409@magic.ms>
In-Reply-To: <4A61FD76.8010409@magic.ms>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think I've found the problem:

------------------------------------------------------------------------
static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe,
				  struct dvb_frontend_parameters *fep)
{
	struct cinergyt2_fe_state *state = fe->demodulator_priv;
	struct dvbt_set_parameters_msg param;
	char result[2];
	int err;

	param.cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
	param.tps = cpu_to_le16(compute_tps(fep));
	param.freq = cpu_to_le32(fep->frequency / 1000);
	param.bandwidth = 8 - fep->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;

	err = dvb_usb_generic_rw(state->d,
			(char *)&param, sizeof(param),
			result, sizeof(result), 0);
------------------------------------------------------------------------

As dvbt_set_parameters_msg is declared with __attribute__((packed)), its
alignment is 8 bits.  In fact, cinergyt2_fe_set_frontend()'s param variable
is not aligned on a 32-bit boundary. Note that param is passed to usb_bulk_msg().
This seems to cause DMA problems on my hardware (Atom N270 + 945GSE + ICH7M).

I hope that I'm not talking to a black hole.
