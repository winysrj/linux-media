Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:42494 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbZK0A2d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 19:28:33 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ?
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
	<E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
	<829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
	<E88E119C-BB86-4F01-8C2C-E514AC6BA5E2@wilsonet.com>
	<m3skc249ev.fsf@intrepid.localdomain>
	<20091126055302.GI23244@core.coreip.homeip.net>
	<m37htduo3i.fsf@intrepid.localdomain>
	<20091126232809.GE6936@core.coreip.homeip.net>
Date: Fri, 27 Nov 2009 01:28:36 +0100
In-Reply-To: <20091126232809.GE6936@core.coreip.homeip.net> (Dmitry Torokhov's
	message of "Thu, 26 Nov 2009 15:28:09 -0800")
Message-ID: <m34oogste3.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> There are binary sysfs attributes.

Aren't they to be used for things like ROMs and EEPROMs exclusively?

> For ioctl you also need to open and
> close the device.

Sure, but I do it once.

> Plus, how often do you expect to perform this
> operation? Don't you think you are trying to optimize something that
> does not have any real performavnce impact here?

Maybe, anyway it will have to work before it's included in the kernel,
so I don't worry too much about it. Perhaps we should then merge the
lirc patches so both driver sets can be improved?
-- 
Krzysztof Halasa
