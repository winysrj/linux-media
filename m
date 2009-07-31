Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:56799 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbZGaVbK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 17:31:10 -0400
Date: Fri, 31 Jul 2009 23:31:09 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: emagick@magic.ms
Cc: linux-media@vger.kernel.org
Subject: Re: Cinergy T2 stopped working with kernel 2.6.30
Message-ID: <20090731213109.GA27893@linuxtv.org>
References: <4A61FD76.8010409@magic.ms>
 <4A733BAB.6080305@magic.ms>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A733BAB.6080305@magic.ms>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 31, 2009 at 08:44:59PM +0200, emagick@magic.ms wrote:
> ------------------------------------------------------------------------
> static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe,
> 				  struct dvb_frontend_parameters *fep)
> {
> 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
> 	struct dvbt_set_parameters_msg param;
> 	char result[2];
> 	int err;
> 
> 	param.cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
> 	param.tps = cpu_to_le16(compute_tps(fep));
> 	param.freq = cpu_to_le32(fep->frequency / 1000);
> 	param.bandwidth = 8 - fep->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
> 
> 	err = dvb_usb_generic_rw(state->d,
> 			(char *)&param, sizeof(param),
> 			result, sizeof(result), 0);
> ------------------------------------------------------------------------
> 
> As dvbt_set_parameters_msg is declared with __attribute__((packed)), its
> alignment is 8 bits.  In fact, cinergyt2_fe_set_frontend()'s param variable
> is not aligned on a 32-bit boundary. Note that param is passed to usb_bulk_msg().
> This seems to cause DMA problems on my hardware (Atom N270 + 945GSE + ICH7M).

I doubt that.  AFAIK EHCI has no alignment requirements on data, and the
x86 architecture has DMA consistent caches.  The code in question is
broken on ARM. MIPS etc. but it should work (and according to you has
worked up to 2.6.29) on x86.  (I'm not at all against fixing the
code for MIPS/ARM but I don't think that would fix the problem for you.)
