Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40391 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966260AbcIYNAs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Sep 2016 09:00:48 -0400
Date: Sun, 25 Sep 2016 14:00:44 +0100
From: Sean Young <sean@mess.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media/input] rc: report rc protocol type to userspace
 through input
Message-ID: <20160925130044.GA10479@gofer.mess.org>
References: <1474451661-28986-1-git-send-email-sean@mess.org>
 <20160922115713.7f341c46@vento.lan>
 <20160923220831.GE25499@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160923220831.GE25499@dtor-ws>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

On Fri, Sep 23, 2016 at 03:08:31PM -0700, Dmitry Torokhov wrote:
> On Thu, Sep 22, 2016 at 11:57:13AM -0300, Mauro Carvalho Chehab wrote:
> > Em Wed, 21 Sep 2016 10:54:21 +0100
> > Sean Young <sean@mess.org> escreveu:
> > 
> > > We might want to know what protocol a remote uses when we do not know. With
> > > this patch and another patch for v4l-utils (follows), you can do that with:
> > > 
> > > ./ir-keytable  -p rc-5,nec,rc-6,jvc,sony,sanyo,sharp,xmp -t
> > > Testing events. Please, press CTRL-C to abort.
> > > 1474415431.689685: event type EV_MSC(0x04): protocol = RC_TYPE_RC6_MCE
> > > 1474415431.689685: event type EV_MSC(0x04): scancode = 0x800f040e
> > > 1474415431.689685: event type EV_SYN(0x00).
> > > 
> > > This makes RC_TYPE_* part of the ABI. We also remove the enum rc_type,
> > > since in input-event-codes.h we cannot not use enums.
> > > 
> > > In addition, now that the input layer knows the rc protocol and scancode,
> > > at a later point we could add a feature where keymaps could be created
> > > based on both protocol and scancode, not just scancode.
> > 
> > We need Dmitry's ack in order to apply this one.
> 
> I'd rather not: I am trying to keep input API hardware-independent and
> the kind of device emitting keycodes (a remote control in the sense of
> drivers/media/rc or USB device or BT device) should not really matter to
> consumers. Similarly how we do not export whether device is USB1.1 or
> USB2 or USB3 (although we do have input->id.bustype, but it is more for
> identification purposes rather than for adjusting properties).

Keyboards produce device dependant scancodes; the only output RC devices 
have is protocol and scancode. The scancode is already being sent to
the input layer, and if we can't send the rc protocol to the input layer
we would need a new char device just for that, which is complete overkill.

Alternatively we can put the rc protocol type in MSC_RAW, MSC_SERIAL or
ABS_MISC or one of the other existing device dependant input codes. 

> For configuration (like loading keymaps) we can examine
> parent hardware device and decide.

Unfortunately there is nothing to examine there. The usb device of an 
infrared receiver will tell you nothing about the remote the user is
using.

It would be really helpful if this could be merged; I don't know what
other solution there is to this problem.


Sean
