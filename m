Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57524 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932341AbdJaSOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 14:14:49 -0400
Date: Tue, 31 Oct 2017 16:14:43 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: av7110: switch to useing timer_setup()
Message-ID: <20171031161443.4e2a685c@vento.lan>
In-Reply-To: <20171031172758.ugfo6br344iso4ni@gofer.mess.org>
References: <20171025004005.hyb43h3yvovp4is2@dtor-ws>
        <20171031172758.ugfo6br344iso4ni@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 31 Oct 2017 17:27:58 +0000
Sean Young <sean@mess.org> escreveu:

> On Tue, Oct 24, 2017 at 05:40:05PM -0700, Dmitry Torokhov wrote:
> > In preparation for unconditionally passing the struct timer_list pointer to
> > all timer callbacks, switch to using the new timer_setup() and from_timer()
> > to pass the timer pointer explicitly.
> > 
> > Also stop poking into input core internals and override its autorepeat
> > timer function. I am not sure why we have such convoluted autorepeat
> > handling in this driver instead of letting input core handle autorepeat,
> > but this preserves current behavior of allowing controlling autorepeat
> > delay and forcing autorepeat period to be whatever the hardware has.  

IR devices basically have only something equivalent to key press events.
They don't have key release ones.

Depending on the device and on the IR protocol, they may have extra events
when a key is kept pressed.

I've seen two types of IR devices: the ones that emit an special "repeat"
event (usually on every 100ms-200ms if a key is kept pressing) and the
ones that just repeat the key's scan code if the key is kept pressed.

The way IR drivers current work is that they send a key press event when
a key is pressed, and if no repeat event happens on an expected time, it
sends a release event.

Thanks,
Mauro
