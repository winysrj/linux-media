Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36525 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbdK0KLv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 05:11:51 -0500
Date: Mon, 27 Nov 2017 02:11:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sean Young <sean@mess.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Improve CEC autorepeat handling
Message-ID: <20171127101147.pgexdet3bju22o5q@dtor-ws>
References: <cover.1511523174.git.sean@mess.org>
 <20171125234752.2z46d3ya7qiaovby@dtor-ws>
 <27b40fb8-a422-e43d-45d4-b4f763f7b82a@xs4all.nl>
 <20171127094724.6cjl6zex46y6wgfd@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127094724.6cjl6zex46y6wgfd@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 27, 2017 at 09:47:24AM +0000, Sean Young wrote:
> Hi Hans,
> 
> On Mon, Nov 27, 2017 at 10:13:51AM +0100, Hans Verkuil wrote:
> > On 11/26/2017 12:47 AM, Dmitry Torokhov wrote:
> > > On Fri, Nov 24, 2017 at 11:43:58AM +0000, Sean Young wrote:
> > >> Due to the slowness of the CEC bus, autorepeat handling rather special
> > >> on CEC. If the repeated user control pressed message is received, a 
> > >> keydown repeat should be sent immediately.
> > > 
> > > This sounds like you want to have hardware autorepeat combined with
> > > software one. This seems fairly specific to CEC and I do not think that
> > > this should be in input core; but stay in the driver.
> > > 
> > > Another option just to decide what common delay for CEC autorepeat is
> > > and rely on the standard autorepeat handling. The benefit is that users
> > > can control the delay before autorepeat kicks in.
> > 
> > They are not allowed to. Autorepeat is only allowed to start when a second
> > keydown message arrives within 550 ms as per the spec. After that autorepeat
> > continues as long as keydown messages are received within 550ms from the
> > previous one. The actual REP_PERIOD time is unrelated to the frequency of
> > the CEC messages but should be that of the local system.

Not allowed by whom? If I, as a user, want my remote to start
autorepeating after 400 msec instead of 550, will the police come and
fine me? Please do not confuse the default behavior with allowed one.
The only restriction is that if you have not seen messages for longer
than 550 msecs you should "release" the key.

> > 
> > The thing to remember here is that CEC is slooow (400 bits/s) so you cannot
> > send messages at REP_PERIOD rate. You should see it as messages that tell
> > you to enter/stay in autorepeat mode. Not as actual autorepeat messages.

Right, and they do not have to match autorepeat timings, just control
whether we should continue repeating or generate release event.

> > 
> > > 
> > >>
> > >> By handling this in the input layer, we can remove some ugly code from
> > >> cec, which also sends a keyup event after the first keydown, to prevent
> > >> autorepeat.
> > > 
> > > If driver does not want input core to handle autorepeat (but handle
> > > autorepeat by themselves) they should indicate it by setting appropriate
> > > dev->rep[REP_DELAY] and dev->rep[REP_PERIOD] before calling
> > > input_register_device(). This will let input core know that it should
> > > not setup its autorepeat timer.
> > 
> > That only means that I have to setup the autorepeat timer myself, there
> > is no benefit in that :-)
> > 
> > Sean, I kind of agree with Dmitry here. The way autorepeat works for CEC
> > is pretty specific to that protocol and unlikely to be needed for other
> > protocols.
> 
> That's a valid point, I guess. The only downside is special case handling
> outside the input layer, which would be much simpler in the input layer.
> 
> > It is also no big deal to keep knowledge of that within cec-adap.c.
> 
> So first of all, the sii8620 uses the CEC protocol as well (see commit
> e25f1f7c94e1 drm/bridge/sii8620: add remote control support), so this
> will have to go into rc-core, not cec-adap.c. There was a discussion about
> some time ago.
> 
> The current implementation has an ugly key up event which would be nice
> to do without.
> 
> > The only thing that would be nice to have control over is that with CEC
> > userspace shouldn't be able to change REP_DELAY and that REP_DELAY should
> > always be identical to REP_PERIOD. If this can be done easily, then that
> > would be nice, but it's a nice-to-have in my opinion.

You could do that by catching EV_REP events in your driver, but I do not
see why you want to remove this flexibility from users. Again, if I want
to wait for autorepeat to start for 10 seconds, or 10 msecs, it is my
choice. You are to provide the default, I am to override it if I want.

> 
> The REP_DELAY must be equal to REP_PERIOD seems a bit odd to me. In fact,
> I propose something different. If REP_DELAY != 0 then the input layer
> produces autorepeats as normal. If REP_DELAY == 0, then generate repeats
> on the second key down event.

I have no idea why you simply not rely on current input core autorepeat
handling, set REP_DELAY to be 550 msec and call it a day.

Thanks.

-- 
Dmitry
