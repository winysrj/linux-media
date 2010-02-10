Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:56836 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab0BJRAX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 12:00:23 -0500
Date: Wed, 10 Feb 2010 18:00:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Daro <ghost-rider@aster.pl>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135   
 variants
Message-ID: <20100210180017.0d341d1f@hyperion.delvare>
In-Reply-To: <4B72E0FA.5000303@aster.pl>
References: <20100127120211.2d022375@hyperion.delvare>
	<4B630179.3080006@redhat.com>
	<1264812461.16350.90.camel@localhost>
	<20100130115632.03da7e1b@hyperion.delvare>
	<1264986995.21486.20.camel@pc07.localdom.local>
	<20100201105628.77057856@hyperion.delvare>
	<1265075273.2588.51.camel@localhost>
	<20100202085415.38a1e362@hyperion.delvare>
	<1265153571.3194.14.camel@pc07.localdom.local>
	<4B72E0FA.5000303@aster.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daro,

On Wed, 10 Feb 2010 17:38:18 +0100, Daro wrote:
> If some tests on my machine could be helpfull just let me know.

Definitely. If you could please test both patches I sent (first one on
2010-01-27, second one on 2010-01-30, both should be in your mailbox)
and confirm that they both work for you (so you no longer need to pass
card=146 to the driver), that would be great.

Mauro doesn't seem to be willing to apply the first patch, but for
future reference I would still be interested to know if it would work
at least in your case. The second patch is what Mauro is likely to
apply, so it would be good to make sure it fixes your problem before
actually applying it.

Thanks!

-- 
Jean Delvare
