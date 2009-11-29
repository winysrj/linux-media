Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZK2QCJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 11:02:09 -0500
Message-ID: <4B129AE5.2020004@redhat.com>
Date: Sun, 29 Nov 2009 14:01:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <m3r5riy7py.fsf@intrepid.localdomain>	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	 <4B116954.5050706@s5r6.in-berlin.de>	 <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>	 <4B117DEA.3030400@s5r6.in-berlin.de>	 <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com>	 <4B11881B.7000204@s5r6.in-berlin.de>	 <9e4733910911281246r65670e1free76e98ff4a23822@mail.gmail.com>	 <4B119A36.8020903@s5r6.in-berlin.de>	 <9e4733910911281410i75bf19b7xa4dfd6ad1dc1b748@mail.gmail.com> <9e4733910911281418s702489e5t418eab5623c2af98@mail.gmail.com>
In-Reply-To: <9e4733910911281418s702489e5t418eab5623c2af98@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> I'm looking at a Sony multi-function remote right now. It has five
> devices and forty keys. Each of the five devices can transmit 0-9,
> power, volume, etc. It transmits 5*40 = 200 unique scancodes.
> 
> I want the five devices to correspond to five apps. What's the plan
> for splitting those 200 scancodes into the five apps?
> 
> I did it by creating five evdev devices each mapping 40 scancodes.
> That's lets me reuse KP_1 for each of the five apps.
> 
> 

In this case, the evdev interface won't solve the issue alone. Some sort
of userspace tool will need to identify what application is expecting that
code and redirect it to that application.

IMO, the biggest LIRC benefit over a pure evdev interface, from user's perspective,
is that it can redirect a keycode to a specific application.

Yet, I don't see why your configfs proposal will solve this issue, as userspace
will keep receiving duplicated KET_
