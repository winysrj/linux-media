Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:49933 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1IXSE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 14:04:28 -0400
Date: Sat, 24 Sep 2011 20:04:18 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: "Sri Deevi" <Srinivasa.Deevi@conexant.com>
Cc: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Maxime Ripard" <maxime.ripard@free-electrons.com>
Subject: Re: cx231xx: DMA problem on ARM
Message-ID: <20110924200418.64cdc73f@skate>
In-Reply-To: <34B38BE41EDBA046A4AFBB591FA311320506479CF0@NBMBX01.bbnet.ad>
References: <20110921135604.64363a2e@skate>
	<CAGoCfiyFbHcZO-Rz2VFr249NprqvhQhcSPBLHRj_Txs9gimYqA@mail.gmail.com>
	<20110922164508.395c2900@skate>
	<CAGoCfiy_RVbgq+3WTsC=ZrJsOfDYEWUov6meOU8=ShACBM7J2g@mail.gmail.com>
	<20110922172929.16df967f@skate>
	<20110923140404.5816c056@skate>
	<34B38BE41EDBA046A4AFBB591FA311320506479CF0@NBMBX01.bbnet.ad>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Srinivasa,

Le Fri, 23 Sep 2011 05:26:07 -0700,
"Sri Deevi" <Srinivasa.Deevi@conexant.com> a écrit :

> Do you have USB Analyzer (hardware) ? If so, Is it possible to take a
> trace and compare it with x86 trace to see for any obvious
> differences ?

Unfortunately, I don't have an hardware USB analyzer to do such a
comparison.

> I am actually confused why set interface fails in the
> log. The device is very simple one with no firmware and is totally
> controlled by hardware itself. So far we had never seen any issue,
> though never tried with any other ARM based devices. Not sure if
> anybody had tried already. 

Seems like nobody ever tried to use this device on an ARM platform,
unfortunately.

Regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
