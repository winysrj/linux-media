Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:40649 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1IUTRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 15:17:35 -0400
Date: Wed, 21 Sep 2011 21:17:26 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: cx231xx: DMA problem on ARM
Message-ID: <20110921211726.26de775e@skate>
In-Reply-To: <CAGoCfiyFbHcZO-Rz2VFr249NprqvhQhcSPBLHRj_Txs9gimYqA@mail.gmail.com>
References: <20110921135604.64363a2e@skate>
	<CAGoCfiyFbHcZO-Rz2VFr249NprqvhQhcSPBLHRj_Txs9gimYqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Devin,

Thanks for your quick reply.

Le Wed, 21 Sep 2011 08:04:52 -0400,
Devin Heitmueller <dheitmueller@kernellabs.com> a écrit :

> I ran into the same issue on em28xx in the past (which is what those
> parts of cx231xx are based on).  Yes, just adding
> URB_NO_TRANSFER_DMA_MAP should result in it starting to work.  Please
> try that out, and assuming it works feel free to submit a patch which
> can be included upstream.

Ok, we'll try this out and report the results, and if those are
positive, the corresponding patch.

Regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
