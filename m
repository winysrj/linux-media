Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:43728 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233AbbGHHde (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jul 2015 03:33:34 -0400
Date: Wed, 8 Jul 2015 09:33:30 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Peter Fassberg <pf@leissner.se>
Cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
Message-ID: <20150708093330.4e06d388@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <alpine.BSF.2.20.1507071845250.72900@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
	<20150705184449.0017f114@lappi3.parrot.biz>
	<alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se>
	<20150707173500.21041ab3@dibcom294.coe.adi.dibcom.com>
	<alpine.BSF.2.20.1507071736350.72900@nic-i.leissner.se>
	<20150707182541.0960177f@lappi3.parrot.biz>
	<alpine.BSF.2.20.1507071845250.72900@nic-i.leissner.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Jul 2015 18:51:16 +0200 (SST) Peter Fassberg <pf@leissner.se>
wrote:

> On Tue, 7 Jul 2015, Patrick Boettcher wrote:
> 
> > Might be the RF frequency that is truncated on 32bit platforms
> > somewhere. That could explain that there is no crash but simply not
> > tuning.
> 
> This is the current status:
> 
> ARM 32-bit, kernel 4.0.6, updated media_tree: Works with DVB-T, no lock on DVB-T2.
> 
> Intel 32-bit, kernel 3.16.0, standard media_tree: Locks, but no PSIs detected.
> 
> Intel 64-bit, kernel 3.16.0, standard media_tree: Works like a charm.
> 
> 
> So I don't think that en RF freq is truncated.

Yes, it was an assumption - not a right one as it turned out. I didn't
find any obvious 32/64-problem in the si*-drivers you are using.

I'm too afraid to look into the em*-drivers and I doubt that there is
any obvious 32/64-bit-problem.

If I were you, I would try to compare the usb-traffic (using
usbmon with wireshark) between a working tune on one frequency with one
standard on each of the 3 scenarios (maybe starting with the intel 32
and 64 platform).

For example

on each platform:

1) start wireshark-capture on the right USB-port,
2) plug the device, 
3) tune (tzap) a valid DVB-T frequency
4) stop capturing

Then compare the traffic log. Most outgoing data should be
identical. Incoming data (except monitoring values and TS) should be
equal as well.

If you see differences in data-buffer-sizes or during the
firmware-download-phase or anywhere else, we can try to find the code
which corresponds and place debug messages. You are lucky, your drivers
are using embedded firmwares which simplifies the communication between
the driver and the device.

regards,
--
Patrick.
