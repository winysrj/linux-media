Return-path: <mchehab@pedra>
Received: from smtp1.Stanford.EDU ([171.67.219.81]:36355 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751523Ab0JMWN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 18:13:56 -0400
Message-ID: <4CB62CB5.9000706@stanford.edu>
Date: Wed, 13 Oct 2010 15:03:33 -0700
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sung Hee Park <shpark7@stanford.edu>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>	<201010111514.37592.laurent.pinchart@ideasonboard.com>	<AANLkTikBWjgNmDdG6dCXQQmcDRBUc4gP7717uqAY3+_J@mail.gmail.com>	<201010111707.21537.laurent.pinchart@ideasonboard.com>	<AANLkTiks9qzC6W4iyu2_QWkWeK-cN-pTOS=trGxeRF=6@mail.gmail.com> <AANLkTimzU8rR2a0=gTLX8UOxGZaiY0gxx4zTr2VH-iMa@mail.gmail.com>
In-Reply-To: <AANLkTimzU8rR2a0=gTLX8UOxGZaiY0gxx4zTr2VH-iMa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 Hi Laurent, linux-media,

We've been working on porting our OMAP3 ISP/mt9p031 Frankencamera framework forward to the current kernel versions (currently, we're using the N900 ISP driver codebase, which is rather old by now).  We'd been following Sakari's omap3camera tree, but as is clear from this discussion, that's a bad idea now.

(I'd love to just send out our mt9p031 driver code, but we still haven't sorted out whether we're free to do so - since we're rewriting it a great deal anyway, it hasn't been a priority to sort out.)

I've been handing off dev work on this to the next set of students on the project, so I haven't been paying much attention to the mailing lists recently, and I apologize if these questions have had clear answers already.

Assuming one has a driver that works fine on the old v4l2_int_framework back in .28-n900 kernel version - what is the best way forward to move it to the 'current best option' framework, whatever that's currently considered to be for the OMAP3 ISP?  And for whatever option that is, is there a document somewhere describing what needs to hooked up to what to make that go, or is the best way to just look at the *-rx51 / et8ek8 code in the right git repository?

Any advice would be appreciated!

Eino-Ville Talvala
Camera 2.0 Project
Stanford University
