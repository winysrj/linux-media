Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:56765 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbZKZU2L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 15:28:11 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jarod@wilsonet.com,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDcbizrJjFB@christoph> <4B0EABF8.9000902@redhat.com>
	<m3r5rlupcb.fsf@intrepid.localdomain> <4B0ECF1B.1090103@redhat.com>
Date: Thu, 26 Nov 2009 21:28:14 +0100
In-Reply-To: <4B0ECF1B.1090103@redhat.com> (Mauro Carvalho Chehab's message of
	"Thu, 26 Nov 2009 16:55:23 -0200")
Message-ID: <m3tywhrpy9.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> The removal of the existing keymaps from kernel depends on having an
> application
> to be called from udev to load the proper keymaps when a device is probed.
>
> After having it for a while, we should deprecate the in-kernel keymaps
> and move them to userspace.

Sounds like a plan.

> I also think that it is important to remove the 7 bits limitation from
> all drivers
> and re-generate the keymaps, since they'll change after it.

I think the existing space/mark media drivers need to be reworked
completely.
-- 
Krzysztof Halasa
