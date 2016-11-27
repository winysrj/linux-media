Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:44107 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752406AbcK0TfM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Nov 2016 14:35:12 -0500
Date: Sun, 27 Nov 2016 19:35:10 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161127193510.GA20548@gofer.mess.org>
References: <20161118174034.GA6167@gofer.mess.org>
 <20161118220107.GA3510@shambles.local>
 <20161120132948.GA23247@gofer.mess.org>
 <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
 <20161122092043.GA8630@gofer.mess.org>
 <20161123123851.GB14257@shambles.local>
 <20161123223419.GA25515@gofer.mess.org>
 <20161124121253.GA17639@shambles.local>
 <20161124133459.GA32385@gofer.mess.org>
 <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 25, 2016 at 07:59:21PM +1100, Vincent McIntyre wrote:
> On 11/25/16, Sean Young <sean@mess.org> wrote:
> >
> > So if I understand you correctly, if you change the keymap, like you
> > changed 0xfe47 to KEY_PAUSE, then "ir-keytable -s rc1 -t" show you the
> > correct (new) key? So as far as ir-keytable is concerned, everything
> > works?
> >
> > However when you try to use the new mapping in some application then
> > it does not work?
> 
> That's correct. ir-keytable seems to be doing the right thing, mapping
> the scancode to the input-event-codes.h key code I asked it to.

ir-keytable reads from the input layer, so that's the key being sent. The
problem is elsewhere.

> The application I am trying to use it with is the mythtv frontend.  I
> am doing the keycode munging from an SSH session while myth is still
> running on the main screen. I didn't think this would matter (since it
> worked for KEY_OK->KEY_ENTER) but perhaps it does. Obviously
> ir-keytable -t intercepts the scancodes when it is running, but when I
> kill it myth responds normally to some keys, but not all.

X and keycodes is a bit messy. You might need xmodmap mappings. You
can check them xev. I don't know much about this, I'm afraid. What
linux distribution, version and keyboard layout are you using? I could
try and see if I can reproduce/fix this.
 
> I wanted to mention that the IR protocol is still showing as unknown.
> Is there anything that can be done to sort that out?

It would be nice if that could be sorted out, although that would be 
a separate patch.

So all we know right now is what scancode the IR receiver hardware
produces but we have no idea what IR protocol is being used. In order to
figure this out we need a recording of the IR the remote sends, for which
a different IR receiver is needed. Neither your imon nor your 
dvb_usb_af9035 can do this, something like a mce usb IR receiver would
be best. Do you have access to one? One with an IR emitter would be
best.

So with that we can have a recording of the IR the remote sends, and
with the emitter we can see which IR protocols the IR receiver 
understands.


Sean
