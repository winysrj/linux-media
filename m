Return-path: <linux-media-owner@vger.kernel.org>
Received: from helios.cedo.cz ([193.165.198.226]:33601 "EHLO postak.cedo.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZAZHMS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 02:12:18 -0500
Message-ID: <000f01c97f85$c013f0c0$f4c6a5c1@tommy>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: <linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
References: <497C95A3.3020704@night-light.net>
Subject: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on HDchannels
Date: Mon, 26 Jan 2009 08:14:38 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Nat Geo HD and Histoy Channel HD are the only two HD channels I can
> lock, and I have problems with digital artefacts, lines across the
> screen missing data and tons of errors from the frontend. See below for
> error log.

Hi Jonas,
just guessing - try another card slot. If there are more devices on one IRQ
the transfer speed from the card can be lower and causing problems at
channels with higher bitrate. I had similar colision between PCI network and
sound cards. When I moved one card to another slot, the problem was solved.

Regards,
Tomas

