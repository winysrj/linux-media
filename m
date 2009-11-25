Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:42318 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZKYUom (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 15:44:42 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: lirc@bartelmus.de (Christoph Bartelmus), awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
	<E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
Date: Wed, 25 Nov 2009 21:44:45 +0100
In-Reply-To: <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com> (Jarod
	Wilson's message of "Wed, 25 Nov 2009 13:07:06 -0500")
Message-ID: <m31vjm5o76.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson <jarod@wilsonet.com> writes:

> Took me a minute to figure out exactly what you were talking about.
> You're referring to the current in-kernel decoding done on an ad-hoc
> basis for assorted remotes bundled with capture devices, correct?

Yes.

> Well, is there any reason most of those drivers with
> currently-in-kernel-but-badly-broken decoding can't be converted to
> use the lirc interface if its merged into the kernel?

For many of them "lirc mode" can be easily _added_.
-- 
Krzysztof Halasa
