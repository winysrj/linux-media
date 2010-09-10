Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:31039 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068Ab0IJNkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:40:41 -0400
Subject: Re: [PATCH] Illuminators and status LED controls
From: Andy Walls <awalls@md.metrocast.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>,
	Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20100909080702.1687d29a@tele>
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
	 <4C86F210.2060605@stanford.edu>
	 <20100908075903.GE29776@besouro.research.nokia.com>
	 <1283963858.6372.81.camel@morgan.silverblock.net>
	 <87fwxkcbat.fsf@macbook.be.48ers.dk>  <20100909080702.1687d29a@tele>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 09:40:11 -0400
Message-ID: <1284126011.2123.90.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 2010-09-09 at 08:07 +0200, Jean-Francois Moine wrote:
> On Wed, 08 Sep 2010 20:58:18 +0200

> Hi,
> 
> If I may resume this exchange:
> 
> - the (microscope or device dependant) illuminators may be controlled
>   by v4l2,

I agree.


> - the status LED should be controlled by the LED interface.

I agree.  However, I think it is overkill based on my perception of
future utilization by end users.

I recommend ultimately implementing something in the v4l2 infrastructure
that helps v4l2 drivers expose LEDs via the LED API easily and
uniformly.  Maybe that can start with a gspca framework implementation,
which then evolves to the v4l2 infrastructure implementation.

Regards,
Andy

