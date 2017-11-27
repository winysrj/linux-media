Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65170 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbdK0T0N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 14:26:13 -0500
Date: Mon, 27 Nov 2017 17:26:07 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Maksym Veremeyenko <verem@m1stereo.tv>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC] not use a DiSEqC switch
Message-ID: <20171127172607.76b62e11@vento.lan>
In-Reply-To: <b5573a09-f841-d126-df19-0ecc76d15511@m1stereo.tv>
References: <b5573a09-f841-d126-df19-0ecc76d15511@m1stereo.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 24 Nov 2017 10:52:04 +0200
Maksym Veremeyenko <verem@m1stereo.tv> escreveu:

> Hi,
> 
> there is a code in function *dvbsat_diseqc_set_input*:
> 
> [...]
> 	/* Negative numbers means to not use a DiSEqC switch */
> 	if (parms->p.sat_number < 0)
> 		return 0;
> [...]
> 
> if it mean /there is no DiSEqC switch/ then LNB's *polarity* and *band* 
> settings still should be applied - attached patch fixes that behavior.
> 
> if it mean /current DVB is a slave/ i.e. it is connected to LOOP OUT of 
> another DVB, so no need to configure anything, then statement above is 
> correct and no patches from this email should be applied.

No, it actually means that there's no DiSEqC at all; the LNBf
is a bandstacking one, where different polarities use different
LO, like on those LNBf:

	{
		.desc = {
			.name = N_("Big Dish - Multipoint LNBf"),
			.alias = "C-MULT",
		},
		.freqrange = {
			{ 3700, 4200, 5150, 0, POLARIZATION_R },
			{ 3700, 4200, 5750, 0, POLARIZATION_L }
		},
	}, {

		.desc = {
			.name = N_("BrasilSat Amazonas 1/2 - 2 Oscilators"),
			.alias = "AMAZONAS",
		},
		.freqrange = {
			{ 11037, 11360, 9670, 0, POLARIZATION_V },
			{ 11780, 12150, 10000, 0, POLARIZATION_H },
			{ 10950, 11280, 10000, 0, POLARIZATION_H },
		},
	},


The case where the LNBf accepts DiSEqC commands, but there's no
switch will work just fine, as the switch control data will be
silently ignored.

Ok, removing them could reduce a little bit the tuning time, at
the expense of making harder for the user, as he would need to
select between 4 different DiSEqC situations:

	- no DiSEqC at all;
	- DiSEqC LNbf, no DiSEqC switch;
	- DiSEqC LNbf, DiSEqC switch with 2 ports (miniDiSEqC);
	- DiSEqC LNbf, DiSEqC switch with 4 ports.

The way the code is, if DiSEqC is selected, it will send both
mini-DiSEqC (if satellite number < 2) and DiSEqC commands, so, 
all 3 DiSEqC cases will be covered by just one configuration.

Regards,
Mauro
