Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35771 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752018AbdHPQ41 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 12:56:27 -0400
Date: Wed, 16 Aug 2017 17:56:25 +0100
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] keytable: ensure udev rule fires on rc input device
Message-ID: <20170816165625.3554yrommvthkscq@gofer.mess.org>
References: <20170717092038.3e7jbjtx7htu3lda@camel2.lan>
 <20170805213802.ni42iaht5rf5rye2@gofer.mess.org>
 <20170806085655.dkaq7hqpyzrc3abj@gofer.mess.org>
 <20170807070926.hvj5qvqb34xb2x3k@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170807070926.hvj5qvqb34xb2x3k@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 07, 2017 at 09:09:26AM +0200, Matthias Reichl wrote:
> Hi Sean!
> 
> On Sun, Aug 06, 2017 at 09:56:55AM +0100, Sean Young wrote:
> > The rc device is created before the input device, so if ir-keytable runs
> > too early the input device does not exist yet.
> > 
> > Ensure that rule fires on creation of a rc device's input device.
> > 
> > Note that this also prevents udev from starting ir-keytable on an
> > transmit only device, which has no input device.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> 
> Signed-off-by: Matthias Reichl <hias@horus.com>
> 
> One comment though, see below
> 
> > ---
> >  utils/keytable/70-infrared.rules | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > Matthias, can I have your Signed-off-by please? Thank you.
> > 
> > 
> > diff --git a/utils/keytable/70-infrared.rules b/utils/keytable/70-infrared.rules
> > index afffd951..b3531727 100644
> > --- a/utils/keytable/70-infrared.rules
> > +++ b/utils/keytable/70-infrared.rules
> > @@ -1,4 +1,12 @@
> >  # Automatically load the proper keymaps after the Remote Controller device
> >  # creation.  The keycode tables rules should be at /etc/rc_maps.cfg
> >  
> > -ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $name"
> > +ACTION!="add", SUBSYSTEMS!="rc", GOTO="rc_dev_end"
> 
> This line doesn't quite what we want it to do.
> 
> As SUBSYSTEMS!="rc" is basically a no-op and would only be
> evaluated on change/remove events anyways that line boils down to
> 
> ACTION!="add", GOTO="rc_dev_end"
> 
> and the following rules are evaluated on all add events.

Yes, you're right. The goto is only executed if all the preceeding matches,
and for ACTION=add that is never the case.

> While that'll still work it'll do unnecessary work, like importing
> rc_sydev for all input devices and could bite us (or users) later
> if we change/extend the ruleset.
> 
> Better do it like in my original comment (using positive logic and
> a GOTO="begin") or use ACTION!="add", GOTO="rc_dev_end" and add
> SUBSYSTEMS=="rc" to the IMPORT and RUN rules below.

I've found a shorter way of doing this.


Sean

----
From: Sean Young <sean@mess.org>
Date: Wed, 16 Aug 2017 17:41:53 +0100
Subject: [PATCH] keytable: ensure the udev rule fires on creation of the input
 device

The rc device is created before the input device, so if ir-keytable runs
too early the input device does not exist yet.

Ensure that rule fires on creation of a rc device's input device.

Note that this also prevents udev from starting ir-keytable on an
transmit only device, which has no input device.

Note that $id in RUN will not work, since that is expanded after all the
rules are matched, at which point the the parent might have been changed
by another match in another rule. The argument to $env{key} is expanded
immediately.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/70-infrared.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/keytable/70-infrared.rules b/utils/keytable/70-infrared.rules
index afffd951..41ca2089 100644
--- a/utils/keytable/70-infrared.rules
+++ b/utils/keytable/70-infrared.rules
@@ -1,4 +1,4 @@
 # Automatically load the proper keymaps after the Remote Controller device
 # creation.  The keycode tables rules should be at /etc/rc_maps.cfg
 
-ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $name"
+ACTION=="add", SUBSYSTEM=="input", SUBSYSTEMS=="rc", KERNEL=="event*", ENV{.rc_sysdev}="$id", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $env{.rc_sysdev}"
-- 
2.13.5
