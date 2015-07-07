Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:48667 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354AbbGGQbN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2015 12:31:13 -0400
Date: Tue, 7 Jul 2015 18:31:08 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Peter Fassberg <pf@leissner.se>
Cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
Message-ID: <20150707183108.3afee7e6@lappi3.parrot.biz>
In-Reply-To: <20150707182541.0960177f@lappi3.parrot.biz>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
	<20150705184449.0017f114@lappi3.parrot.biz>
	<alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se>
	<20150707173500.21041ab3@dibcom294.coe.adi.dibcom.com>
	<alpine.BSF.2.20.1507071736350.72900@nic-i.leissner.se>
	<20150707182541.0960177f@lappi3.parrot.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Jul 2015 18:25:41 +0200
Patrick Boettcher <patrick.boettcher@posteo.de> wrote:

> > [  301.275434] si2168 1-0064: firmware version: 4.0.4 [  301.284625] si2157 2-0060: found a 'Silicon Labs Si2157-A30'
> > [  301.340643] si2157 2-0060: firmware version: 3.0.5

> Can you easily try more recent kernels or media_trees?

It seems you are already using a more recent version of the
si21xx-drivers than provided with 3.16. (in 3.16.0 there is no firmware
version-print in si2157)

--
Patrick.
