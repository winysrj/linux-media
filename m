Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:55923 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbZKYQpl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 11:45:41 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Andy Walls <awalls@radix.net>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>
	<1259024037.3871.36.camel@palomino.walls.org>
Date: Wed, 25 Nov 2009 17:45:44 +0100
In-Reply-To: <1259024037.3871.36.camel@palomino.walls.org> (Andy Walls's
	message of "Mon, 23 Nov 2009 19:53:57 -0500")
Message-ID: <m3k4xe7dtz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls <awalls@radix.net> writes:

> I would also note that RC-6 Mode 6A, used by most MCE remotes, was
> developed by Philips, but Microsoft has some sort of licensing interest
> in it and it is almost surely encumbered somwhow:

I don't know about legal problems in some countries but from the
technical POV handling the protocol in the kernel is more efficient
or (/and) simpler.
-- 
Krzysztof Halasa
