Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:53206 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZBYNLQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 08:11:16 -0500
Message-ID: <49A5436F.8000908@kaiser-linux.li>
Date: Wed, 25 Feb 2009 14:11:11 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Adam Baker <linux@baker-net.org.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	Olivier Lorin <o.lorin@laposte.net>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <20090223080715.0c97774e@pedra.chehab.org> <200902232237.32362.linux@baker-net.org.uk> <alpine.LNX.2.00.0902231730410.13397@banach.math.auburn.edu> <alpine.LRH.2.00.0902241723090.6831@pedra.chehab.org> <alpine.LNX.2.00.0902241449020.15189@banach.math.auburn.edu> <alpine.LRH.2.00.0902242153490.6831@pedra.chehab.org> <49A4B4FC.9030209@kaiser-linux.li> <alpine.LNX.2.00.0902242341070.15857@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0902242341070.15857@banach.math.auburn.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 >> Actually, this happens and is happening!

I got OT. I just needed to vent!

Sorry for the spam.

For the sensor mounting, I think the cam knows how the sensor is mounted 
and therefor the driver knows (driver -> first abstraction layer between 
software and hardware). Therefor the drive has to report the sensor 
orientation to user space (read only).

Thomas

PS: May be, I am OT all ready.


