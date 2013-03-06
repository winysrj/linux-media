Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:24297 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab3CFPDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 10:03:46 -0500
Date: Wed, 6 Mar 2013 16:03:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: TerraTec Cinergy T PCIe Dual not working
Message-ID: <20130306160335.01cc5cd4@endymion.delvare>
In-Reply-To: <51374B6D.9010805@schinagl.nl>
References: <20130306142713.6a68179a@endymion.delvare>
	<51374B6D.9010805@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

Thanks for your fast reply.

On Wed, 06 Mar 2013 14:58:05 +0100, Oliver Schinagl wrote:
> I have the same card, and have not much problems. I have some reception 
> issues, but I don't think it's to blame on the card (yet). I do use 
> tvheadend however.
> 
> In anycase, can you use w_scan or dvb-scan?

I have neither but I have "scan" from package "dvb" which does work.
This gave me the idea to re-run scan with different frequency files and
different antennas.

It turns out that my problem is the antenna. I was using the antenna I
have been using with my previous card, which is an internal DVB-T
antenna with amplification (external power supply.) I get zero signal
with that. But using the Terratec-provided cheap "stick" antenna, I get
signal again, with reasonable quality (although not as stable as with
the old card and the powered antenna.) I also get signal (but not all
channels) with my original antenna _unpowered_ (thus signal not
amplified.)

I admit I don't quite understand. I would understand that a bad,
unpowered antenna causes no signal to be sensed. But how is it possible
that a supposedly better, powered antenna causes that kind of issue?

Oliver, out of curiosity, what antenna are you using? The
Terratec-provided one, or another one?

-- 
Jean Delvare
