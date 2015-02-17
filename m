Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbbBQNqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 08:46:32 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150217095705.6b317321@recife.lan>
References: <20150217095705.6b317321@recife.lan> <20150216153307.19963.61947.stgit@warthog.procyon.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: dhowells@redhat.com, mkrufky@linuxtv.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] cxusb: Use enum to represent table offsets rather than hard-coding numbers
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28063.1424180750.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 Feb 2015 13:45:50 +0000
Message-ID: <28064.1424180750@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> I would do a s/ix_USB_PID_// in the above, in order to simplify the
> namespace and to avoid giving the false impression that those are vendor
> IDs.

Okay.

> If you look below on your patch, even you forgot to add a "ix_" prefix into
> one of the entires ;)

Bah.  I realised I'd forgotten and went back to try and fix them up.

> Just calling MEDION_MD95700..MYGICA_T230 would be enough and shorter.

True.

> static struct usb_device_id cxusb_table [] = {
> 	[VID_MEDION] = {USB_VID_MEDION,	USB_PID_MEDION_MD95700},
> ...

That should really be:

	[VID_MEDION_MD95700] = {USB_VID_MEDION,	USB_PID_MEDION_MD95700},

since the index number is the model, not the vendor, which brings me to:

	[DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM] = {USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM},

which would be excessively long.

> > +	_(USB_VID_MEDION,	USB_PID_MEDION_MD95700), // 0
> 
> Please don't use c99 comments. Also, I don't think that the comments would
> help, as the entries on this table doesn't need to follow the same order
> as defined at the enum.

Sorry, yes, I meant those as guides purely for when I was converting numbers
to symbols.

David
