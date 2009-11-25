Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:37129 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759819AbZKYUrp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 15:47:45 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:  Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
	<E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
	<829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
Date: Wed, 25 Nov 2009 21:47:48 +0100
In-Reply-To: <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
	(Devin Heitmueller's message of "Wed, 25 Nov 2009 13:20:21 -0500")
Message-ID: <m3ws1e49hn.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller@kernellabs.com> writes:

> The other key thing I don't think we have given much thought to is the
> fact that in many tuners, the hardware does RC decoding and just
> returns NEC/RC5/RC6 codes.  And in many of those cases, the hardware
> has to be configured to know what format to receive.  We probably need
> some kernel API such that the hardware can tell lirc what formats are
> supported, and another API call to tell the hardware which mode to
> operate in.

For such cases, I wouldn't bother with lirc mode. Input layer + key
mapping with ioctl (probably improved), and lircd can grab events from
input layer if needed.
-- 
Krzysztof Halasa
