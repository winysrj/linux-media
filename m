Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1263 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab2HPOHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 10:07:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: dvb-usb-v2 change broke s2250-loader compilation
Date: Thu, 16 Aug 2012 16:07:03 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201208161233.43618.hverkuil@xs4all.nl> <502CE527.2070006@iki.fi> <502CF98B.1060700@iki.fi>
In-Reply-To: <502CF98B.1060700@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208161607.03380.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu August 16 2012 15:45:47 Antti Palosaari wrote:
> On 08/16/2012 03:18 PM, Antti Palosaari wrote:
> > On 08/16/2012 01:33 PM, Hans Verkuil wrote:
> >> Building the kernel with the Sensoray 2250/2251 staging go7007 driver
> >> enabled
> >> fails with this link error:
> >>
> >> ERROR: "usb_cypress_load_firmware"
> >> [drivers/staging/media/go7007/s2250-loader.ko] undefined!
> >>
> >> As far as I can tell this is related to the dvb-usb-v2 changes.
> >>
> >> Can someone take a look at this?
> >>
> >> Thanks!
> >>
> >>     Hans
> >
> > Yes it is dvb usb v2 related. I wasn't even aware that someone took that
> > module use in few days after it was added for the dvb-usb-v2.
> >
> > Maybe it is worth to make it even more common and move out of dvb-usb-v2...
> >
> > regards
> > Antti
> 
> And after looking it twice I cannot see the reason. I split that Cypress 
> firmware download to own module called dvb_usb_cypress_firmware which 
> offer routine usbv2_cypress_load_firmware(). Old DVB USB is left 
> untouched. I can confirm it fails to compile for s2250, but there is 
> still old dvb_usb_cxusb that is compiling without a error.
> 
> Makefile paths seems to be correct also, no idea whats wrong....

drivers/media/usb/Makefile uses := instead of += for the dvb-usb(-v2) directories,
and that prevents dvb-usb from being build. I think that's the cause of the link
error.

In addition I noticed that in usb/dvb-usb there is a dvb_usb_dvb.c and a
dvb-usb-dvb.c file: there's a mixup with _ and -.

Mauro, did that happen during the reorganization?

Regards,

	Hans
