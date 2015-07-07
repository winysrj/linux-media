Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.leissner.se ([212.3.1.210]:30032 "EHLO
	mailgate.leissner.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbGGQv3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2015 12:51:29 -0400
Date: Tue, 7 Jul 2015 18:51:16 +0200 (SST)
From: Peter Fassberg <pf@leissner.se>
To: Patrick Boettcher <patrick.boettcher@posteo.de>
cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
In-Reply-To: <20150707182541.0960177f@lappi3.parrot.biz>
Message-ID: <alpine.BSF.2.20.1507071845250.72900@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se> <20150705184449.0017f114@lappi3.parrot.biz> <alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se> <20150707173500.21041ab3@dibcom294.coe.adi.dibcom.com> <alpine.BSF.2.20.1507071736350.72900@nic-i.leissner.se>
 <20150707182541.0960177f@lappi3.parrot.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Jul 2015, Patrick Boettcher wrote:

> Might be the RF frequency that is truncated on 32bit platforms
> somewhere. That could explain that there is no crash but simply not
> tuning.

This is the current status:

ARM 32-bit, kernel 4.0.6, updated media_tree: Works with DVB-T, no lock on DVB-T2.

Intel 32-bit, kernel 3.16.0, standard media_tree: Locks, but no PSIs detected.

Intel 64-bit, kernel 3.16.0, standard media_tree: Works like a charm.


So I don't think that en RF freq is truncated.



-- Peter

