Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.233]:40098 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0HZHkB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 03:40:01 -0400
Subject: Re: [PATCH v4 2/5] MFD: WL1273 FM Radio: MFD driver for the FM
 radio.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <676453.10169.qm@web94907.mail.in2.yahoo.com>
References: <676453.10169.qm@web94907.mail.in2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 10:39:45 +0300
Message-ID: <1282808385.14489.247.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi.

On Wed, 2010-08-25 at 23:20 +0200, ext Pavan Savoy wrote:
> 
> > I'm sorry for not answering to you earlier. But I don't
> > have my own
> > public repository. But to create the whole thing is
> > extremely simple:
> > just take the current mainline tree and apply my patches on
> > top of it...
> 
> Yep, that I can do, the reason I asked for was, we've pushed a few patches of our own for WL1283 over shared transport/UART (Not HCI-VS, but I2C like commands, packed in a CH8 protocol format).
> The FM register set in both chip are a match, with only transport being the difference (i2c vs. UART).
> Also we have the Tx version of driver ready too, it just needs a bit of cleanup and more conformance to already existing V4L2 TX Class..
> 
> So I was wondering, although there is no problem with WL1273 with I2C and WL1283 with UART being there on the kernel (whenever that happens), but it would be way more cooler if the transport was say abstracted out ..
> 
> what do you say? just an idea...

I think it's a good idea. And the WL1273 ship can also used with a UART
connection, we just chose I2C when the driver development started etc...

B.R.
Matti A.


