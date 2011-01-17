Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([64.81.146.143]:54328 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab1AQDRR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 22:17:17 -0500
Date: Sun, 16 Jan 2011 21:17:16 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Andy Walls <awalls@md.metrocast.net>
cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mike Isely <isely@isely.net>
Subject: Re: [RFC PATCH] pvrusb2: Provide more information about IR units to
 lirc_zilog and ir-kbd-i2c
In-Reply-To: <1295233673.2407.33.camel@localhost>
Message-ID: <alpine.DEB.1.10.1101162110140.5396@ivanova.isely.net>
References: <1295225086.2400.119.camel@localhost>  <alpine.DEB.1.10.1101162018420.5396@ivanova.isely.net> <1295233673.2407.33.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 16 Jan 2011, Andy Walls wrote:

> On Sun, 2011-01-16 at 20:27 -0600, Mike Isely wrote:

   [,,,]

> 
> Right now, yes.  In the near future, I need to use to to pass 3
> non-const items though:
> 
> 1. A "struct mutex *transceiver_lock" so that the bridge driver can pass
> a mutex to multiple modules accessing the Z8.  That would be a per
> device instance mutex, instantiated and initialized by the bridge
> driver.  The use case where this would be needed is a setup where
> ir-kbd-i2c handles Z8 IR Rx and lirc_zilog handles only Z8 IR Tx of the
> same chip.
> 
> 2. A bridge driver provided "void (*reset_ir_chip)(struct i2c_adapter
> *adap)",  or maybe "void (*reset_ir_chip)(void *priv)", callback to
> reset the transceiver chip when it gets hung.  The original lirc_pvr150
> module had some hard coded reset function names and calls in it, but
> they were removed with the rename to lirc_zilog and move into the
> kernel.  I'd like to get that ability back.
> 
> 3. A bridge driver provided private data structure for the "void *priv"
> argument of the aforementioned reset callback.  This would also be a per
> device object instantiated and initialized by the bridge driver. 
> 

I follow.  Makes sense.

Something to consider, perhaps for the future:  Seems like what you have 
here amounts to some configuration data which will always be read-only, 
and other data which maps to the "context" in which the driver is being 
used (e.g. mutex instance, callback private context pointer, etc).  
That configuration data, if packed up into its own struct, could then be 
squirreled away at compile-time by the bridge driver and provided as 
part of a single table lookup.  This only makes sense if there are a lot 
of configuration bits - but here I count 6 different items.


> 
> > I believe I follow this and it looks good.  The concept looks very 
> > simple and it's nice that the changes are really only in a single spot.  
> > Just thinking ahead about making the setup table-driven and not 
> > requiring data segment storage.
> 
> With the patch right now it could be constant, I think.  You would have
> to use some generic name, like "pvrusb2 IR", instead of
> hdw->hdw_desc->description though.
> 
> For my future plans, if you don't provide a reset callback and don't
> wish to provide a mutex, then yes you can keep it constant.
> 
> I suspect not providing a reset callback may be OK.
> 
> Not providing a mutex is also OK but it imposes a limitation: only one
> IR module should be allowed to use the Z8 chip.  That means
> only lirc_zilog for IR Tx/Rx with Rx through LIRC, or
> only ir-kbd-i2c for IR Rx through the the Linux input subsystem.

For the future, I have no problem providing a reset callback.  And given 
what you've said, I see no reason to do anything here which would 
constrain what you're trying to accomplish.  But if down the road you do 
set up a separate configuration struct which this context struct might 
point to, then I'd like to update the pvrusb2 driver to take advantage 
of it.  But this is no big deal for now.

> 
> >   -Mike
> > 
> > 
> > Acked-By: Mike Isely <isely@pobox.com>
> 
> Thanks.  I'll pull this into my Z8 branch then.

You're welcome.

  -Mike

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
