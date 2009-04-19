Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:53336 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZDSX7U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 19:59:20 -0400
Date: Sun, 19 Apr 2009 18:59:18 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Alexey Klimov <klimov.linux@gmail.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,  2.6.16-2.6.21:
 ERRORS
In-Reply-To: <208cbae30904191542l4e3996cejf1df9cadfb187dfe@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904191849280.19718@cnc.isely.net>
References: <200904191818.n3JIISWN021959@smtp-vbr12.xs4all.nl>
 <208cbae30904191542l4e3996cejf1df9cadfb187dfe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Apr 2009, Alexey Klimov wrote:

   [...]

> When trying to compile v4l-dvb tree under 2.6.30-rc2 (up-to-date) i
> have such error with pvr2 module:
> 
>   CC [M]  /w/new/v4l-dvb/v4l/pvrusb2-hdw.o
> /w/new/v4l-dvb/v4l/pvrusb2-hdw.c: In function 'pvr2_upload_firmware1':
> /w/new/v4l-dvb/v4l/pvrusb2-hdw.c:1474: error: implicit declaration of
> function 'usb_settoggle'
> /w/new/v4l-dvb/v4l/pvrusb2-hdw.c: In function 'pvr2_hdw_load_modules':
> /w/new/v4l-dvb/v4l/pvrusb2-hdw.c:2133: warning: format not a string
> literal and no format arguments
> make[3]: *** [/w/new/v4l-dvb/v4l/pvrusb2-hdw.o] Error 1
> make[2]: *** [_module_/w/new/v4l-dvb/v4l] Error 2
> 
> It's probably due to this git commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3444b26afa145148951112534f298bdc554ec789
> 
> I don't have idea how to fix it fast and correctly.

This might explain things a bit.  The following thread took place on 
linux-usb on 7-April:

<quote>

On Tue, 7 Apr 2009, Greg KH wrote:

> On Tue, Apr 07, 2009 at 05:31:55PM +0000, David Vrabel wrote:
> > Wireless USB endpoint state has a sequence number and a current
> > window and not just a single toggle bit.  So allow HCDs to provide a
> > endpoint_reset method and call this or clear the software toggles as
> > required (after a clear halt).
> >
> > usb_settoggle() and friends are then HCD internal and are moved into
> > core/hcd.h.
>
> You remove this api, yet the pvrusb2 driver used it, and you don't seem
> to have resolved the issue where it was calling it:
>
> > diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> > index fa304e5..b86682d 100644
> > --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> > +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> > @@ -1418,7 +1418,6 @@ static int pvr2_upload_firmware1(struct pvr2_hdw *hdw)
> >             return ret;
> >     }
> >
> > -   usb_settoggle(hdw->usb_dev, 0 & 0xf, !(0 & USB_DIR_IN), 0);
> >     usb_clear_halt(hdw->usb_dev, usb_sndbulkpipe(hdw->usb_dev, 0 & 0x7f));
> >
> >     pipe = usb_sndctrlpipe(hdw->usb_dev, 0);
>
> Should usb_reset_endpoint() be called here instead?
>

Speaking as the maintainer of that driver, I'm OK with accepting this
as-is for now.  This is a sequence that should not interfere with normal
driver operation.  I will look at this further a little later (not
likely before the merge window closes) and if this change turns out to
cause a problem I'll make a follow-up fix upstream.

Acked-By: Mike Isely <isely@pobox.com>

  -Mike

</quote>

So the kernel already has this; it just needs to be pulled back into 
v4l-dvb.  It's an obvious trivial thing for now and I've acked it there.  
Obviously we're getting had here because you're compiling against a 
kernel snapshot that's been changed but v4l-dvb doesn't have the 
corresponding change in its local copy of the pvrusb2 driver.  Part of 
the fun of synchronizing changes from different trees :-(

Mauro:  If you just want to take this as-is (or find the git commit and 
pull it down), I'm fine.  Otherwise I'll set up a repo that you can pull 
from with this single-line change.  The above changeset also has the 
following attributions:

From: David Vrabel <david.vrabel@csr.com>
Signed-off-by: David Vrabel <david.vrabel@csr.com>

  -Mike



-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
