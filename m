Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49257 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751834AbdHEViF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 17:38:05 -0400
Date: Sat, 5 Aug 2017 22:38:03 +0100
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [v4l-utils] 70-infrared.rules starts ir-keytable too early
Message-ID: <20170805213802.ni42iaht5rf5rye2@gofer.mess.org>
References: <20170717092038.3e7jbjtx7htu3lda@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170717092038.3e7jbjtx7htu3lda@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 17, 2017 at 11:20:38AM +0200, Matthias Reichl wrote:
> While testing serial_ir on kernel 4.11.8 with ir-keytable 1.12.3
> I noticed that my /etc/rc_maps.cfg configuration wasn't applied.
> Manually running "ir-keytable -a /etc/rc_maps.cfg -s rc0" always
> worked fine, though.
> 
> Digging further into this I tracked it down to the udev rule
> being racy. The udev rule triggers on the rc subsystem, but this
> is before the input and event devices are created.

That's an interesting race condition, I haven't seen this before.

> One solution is to trigger ir-keytable -a execution from the event device
> creation instead. I'm currently testing with the following udev rule:
> 
> ACTION=="add", SUBSYSTEMS=="rc", GOTO="begin"
> GOTO="end"
> 
> LABEL="begin"
> 
> SUBSYSTEM=="rc", ENV{rc_sysdev}="$name"
> 
> SUBSYSTEM=="input", IMPORT{parent}="rc_sysdev"
> 
> KERNEL=="event[0-9]*", ENV{rc_sysdev}=="?*", \
>    RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $env{rc_sysdev}"
> 
> LABEL="end"
> 
> That udev rule is a bit messy, ir-keytable -a needs the rcX sysdev,
> which doesn't seem to be easily available from the event node in
> the input subsystem, so I'm propagating that info through an
> environment variable.

This is a good idea; this also solves the problem of udev firing off
ir-keytable for transmit-only devices, which have no input device.

> So far testing is working fine, but hints for better/nicer solutions
> are welcome!

So far I've only come up with a minor change:

ACTION!="add", SUBSYSTEMS!="rc", GOTO="rc_dev_end"

SUBSYSTEM=="rc", ENV{rc_sysdev}="$name"

SUBSYSTEM=="input", IMPORT{parent}="rc_sysdev"

KERNEL=="event[0-9]*", ENV{rc_sysdev}=="?*", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $env{rc_sysdev}"

LABEL="rc_dev_end"

I think we should get this merged into v4l-utils, it solves a real issue.


Sean
