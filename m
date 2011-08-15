Return-path: <linux-media-owner@vger.kernel.org>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:52030 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1HOIor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 04:44:47 -0400
Subject: Re: PCTV 290e - assorted problems
From: Steve Kerrison <steve@stevekerrison.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
In-Reply-To: <1313366188.5010.YahooMailClassic@web121715.mail.ne1.yahoo.com>
References: <1313366188.5010.YahooMailClassic@web121715.mail.ne1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 09:44:41 +0100
Message-ID: <1313397881.2818.11.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

Take a look at this breakdown of muxes on the crystal palace
transmitter:

http://www.ukfree.tv/txdetail.php?a=TQ339712

You'll see mixed power levels and FFT sizes. I have the same thing
(albeit with a larger range of power levels) here in Mendip and as a
result its very difficult to get certain muxes.

You could try a variable attenuator to see if you can trim things a bit
to make the tuner/frontend happier getting a lock on all the muxes. It
depends on whether the problem is a weak signal or a too strong signal.

Of course it might be something else altogether, but this sort of thing
is precisely the kind of rubbish we have to deal with during the UK
digital switchover.

Regards,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Sun, 2011-08-14 at 16:56 -0700, Chris Rankin wrote:
> --- On Mon, 15/8/11, Antti Palosaari <crope@iki.fi> wrote:
> > T 554000000 8MHz + auto auto auto etc.
> > is enough.
> 
> Hmm, not here it isn't:
> 
> $ scandvb -u -vvv uk-CrystalPalace 
> scanning uk-CrystalPalace
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 554000000 0 9 9 6 2 4 4
> >>> tune to: 554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO
> >>> tuning status == 0x00
> >>> tuning status == 0x00
> >>> tuning status == 0x00
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> WARNING: >>> tuning failed!!!
> >>> tune to: 554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO (tuning failed)
> >>> tuning status == 0x00
> >>> tuning status == 0x00
> >>> tuning status == 0x00
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> >>> tuning status == 0x0f
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> 
> Although it was working (briefly) on Saturday morning.
> 
> > Have you tried it on Windows?
> 
> No, because I don't own a Windows machine.
> 
> Cheers,
> Chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

