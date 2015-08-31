Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.aon.at ([195.3.96.117]:47781 "EHLO smtpout.aon.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbbHaQZY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 12:25:24 -0400
Message-ID: <55E47FE8.7000206@a1.net>
Date: Mon, 31 Aug 2015 18:25:12 +0200
From: Johann Klammer <klammerj@a1.net>
MIME-Version: 1.0
To: Maximilian Imgrund <max@imgrunds.de>, linux-media@vger.kernel.org
Subject: Re: New Terratec Cinergy S2 Box usb-id
References: <201508311109.t7VB9utm008834@higgs.fritz.box> <55E43855.3060409@imgrunds.de>
In-Reply-To: <55E43855.3060409@imgrunds.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2015 01:19 PM, Maximilian Imgrund wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> Dear all,
> 
> I am currently figuring out how to get the Terratec Cinergy S2 USB Box
> up and running. I already modified a patch to  previous version (see
> attachment) to include the new ID in the device driver, module is also
> loading with the ds3000 firmware. However, when using w_scan, the
> reported frequency range is .95GHz ... 2.15Ghz which is roughly a
> factor of 10 lower than I expected (Astra is 12.515Ghz e.g.). Since
> the tuner seems to tune in correctly but in the wrong frequency range,
> I feel that is the reason for me not getting in any channels.
> 
> Can you help me with what to change in the driver to get this working
> ? I feel like an additional .frequency_div should do the job, however
> I am unable to find further informaion on that...
> 
> Best
> Maximilian Imgrund
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2
> 
> iF4EAREIAAYFAlXkOFIACgkQR/X5cR0fI/6sfAD+OVauTyLw0oWSMr8ONzmrguF+
> Ci/vg4uO9mxZwzjgGXkA/ipgQ/IuX+8n2CSScHg6CFjt9tIBbFOAVzStuUrOpwx2
> =AAXS
> -----END PGP SIGNATURE-----
> 

The driver has to tune to the intermediate frequency 
that's output by the LNB. (There is a local oscillator+downmixer in there...)

This is what the one here has

info = {
      name = "ST STV0299 DVB-S", '\000' <repeats 111 times>, type = FE_QPSK, 
      frequency_min = 950000, frequency_max = 2150000, 
      frequency_stepsize = 125, frequency_tolerance = 0, 
      symbol_rate_min = 1000000, symbol_rate_max = 45000000, 
      symbol_rate_tolerance = 500, notifier_delay = 0, 
      caps = (FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO | FE_CAN_QPSK)}, 

Frequency_min and max match yours. 

Try a different scan tool, and make sure you get a signal out of your LNB. 
Proper DISH ALIGNMENT is important, 
and don't forget a grounding bloc. 


