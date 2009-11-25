Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:51925 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759446AbZKYRkj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 12:40:39 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: lirc@bartelmus.de (Christoph Bartelmus)
Cc: awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDZb9P9ZjFB@christoph>
Date: Wed, 25 Nov 2009 18:40:42 +0100
In-Reply-To: <BDZb9P9ZjFB@christoph> (Christoph Bartelmus's message of "25 Nov
	2009 18:20:00 +0100")
Message-ID: <m3skc25wpx.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc@bartelmus.de (Christoph Bartelmus) writes:

> I'm not sure what two ways you are talking about. With the patches posted  
> by Jarod, nothing has to be changed in userspace.
> Everything works, no code needs to be written and tested, everybody is  
> happy.

The existing drivers use input layer. Do you want part of the tree to
use existing lirc interface while the other part uses their own
in-kernel (badly broken for example) code to do precisely the same
thing?

We can have a good code for both, or we can end up with "badly broken"
media drivers and incompatible, suboptimal existing lirc interface
(though most probably much better in terms of quality, especially after
Jarod's work).
-- 
Krzysztof Halasa
