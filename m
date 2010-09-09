Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:4164 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792Ab0IIVhn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 17:37:43 -0400
Subject: Re: [PATCH] Illuminators and status LED controls
From: Andy Walls <awalls@md.metrocast.net>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>
In-Reply-To: <4C88DE80.1050207@redhat.com>
References: <e3kwq01m3v9rvkx9fdhst6mo.1284042856851@email.android.com>
	 <4C88DE80.1050207@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 17:37:10 -0400
Message-ID: <1284068230.4438.1.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 2010-09-09 at 15:17 +0200, Hans de Goede wrote:
> Hi,
> 
> On 09/09/2010 04:41 PM, Andy Walls wrote:
> > Hans de Goede,
> >
> > The uvc API that creates v4l2 ctrls on behalf of userspace could intercept those calls and create an LED interface instead of, or in addition to, the v4l2 ctrl.
> 
> That would mean special casing certain extension controls which I
> don't think is something which we want to do.

I concur, it's a kludge.

I was careful to word my original statement with "could".

Regards,
Andy


> Regards,
> 
> Hans


