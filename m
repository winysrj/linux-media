Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:33821 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbZKZSj5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 13:39:57 -0500
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
Date: Thu, 26 Nov 2009 19:40:01 +0100
In-Reply-To: <20091126055302.GI23244@core.coreip.homeip.net> (Dmitry
	Torokhov's message of "Wed, 25 Nov 2009 21:53:02 -0800")
Message-ID: <m37htduo3i.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> Why would sysfs write be slower than ioctl?

Sysfs is generally one-value, one-file. open, read/write, close.
ioctl() OTOH does everything (e.g. a whole key table) in one syscall.
-- 
Krzysztof Halasa
