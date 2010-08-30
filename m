Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.105.134]:57891 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0H3LpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 07:45:22 -0400
Subject: Re: [PATCH v4 2/5] MFD: WL1273 FM Radio: MFD driver for the FM
 radio.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: ext Pavan Savoy <pavan_savoy@yahoo.co.in>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	petri.karhula@nokia.com
In-Reply-To: <201008281129.04602.hverkuil@xs4all.nl>
References: <676453.10169.qm@web94907.mail.in2.yahoo.com>
	 <1282808385.14489.247.camel@masi.mnp.nokia.com>
	 <201008281129.04602.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 14:44:57 +0300
Message-ID: <1283168697.14489.290.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello.

On Sat, 2010-08-28 at 11:29 +0200, ext Hans Verkuil wrote:
> On Thursday, August 26, 2010 09:39:45 Matti J. Aaltonen wrote:
> > Hi.
> > 
> > On Wed, 2010-08-25 at 23:20 +0200, ext Pavan Savoy wrote:
> > > 
> > > > I'm sorry for not answering to you earlier. But I don't
> > > > have my own
> > > > public repository. But to create the whole thing is
> > > > extremely simple:
> > > > just take the current mainline tree and apply my patches on
> > > > top of it...
> > > 
> > > Yep, that I can do, the reason I asked for was, we've pushed a few patches of our own for WL1283 over shared transport/UART (Not HCI-VS, but I2C like commands, packed in a CH8 protocol format).
> > > The FM register set in both chip are a match, with only transport being the difference (i2c vs. UART).
> > > Also we have the Tx version of driver ready too, it just needs a bit of cleanup and more conformance to already existing V4L2 TX Class..
> > > 
> > > So I was wondering, although there is no problem with WL1273 with I2C and WL1283 with UART being there on the kernel (whenever that happens), but it would be way more cooler if the transport was say abstracted out ..
> > > 
> > > what do you say? just an idea...
> > 
> > I think it's a good idea. And the WL1273 ship can also used with a UART
> > connection, we just chose I2C when the driver development started etc...
> 
> Making a completely bus-independent driver is actually possible. It would require
> that the driver uses the subdev API (include/media/v4l2-subdev.h). Any register
> read or writes can be done by calling the v4l2_device notify() callback and the
> bridge/host driver can then translate the callback to either i2c or uart read
> or writes.
> 
> Both v4l2_device and v4l2_subdev structs are completely abstract structs (i.e.
> they do not rely on any particular bus), so it should be possible to implement
> this.
> 
> I had this scenario in the back of my mind when I designed these APIs, but this
> would be the first driver where this would actually apply to.
> 

That sounds interesting. I think that after the driver gets accepted in
its current form we can start to work according to the above scenario...

Cheers,
Matti






