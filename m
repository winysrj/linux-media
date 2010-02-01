Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:58866 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0BAJ4c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 04:56:32 -0500
Date: Mon, 1 Feb 2010 10:56:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135  
 variants
Message-ID: <20100201105628.77057856@hyperion.delvare>
In-Reply-To: <1264986995.21486.20.camel@pc07.localdom.local>
References: <20100127120211.2d022375@hyperion.delvare>
	<4B630179.3080006@redhat.com>
	<1264812461.16350.90.camel@localhost>
	<20100130115632.03da7e1b@hyperion.delvare>
	<1264986995.21486.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

On Mon, 01 Feb 2010 02:16:35 +0100, hermann pitton wrote:
> For now, I only faked a P7131 Dual with a broken IR receiver on a 2.6.29
> with recent, you can see that gpio 0x40000 doesn't go high, but your
> patch should enable the remote on that P7131 analog only.

I'm not sure why you had to fake anything? What I'd like to know is
simply if my first patch had any negative effect on other cards.

-- 
Jean Delvare
