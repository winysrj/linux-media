Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35774 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934194AbcIWWIf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 18:08:35 -0400
Date: Fri, 23 Sep 2016 15:08:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sean Young <sean@mess.org>, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media/input] rc: report rc protocol type to userspace
 through input
Message-ID: <20160923220831.GE25499@dtor-ws>
References: <1474451661-28986-1-git-send-email-sean@mess.org>
 <20160922115713.7f341c46@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160922115713.7f341c46@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 22, 2016 at 11:57:13AM -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 21 Sep 2016 10:54:21 +0100
> Sean Young <sean@mess.org> escreveu:
> 
> > We might want to know what protocol a remote uses when we do not know. With
> > this patch and another patch for v4l-utils (follows), you can do that with:
> > 
> > ./ir-keytable  -p rc-5,nec,rc-6,jvc,sony,sanyo,sharp,xmp -t
> > Testing events. Please, press CTRL-C to abort.
> > 1474415431.689685: event type EV_MSC(0x04): protocol = RC_TYPE_RC6_MCE
> > 1474415431.689685: event type EV_MSC(0x04): scancode = 0x800f040e
> > 1474415431.689685: event type EV_SYN(0x00).
> > 
> > This makes RC_TYPE_* part of the ABI. We also remove the enum rc_type,
> > since in input-event-codes.h we cannot not use enums.
> > 
> > In addition, now that the input layer knows the rc protocol and scancode,
> > at a later point we could add a feature where keymaps could be created
> > based on both protocol and scancode, not just scancode.
> 
> We need Dmitry's ack in order to apply this one.

I'd rather not: I am trying to keep input API hardware-independent and
the kind of device emitting keycodes (a remote control in the sense of
drivers/media/rc or USB device or BT device) should not really matter to
consumers. Similarly how we do not export whether device is USB1.1 or
USB2 or USB3 (although we do have input->id.bustype, but it is more for
identification purposes rather than for adjusting properties).

For configuration (like loading keymaps) we can examine
parent hardware device and decide.

Thanks.

-- 
Dmitry
