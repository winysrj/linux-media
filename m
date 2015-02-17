Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36721 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933052AbbBQN6D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 08:58:03 -0500
Date: Tue, 17 Feb 2015 11:57:58 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David Howells <dhowells@redhat.com>
Cc: mkrufky@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] cxusb: Use enum to represent table offsets rather than
 hard-coding numbers
Message-ID: <20150217115758.3c7fc5bf@recife.lan>
In-Reply-To: <28064.1424180750@warthog.procyon.org.uk>
References: <20150217095705.6b317321@recife.lan>
	<20150216153307.19963.61947.stgit@warthog.procyon.org.uk>
	<28064.1424180750@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Feb 2015 13:45:50 +0000
David Howells <dhowells@redhat.com> escreveu:

> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > I would do a s/ix_USB_PID_// in the above, in order to simplify the
> > namespace and to avoid giving the false impression that those are vendor
> > IDs.
> 
> Okay.
> 
> > If you look below on your patch, even you forgot to add a "ix_" prefix into
> > one of the entires ;)
> 
> Bah.  I realised I'd forgotten and went back to try and fix them up.
> 
> > Just calling MEDION_MD95700..MYGICA_T230 would be enough and shorter.
> 
> True.
> 
> > static struct usb_device_id cxusb_table [] = {
> > 	[VID_MEDION] = {USB_VID_MEDION,	USB_PID_MEDION_MD95700},
> > ...
> 
> That should really be:
> 
> 	[VID_MEDION_MD95700] = {USB_VID_MEDION,	USB_PID_MEDION_MD95700},

Actually, MEDION_MD95700 :)

> 
> since the index number is the model, not the vendor, which brings me to:
> 
> 	[DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM] = {USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM},
> 
> which would be excessively long.

True. Perhaps:

	[DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM] = {
		USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM
	},

Would be better, as it follows better the CodingStyle.

> 
> > > +	_(USB_VID_MEDION,	USB_PID_MEDION_MD95700), // 0
> > 
> > Please don't use c99 comments. Also, I don't think that the comments would
> > help, as the entries on this table doesn't need to follow the same order
> > as defined at the enum.
> 
> Sorry, yes, I meant those as guides purely for when I was converting numbers
> to symbols.
> 
> David

Thanks!
Mauro
