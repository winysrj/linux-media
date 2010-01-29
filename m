Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58911 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab0A2UO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 15:14:58 -0500
Received: by bwz27 with SMTP id 27so1769323bwz.21
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 12:14:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B633E1D.2050609@redhat.com>
References: <4B60F901.20301@redhat.com>
	 <1264731845.3095.16.camel@palomino.walls.org>
	 <829197381001290922p69a68ce5k3f5192f427f4658a@mail.gmail.com>
	 <4B632BB8.3000904@redhat.com>
	 <829197381001291057o5b94d1d7k4d5f7f6d7251101f@mail.gmail.com>
	 <4B633E1D.2050609@redhat.com>
Date: Fri, 29 Jan 2010 15:14:55 -0500
Message-ID: <829197381001291214m40d8aae2gac445975ce59e107@mail.gmail.com>
Subject: Re: cx18 fix patches
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 29, 2010 at 2:59 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The asynchronous load were added not to improve the boot load time, but to
> avoid some troubles that happens when the load is synchronous.
> I don't remember what were the exact trouble, but I suspect that it was
> something related to i2c. The result was that, sometimes, the driver
> used to enter into a deadlock state (something like driver A waits for driver B
> to load, but, as driver B needs functions provided by driver A, both are put
> into sleep).

It would be good if you could locate some specifics in terms of what
prompted this.

> Also, reducing the driver load time is a good thing. The asynchronous load
> is very interesting for devices where the firmware load takes a very long time.

I do not believe that loading the module synchronously will have any
impact on the actual load time, since other modules can be loading in
parallel to the initialization of the em28xx device (regardless of
whether it is a single module, or three modules loading synchronously
or asynchronously).

Also, for xc3028 in particular, we could defer firmware loading until
first use like we do with xc5000 - doing the firmware load at driver
init isn't very useful anyway since we load the firmware and then
immediately and put the device to sleep.

> Maybe one alternative would be to register the interfaces asynchronously
> also, as a deferred task that is started only after the driver enters into
> a sane state.

Potentially.  I feel this should really only be done though in
response to an actual problem/bug.  Otherwise it adds additional
complexity with no real benefit.

> As the problem is common, the better is to provide a global way to avoid
> device open while the initialization is not complete, at the v4l core.

I would be in favor of this, although I am not sure how practical it
is given the diversity in the way different bridges are implemented.
Also, we would need to take into account how this would work with DVB,
since many of the races we run into are applications attempting to use
both the v4l and dvb interfaces of a hybrid device.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
