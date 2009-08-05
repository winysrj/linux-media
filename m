Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:46635 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663AbZHEVrL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Aug 2009 17:47:11 -0400
Subject: Re: Issue with LifeView FlyDVB-T Duo CardBus.
From: hermann pitton <hermann-pitton@arcor.de>
To: Francesco Marangoni <fmarangoni@libero.it>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <KNX5SY$6C51C56E77BDD749002D37C1F5412E1A@libero.it>
References: <KNX5SY$6C51C56E77BDD749002D37C1F5412E1A@libero.it>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 23:28:10 +0200
Message-Id: <1249507690.4068.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Francesco,

Am Mittwoch, den 05.08.2009, 21:50 +0200 schrieb Francesco Marangoni:
> Hermann,
> 
> thankyou very much for your support. Do you have any suggestion for a light linux distribution with a recent and vanilla kernel. In the last month i tried TinyMe and Ubuntu Lite. Is it possible to install a recent vanilla kernel on the version of ubuntu lite i'm using?
> Thanks.
> 

can't tell it, but it seems u-lite is not prepared for custom kernels.

http://u-lite.org/content/custom-kernel

The LIVE CD has only 356MB.

The card is supported since years, you don't need latest for it.
The radio support was added a little later.

If it should be fairly new, maybe they changed something without
changing the PCI subsystem. Would be very unusual for LifeView products.

That is why I'm asking also for the logs of the analog tuner.
On analog a changed tuner address would be detected, but that is not the
case for DVB-T.

Cheers,
Hermann


