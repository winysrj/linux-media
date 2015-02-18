Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34003 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbbBRRA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 12:00:58 -0500
Message-ID: <1424278854.3727.47.camel@pengutronix.de>
Subject: Re: [RFC v01] Driver for Toshiba TC358743 CSI-2 to HDMI bridge
From: Philipp Zabel <p.zabel@pengutronix.de>
To: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
Cc: linux-media@vger.kernel.org, hansverk@cisco.com
Date: Wed, 18 Feb 2015 18:00:54 +0100
In-Reply-To: <54E363F8.5050608@cisco.com>
References: <1418667661-21078-1-git-send-email-matrandg@cisco.com>
	 <1424163029.3841.15.camel@pengutronix.de> <54E363F8.5050608@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mats,

Am Dienstag, den 17.02.2015, 16:53 +0100 schrieb Mats Randgaard
(matrandg):
> > I think this calculation should include the blanking intervals.
> 
> As far as I understand is only the active video from the HDMI interface 
> transferred on the CSI interface, so I think this calculation is 
> correct. We transfer 1080p60 video on four lanes with 823.5 Mbps/lane, 
> which would not have been possible if the blanking should have been 
> transferred as well ((2200 * 1125 * 60 * 24) bps / 823.5 Mbps/lane  = 
> 4.33 lanes.

You are right, I confused the "reference" and "minimum" suitable CSI
lane speed fields in REF_02. There ought to be _some_ overhead though?
(1920 * 1080 * 60 * 24) bps = 746.496 Mbps, but REF_02 suggests a
minimum of 820.92 Mbps per lane (reference is 891 Mbps as expected).

[...]
> >> +	i2c_wr32(sd, HSTXVREGEN,
> >> +			((lanes > 0) ? MASK_CLM_HSTXVREGEN : 0x0) |
> >> +			((lanes > 0) ? MASK_D0M_HSTXVREGEN : 0x0) |
> >> +			((lanes > 1) ? MASK_D1M_HSTXVREGEN : 0x0) |
> >> +			((lanes > 2) ? MASK_D2M_HSTXVREGEN : 0x0) |
> >> +			((lanes > 3) ? MASK_D3M_HSTXVREGEN : 0x0));
> >> +
> >> +	i2c_wr32(sd, TXOPTIONCNTRL, MASK_CONTCLKMODE);
> > Since anything below can't be undone without pulling CTXRST, I propose
> > to split tc358743_set_csi into tc358743_set_csi (above) and
> > tc358743_start_csi (below).
> >
> > To make this driver work with the Synopsys DesignWare MIPI CSI-2 Host
> > Controller, there needs to be a time when the lanes are in stop state
> > first, so the host can synchronize. I'd then like to call start_csi in
> > s_stream only.
> 
> With help from Toshiba we have now implemented start and stop of the CSI 
> interface without pulling CTXRST. You can see our solution in the next 
> RFC, and I would appreciate if you could test if that works fine for you 
> as well!

I'm looking forward to it.

regards
Philipp

