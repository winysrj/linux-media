Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:53873 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1IZINe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 04:13:34 -0400
Date: Mon, 26 Sep 2011 10:13:23 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: cx231xx: DMA problem on ARM
Message-ID: <20110926101323.41708d64@skate>
In-Reply-To: <4E7D3D5A.6030008@redhat.com>
References: <20110921135604.64363a2e@skate>
	<CAGoCfiyFbHcZO-Rz2VFr249NprqvhQhcSPBLHRj_Txs9gimYqA@mail.gmail.com>
	<20110922164508.395c2900@skate>
	<CAGoCfiy_RVbgq+3WTsC=ZrJsOfDYEWUov6meOU8=ShACBM7J2g@mail.gmail.com>
	<20110922172929.16df967f@skate>
	<20110923140404.5816c056@skate>
	<4E7D3D5A.6030008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Le Fri, 23 Sep 2011 23:15:54 -0300,
Mauro Carvalho Chehab <mchehab@redhat.com> a écrit :

> > And still the result is the same: we get a first frame, and then
> > nothing more, and we have a large number of error messages in the
> > kernel logs.
> 
> I don't think that this is related to the power manager anymore. It can
> be related to cache coherency and/or to iommu support.

As you suspected, increasing PWR_SLEEP_INTERVAL didn't change anything.
What do you suggest to track down the potential cache coherency issues ?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
